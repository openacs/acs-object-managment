<?xml version="1.0"?>

<queryset>

  <fullquery name="get_inherited_attributes">
    <querytext>
      select a.attribute_id, a.attribute_name, a.pretty_name, a.pretty_plural,
        a.datatype, t.pretty_name as object_pretty_name
      from acs_attributes a, acs_object_types t
      where t.object_type in (select ot1.object_type
                              from acs_object_types ot1, acs_object_types ot2
                              where ot2.tree_sortkey between 
                                tree_left(ot1.tree_sortkey) and tree_right(ot1.tree_sortkey)
                                and ot2.object_type = :object_type)
        and a.object_type = t.object_type
      order by t.tree_sortkey desc, a.sort_order asc;
    </querytext>
  </fullquery>

</queryset>
