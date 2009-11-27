ad_page_contract {

    @author Timo Hentschel (timo@timohentschel.de)
    @author Don Baccus (dhogaza@pacifeir.com)
    @creation-date 2005-05-02
    @cvs-id $Id$

    This is a derivative of the dynamic types package.
} {
    {orderby "pretty_name,asc"}
}

set page_title "[_ acs-object-management.dynamic_types]"
set context [list $page_title]

list::create \
    -name object_types \
    -caption $page_title \
    -multirow object_types \
    -key object_type \
    -actions [list "[_ acs-object-management.add_type]" [export_vars -base object-type-add] "[_ acs-object-management.add_type]"] \
    -row_pretty_plural "[_ acs-object-management.dynamic_types]" \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
            link_url_eval $object_type_url
            orderby "lower(pretty_name)"
        }
        object_type {
            label "[_ acs-object-management.object_type]"
            orderby "object_type"
        }
        action {
            label "[_ acs-object-management.Action]"
            display_template "
                <a class=\"button\" href=\"@object_types.delete_url@\" title=\"[_ acs-object-management.delete]\">
                  [_ acs-object-management.delete]
                </a>"
        }

    }

set orderby_clause [list::orderby_clause -orderby -name object_types]

db_multirow -extend { object_type_url delete_url } object_types select_object_types {} {
    set object_type_url [export_vars -base object-type {object_type}]
    set delete_url [export_vars -base object-type-delete {object_type}]
}
