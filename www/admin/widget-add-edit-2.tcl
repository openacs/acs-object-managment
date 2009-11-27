ad_page_contract {

    Set widget parameter values.

} {
    attribute_id:naturalnum
    object_view:sql_identifier
    widget:sql_identifier
}

ad_form -name widget_register -export {attribute_id object_view} -form {
    {object_view_pretty:text(inform)
        {label "Object View"}
    }
    {attribute_name_pretty:text(inform)
        {label "Attribute"}
    }
    {widget:keyword(inform)
        {label "Widget"}
    }
    {-section "Widget Parameters" {legendtext "Widget Parameters"}}
}

db_multirow params get_params {} {
    set optional_flag [expr { $required_p ? "" : ",optional" }]
    set param [lang::util::localize $param]
    ad_form -extend -name widget_register -form {
        {${param}:text(textarea)$optional_flag}
    }
}

ad_form -extend -name widget_register -on_request {
    db_1row get_attr_info ""
    set object_view_pretty [lang::util::localize $object_view_pretty]
    set attribute_name_pretty [lang::util::localize $attribute_name_pretty]
    ad_set_form_values object_view_pretty attribute_name_pretty widget

    for { set i 1 } { $i <= [template::multirow size params] } { incr i } {
        ad_set_element_value -element [template::multirow get params $i param] \
            [template::multirow get params $i value]
    }

    wizard submit widget_register -buttons { back next }
} -on_submit {
    for { set i 1 } { $i <= [template::multirow size params] } { incr i } {
        set value [template::element::get_value widget_register [template::multirow get params $i param]]
        set param_id [template::multirow get params $i param_id]
        if { $value eq "" } {
            object_view::attribute::widget::param::delete \
                -object_view $object_view \
                -attribute_id $attribute_id \
                -param_id $param_id
        } else {
            object_view::attribute::widget::param::set \
                -object_view $object_view \
                -attribute_id $attribute_id \
                -param_id $param_id \
                -value $value
        }
    }
    wizard forward
    ad_script_abort
}

