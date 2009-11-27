ad_page_contract {

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2009-07-25

} {
    object_view:sql_identifier,notnull
    attribute_id:integer,multiple
    return_url:notnull
}

foreach one_attribute_id $attribute_id {
    object_view::attribute::delete \
        -object_view $object_view \
        -attribute_id $one_attribute_id
}

ad_returnredirect $return_url

