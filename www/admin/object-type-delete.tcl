ad_page_contract {

} {
    object_type:sql_identifier,notnull
}

object_type::get -object_type $object_type -array type

ad_form -name delete -export {object_type} -form {
} -on_submit {

    object_type::delete -object_type $object_type -drop_table_p t -drop_children_p t
    ad_returnredirect ./[export_vars -base .]
    ad_script_abort
}
