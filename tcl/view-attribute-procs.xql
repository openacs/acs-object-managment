<?xml version="1.0"?>
<queryset>

  <fullquery name="object_view::attribute::copy.copy">
    <querytext>
      insert into acs_view_attributes
        (attribute_id, view_attribute, object_view, pretty_name, col_expr, sort_order)
      select attribute_id, view_attribute, :to_object_view, pretty_name, col_expr,
        (select coalesce(max(sort_order)+1, 1)
         from acs_view_attributes
         where object_view = :to_object_view)
      from acs_view_attributes
      where object_view = :from_object_view
        and attribute_id = :attribute_id
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::delete.delete">
    <querytext>
      delete from acs_view_attributes
      where object_view = :object_view
        and attribute_id = :attribute_id
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::delete.reorder">
    <querytext>
      update acs_view_attributes
        set sort_order = sort_order - 1
      where object_view = :object_view
        and sort_order > (select sort_order
                            from acs_view_attributes
                           where object_view = :object_view
                             and attribute_id = :attribute_id)
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::get.get">
    <querytext>
      select aa.object_type, aa.datatype, aa.default_value, aova.view_attribute,
        aova.pretty_name, aova.sort_order, aova.col_expr
      from acs_attributes aa, acs_view_attributes aova
      where aova.object_view = :object_view
        and aova.attribute_id = :attribute_id
        and aa.attribute_id = :attribute_id
    </querytext>
  </fullquery>

</queryset>
