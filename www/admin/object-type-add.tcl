ad_page_contract {

    @author Vinod Kurup (vinod@kurup.com)
    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2009-07-20

    Modified from dynamic types.
}

set page_title [_ acs-object-management.create_type]
set context [list $page_title]


ad_form -name dtype-add -form {
    {object_type:keyword
      {label {[_ acs-object-management.object_type]}}
      {html {size 30 maxlength 100}}
    }
    {pretty_name:text
      {label {[_ acs-object-management.pretty_name]}}
      {html {size 30 maxlength 100}}
    }
    {pretty_plural:text
      {label {[_ acs-object-management.pretty_plural]}}
      {html {size 30 maxlength 100}}
    }
    {supertype:keyword(select)
      {label {[_ acs-object-management.supertype]}}
      {options {[lang::util::localize [db_list_of_lists select_object_types {}]]}}
    }
} -on_submit {
    object_type::new \
        -object_type $object_type \
        -supertype $supertype \
        -pretty_name $pretty_name \
        -pretty_plural $pretty_plural \
        -create_table_p t
} -after_submit {
    ad_returnredirect ./
    ad_script_abort
}

