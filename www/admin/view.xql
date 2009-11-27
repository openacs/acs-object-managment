<?xml version="1.0"?>

<queryset>

<fullquery name="get_view_attributes">
  <querytext>
    select aova.attribute_id, aova.view_attribute, aova.pretty_name, aova.sort_order,
      aova.col_expr, aa.datatype, aa.object_type
    from acs_attributes aa join acs_view_attributes aova using (attribute_id)
    where aova.object_view = :object_view
    order by aova.sort_order
  </querytext>
</fullquery>

<fullquery name="get_available_attributes">
  <querytext>
    select aova.attribute_id, aova.view_attribute, aova.pretty_name, aova.sort_order,
      aova.col_expr, aa.datatype, aa.object_type
    from acs_attributes aa join acs_view_attributes aova using (attribute_id)
      join acs_views aov using (object_view)
    where aov.object_type = :object_type
      and aov.root_view_p
      and not exists (select 1
                      from acs_view_attributes aova2
                      where aova2.object_view = :object_view
                        and aova2.view_attribute = aova.view_attribute)
      order by aova.sort_order
  </querytext>
</fullquery>

</queryset>
