<?xml version="1.0"?>

<queryset>

<fullquery name="select_values">
  <querytext>
    select *
    from ${object_view}
    where ${object_view}_id = [set ${object_view}_id]
  </querytext>
</fullquery>

</queryset>
