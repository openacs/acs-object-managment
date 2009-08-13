ad_library {
    
    Procs to help with attributes for object types, supplementary for now to
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

    Add an attribute to an object type, optionally create the column in the SQL table,
    and recreate the type's root view.

    @param object_type The type the new attribute belongs to.
    @param attribute_name The name of the new attribute.
    @param datatype The acs datatype of the new attribute.
    @param pretty_name The human-readable name for the new attribute.
    @param pretty_plural Optional human-readable plural name for the new attribute.
    @param table_name SQL table to use for storage (defaults to the type's table).
    @param column_name Column name for the attribute (default attribute name).
    @param default_value Default value (default null).
    @param min_n_values Minimum number of values for the attribute (default 1).
    @param max_n_values Maximum number of values for the attribute (default 1).
    @param sort_order Sort order (defaults to the current maximum+1 for the type).
    @param storage_type Storage type, either "generic" or "type_specific" (default "type_specific").
    @param static_p If true, only one value exists for the entire object type.
    @param create_column_p If true, automatically create the column in the SQL table.
    @param database_type The SQL datatype for this attribute (defaults to the type defined
           for the abstract acs_datatype).
    @param size Optional size parameter (for types like number or varchar).
    @param null_p If true, this attribute can have the value null.
    @param references Optional table name to reference via a foreign key (table must have a
           primary key).
    @param check_expr Optional check expression to apply to the SQL column.
    @param column_spec Optional column_spec for the column.  Overrides database_type,
           size, null_p, references, check_expr.  If column_spec is not null, it must be
           a complete SQL column specification.

    @return The attribute_id of the new attribute.
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
    set attribute_id [package_exec_plsql -var_list $var_list acs_attribute create_attribute]

    package_exec_plsql -var_list [list [list object_type $object_type]] acs_object_type refresh_view
    object_type::flush_cache -object_type $object_type
    return $attribute_id
}

ad_proc object_type::attribute::delete {
    -object_type:required
    -attribute_name:required
    {-drop_column_p f}
} {

    Delete the given attribute for the given object type.

    @param object_type The object type this attribute belongs to.
    @param attribute_name The name (not id) of the attribute to delete.
    @param drop_column_p If true, delete the column from the SQL table.

} {
    set var_list [list \
        [list object_type $object_type] \
        [list attribute_name $attribute_name] \
        [list drop_column_p $drop_column_p]]
    package_exec_plsql -var_list $var_list acs_attribute drop_attribute
    package_exec_plsql -var_list [list [list object_type $object_type]] acs_object_type refresh_view
    object_type::flush_cache -object_type $object_type
}

ad_proc object_type::attribute::get {
    -object_type:required
    -attribute_name:required
    -array:required
} {

    Get the metadata for the given attribute and place it in the named array at the
    caller's level.

    @param object_type The object type this attribute belongs to.
    @param attribute_name The name of the attribute.
    @param array The name of the array to store the metadata in.
} {
    upvar $array local
    db_1row -cache_pool acs_metadata -cache_key t::${object_type}::attribute::get \
        get {} -column_array local
}

ad_proc object_type::attribute::get_attribute_id {
    -object_type:required
    -attribute_name:required
} {

    Get the attribute id for the given attribute name associated with the given object type.
    If the attribute doesn't exist, an error will be thrown.

    @param object_type The object type this attribute belongs to.
    @param attribute_name The name of the attribute.

    @return The attribute_id of the given attribute.
} {
    upvar $array local
    return [db_string \
               -cache_pool acs_metadata \
               -cache_key t::${object_type}::attribute::get_attribute_id \
               get_attribute_id]
}
