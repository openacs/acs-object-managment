<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>                                                                             
<fullquery name="object_type::supertype.supertypes">      
  <querytext>
    select object_type
    from object_types
    start with object_type = :subtype
    connect by prior supertype = object_type
    where object_type != :substype
    order by level desc
  </querytext>
</fullquery>

</queryset>
