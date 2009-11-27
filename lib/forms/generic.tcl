ad_page_contract {

    Includelet to handle generic add/edit operations for a non-content repository
    object object_view.

    Adding a new object requires "create" on [ad_conn package_id].
    Editing an existing object requires "write" on the object.
    
} "
    ${object_view}_id:naturalnum,optional
"

ad_form -name $object_view \
  -form [form::form_part -object_view $object_view] \
  -select_query_name select_values \
  -on_request {
    if { [info exists ${object_view}_id] } {
        permission::require_permission \
            -party_id [ad_conn user_id] \
            -object_id [set ${object_view}_id] \
            -privilege write
    } else {
        permission::require_permission \
            -party_id [ad_conn user_id] \
            -object_id [ad_conn package_id] \
            -privilege create
    }
} -new_data {
    object::new_from_form -object_view $object_view 
} -edit_data {
    object::update_from_form -object_view $object_view
} -after_submit {
    if { [info exists return_url] } {
        ad_returnredirect $return_url
        ad_script_abort
    }
}
