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
    -object_type:required
    -object_view:required
    -pretty_name:required
} {
} {
    db_dml insert_object_view {}
    object_type::flush_cache -object_type $object_type
}

ad_proc object_type::view::delete {
    -object_view:required
} {
} {
    object_type::view::flush_cache -object_view $object_view
    db_dml delete_object_view {}
}

ad_proc object_type::view::get {
    -object_view:required
    -array:required
} {
} {
    upvar $array local
    db_1row -cache_pool acs_metadata -cache_key v::${object_view}::get \
        get_object_view {} -column_array local
}

ad_proc object_type::view::get_element {
    -object_view:required
    -element:required
} {
} {
    object_type::view::get -object_view $object_view -array view
    return $view($element)
}

ad_proc object_type::view::flush_cache {
    -object_view:required
} {
    object_type::flush_cache -object_type [object_type::view::get_element \
                                              -object_view $object_view \
                                              -element object_type]
    db_flush_cache -cache_pool acs_metadata -cache_key_pattern v::${object_view}::*
}
