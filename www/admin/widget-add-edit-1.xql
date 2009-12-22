<?xml version="1.0"?>
<queryset>

  <fullquery name="get_form_widgets"> 
    <querytext>
      select widget, widget
      from acs_form_allowable_widgets    
      where datatype = (select datatype
                          from acs_attributes
                         where attribute_id = :attribute_id)
    </querytext>
  </fullquery>

  <fullquery name="get_reg_widget">
    <querytext>
      select widget as registered_widget
      from acs_view_attribute_widgets
      where attribute_id = :attribute_id
        and object_view = :object_view
    </querytext>
  </fullquery>

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

</queryset>
