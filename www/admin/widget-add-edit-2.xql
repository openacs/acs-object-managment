<?xml version="1.0"?>
<queryset>

  <fullquery name="get_attr_info">      
    <querytext>
      select aova.pretty_name as attribute_name_pretty, 
          aov.pretty_name as object_view_pretty
      from acs_view_attributes aova, acs_views aov
      where aov.object_view = :object_view
        and aova.attribute_id = :attribute_id
        and aova.object_view = :object_view
    </querytext>
  </fullquery>
 
  <fullquery name="get_params">      
    <querytext>
      select
        afwp.param_id, afwp.param, afwp.required_p, afwp.html_p,
        coalesce(aovawp.value, afwp.default_value) as value,
        coalesce(aovawp.param_source,'literal') as param_source
      from
        acs_form_widget_params afwp 
        left join acs_view_attribute_widgets aovaw using (widget)
        left join acs_view_attribute_widget_params aovawp
        using (param_id, attribute_id, object_view)
      where aovaw.attribute_id = :attribute_id
        and aovaw.object_view = :object_view
      order by afwp.html_p, afwp.param_id
    </querytext>
  </fullquery>

</queryset>
