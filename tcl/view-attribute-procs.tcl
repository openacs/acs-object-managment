ad_library {
    
    Procs to help with attributes for object views.

    @author Don Baccus (dhogaza@pacifierlcom)
    @cvs-id $Id$
}

namespace eval object_view {}
namespace eval object_view::attribute {}

ad_proc object_view::attribute::copy {
    -to_object_view:required
    -from_object_view
    -attribute_id:required
} {
    @param to_object_view The object view to copy the attribute to.
    @param from_object_view The object view to copy the attribute from.  Defaults to the
           root view for the underlying object type.
    @param attribute_id The attribute_id to copy.
} {
    set object_type \
        [object_view::get_element -object_view $to_object_view -element object_type]
   
    if { ![info exists from_object_view] } {
        set from_object_view [object_type::get_root_view -object_type $object_type]
    }

    db_dml copy {}
    object_view::flush_cache -object_view $to_object_view
    set var_list [list [list object_view $to_object_view]]
    package_exec_plsql -var_list $var_list acs_view create_sql_view
}

ad_proc object_view::attribute::delete {
    -object_view:required
    -attribute_id:required
} {
    Delete an object view attribute.

    @param object_view:required
    @param attribute_id:required
} {
    db_dml delete {}
    object_view::flush_cache -object_view $object_view
    set var_list [list [list object_view $object_view]]
    package_exec_plsql -var_list $var_list acs_view create_sql_view
}

ad_proc object_view::attribute::get {
    -object_view:required
    -attribute_id:required
    -array:required
} {

    Get the metadata for the given view attribute and place it in the named array at the
    caller's level.

    @param object_view The object type this attribute belongs to.
    @param attribute_name The name of the attribute.
    @param array The name of the array to store the metadata in.

} {
    upvar $array row
    db_1row -cache_pool acs_metadata \
        -cache_key v::${object_view}::${attribute_id}::attribute::get \
        get {} -column_array row
}

ad_proc object_view::attribute::get_element {
    -object_view:required
    -attribute_id:required
    -element:required
} {

    Get the metadata for the given view attribute and return the requested element.

    @param object_type The object type this attribute belongs to.
    @param attribute_name The name of the attribute.

} {
    object_view::attribute::get \
        -object_view $object_view \
        -attribute_id $attribute_id \
        -array row 
    return $row($element)
}

