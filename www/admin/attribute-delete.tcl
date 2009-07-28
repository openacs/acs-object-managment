ad_page_contract {

} {
    object_type:sql_identifier,notnull
    attribute_name:sql_identifier,notnull
}

object_type::attribute::get \
    -object_type $object_type \
    -attribute_name $attribute_name \
    -array attribute

ad_form -name delete -export {object_type attribute_name} -form {
} -on_submit {
    object_type::attribute::delete \
        -attribute_name $attribute_name \
        -object_type $object_type \
        -drop_column_p t
    ad_returnredirect ./[export_vars -base dtype {object_type}]
    ad_script_abort
}
