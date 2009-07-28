ad_page_contract {

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-05-02
    @cvs-id $Id$

} {
    {object_type:notnull,sql_identifier}
}

object_type::get -object_type $object_type -array type_info

set page_title $type_info(pretty_name)
set context [list [list . "Dynamic Types"] $page_title]

list::create \
    -name attributes \
    -multirow attributes \
    -key attribute_id \
    -pass_properties {
        object_type
    } -actions [list "[_ acs-object-management.add_attribute]" [export_vars -base attribute {object_type}] "[_ acs-object-management.add_attribute]"] \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
            link_url_eval $attribute_url
        }
        attribute_name {
            label "[_ acs-object-management.attribute]"
        }
        datatype {
            label "[_ acs-object-management.datatype]"
        }
        delete {
            label "[_ acs-object-management.Delete]"
            display_template "
                <a href=\"@attributes.delete_url@\">
                  [_ acs-object-management.delete]
                </a>"
        }
    } -filters {
        object_type {}
    }

db_multirow -cache_pool acs_metadata -cache_key ${object_type}::get_attributes \
    -extend { attribute_url delete_url } attributes get_attributes {} {
    set attribute_url [export_vars -base attribute {attribute_id object_type}]
    set delete_url [export_vars -base attribute-delete {object_type attribute_name}]
}

list::create \
    -name inherited_attributes \
    -multirow inherited_attributes \
    -key attribute_id \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
        }
        attribute_name {
            label "[_ acs-object-management.attribute]"
        }
        attribute_object_type {
            label "[_ acs-object-management.object_type]"
        }
        datatype {
            label "[_ acs-object-management.datatype]"
        }
    } -filters {
        object_type {}
    }

db_multirow -cache_pool acs_metadata -cache_key ${object_type}::get_inherited_attributes \
    inherited_attributes get_inherited_attributes {}

list::create \
    -name views \
    -multirow views \
    -key object_view \
    -actions [list "[_ acs-object-management.add_view]" [export_vars -base view-add {object_type}] "[_ acs-object-management.add_view]"] \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
            display_template "
              <if @views.root_view_p@>
                @views.pretty_name@
              </if>
              <else
                <a href=\"@views.view_url@\">
                  @views.pretty_name@
                </a>
              </else>" 
        }
        object_view {
            label "[_ acs-object-management.view]"
        }
        delete {
            label "[_ acs-object-management.Delete]"
            display_template "
              <if @views.root_view_p@ eq \"f\">
                <a href=\"@views.delete_url@\">
                  [_ acs-object-management.delete]
                </a>
              </if>"
        }
    } -filters {
        object_type {}
    }

db_multirow -cache_pool acs_metadata -cache_key ${object_type}::get_views \
    -extend { view_url delete_url } views get_views {} {
    set delete_url [export_vars -base view-delete { object_view }]
    set view_url [export_vars -base view { object_view }]
ns_log Notice "Huh? view_url: $view_url delete_url: $delete_url"
}

set add_form_url [export_vars -base form-ae {object_type}]
set return_url [ad_return_url]
ad_return_template
