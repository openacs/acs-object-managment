<?xml version="1.0"?>

<queryset>

  <fullquery name="get_datatypes">
    <querytext>
      select datatype, datatype
      from acs_datatypes
      order by datatype
    </querytext>
  </fullquery>

  <fullquery name="get_attributes">
    <querytext>
      select attribute_name
      from acs_attributes
      where object_type = :object_type
    </querytext>
  </fullquery>

  <fullquery name="get_current_name">
    <querytext>
      select attribute_name
      from acs_attributes
      where attribute_id = :attribute_id
    </querytext>
  </fullquery>

  <fullquery name="attribute_data">
    <querytext>
      select attribute_name, pretty_name, pretty_plural, datatype, default_value
      from acs_attributes
      where attribute_id = :attribute_id
    </querytext>
  </fullquery>

</queryset>
