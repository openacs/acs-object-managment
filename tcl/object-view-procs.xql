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

</queryset>
