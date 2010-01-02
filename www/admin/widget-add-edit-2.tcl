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

set param_procs [list]
set param_procs [info procs ::form::param_procs::*]
foreach proc $param_procs {
    set _proc [string range $proc 2 end]
    lappend _param_procs [list [lindex [split $proc ::] end] $_proc] 
}
set param_procs [lsort -index 0 $_param_procs]
set param_procs [linsert $param_procs 0 [list "" ""]]

db_multirow -unclobber params get_params {} {
    if {$param_source eq "literal"} {
        # reverse transform any escaped characters when we submitted
        set value [string map {\\$ $ \\[ [ \\] ] \\\\ \\} $value]    
    }
    set optional_flag [expr { $required_p ? "" : ",optional" }]
    set param [lang::util::localize $param]
    
    if {[lsearch -exact {value values options} $param] > -1} {
        set param_source_options {{#acs-object-management.literal# literal}}
        if { $tcl_allowed_p } {
            lappend param_source_options {#acs-object-management.tcl_proc# eval}
        }
        ad_form -extend -name widget_register -form {
            {${param}_source:text(radio),optional
                {label "$param #acs-object-management.source#"}
                {options $param_source_options}
                {value $param_source}
                {html {id ${param}_source onClick restrict_value_widget('$param')}}
            }            
            {${param}_literal:text(textarea),optional
                {label "$param literal"}
            }
            {${param}_eval:text(select),optional
                {label "$param tcl proc"}
                {options $param_procs}
            }
        } 
    } else {
        ad_form -extend -name widget_register -form {
            {${param}:text(textarea)$optional_flag}
        }
    }
}


ad_form -extend -name widget_register -on_request {
    db_1row get_attr_info ""
    set object_view_pretty [lang::util::localize $object_view_pretty]
    set attribute_name_pretty [lang::util::localize $attribute_name_pretty]
    ad_set_form_values object_view_pretty attribute_name_pretty widget
    for { set i 1 } { $i <= [template::multirow size params] } { incr i } {
        set param [template::multirow get params $i param]
        set value [template::multirow get params $i value]
        ad_set_element_value -element $param $value            
        if {[lsearch -exact {value values options} $param] > -1} {
            set param_source [template::element::get_value widget_register ${param}_source]
            if {$param_source eq "literal"} {
                ad_set_element_value -element ${param}_literal $value
            } else {
                ad_set_element_value -element ${param}_eval $value
            }
            template::add_body_handler -event onload \
                                       -script restrict_value_widget('$param')
        }
    }

    wizard submit widget_register -buttons { back next }
} -on_submit {
    for { set i 1 } { $i <= [template::multirow size params] } { incr i } {
        set param [template::multirow get params $i param]        
        set param_id [template::multirow get params $i param_id]
        set param_source literal
        if {[lsearch -exact {value values options} $param] > -1} {
            set param_source [template::element::get_value widget_register ${param}_source]
            if {$param_source eq "literal"} {
                set value [template::element::get_value widget_register ${param}_literal]
            } else {
                set value [template::element::get_value widget_register ${param}_eval]
            }
        } else {
            set value [template::element::get_value widget_register [template::multirow get params $i param]]
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

template::head::add_javascript -src widget-add-edit-2.js