ad_library {

    Supporting procs for widgets and views.  Essentially allows for the assignment of
    a widget and parameters to individual view attributes.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date August 28, 2009
    @cvs-id $Id$

}

namespace eval object_type {}
namespace eval object_view {}
namespace eval object_view::attribute::widget {}
namespace eval object_view::attribute::widget::param {}

ad_proc object_view::attribute::widget::register {
    -object_view:required
    -attribute_id:required
    -widget:required
    -required_p:required
    -help_text:required
} {
} {
    if { [db_0or1row widget_exists {}] } {
        db_dml update_widget {}
    } else {
        db_dml insert_widget {}
    }
    object_view::flush_cache -object_view $object_view
}

ad_proc object_view::attribute::widget::unregister {
    -object_view:required
    -attribute_id:required
} {
} {
    db_dml delete_widget {}
    object_view::flush_cache -object_view $object_view
}

ad_proc object_view::attribute::widget::exists_p {
    -object_view:required
    -attribute_id:required
} {
} {
    return [db_0or1row exists {}]
}

ad_proc object_view::attribute::widget::get {
    -object_view:required
    -attribute_id:required
    -array:required
} {
} {
    upvar $array row
    db_1row get {} -column_array row
}

ad_proc object_view::attribute::widget::get_element {
    -object_view:required
    -attribute_id:required
    -element:required
} {
} {
    object_view::attribute::widget::get \
        -object_view $object_view \
        -attribute_id $attribute_id \
        -array row
    return $row($element)
}

ad_proc object_view::attribute::widget::param::delete {
    -object_view:required
    -attribute_id:required
    -param_id:required
} {
} {
    db_dml delete {}
}

ad_proc object_view::attribute::widget::param::delete_all {
    -object_view:required
    -attribute_id:required
} {
} {
    db_dml delete_all {}
}

ad_proc object_view::attribute::widget::param::set {
    -object_view:required
    -attribute_id:required
    -param_id:required
    {-param_type "onevalue"}
    {-param_source "literal"}
    -value:required
} {
} {
    if { [db_0or1row param_exists {}] } {
        db_dml update_value {}
    } else {
        db_dml insert_param {}
    }
}
