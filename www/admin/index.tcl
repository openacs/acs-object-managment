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
    -name dtypes \
    -multirow dtypes \
    -key object_type \
    -actions [list "[_ acs-object-management.add_type]" [export_vars -base dtype-add] "[_ acs-object-management.add_type]"] \
    -row_pretty_plural "[_ acs-object-management.dynamic_types]" \
    -bulk_actions [list "[_ acs-object-management.export]" dtypes-code "[_ acs-object-management.code_export]"] \
    -elements {
        pretty_name {
            label "[_ acs-object-management.pretty_name]"
            link_url_eval $dtype_url
            orderby "lower(pretty_name)"
        }
        object_type {
            label "[_ acs-object-management.object_type]"
            orderby "object_type"
        }
        delete {
            label "Delete"
            display_template "<a href=\"@dtypes.delete_url@\">delete</a>"
        }

    }

set orderby_clause [list::orderby_clause -orderby -name dtypes]

db_multirow -extend { dtype_url delete_url } dtypes select_dtypes {} {
    set dtype_url [export_vars -base dtype {object_type}]
    set delete_url [export_vars -base dtype-delete {object_type}]
}
