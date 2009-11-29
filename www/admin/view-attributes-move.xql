<?xml version="1.0"?>
<queryset>

  <fullquery name="move_up">
    <querytext>

      update acs_view_attributes
         set sort_order = sort_order + :displacement
      where object_view = :object_view
        and attribute_id = (select attribute_id
                              from acs_view_attributes
                             where object_view = :object_view
                               and sort_order = (select sort_order - :displacement
                                                   from acs_view_attributes
                                                  where object_view = :object_view
                                                    and attribute_id = :attribute_id));
      update acs_view_attributes
         set sort_order = sort_order - :displacement
      where object_view = :object_view
        and attribute_id = :attribute_id;

    </querytext>
  </fullquery>
  
</queryset>
