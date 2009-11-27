ad_page_contract {

    Remove the widget registered to a view attribute.

} {
    attribute_id:naturalnum
    object_view:sql_identifier
    return_url:notnull
}

    object_view::attribute::widget::unregister \
        -object_view $object_view \
        -attribute_id $attribute_id

ad_returnredirect $return_url
