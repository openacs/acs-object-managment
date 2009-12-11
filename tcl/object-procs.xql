<?xml version="1.0"?>
<queryset>

  <fullquery name="object::new_inner.insert_object">
    <querytext>
      insert into $object_type_info(table_name)
        ([join $name_list ,])
      values
        ([join $value_list ,])
    </querytext>
  </fullquery>

  <fullquery name="object::update_inner.update_object">
    <querytext>
      update $object_type_info(table_name)
        set [join $name_value_list ,]
      where $id_column = :object_id
    </querytext>
  </fullquery>

  <fullquery name="object::get_object_type.get_object_type">
    <querytext>
      select object_type
      from acs_objects
      where object_id = :object_id
    </querytext>
  </fullquery>

  <fullquery name="object::get.get">
    <querytext>
      select [join $names ,]
      from $view
      where ${view}_id = :object_id
    </querytext>
  </fullquery>

</queryset>
