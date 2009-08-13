ad_library {

    Supporting procs for ACS Object Types

    @author Yonatan Feldman (yon@arsdigita.com)
    @creation-date August 13, 2000
    @cvs-id $Id$

}

namespace eval object_type {}

ad_proc -public object_type::new {
    -object_type:required
    -pretty_name:required
    -pretty_plural:required
    {-supertype acs_object}
    {-table_name ""}
    {-package_name ""}
    {-abstract_p f}
    {-type_extension_table ""}
    {-name_method ""}
    {-create_table_p f}
    {-dynamic_p t}
    -attributes
} {
} {
    set var_list [list \
        [list object_type $object_type] \
        [list pretty_name $pretty_name] \
        [list pretty_plural $pretty_plural] \
        [list supertype $supertype] \
        [list table_name $table_name] \
        [list package_name $package_name] \
        [list abstract_p $abstract_p] \
        [list type_extension_table $type_extension_table] \
        [list name_method $name_method] \
        [list create_table_p $create_table_p] \
        [list dynamic_p $dynamic_p]]

    db_transaction {
        package_exec_plsql -var_list $var_list acs_object_type create_type

        if { [info exists attributes] } {
            foreach {name attr_info}  $attributes {
                set params [list -object_type $object_type -attribute_name $name]
                if { $create_table_p } {
                    lappend params -create_column_p
                    lappend params t
                }
                foreach {param value} $attr_info {
                    lappend params -$param
                    lappend params $value
                }
            }
            eval [concat object_type::attribute::new $params]
        }
        package_exec_plsql \
            -var_list [list [list object_type $object_type]] acs_object_type refresh_view
    }
}

ad_proc -public object_type::delete {
    -object_type:required
    {-cascade_p t}
    {-drop_table_p f}
    {-drop_children_p f}
} {
    set var_list [list \
        [list object_type $object_type] \
        [list cascade_p $cascade_p] \
        [list drop_table_p $drop_table_p] \
        [list drop_children_p $drop_children_p]]
    package_exec_plsql -var_list $var_list acs_object_type drop_type
    object_type::flush_cache -object_type $object_type
    object_view::flush_cache -object_view *
}

ad_proc -public object_type::get {
    -object_type:required
    -array:required
} {
    Get info about an object type. Returns columns 

    <ul>
      <li>object_type,
      <li>supertype,
      <li>abstract_p,
      <li>pretty_name,
      <li>pretty_plural,
      <li>table_name,
      <li>id_column,
      <li>package_name,
      <li>name_method,
      <li>type_extension_table,
      <li>dynamic_p
    </ul>
} {
    upvar 1 $array row
    db_1row -cache_pool acs_metadata -cache_key t::${object_type}::get \
        select_object_type_info {} -column_array row
}

ad_proc -public object_type::get_element {
    -object_type:required
    -element:required
} {
} {
    object_type::get -object_type $object_type -array object_type_info
    return $object_type_info($element)
}

ad_proc object_type::get_root_view {
    -object_type:required
} {
} {
    return [db_string -cache_pool acs_metadata -cache_key t::${object_type}::get_root_view \
      select_root_view {}]
}

ad_proc -private object_type::acs_object_instance_of {
    {-object_id:required}
    {-type:required}
} {
    Returns true if the specified object_id is a subtype of the specified type.
    This is an inclusive check.

    @author Lee Denison (lee@thaum.net)
} {
    acs_object::get -object_id $object_id -array obj

    return [object_type::supertype \
        -supertype $type \
        -subtype $obj(object_type)]
}

ad_proc -private object_type::supertype {
    {-supertype:required}
    {-subtype:required}
} {
    Returns true if subtype is equal to, or a subtype of, supertype.

    @author Lee Denison (lee@thaum.net)
} {
    set supertypes [object_type::supertypes]
    append supertypes $subtype

    return [expr {[lsearch $supertypes $supertype] >= 0}]
}

ad_proc -private object_type::supertypes {
    {-subtype:required}
} {
    Returns a list of the supertypes of subtypes.

    @author Lee Denison (lee@thaum.net)
} {
    return [db_list -cache_pool acs_metadata -cache_key t::${subtype}::supertypes supertypes {}]
}

ad_proc object_type::get_attribute_names {
    -object_type:required
} {
    Return a list of attribute names declared for the given object type.
} {
    return [db_list -cache_pool acs_metadata -cache_key t::${object_type}::attribute_names \
        select_attribute_names {}]
}

ad_proc -public object_type::flush_cache {
    -object_type:required
} {
} {
    db_flush_cache -cache_pool acs_metadata -cache_key_pattern t::${object_type}::*
}
