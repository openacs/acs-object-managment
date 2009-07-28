ad_library {

    Supporting procs for ACS Objects.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date July 1, 2009
    @cvs-id $Id$

}

namespace eval object {}

ad_proc -private object::split_attributes {
    -object_type:required
    -attributes_array:required
    -type_attributes_array:required
    -supertype_attributes_array:required
} {
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
      
# Change this to allow an array name or attributes, with the appropriate error.

ad_proc -private object::new_inner {
    -object_type:required
    -object_id:required
    -attributes:required
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
        if { [llength [array name subtype_attributes]] > 0 } {
            # error ...
        }
    }

    if { $object_type_info(table_name) ne "" } {

        set our_attributes($id_column) $object_id
        foreach name [array names our_attributes] {
            lappend name_list $name
            set __$name $our_attributes($name)
            lappend value_name_list :__$name
        }

        db_dml insert_object {}

    } else {
        # error for now as we don't handle generics etc
    }

    return $object_id
}

ad_proc object::new {
    {-object_type acs_object}
    {-object_id ""}
    {-attributes ""}
} {
} {
    array set attributes_array $attributes

    set attributes_array(object_type) $object_type

    if { [ad_conn isconnected] } {
	if { ![exists_and_not_null attributes_array(creation_user)] } {
	    set attributes_array(creation_user) [ad_conn user_id]
	} 
	if { ![exists_and_not_null attributes_array(creation_ip)] } {
	    set attributes_array(creation_ip) [ad_conn peeraddr]
	}
    }

    db_transaction {
        set object_id [object::new_inner \
                          -object_type $object_type \
                          -object_id $object_id \
                          -attributes [array get attributes_array]]
    }
    return $object_id
}

ad_proc object::delete {
    -object_id:required
} {
} {
    package_exec_plsql -var_list [list [list object_id $object_id]] acs_object delete
}

ad_proc object::get_object_type {
    -object_id:required
} {
} {
    return [db_string get_object_type {}]
}

ad_proc object::get {
    -object_id:required
    {-view ""}
    -array:required
} {
} {
    upvar $array local_array
    if { $view eq "" } {
        set view [object_type::get_root_view \
                     -object_type [object::get_object_type -object_id $object_id]]
    }
    db_1row get {} -column_array local_array
}

ad_proc object::update_inner {
    -object_id:required
    -object_type:required
    -attributes:required
} {
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
        if { [llength [array name subtype_attributes]] > 0 } {
            # error ...
        }
    }

    if { $object_type_info(table_name) ne "" } {

        foreach name [array names our_attributes] {
            set __$name $our_attributes($name)
            lappend name_value_list "$name = :__$name"
        }

        if { [llength $name_value_list] > 0 } {
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

    set object_type [object::get_object_type -object_id $object_id]

    db_transaction {
        object::update_inner \
            -object_id $object_id \
            -object_type $object_type \
            -attributes [array get attributes_array]
    }
}
