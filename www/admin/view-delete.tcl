ad_page_contract {

} {
    object_view:sql_identifier,notnull
}

object_view::get -object_view $object_view -array view
set object_type $view(object_type)

ad_form -name delete -export {object_view object_type} -form {
} -on_submit {
    object_view::delete -object_view $object_view
    ad_returnredirect ./[export_vars -base object-type {object_type}]
    ad_script_abort
}
