ad_library {

    Supporting procs for ACS Object Types

    @author Yonatan Feldman (yon@arsdigita.com)
    @creation-date August 13, 2000
    @cvs-id $Id$

}

namespace eval object_type {}
namespace eval object_type::view {}
namespace eval object_type::view::attribute {}

ad_proc object_type::view::new {
    -object_view:required
    -pretty_name:required
    -object_type:required
} {

    Create the metadata for a new view for an object type.  As of now, this
    procedure doesn't allow for the creation of attributes (the paradigm is to
    copy attributes from the type's root view), so it doesn't physically create
    the SQL view.  This will be done as attributes are added.

    @param object_view The name of the new view.
    @param pretty_name The human-readable name of the new view.
    @param object_type The object type the view's being built for.
} {
    db_dml insert_object_view {}
    object_type::flush_cache -object_type $object_type
}

ad_proc object_type::view::delete {
    -object_view:required
} {
    Delete a view, both the metadata and SQL view.

    @param object_view The name of the view to delete.
} {
    object_type::view::flush_cache -object_view $object_view
    db_dml delete_object_view {}
    db_dml drop_view {}
}

ad_proc object_type::view::get {
    -object_view:required
    -array:required
} {
    Get the metadata information for a view, and return it in an array in the
    caller's namespace.

    @param object_view The object view whose metadata should be returned.
    @param array The name of the output array to hold the result.
} {
    upvar $array local
    db_1row -cache_pool acs_metadata -cache_key v::${object_view}::get \
        get_object_view {} -column_array local
}

ad_proc object_type::view::get_element {
    -object_view:required
    -element:required
} {
    Return one metadata element for an object view.

    @param object_view The object view whose metadata should be returned.
    @param element The name of the metadata element to return (pretty_name, etc).
} {
    object_type::view::get -object_view $object_view -array view
    return $view($element)
}

ad_proc object_type::view::flush_cache {
    -object_view:required
} {
    Flush all queries dependent on a view.  This also flushes queries dependent on the
    view's type, as when we delete a view (for instance) the set of views belonging to a
    type changes.

    @param object_view The view to flush.
} {
    object_type::flush_cache -object_type [object_type::view::get_element \
                                              -object_view $object_view \
                                              -element object_type]
    db_flush_cache -cache_pool acs_metadata -cache_key_pattern v::${object_view}::*
}
