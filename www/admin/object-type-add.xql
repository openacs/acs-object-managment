<?xml version="1.0"?>

<queryset>

<fullquery name="select_object_types">
  <querytext>
    select repeat('&nbsp;&nbsp;', tree_level(tree_sortkey)-1) || pretty_name, object_type
    from acs_object_types
    order by tree_sortkey
  </querytext>
</fullquery>

</queryset>
