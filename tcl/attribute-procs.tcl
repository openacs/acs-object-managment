ad_library {
    
    Procs to help with attributes for object types, supplemantary for now to
    mbryzek's original arsdigita code found in acs-subsite.

    @author Don Baccus (dhogaza@pacifierlcom)
    @cvs-id $Id$
}

namespace eval object_type { 
    namespace eval attribute {}
}

ad_proc object_type::attribute::new {
    -object_type:required
    -attribute_name:required
    -datatype:required
    -pretty_name:required
    {-pretty_plural ""}
    {-table_name ""}
    {-column_name ""}
    {-default_value ""}
    {-min_n_values 1}
    {-max_n_values 1}
    {-sort_order ""}
    {-storage type_specific}
    {-static_p f}
    {-create_column_p f}
    {-database_type ""}
    {-size ""}
    {-null_p ""}
    {-references ""}
    {-check_expr ""}
    {-column_spec ""}
} {
} {
    set var_list [list \
        [list object_type $object_type] \
        [list attribute_name $attribute_name] \
        [list datatype $datatype] \
        [list pretty_name $pretty_name] \
        [list pretty_plural $pretty_plural] \
        [list table_name $table_name] \
        [list column_name $column_name] \
        [list default_value $default_value] \
        [list min_n_values $min_n_values] \
        [list max_n_values $max_n_values] \
        [list sort_order $sort_order] \
        [list storage $storage] \
        [list static_p $static_p] \
        [list create_column_p $create_column_p] \
        [list database_type $database_type] \
        [list size $size] \
        [list null_p $null_p] \
        [list references $references] \
        [list check_expr $check_expr] \
        [list column_spec $column_spec]]
    package_exec_plsql -var_list $var_list acs_attribute create_attribute
    package_exec_plsql -var_list [list [list object_type $object_type]] acs_object_type refresh_view
    db_flush_cache -cache_pool acs_metadata -cache_key_pattern ${object_type}::*
}

ad_proc object_type::attribute::delete {
    -object_type:required
    -attribute_name:required
    {-drop_column_p f}
} {
} {
    set var_list [list \
        [list object_type $object_type] \
        [list attribute_name $attribute_name] \
        [list drop_column_p $drop_column_p]]
    package_exec_plsql -var_list $var_list acs_attribute drop_attribute
    package_exec_plsql -var_list [list [list object_type $object_type]] acs_object_type refresh_view
    db_flush_cache -cache_pool acs_metadata -cache_key_pattern ${object_type}::*
}

ad_proc object_type::attribute::get {
    -object_type:required
    -attribute_name:required
    -array:required
} {
} {
    upvar $array local
    db_1row -cache_pool acs_metadata -cache_key ${object_type}::attribute::get \
        get {} -column_array local
}

ad_proc object_type::attribute::get_attribute_id {
    -object_type:required
    -attribute_name:required
    -array:required
} {
} {
    upvar $array local
    db_1row -cache_pool acs_metadata -cache_key ${object_type}::attribute::get_attribute_id \
        get_attribute_id {} -column_array local
}
