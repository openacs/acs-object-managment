<?xml version="1.0"?>

<queryset>

<fullquery name="get_form_elements">
  <querytext>
    select aova.attribute_id, aova.view_attribute, aova.pretty_name, aova.sort_order,
      aova.col_expr, aa.datatype, aa.object_type, 
      coalesce(aovaw.widget,
        (select widget from acs_form_default_widgets where datatype = aa.datatype)) as widget
    from acs_attributes aa join acs_view_attributes aova using (attribute_id)
      left join acs_view_attribute_widgets aovaw using (object_view, attribute_id)
    where aova.object_view = :object_view
    order by aova.sort_order
  </querytext>
</fullquery>

</queryset>
