<?xml version="1.0"?>
<queryset>

  <fullquery name="form::form_part.get_attribute_ids">
    <querytext>
      select attribute_id
      from acs_view_attributes
      where object_view = :object_view
      order by sort_order
    </querytext>
  </fullquery>

  <fullquery name="form::get_attributes.get_attribute_ids">
    <querytext>
      select attribute_id
      from acs_view_attributes
      where object_view = :object_view
      order by sort_order
    </querytext>
  </fullquery>

  <fullquery name="form::element.get_attr_info">
    <querytext>
      select aova.pretty_name, aova.sort_order, aa.datatype, aa.object_type, aova.view_attribute,
        coalesce(aovaw.widget,
          (select widget from acs_form_default_widgets where datatype = aa.datatype)) as widget,
        coalesce(aovaw.required_p, 'f') as required_p, aovaw.help_text
      from acs_attributes aa join acs_view_attributes aova using (attribute_id)
        left join acs_view_attribute_widgets aovaw using (object_view, attribute_id)
      where aova.object_view = :object_view
        and aa.attribute_id = :attribute_id
    </querytext>
  </fullquery>

  <fullquery name="form::element.get_params">
    <querytext>
      select afwp.param, afwp.html_p, aovawp.value
      from acs_form_widget_params afwp, acs_view_attribute_widget_params aovawp,
        acs_view_attribute_widgets avaw
      where avaw.object_view = :object_view
        and aovawp.attribute_id = :attribute_id
        and afwp.param_id = aovawp.param_id
      union
      select afwp2.param, afwp2.html_p, afwp2.default_value as value
      from acs_form_widget_params afwp2
      where not exists (select 1
                        from acs_view_attribute_widgets
                        where object_view = :object_view
                          and attribute_id = :attribute_id)
        and afwp2.default_value is not null
    </querytext>
  </fullquery>

</queryset>
