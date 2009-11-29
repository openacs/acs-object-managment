ad_page_contract {
    Move an attribute up or down in the view.
} {
    object_view:sql_identifier,notnull
    attribute_id:integer,multiple
    return_url:notnull
    direction:notnull
} -validate {
    direction_validate {
        if {$direction ne "up" && $direction ne "down"} {
           ad_complain "direction must be up or down."
        }
    }    
}

if {$direction eq "up"} {
    set displacement 1
} elseif {$direction eq "down"} {
    set displacement -1
}

db_dml move_up {}

object_view::flush_cache -object_view $object_view

ad_returnredirect $return_url
ad_script_abort