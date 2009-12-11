<?xml version="1.0"?>
<queryset>

  <fullquery name="object_view::new.insert_object_view">
    <querytext>
      insert into acs_views
        (object_view, object_type, pretty_name, root_view_p)
      values
        (:object_view, :object_type, :pretty_name, 'f')
    </querytext>
  </fullquery>

  <fullquery name="object_view::delete.delete_object_view">
    <querytext>
      delete from acs_views
      where object_view = :object_view
    </querytext>
  </fullquery>

  <fullquery name="object_view::get.get_object_view">
    <querytext>
      select *
      from acs_views
      where object_view = :object_view
    </querytext>
  </fullquery>

  <fullquery name="object_view::get_attribute_names.get_attr_names">
    <querytext>
      select view_attribute
      from acs_view_attributes
      where object_view = :object_view
      order by sort_order
    </querytext>
  </fullquery>

  <fullquery name="object_view::get_attribute_ids.get_attr_ids">
    <querytext>
      select attribute_id
      from acs_view_attributes
      where object_view = :object_view
      order by sort_order
    </querytext>
  </fullquery>

</queryset>
