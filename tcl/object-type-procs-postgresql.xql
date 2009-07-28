<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

  <fullquery name="object_type::supertypes.supertypes">      
    <querytext>
      select o2.object_type
      from acs_object_types o1, acs_object_types o2
      where o1.object_type = :subtype
        and o1.tree_sortkey between tree_left(o2.tree_sortkey) and tree_right(o2.tree_sortkey)
      order by tree_level(o2.tree_sortkey) desc
    </querytext>
  </fullquery>
 
</queryset>
