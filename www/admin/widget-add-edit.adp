<master>
<property name="title">#acs-object-management.widget_add_edit#</property>

<multiple name="wizard">
  <if @wizard.id@ ne @wizard:current_id@>
    <a href="@wizard.link@" title="@wizard.label@">@wizard.rownum@. @wizard.label@</a>  
  </if>
  <else>
    @wizard.rownum@. @wizard.label@
  </else>  
  <if @wizard.rownum@ lt @wizard:rowcount@> &sect; </if>
</multiple>
<include src="@wizard:current_url;noquote@"-->
