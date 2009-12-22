ad_page_contract {

    Preview a widget that's been registered to an attribute.

} {
    object_view:sql_identifier,notnull
    attribute_id:naturalnum
}

set step [wizard current_step]
set last_step [expr $step-1]
set back_url [wizard get_forward_url $last_step]

if {[catch {
    ad_form -name widget_preview -has_submit 1 -form \
        [list [form::element \
                  -object_view $object_view \
                  -attribute_id $attribute_id]]
} errmsg] } {
    ad_return_error "[_ acs-subsite.Error]" "[_ acs-object-management.error_previewing_widget]"
    ad_script_abort
}

ad_form -name widget_buttons -form {
} -on_request {
    wizard submit widget_buttons -buttons { back finish }
} -on_submit {
    wizard forward
    ad_script_abort
}

