<?xml version="1.0"?>
<queryset>

  <fullquery name="object_type::attribute::get_attribute_id.get_attribute_id">
    <querytext>
      select attribute_id
      from acs_attributes
      where object_type = :object_type
        and attribute_name = :attribute_name
    </querytext>
  </fullquery>

  <fullquery name="object_type::attribute::get.get">
    <querytext>
      select *
      from acs_attributes
      where object_type = :object_type
        and attribute_name = :attribute_name
    </querytext>
  </fullquery>

</queryset>
