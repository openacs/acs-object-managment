<?xml version="1.0"?>
<queryset>

  <fullquery name="object_type::view::new.insert_object_view">
    <querytext>
      insert into acs_object_views
        (object_view, object_type, pretty_name, root_view_p)
      values
        (:object_view, :object_type, :pretty_name, 'f')
    </querytext>
  </fullquery>

  <fullquery name="object_type::view::delete.delete_object_view">
    <querytext>
      delete from acs_object_views
      where object_view = :object_view
    </querytext>
  </fullquery>

  <fullquery name="object_type::view::get.get_object_view">
    <querytext>
      select *
      from acs_object_views
      where object_view = :object_view
    </querytext>
  </fullquery>

</queryset>
