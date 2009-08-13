ad_page_contract {

} {
    object_view:sql_identifier,notnull
    object_type:sql_identifier,notnull
}

object_type::view::get \
    -object_view $object_view \
    -array view

ad_form -name delete -export {object_view object_type} -form {
} -on_submit {
    object_type::view::delete -object_view $object_view
    ad_returnredirect ./[export_vars -base dtype {object_type}]
    ad_script_abort
}
