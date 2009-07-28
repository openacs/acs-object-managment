<?xml version="1.0"?>

<queryset>

<fullquery name="select_dtypes">
  <querytext>

    select object_type, pretty_name
    from acs_object_types
    where dynamic_p = 't'
    $orderby_clause

  </querytext>
</fullquery>

</queryset>
