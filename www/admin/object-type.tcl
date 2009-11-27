ad_page_contract {

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-05-02
    @cvs-id $Id$

} {
    object_type:notnull,sql_identifier
}

object_type::get -object_type $object_type -array type_info

set page_title $type_info(pretty_name)
set context [list [list . "Object Types"] $page_title]
set return_url [ad_conn url]?[ad_conn query]

list::create \
    -name attributes \
    -caption [_ acs-object-management.attributes] \
    -multirow attributes \
    -key attribute_id \
    -pass_properties {
        object_type
    } -actions [list "[_ acs-object-management.add_attribute]" [export_vars -base attribute {object_type}] "[_ acs-object-management.add_attribute]"] \
    -elements {
        pretty_name {
            label "[_ acs-object-management.attribute]"
            link_url_eval $attribute_url
        }
        datatype {
            label "[_ acs-object-management.datatype]"
        }
        action {
            label "[_ acs-object-management.Action]"
            display_template "
                <a class=\"button\" href=\"@attributes.delete_url@\" title=\"[_ acs-object-management.delete]\">
                  [_ acs-object-management.delete]
                </a>"
        }
    } -filters {
        object_type {}
    }

db_multirow -cache_pool acs_metadata -cache_key t::${object_type}::get_attributes \
    -extend { attribute_url delete_url} attributes get_attributes {} {
    set attribute_url [export_vars -base attribute {attribute_id object_type}]
    set delete_url [export_vars -base attribute-delete {object_type attribute_name}]
}

list::create \
    -name inherited_attributes \
    -caption [_ acs-object-management.inherited_attributes] \
    -multirow inherited_attributes \
    -key attribute_id \
    -elements {
        pretty_name {
            label "[_ acs-object-management.attribute]"
        }
        object_pretty_name {
            label "[_ acs-object-management.object_type]"
        }
        datatype {
            label "[_ acs-object-management.datatype]"
        }
    } -filters {
        object_type {}
    }

db_multirow -cache_pool acs_metadata -cache_key t::${object_type}::get_inherited_attributes \
    inherited_attributes get_inherited_attributes {}

list::create \
    -name views \
    -caption [_ acs-object-management.views] \
    -multirow views \
    -key object_view \
    -actions [list "[_ acs-object-management.add_view]" [export_vars -base view-add {object_type}] "[_ acs-object-management.add_view]"] \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
            display_template "
              <if @views.root_view_p@ eq \"t\">
                @views.pretty_name@
              </if>
              <else>
                <a href=\"@views.view_url@\" title=\"@views.pretty_name@\">
                  @views.pretty_name@
                </a>
              </else>" 
        }
        object_view {
            label "[_ acs-object-management.view]"
        }
        actions {
            label "[_ acs-object-management.Action]"
            display_template "
              <if @views.root_view_p@ eq \"f\">
                <a class=\"button\" href=\"@views.manage_form_url@\" title=\"[_ acs-object-management.manage_form]\">
                  [_ acs-object-management.manage_form]
                </a>
                <a class=\"button\" href=\"@views.delete_url@\" title=\"[_ acs-object-management.delete]\">
                  [_ acs-object-management.delete]
                </a>
              </if>"
        }
    } -filters {
        object_type {}
    }

db_multirow -cache_pool acs_metadata -cache_key t::${object_type}::get_views \
    -extend { view_url delete_url manage_form_url } views get_views {} {
    set delete_url [export_vars -base view-delete {return_url object_view}]
    set manage_form_url [export_vars -base form {object_view}]
    set view_url [export_vars -base view {object_view}]
}

ad_return_template
