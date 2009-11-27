ad_page_contract {

    wizard for adding/editing widgets registered to object views.

} {
    attribute_id:naturalnum
    object_view:sql_identifier,notnull
    widget:sql_identifier
}

wizard set_param attribute_id $attribute_id
wizard set_param object_view $object_view
wizard set_param widget $widget

wizard create -action widget-add-edit -params {
    attribute_id object_view widget
} -steps {
    1 -label "[_ acs-object-management.choose_a_widget]" -url widget-add-edit-1
    2 -label "[_ acs-object-management.edit_widget_params]" -url widget-add-edit-2
    3 -label "[_ acs-object-management.preview_widget]" -url "widget-add-edit-3" 
}
wizard set_finish_url [export_vars -base form {object_view}]

wizard get_current_step
