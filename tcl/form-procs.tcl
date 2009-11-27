ad_library {

    Supporting procs for forms that work with views.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date August 28, 2009
    @cvs-id $Id$

}

namespace eval form {}

ad_proc form::form_part {
    -object_view:required
} {

    Returns an ad_form snippet meant to be embedded in the "-form" part of the call.

    @param object_view The object view whose form we should render.

} {
    set form_part [list [list ${object_view}_id:key(acs_object_id_seq)]]
    lappend form_part [list object_view:text(hidden) [list value $object_view]]
    foreach attribute_id [db_list get_attribute_ids {}] {
        lappend form_part [form::element -object_view $object_view -attribute_id $attribute_id]
    }
    return $form_part
}

ad_proc form::get_attributes {
    -object_view:required
    -array:required
} {
    upvar $array local
    foreach attribute_id [db_list get_attribute_ids {}] {
        object_view::attribute::get \
            -object_view $object_view \
            -attribute_id $attribute_id \
            -array attr
        set value [template::element::get_value $object_view $attr(view_attribute)]
        if { [llength [info procs ::template::data::to_sql::${attr(datatype)}]] } {
            set value [template::data::to_sql::${attr(datatype)} $value]
        } else {
            set value "'$value'"
        }
        set local($attr(view_attribute)) $value
    }
}

ad_proc form::element {
    -object_view:required
    -attribute_id:required
} {
} {
    db_1row get_attr_info {}

    set html_params {}
    set params {}
    db_foreach get_params {} {
        if { $html_p } {
            lappend html_params $param
            lappend html_params $value
        } else {
            lappend params [list $param $value]
        }
    }
    if { [llength $html_params] > 0 } {
        lappend params [list html $html_params]
    }
    if { $pretty_name ne "" } {
        lappend params [list label $pretty_name]
    }
    if { $help_text ne "" } {
        lappend params [list help_text $help_text]
    }
    set optional [expr { $required_p ? "" : ",optional" }]
    return [concat ${view_attribute}:${datatype}($widget)$optional $params]
}
