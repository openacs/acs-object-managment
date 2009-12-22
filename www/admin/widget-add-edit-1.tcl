ad_page_contract {

    Register a widget to an attribute
} {
    attribute_id:naturalnum
    object_view:sql_identifier,notnull
    widget:sql_identifier,notnull
}

set form_widgets [db_list_of_lists get_form_widgets "" ]

ad_form -name widget_register -export {attribute_id object_view} -form {
    {object_view_pretty:text(inform)
        {label "[_ acs-object-management.view]"}
    }
    {attribute_name_pretty:text(inform)
        {label "[_ acs-object-management.attribute]"}
    }
    {widget:keyword(select)
        {label "[_ acs-object-management.form_widget]"}
        {options $form_widgets}
    }
    {required_p:boolean(radio) 
        {label "[_ acs-object-management.required_p]"}
        {options {{"[_ acs-object-management.Yes]" t}
                  {"[_ acs-object-management.No]" f}}}
    }
    {help_text:text,optional
        {label "[_ acs-object-management.help_text]"}
    }
} -on_request {
    db_1row get_attr_info {}
    set object_view_pretty [lang::util::localize $object_view_pretty]
    set attribute_name_pretty [lang::util::localize $attribute_name_pretty]
    ad_set_form_values object_view_pretty attribute_name_pretty

    if { [object_view::attribute::widget::exists_p \
             -object_view $object_view \
             -attribute_id $attribute_id] } { 
        object_view::attribute::widget::get \
             -object_view $object_view \
             -attribute_id $attribute_id \
             -array current
        ad_set_form_values {widget $widget} {required_p $current(required_p)} \
            {help_text $current(help_text)}
    } else {
        ad_set_form_values {widget $widget} {required_p f}
    }

    wizard submit widget_register -buttons { next }
} -on_submit {
    db_transaction {
        if { [db_0or1row get_reg_widget {}] && $registered_widget ne $widget } {
            object_view::attribute::widget::param::delete_all \
                -object_view $object_view \
                -attribute_id $attribute_id
            object_view::attribute::widget::unregister \
                -object_view $object_view \
                -attribute_id $attribute_id
        }
        object_view::attribute::widget::register \
            -object_view $object_view \
            -attribute_id $attribute_id \
            -widget $widget \
            -required_p $required_p \
            -help_text $help_text
    }
    wizard set_param widget $widget
    wizard forward
    ad_script_abort
}

