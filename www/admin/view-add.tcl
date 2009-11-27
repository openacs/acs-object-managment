ad_page_contract {

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2009-07-25

} {
    object_type:sql_identifier,notnull
}

set page_title [_ acs-object-management.create_view]
set context [list $page_title]

ad_form -name view-add -export {object_type} -form {
    {object_view:keyword
      {label {[_ acs-object-management.view]}}
      {html {size 30 maxlength 100}}
    }
    {pretty_name:text
      {label {[_ acs-object-management.pretty_name]}}
      {html {size 30 maxlength 100}}
    }
} -on_submit {
    object_view::new \
        -object_type $object_type \
        -object_view $object_view \
        -pretty_name $pretty_name 
} -after_submit {
    ad_returnredirect ./[export_vars -base object-type {object_type}]
    ad_script_abort
}

