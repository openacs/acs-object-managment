ad_library {

    Supporting procs for ACS Objects.  Unlike the object type and view metadata procs,
    these don't cache at the moment.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date July 1, 2009
    @cvs-id $Id$

}

namespace eval object {}

ad_proc -private object::quote_attribute_values {
    -array:required
} {
    upvar $array attributes
    foreach attribute [array names attributes] {
        set attributes($attribute) "'[DoubleApos $attributes($attribute)]'"
    }
}

ad_proc -private object::split_attributes {
    -object_type:required
    -attributes_array:required
    -type_attributes_array:required
    -supertype_attributes_array:required
} {

    Walk through the attribute names stored in the attribute_array parameter, and
    generate two arrays.  The "type_attributes_array" will contain the values for
    the attributes that belong to the given object type, while the
    supertype_attributes_array will contain the values for the attributes that
    belong to the set of given object_type's supertypes.

    This is used privately to generate insert/update dml statements for each of the
    tables associated with a given type's inheritance hierarchy.

    @param object_type The object type we're processing.
    @param attributes_array The attributes for the object type and all of its supertypes.
    @param type_attributes_array Output array for the attribute values for the object type.
    @param supertype_attributes_array Output array for the attribute values for all of
           the type's supertypes.

} {
    upvar $attributes_array local_attributes_array
    upvar $type_attributes_array local_type_attributes_array
    upvar $supertype_attributes_array local_supertype_attributes_array

    set type_attribute_names [object_type::get_attribute_names \
                                 -object_type $object_type]
    foreach attribute_name [array names local_attributes_array] {
        if { [lsearch -exact $type_attribute_names $attribute_name] == -1 } {
            set local_supertype_attributes_array($attribute_name) \
                $local_attributes_array($attribute_name)
        } else {
            set local_type_attributes_array($attribute_name) \
                $local_attributes_array($attribute_name)
        }
    }
}
      
ad_proc -private object::new_inner {
    -object_type:required
    -object_id:required
    -attributes:required
} {

    Private function called by object::new to create a new object of a given type.  It
    recursively walks the type hierarchy, inserting table values for the type's 
    supertypes as it goes.  object::new wraps the outer call in a transaction to
    guarantee that object creation is atomic.

    @param object_type The type we're creating.
    @param object_id The id of the object we're creating.  If empty, a new object_id
           will be created.
    @param attributes The attribute values for the new object in array get format.

    @return The object_id of the new object.
} {

    array set attributes_array $attributes
  
    object_type::get -object_type $object_type -array object_type_info
    set id_column $object_type_info(id_column)

    object::split_attributes \
        -object_type $object_type \
        -attributes_array attributes_array \
        -type_attributes_array our_attributes \
        -supertype_attributes_array supertype_attributes

    # If this conditional looks weird to you, it's because the supertype of acs_object is
    # acs_object, not null (boo, hiss, aD!)

    if { $object_type_info(supertype) ne $object_type } {
        set object_id \
            [object::new_inner \
                -object_type $object_type_info(supertype) \
                -object_id $object_id \
                -attributes [array get supertype_attributes]]
    } else {
        if { $object_id eq "" } {
            set object_id [db_nextval acs_object_id_seq]
        }
        if { [llength [array names supertype_attributes]] > 0 } {
            # Internal error check - if we're creating an acs_object, it has no supertype
            # therefore should have no supertype_attributes.
            ns_log Error "supertype_attributes should be empty, value: [array get supertype_attributes]"
            return -code error "Internal error - supertype_attributes should be empty"
        }
    }

    if { $object_type_info(table_name) ne "" } {

        set our_attributes($id_column) $object_id
        foreach name [array names our_attributes] {
            lappend name_list $name
            set __$name $our_attributes($name)
            lappend value_list [set __$name]
        }

        db_dml insert_object {}

    } else {
        # error for now as we don't handle generics etc
        return -code error "Generic attributes are not supported."
    }

    return $object_id
}

ad_proc object::new {
    {-object_type acs_object}
    {-object_id ""}
    -attributes
    -array
} {

    Create a new object.  This does not fully support the OpenACS object model.

    1. We don't call the object type's "new" function, if one exists.  This package
       doesn't create them, and in general I'd like to move away from them as it's
       one of the things that makes supporting both oracle and postgresql burdensome.

    2. This means that this function will fail if an object type has a "new" function
       that does tricky things beyond simply creating the supertype object, then
       adding the given type's table entry.

    3. This function doesn't handle generic storage.  This is definitely a feature,
       not a bug.

    @param object_type The type we're creating.  Defaults to acs_object.
    @param object_id The id of the object we're creating.  If empty, a new object_id
           will be created.
    @param attributes The attribute values for the new object in array get format. If
           given, the 'array' parameter must not be specified.
    @param array The name of the array in the caller's namespace that contains the
           attribute values.  If given, the 'attribute' parameter value must not specified.

    @return The object_id of the new object.

} {

    if { [info exists attributes] && [info exists array] } {
        return -code error "Only one of the 'attributes' and 'array' parameters can be given"
    }

    if { [info exists attributes] } {
        array set attributes_array $attributes
    } elseif { [info exists array] } {
        upvar $array attributes_array
    } else {
        array set attributes_array {}
    }

    set attributes_array(object_type) $object_type

    object::quote_attribute_values -array attributes_array

    db_transaction {
        set object_id [object::new_inner \
                          -object_type $object_type \
                          -object_id $object_id \
                          -attributes [array get attributes_array]]
    }
    return $object_id
}

ad_proc object::new_from_form {
    -object_view:required
    -object_id
    -form
} {
} {

    if { ![info exists form] } {
        set form $object_view
    }

    if { ![info exists object_id] } {
        set object_id [template::element::get_value $form \
                          [template::element::get_value $form __key]]
    }

    form::get_attributes \
        -object_view $object_view \
        -array attributes

    set object_type [object_view::get_element \
                        -object_view $object_view \
                        -element object_type]

    set attributes(creation_user) "'[ad_conn user_id]'"
    set attributes(creation_ip) "'[ad_conn peeraddr]'"
    set attributes(object_type) "'$object_type'"

    db_transaction {
        object::new_inner \
            -object_type $object_type \
            -object_id $object_id \
            -attributes [array get attributes]
    }
}

ad_proc object::delete {
    -object_id:required
} {

    Delete an object.

    @param object_id The id of the object to delete.
} {
    package_exec_plsql -var_list [list [list object_id $object_id]] acs_object delete
}

ad_proc object::get_object_type {
    -object_id:required
} {

    Return the type of an object.

    @param object_id The object's id.

    @return The object's type.

} {
    return [db_string get_object_type {}]
}

ad_proc object::get {
    -object_id:required
    {-view ""}
    -array:required
} {

    Return the attributes of an object type, using the given view (the root view, i.e.
    all attributes, by default).  View attributes rather than type attributes are used
    because they contain information on how to transform the database values to a
    canonical form (i.e. calling to_char(date, 'YYYY-MMM-DD').

    To do: localize values if asked to (create a localization proc that can be
    called explicitly by code that doesn't use our "get" function).

    @param object_id The id of the object.
    @param view The object view to use.  Defaults to the root view, i.e. all attributes.  If
           the specified view has been created for a type different than the object's type,
           the results will be interesting.  Actually, carefully done, this can be used to
           cast from a supertype to a subtype but you'd better know what you're doing.
    @param array The name of an output array in the caller's namespace. 

} {
    upvar $array local_array
    if { $view eq "" } {
        set view [object_type::get_root_view \
                     -object_type [object::get_object_type -object_id $object_id]]
    }
    set names [object_view::get_attribute_names -object_view $view]
    db_1row get {} -column_array local_array
}

ad_proc object::update_inner {
    -object_id:required
    -object_type:required
    -attributes:required
} {
    Private function called by object::update to update an object of a given type.  It
    recursively walks the type hierarchy, updating table values for the type's 
    supertypes as it goes.  object::update wraps the outer call in a transaction to
    guarantee that object creation is atomic.

    @param object_type The type we're updating.
    @param object_id The id of the object we're updating.
    @param attributes The new attribute values for the object in array get format.
} {
    array set attributes_array $attributes
    object_type::get -object_type $object_type -array object_type_info
    set id_column $object_type_info(id_column)

    object::split_attributes \
        -object_type $object_type \
        -attributes_array attributes_array \
        -type_attributes_array our_attributes \
        -supertype_attributes_array supertype_attributes

    # If this conditional looks weird to you, it's because the supertype of acs_object is
    # acs_object, not null (boo, hiss, aD!)

    if { $object_type_info(supertype) ne $object_type } {
        object::update_inner \
            -object_type $object_type_info(supertype) \
            -object_id $object_id \
            -attributes [array get supertype_attributes]
    } else {
        if { [llength [array names supertype_attributes]] > 0 } {
            # Internal error check - if we're creating an acs_object, it has no supertype
            # therefore should have no supertype_attributes.
            ns_log Error "supertype_attributes should be empty, value: [array get supertype_attributes]"
            return -code error "Internal error - supertype_attributes should be empty"
        }
    }

    if { $object_type_info(table_name) ne "" } {

        foreach name [array names our_attributes] {
            set __$name $our_attributes($name)
            lappend name_value_list "$name = [set __$name]"
        }

        if { [info exists name_value_list] } {
            db_dml update_object {}
        }

    } else {
        # error for now as we don't handle generics etc
    }

}

ad_proc object::update {
    -object_id:required
    -attributes:required
} {
    Update an object's value.  One of the interesting things about the original
    Ars Digita object type specification is that it called for new and delete procs
    for object types, but not for update procs.  Some object types created for
    packages include update procs, most do not.

    Since most types don't include update procs, unlike the object create case, we're not
    losing any functionality for them by doing explicit updates at the Tcl level.

    @param object_type The type we're updating.
    @param object_id The id of the object we're updating.
    @param attributes The new attribute values for the object in array get format.
} {
    array set attributes_array $attributes

    if { [ad_conn isconnected] } {
	if { ![exists_and_not_null attributes_array(modifying_user)] } {
	    set attributes_array(modifying_user) [ad_conn user_id]
	} 
	if { ![exists_and_not_null attributes_array(modifying_ip)] } {
	    set attributes_array(modifying_ip) [ad_conn peeraddr]
	}
    }

    object::quote_attribute_values -array attributes_array

    set object_type [object::get_object_type -object_id $object_id]

    db_transaction {
        object::update_inner \
            -object_id $object_id \
            -object_type $object_type \
            -attributes [array get attributes_array]
    }
}

ad_proc object::update_from_form {
    -object_view:required
    -object_id
    -form
} {
} {

    if { ![info exists form] } {
        set form $object_view
    }

    if { ![info exists object_id] } {
        set object_id [template::element::get_value $form \
                          [template::element::get_value $form __key]]
    }

    form::get_attributes \
        -object_view $object_view \
        -form $form \
        -array attributes

    set object_type [object_view::get_element \
                        -object_view $object_view \
                        -element object_type]

    set attributes(modifying_user) "'[ad_conn user_id]'"
    set attributes(modifying_ip) "'[ad_conn peeraddr]'"

    db_transaction {
        object::update_inner \
            -object_id $object_id \
            -object_type $object_type \
            -attributes [array get attributes]
    }
}
