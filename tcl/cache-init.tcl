ad_library {

    Initialization cache for object metadata operations

    @creation-date 30 June 2009
    @author Don Baccus (dhogaza@pacifier.com)
    @cvs-id $Id$

}

ns_cache create acs_metadata -size \
    [parameter::get_from_package_key  \
        -package_key acs-object-management \
        -parameter DBCacheSize -default 50000]
