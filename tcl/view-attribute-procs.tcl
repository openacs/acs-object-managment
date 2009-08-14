ad_library {
    
    Procs to help with attributes for object views.

    @author Don Baccus (dhogaza@pacifierlcom)
    @cvs-id $Id$
}

namespace eval object_type {}
namespace eval object_type::view {}
namespace eval object_type::view::attribute {}

ad_proc object_type::view::attribute::copy {
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
        [object_type::view::get_element -object_view $to_object_view -element object_type]
   
    if { ![info exists from_object_view] } {
        set from_object_view [object_type::get_root_view -object_type $object_type]
    }

    db_dml copy {}
    object_type::view::flush_cache -object_view $to_object_view
}

ad_proc object_type::view::attribute::delete {
    -object_view:required
    -attribute_id:required
} {
    Delete an object view attribute.

    @param object_view:required
    @param attribute_id:required
} {
    db_dml delete {}
    object_type::view::flush_cache -object_view $object_view
}
