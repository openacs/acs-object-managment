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

    Create a new object type, with an initial set of attributes.  Optionally create
    the type's SQL table and type attribute SQL columns.

    For detailed information on the various parameters to this procedure, please
    read the developer's documentation for the SQL procedures which do the actual
    type and attribute creation.

    @param object_type The name of the type to create.
    @param pretty_name The human-readable name of the type to create.
    @param pretty_plural Plural human-readable name of the type to create.
    @param supertype Supertype of the type to create (default "acs_object").
    @param table_name Optional name of the associated SQL table for the new type.  Default
           will be the name of the new type appended with "_t".
    @param package_name Optional name of the associated SQL package used to manipulate
           objects of this type.  Note: the acs-object-management does it with a Tcl API.
    @param abstract_p If true, the type's abstract (no attributes).
    @param type_extension_table Optional table to extend acs_object_types information for
           the new type.  Rarely used.  Probably shouldn't be used.
    @param name_method Optional name of a SQL procedure which returns the name of an object
           of this type.
    @param create_table_p If true, create the table and attribute columns automatically.
           Defaults to false for backwards compatibility with existing ways of doing things,
           but having this procedure create the SQL table and columns is commended and
           convenient.
    @param dynamic_p If true, it's a dynamic type that can be manipulated by the admin UI.
    @param attributes A list of attributes and their qualifiers of the form:
           \{ attr_name \{ (qualifiers in array get format) \}
           \{ attr_name_2 \{ (qualifers) \}
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
                eval [concat object_type::attribute::new $params]
            }
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

    Delete an object type, and optionally its subtypes and any other tables or views
    which depend on it.

    @param object_type The object type to delete.
    @param cascade_p If true, append "cascade" to the SQL drop table command.
    @param drop_table_p If true (recommended) drop the table associated with the object type.
    @param drop_children_p If true (recommended) drop all subtypes dependent on this type.
} {
    set var_list [list \
        [list object_type $object_type] \
        [list cascade_p $cascade_p] \
        [list drop_table_p $drop_table_p] \
        [list drop_children_p $drop_children_p]]
    package_exec_plsql -var_list $var_list acs_object_type drop_type
    object_type::flush_cache -object_type $object_type
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

    @param object_type The object type whose metadata should be returned.
    @param array The name of the output array to hold the metadata.
} {
    upvar 1 $array row
    db_1row -cache_pool acs_metadata -cache_key t::${object_type}::get \
        select_object_type_info {} -column_array row
}

ad_proc -public object_type::get_element {
    -object_type:required
    -element:required
} {

    Return one metadata element for an object type, i.e. pretty name etc.

    @param object_type The object type whose metadata should be returned.
    @param element The name of the element desired.

    @return The value for the metadata element for the given object type.
} {
    object_type::get -object_type $object_type -array object_type_info
    return $object_type_info($element)
}

ad_proc object_type::get_root_view {
    -object_type:required
} {

    Return the name of the root view for the given object type.  The root view is created by
    object_type::new (actually the underlying SQL procedure create_type) and contains all
    attributes declared for the type and its supertypes, along with the innermost
    tree_sortkey for PG types, and the object id.

    @param object_type The type whose root view should be returned.

    @return The name of the root view for the type.
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
    Flush the cache of all query resultsets which depend on the object type.  See cache-init.tcl
    for the cache key naming scheme which must be followed.  This very aggressively flushes
    all view and object queries (since the related object_type isn't tracked in the cache_key)
    but since type creation and modification operations are relatively infrequent, there's
    not much motifivation to be clever about it.

    @param object_type The object type whose query resultsets should be flushed from the
           cache.
} {
    db_flush_cache -cache_pool acs_metadata -cache_key_pattern t::${object_type}::*
    db_flush_cache -cache_pool acs_metadata -cache_key_pattern v::*
    db_flush_cache -cache_pool acs_metadata -cache_key_pattern o::*
}
