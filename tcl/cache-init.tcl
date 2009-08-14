ad_library {

    Initialization cache for object metadata operations.  Modify the size by
    changing the value of the package parameter DBCacheSize and restarting
    your server.

    Cache keys in the object Tcl API have the following form:

    t::object_type::query_name For all queries dealing with the specified object type.
    v::object_view::query_name For all queries dealing with the specified object view.
    o::object_id::query_name For all queries dealing with the specified object.

    @creation-date 30 June 2009
    @author Don Baccus (dhogaza@pacifier.com)
    @cvs-id $Id$

}

ns_cache create acs_metadata -size \
    [parameter::get_from_package_key  \
        -package_key acs-object-management \
        -parameter DBCacheSize -default 50000]
