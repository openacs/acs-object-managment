<?xml version="1.0"?>
<queryset>

  <fullquery name="object_type::get.select_object_type_info">
    <querytext>
      select object_type, supertype, abstract_p, pretty_name,
        pretty_plural, table_name, id_column, package_name, name_method,
        type_extension_table, dynamic_p
      from   acs_object_types
      where  object_type = :object_type
    </querytext>
  </fullquery>

  <fullquery name="object_type::get_attribute_names.select_attribute_names">
    <querytext>
      select attribute_name
      from acs_attributes
      where  object_type = :object_type
    </querytext>
  </fullquery>

  <fullquery name="object_type::get_root_view.select_root_view">
    <querytext>
      select object_view
      from acs_views
      where  object_type = :object_type
        and root_view_p
    </querytext>
  </fullquery>

</queryset>
