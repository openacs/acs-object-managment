ad_page_contract {

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2009-08-07
    @cvs-id $Id$

} {
    object_view:notnull,sql_identifier
}

object_view::get -object_view $object_view -array view_info
object_type::get -object_type $view_info(object_type) -array type_info

set page_title $view_info(pretty_name)
set context [list [list . "Types"] \
    [list [export_vars -base object-type \
               {{object_type $view_info(object_type)}}] $type_info(pretty_name)] \
    [list [export_vars -base view {object_view}] "Form For $view_info(pretty_name)"] \
    $page_title]
set return_url [ad_conn url]?[ad_conn query]

list::create \
    -name form_elements \
    -caption [_ acs-object-management.form_elements] \
    -multirow form_elements \
    -key attribute_id \
    -pass_properties {
        object_view
    } \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
        }
        datatype {
            label "[_ acs-object-management.datatype]"
        }
        widget {
            label "[_ acs-object-management.widget]"
        }
        action {
            label "[_ acs-object-management.Action]"
            display_template "
              <a class=\"button\" href=\"@form_elements.add_edit_widget_url@\"
                title=\"[_ acs-object-management.customize_widget]\">
                [_ acs-object-management.customize_widget]
              </a>
            "
        }
    }

db_multirow -extend {add_edit_widget_url} \
    form_elements get_form_elements {} {
    set add_edit_widget_url [export_vars -base widget-add-edit \
                                {object_view attribute_id widget}]
}

set form_preview_url [export_vars -base form-preview {object_view}]
ad_return_template
