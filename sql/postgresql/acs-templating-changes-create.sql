-- Some of these should probably be objects, but I'll worry about that later.

create table acs_form_widgets (
  widget           text
                   constraint acs_form_widgets_pk
		   primary key
);

create table acs_form_default_widgets (
  widget           text
                   constraint acs_form_default_widgets_fk
		   references acs_form_widgets,
  datatype         text
                   constraint acs_form_default_widgets_datatype_fk
                   references acs_datatypes (datatype),
  primary key (widget, datatype)
);

comment on table acs_form_widgets is '
  Canonical list of all template form widgets defined in the system.
';

create sequence acs_form_widget_param_seq;

create table acs_form_widget_params (
  param_id         integer
                   constraint acs_form_widget_params_pk
		   primary key,
  widget           text
                   constraint acs_widget_params_fk
                   references acs_form_widgets
                   on delete cascade,
  param            text
                   constraint acs_widget_param_nil
                   not null,
  required_p       boolean
                   constraint acs_form_widget_params_required_p_nn
                   not null,
  html_p           boolean
                   constraint acs_form_widget_params_html_p_nn
                   not null,
  default_value    text
);

comment on table acs_form_widget_params is '
  Parameters that are specific to a particular type of form widget.
';

create table acs_view_attribute_widgets (
  attribute_id     integer,
  object_view      text,
  widget	   text
                   constraint acs_attr_widget_widget_fk
                   references acs_form_widgets
                   on delete cascade
                   constraint acs_attr_widget_nnl
                   not null,
  required_p       boolean
                   constraint acs_view_attribute_widgets_required_p_nn
                   not null,
  help_text        text,

  constraint acs_view_attribute_widgets_pk
  primary key (object_view, attribute_id),

  constraint acs_view_attribute_widgets_fk
  foreign key (object_view, attribute_id)
  references acs_view_attributes
  on delete cascade
);

comment on table acs_view_attribute_widgets is '
  Map of widgets to object view attributes, only one allowed per attribute.
';

create table acs_view_attribute_widget_params (
  attribute_id     integer,
  object_view      text,
  param_id         integer
                   constraint acs_view_attr_widg_params_param_nn
                   not null
                   constraint acs_view_attr_widg_paramsparam_fk
                   references acs_form_widget_params
                   on delete cascade,
  param_type       text default 'onevalue'
                   constraint acs_view_attr_widg_params_param_type_nn
                   not null
                   constraint acs_view_attr_widg_params_param_type_ck
                   check (param_type in ('onevalue', 'onelist', 'multilist')),
  param_source     text default 'literal'
                   constraint acs_view_attr_widg_params_param_src_nn
                   not null
                   constraint acs_view_attr_widg_params_param_src_ck 
                   check (param_source in ('literal', 'query', 'eval')),
  value		   text,

  constraint acs_view_attr_widg_params_attr_fk
  foreign key (object_view, attribute_id)
  references acs_view_attributes
  on delete cascade,

  constraint acs_view_attr_widg_param_pk
  primary key (object_view, attribute_id, param_id)
);

comment on table acs_view_attribute_widget_params is '
  Parameter values for specific object view attribute widgets.
';

-- insert the standard form widgets.  This was taken from CMS and is incomplete.

begin;

  -- text widget
  insert into acs_form_widgets (widget) values ('text');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (10, 'text', 'size', 'f', 't', '30');

  insert into acs_form_widget_params
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (11, 'text', 'maxlength', 'f', 't', null);

  -- textarea widget
  insert into acs_form_widgets (widget) values ('textarea');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (20, 'textarea', 'rows', 'f', 't', '6');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (30, 'textarea', 'cols', 'f', 't', '60');

  insert into acs_form_widget_params
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (31, 'textarea', 'wrap', 'f', 't', 'physical');

  -- radio widget
  insert into acs_form_widgets (widget) values ('radio');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (40, 'radio', 'options', 't', 'f', null);

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (41, 'radio', 'values', 'f', 'f', null);

  -- checkbox widget
  insert into acs_form_widgets (widget) values ('checkbox');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (50, 'checkbox', 'options', 't', 'f', null);

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (51, 'checkbox', 'values', 'f', 'f', null);

  -- select widget
  insert into acs_form_widgets (widget) values ('select');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (60, 'select', 'options', 't', 'f', '{ -- {} }');

  insert into acs_form_widget_params
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (61, 'select', 'values', 'f', 'f', '{}');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (70, 'select', 'size', 'f', 't', null);

  -- multiselect widget
  insert into acs_form_widgets (widget) values ('multiselect');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (80, 'multiselect', 'options', 't', 'f', null);

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (90, 'multiselect', 'size', 'f', 't', null);

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (91, 'multiselect', 'values', 'f', 'f', null);

  -- timestamp widget
  insert into acs_form_widgets (widget) values ('timestamp');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (92, 'timestamp', 'format', 'f', 'f', null);

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (93, 'timestamp', 'year_interval', 'f', 'f', null);

  -- date widget
  insert into acs_form_widgets (widget) values ('date');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (100, 'date', 'format', 'f', 'f', null);

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (110, 'date', 'year_interval', 'f', 'f', null);

  -- richtext widget
  insert into acs_form_widgets (widget) values ('richtext');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (200, 'richtext', 'rows', 'f', 't', '20');

  insert into acs_form_widget_params 
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (230, 'richtext', 'cols', 'f', 't', '80');

  insert into acs_form_widget_params
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (231, 'richtext', 'wrap', 'f', 't', 'physical');

  -- search widget
  insert into acs_form_widgets (widget) values ('search');

  insert into acs_form_widget_params
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (120, 'search', 'search_query', 't', 'f', null);

  insert into acs_form_widget_params
    (param_id, widget, param, required_p, html_p, default_value)
  values
    (121, 'search', 'result_datatype', 'f', 'f', 'search');
end;

-- default widgets for datatypes

begin;

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('url', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('richtext', 'richtext');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('text', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('string', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('boolean', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('number', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('integer', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('money', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('enumeration', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('email', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('file', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('keyword', 'text');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('date', 'date');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('timestamp', 'timestamp');

  insert into acs_form_default_widgets
    (datatype, widget)
  values
    ('time_of_day', 'timestamp');
end;
