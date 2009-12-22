ad_page_contract {

    Set widget parameter values.

} {
    attribute_id:naturalnum
    object_view:sql_identifier
    widget:sql_identifier
}

ad_form -name widget_register -export {attribute_id object_view} -form {
    {object_view_pretty:text(inform)
        {label #acs-object-management.object_view#}
    }
    {attribute_name_pretty:text(inform)
        {label #acs-object-management.attribute#}
    }
    {widget:keyword(inform)
        {label #acs-object-management.widget#}
    }
    {-section "Widget Parameters" {legendtext #acs-object-management.widget_parameters#}}
}

db_multirow -unclobber params get_params {} {
    if {$param_source eq "literal"} {
        # reverse transform any escaped characters when we submitted
        set value [string map {\\$ $ \\[ [ \\] ] \\\\ \\} $value]    
    }
    set optional_flag [expr { $required_p ? "" : ",optional" }]
    set param [lang::util::localize $param]
    if { $tcl_allowed_p } {
        set param_source_options {{#acs-object-management.literal# literal} {#acs-object-management.tcl_proc# eval}}
    } else {
        set param_source_options {{#acs-object-management.literal# literal}}
    }
    if {[lsearch -exact {value values options} $param] > -1} {
        ad_form -extend -name widget_register -form {
            {${param}_source:text(radio)
                {label {$param #acs-object-management.source#}}
                {options $param_source_options}
                {value $param_source}
            }
        }
    }
    ad_form -extend -name widget_register -form {
        {${param}:text(textarea)$optional_flag {html {rows 6 cols 50}}}
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
        set param [template::multirow get params $i param]
        set value [template::element::get_value widget_register [template::multirow get params $i param]]
        set param_id [template::multirow get params $i param_id]
        set param_source literal
        if {[lsearch -exact {value values options} $param] > -1} {
            set param_source [template::element::get_value widget_register ${param}_source]
        }
        if {$param_source eq "literal"} {
            # escape malicious characters
            set value [string map {$ \\$ [ \\[ ] \\] \\ \\\\} $value]
        }    
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
                -param_source $param_source \
                -value $value
        }
    }
    wizard forward
    ad_script_abort
}

