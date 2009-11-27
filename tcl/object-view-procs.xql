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

</queryset>
