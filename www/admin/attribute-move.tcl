ad_page_contract {
    Change attribute sort order
} {
    attribute_id:integer,notnull
    object_type
    sort_order
    direction:notnull
    {return_url ""}
}

set user_id [auth::require_login]

permission::require_permission \
    -object_id [ad_conn package_id] \
    -party_id $user_id \
    -privilege admin

if { $direction=="up" } {
    set next_sort_order [expr { $sort_order - 1 }]
} else {
    set next_sort_order [expr { $sort_order + 1 }]
}

db_transaction {
    db_dml swap_sort_orders "
update acs_attributes
set sort_order = (case when sort_order = (cast (:sort_order as integer)) then
      cast (:next_sort_order as integer)
      when
sort_order = (cast (:next_sort_order as integer)) then cast (:sort_order as integer) end)
where object_type = :object_type and sort_order in (:sort_order, :next_sort_order)
"
    set function "dtype::form::metadata::\[^ \]*_list -no_cache" 
    util_memoize_flush_regexp "$function -object_type \"$object_type\".*"

} on_error {

    ad_return_error "Database error" "A database error occured while trying
to swap your questions. Here's the error:
<pre>
$errmsg
</pre>
"
    ad_script_abort
}

if {$return_url eq ""} {
    set return_url [export_vars -base dtype {object_type}]
}

ad_returnredirect $return_url