ad_library {

    Supporting procs for ACS Object Types

    @author Yonatan Feldman (yon@arsdigita.com)
    @creation-date August 13, 2000
    @cvs-id $Id$

}

namespace eval object_type::view {}

ad_proc -public object_type::view::new {
    -object_type:required
    -object_view:required
    -pretty_name:required
} {
} {
    db_dml insert_object_view {}
}
