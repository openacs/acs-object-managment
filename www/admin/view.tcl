ad_page_contract {

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2009-08-07
    @cvs-id $Id$

} {
    object_view:notnull,sql_identifier
}

object_type::view::get -object_view $object_view -array view_info
set object_type $view_info(object_type)

set page_title $view_info(pretty_name)
set context [list [list . "Dynamic Types"] \
    [list [export_vars -base dtype \
               {{object_type $view_info(object_type)}}] $view_info(object_type)] \
    $page_title]
set return_url [ad_conn url]?[ad_conn query]

list::create \
    -name view_attributes \
    -caption [_ acs-object-management.view_attributes] \
    -multirow view_attributes \
    -key attribute_id \
    -pass_properties {
        object_view
    } \
    -bulk_actions [list [_ acs-object-management.delete_checked_attributes] view-attributes-delete [_ acs-object-management.delete_checked_attributes]] \
    -bulk_action_export_vars {return_url object_view} \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
            link_url_eval $attribute_url
        }
        col_name {
            label "[_ acs-object-management.attribute]"
        }
        object_type {
            label "[_ acs-object-management.object_type]"
        }
        datatype {
            label "[_ acs-object-management.datatype]"
        }
        action {
            label "[_ acs-object-management.Action]"
            display_template "
                <a href=\"@view_attributes.delete_url@\">
                  [_ acs-object-management.delete]
                </a>"
        }
    }

db_multirow -cache_pool acs_metadata -cache_key v::${object_view}::get_view_attributes \
    -extend {attribute_url delete_url} view_attributes get_view_attributes {} {
    set delete_url [export_vars -base view-attributes-delete {object_view return_url attribute_id}]
}

list::create \
    -name available_attributes \
    -caption [_ acs-object-management.available_attributes] \
    -multirow available_attributes \
    -key attribute_id \
    -bulk_actions [list [_ acs-object-management.add_checked_attributes] view-attributes-add [_ acs-object-management.add_checked_attributes]] \
    -bulk_action_export_vars {return_url object_view} \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
        }
        col_name {
            label "[_ acs-object-management.attribute]"
        }
        object_type {
            label "[_ acs-object-management.object_type]"
        }
        datatype {
            label "[_ acs-object-management.datatype]"
        }
        action {
            label "[_ acs-object-management.Action]"
            display_template "
                <a href=\"@available_attributes.add_url@\">
                  [_ acs-object-management.add]
                </a>"
        }
    }

db_multirow -cache_pool acs_metadata -cache_key v::${object_view}::get_available_attributes \
    -extend {add_url} available_attributes get_available_attributes {} {
    set add_url [export_vars -base view-attributes-add {object_view attribute_id return_url}]
}

set add_form_url [export_vars -base form-ae {object_type}]
set return_url [ad_return_url]
ad_return_template
