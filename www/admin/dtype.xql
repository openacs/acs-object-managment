<?xml version="1.0"?>

<queryset>

  <fullquery name="get_attributes">
    <querytext>
      select a.attribute_id, a.attribute_name, a.pretty_name, a.pretty_plural,
        a.datatype
      from acs_attributes a
      where a.object_type = :object_type
      order by a.sort_order asc;
    </querytext>
  </fullquery>

  <fullquery name="get_views">
    <querytext>
      select object_view, pretty_name, root_view_p
      from acs_object_views
      where object_type = :object_type
    </querytext>
  </fullquery>

</queryset>
