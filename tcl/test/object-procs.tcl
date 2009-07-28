ad_library {
    Automated tests for the acs-object Tcl API.

    @author Don Baccus (dhogaza@pacifier.com)
}

aa_register_case -cats {api db smoke} object {

} {
    set object_id [object::new]
    aa_log_result pass "Object create"
    object::delete -object_id $object_id
    aa_log_result pass "Object delete"

    set object_id [db_nextval acs_object_id_seq]
    aa_equals "Pre-allocated object_id" $object_id [object::new -object_id $object_id]
    object::delete -object_id $object_id
    aa_log_result pass "Object delete"

    set attributes(email) foo@bar.com
    set attributes(url) "http://url.url"
    set attributes(first_names) foo
    set attributes(last_name) bar
    set object_id [object::new -object_type person -attributes [array get attributes]]
    aa_log_result pass "Person create"

    set attributes(first_names) "foo fu"
    object::update -object_id $object_id -attributes [array get attributes]
    object::get -object_id $object_id -array check_attributes
    aa_log_result pass "Person update"
    aa_equals "Check update first_names value" $check_attributes(first_names) "foo fu"
    aa_equals "Check update email value" $check_attributes(email) foo@bar.com

    object::delete -object_id $object_id
    aa_log_result pass "Person delete"

}
