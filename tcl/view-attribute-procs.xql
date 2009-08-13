<?xml version="1.0"?>
<queryset>

  <fullquery name="object_type::view::attribute::copy.copy">
    <querytext>
      insert into acs_object_view_attributes
        (attribute_id, col_name, object_view, pretty_name, col_expr, sort_order)
      select attribute_id, col_name, :to_object_view, pretty_name, col_expr,
        (select coalesce(max(sort_order), 1)
         from acs_object_view_attributes
         where object_view = :to_object_view)
      from acs_object_view_attributes
      where object_view = :from_object_view
        and attribute_id = :attribute_id
    </querytext>
  </fullquery>

  <fullquery name="object_type::view::attribute::delete.delete">
    <querytext>
      delete from acs_object_view_attributes
      where object_view = :object_view
        and attribute_id = :attribute_id
    </querytext>
  </fullquery>

</queryset>
