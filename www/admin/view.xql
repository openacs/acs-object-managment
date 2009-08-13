<?xml version="1.0"?>

<queryset>

<fullquery name="get_view_attributes">
  <querytext>
    select aova.attribute_id, aova.col_name, aova.pretty_name, aova.sort_order,
      aova.col_expr, aa.datatype, aa.object_type
    from acs_attributes aa, acs_object_view_attributes aova
    where aova.object_view = :object_view
      and aa.attribute_id = aova.attribute_id
  </querytext>
</fullquery>

<fullquery name="get_available_attributes">
  <querytext>
    select aova.attribute_id, aova.col_name, aova.pretty_name, aova.sort_order,
      aova.col_expr, aa.datatype, aa.object_type
    from acs_object_views aov, acs_object_view_attributes aova,
      acs_attributes aa
    where aov.object_type = :object_type
      and aov.root_view_p
      and aov.object_view = aova.object_view
      and aova.attribute_id = aa.attribute_id
      and not exists (select 1
                      from acs_object_view_attributes aova2
                      where aova2.object_view = :object_view
                        and aova2.col_name = aova.col_name)
      order by aova.sort_order
  </querytext>
</fullquery>

</queryset>
