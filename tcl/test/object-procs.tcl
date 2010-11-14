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

aa_register_case -cats {api db smoke} object_attributes_datatypes {
    Test object creation of attributes and datatypes
} {
    set object_type object_type_test
    # create new type with attributes for each datatype
    aa_false "Object Type Created" \
        [catch {object_type::new \
                    -object_type $object_type \
                    -pretty_name "Object Type" \
                    -pretty_plural "Object Types" \
                    -create_table_p t \
                    -attributes \
                    {s {datatype string pretty_name s}
                        b {datatype boolean pretty_name b}
                        n {datatype number pretty_name n}
                        i {datatype integer pretty_name i}
                        m {datatype currency pretty_name m}
                        d {datatype date pretty_name d}
                        ts {datatype timestamp pretty_name ts}
                        td {datatype time_of_day pretty_name td}
                        t {datatype text pretty_name t}
                        rt {datatype richtext pretty_name rt}
                    }} error]
    aa_log $error
    
    array set attributes \
        [list s string b 0 n 1000 i 1000000 m 10.00 d 2010-01-01 ts "2010-01-01 00:00:00" td "2010-01-01 00:00:00" t "text" rt "'Single quoted string'"]
    
    aa_false "Object Created" \
        [catch {set object_id [object::new \
                                   -object_type $object_type \
                                   -array attributes]
        } error]
    object::delete -object_id $object_id
    
    aa_log $error
    
    set view_name "object_type_test_v2"
    aa_false "View created" \
        [catch {
            object_view::new \
                -object_type $object_type \
                -object_view  $view_name \
                -pretty_name "Object Type Test View 2" 
            
            db_foreach get_attribs \
                {select *
                    from acs_attributes
                    where object_type = :object_type} {
                        object_view::attribute::copy \
                            -to_object_view $view_name \
                            -attribute_id $attribute_id
                    }
        } error]
    aa_log $error

    aa_false "Form created" \
        [catch {

            set form_part [form::form_part -object_view $view_name]
            aa_log $form_part
            ad_form -name $view_name \
                -form $form_part
            
            foreach {a v} [list s string b 0 n 1000 i 1000000 m 10.00 d 2010-01-01 ts "2010-01-01 00:00:00" td "2010-01-01 00:00:00" t "text" rt "'Single quoted string'"] {
                template::element::set_value $view_name $a $v
            }
        } error]
    aa_log $error
    
    aa_false "Object created from form" \
        [catch {set object_id [object::new_from_form \
                                   -object_view $view_name \
                                   -form $view_name]} error]
    object::delete -object_id $object_id
    aa_log $error
    aa_false "Type Removed" [catch {
        object_type::delete -object_type $object_type \
            -cascade_p t \
            -drop_table_p t
    } error]
    aa_log $error
}

