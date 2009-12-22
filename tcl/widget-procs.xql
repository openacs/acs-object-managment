<?xml version="1.0"?>
<queryset>

  <fullquery name="object_view::attribute::widget::register.widget_exists">
    <querytext>
      select 1
      from acs_view_attribute_widgets
      where attribute_id = :attribute_id
        and object_view = :object_view
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::register.update_widget">
    <querytext>
      update acs_view_attribute_widgets
      set required_p = :required_p,
        help_text = :help_text,
        widget = :widget
      where attribute_id = :attribute_id
        and object_view = :object_view
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::register.insert_widget">
    <querytext>
      insert into acs_view_attribute_widgets
        (object_view, attribute_id, widget, required_p, help_text)
      values
        (:object_view, :attribute_id, :widget, :required_p, :help_text)
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::unregister.delete_widget">
    <querytext>
      delete from acs_view_attribute_widgets
      where attribute_id = :attribute_id
        and object_view = :object_view
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::exists_p.exists">
    <querytext>
      select 1
      where exists (select *
                    from acs_view_attribute_widgets
                     where object_view = :object_view
                       and attribute_id = :attribute_id)
    </querytext>
  </fullquery>


  <fullquery name="object_view::attribute::widget::get.get">
    <querytext>
      select widget, required_p, help_text
      from acs_view_attribute_widgets
      where object_view = :object_view
        and attribute_id = :attribute_id
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::param::delete.delete">
    <querytext>
      delete from acs_view_attribute_widget_params
      where object_view = :object_view
        and attribute_id = :attribute_id
        and param_id = :param_id
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::param::delete_all.delete_all">
    <querytext>
      delete from acs_view_attribute_widget_params
      where object_view = :object_view
        and attribute_id = :attribute_id
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::param::set.param_exists">
    <querytext>
      select 1
      from acs_view_attribute_widget_params
      where object_view = :object_view
        and attribute_id = :attribute_id
        and param_id = :param_id
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::param::set.update_value">
    <querytext>
      update acs_view_attribute_widget_params
      set param_type = :param_type,
          param_source = :param_source,
          value = :value
      where object_view = :object_view
        and attribute_id = :attribute_id
        and param_id = :param_id
    </querytext>
  </fullquery>

  <fullquery name="object_view::attribute::widget::param::set.insert_param">
    <querytext>
      insert into acs_view_attribute_widget_params
        (object_view, attribute_id, param_id, param_type, param_source, value)
      values
        (:object_view, :attribute_id, :param_id, :param_type, :param_source, :value)
    </querytext>
  </fullquery>

</queryset>
