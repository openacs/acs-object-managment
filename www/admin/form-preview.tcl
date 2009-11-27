ad_page_contract {

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2009-08-07
    @cvs-id $Id$

} {
    object_view:notnull,sql_identifier
}

ad_form -name object_view \
  -form [form::form_part -object_view $object_view] \
  -after_submit {
    ad_returnredirect [export_vars -base form {object_view}]
    ad_script_abort
}

ad_return_template
