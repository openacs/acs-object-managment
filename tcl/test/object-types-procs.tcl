ad_library {
    Automated tests for the acs-object-types Tcl API.

    @author Don Baccus (dhogaza@pacifier.com)
}

aa_register_case -cats {api db smoke} object_type {

} {

    if { [catch {object_type::new \
                     -object_type object_type_test \
                     -pretty_name "Object Type" \
                     -pretty_plural "Object Types" \
                     -create_table_p t \
                     -attributes {i {datatype integer pretty_name i}}} error] } {
        aa_log_result fail "Attempt to create type \"object_type_test\" failed: $error"
    } else {
        aa_log_result pass "Created type \"object_type_test\""
    }

    if { [catch {object_type::attribute::delete \
                     -object_type object_type_test \
                     -attribute_name i \
                     -drop_column_p t} error] } {
        aa_log_result fail "Attempt to delete attribute \"i\" of \"object_type_test\" failed: $error"
    } else {
        aa_log_result pass "Deleted attribute \"i\" of \"object_type_test\""
    }

    if { [catch {object_type::attribute::delete \
                     -object_type object_type_test \
                     -attribute_name xxx \
                     -drop_column_p t} error] } {
        aa_log_result pass "Attempt to delete non-existent attribute \"xxx\" of \"object_type_test\" failed: $error"
    } else {
        aa_log_result fail "Deleted non-existent attribute \"xxx\" of \"object_type_test\""
    }

    if { [catch {object_type::delete \
                     -object_type object_type_test \
                     -drop_table_p t \
                     -cascade_p t \
                     -drop_children_p t} error] } {
        aa_log_result fail "Attempt to delete type \"object_type_test\" failed: $error"
    } else {
        aa_log_result pass "Deleted type \"object_type_test\""
    }

    if { [catch {object_type::new \
                     -object_type object_type_test2 \
                     -pretty_name "Object Type 2" \
                     -pretty_plural "Object Types 2" \
                     -create_table_p t \
                     -attributes {i {datatype integer \
                                     pretty_name i \
                                     references acs_objects \
                                     null_p t}}} error] } {
        aa_log_result fail "Attempt to create type \"object_type_test2\" failed: $error"
    } else {
        aa_log_result pass "Created type \"object_type_test2\""
    }

    if { [catch {object_type::delete \
                     -object_type object_type_test2 \
                     -drop_table_p t \
                     -cascade_p t \
                     -drop_children_p t} error] } {
        aa_log_result fail "Attempt to delete type \"object_type_test2\" failed: $error"
    } else {
        aa_log_result pass "Deleted type \"object_type_test2\""
    }

    if { [catch {object_type::new \
                     -object_type object_type_test3 \
                     -pretty_name "Object Type 3" \
                     -pretty_plural "Object Types 3" \
                     -create_table_p t } error] } {
        aa_log_result fail "Attempt to create type \"object_type_test3\" failed: $error"
    } else {
        aa_log_result pass "Created type \"object_type_test3\""
    }

    if { [catch {object_type::delete \
                     -object_type object_type_test3 \
                     -drop_table_p t \
                     -cascade_p t \
                     -drop_children_p t} error] } {
        aa_log_result fail "Attempt to delete type \"object_type_test3\" failed: $error"
    } else {
        aa_log_result pass "Deleted type \"object_type_test3\""
    }

    if { [catch {object_type::new \
                     -object_type object_type_test4 \
                     -pretty_name "Object Type 4" \
                     -pretty_plural "Object Types 4" \
                     -table_name acs_objects } error] } {
        aa_log_result pass "Attempt to create type \"object_type_test4\" with table \"acs_objects\" failed: $error"
    } else {
        aa_log_result fail "Created type \"object_type_test4\" with table \"acs_objects\""
    }

    if { [catch {object_type::new \
                     -object_type object_type_test5 \
                     -pretty_name "Object Type 5" \
                     -pretty_plural "Object Types 5" \
                     -table_name acs_object_types \
                     -create_table_p t } error] } {
        aa_log_result pass "Attempt to create type \"object_type_test5\" creating table \"acs_object_types\" failed: $error"
    } else {
        aa_log_result fail "Created type \"object_type_test5\" creating table \"acs_object_types\""
    }
}
