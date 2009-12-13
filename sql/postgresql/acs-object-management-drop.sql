drop table acs_view_attribute_widget_params;
drop table acs_view_attribute_widgets;
drop table acs_form_widget_params;
drop table acs_form_default_widgets;
drop table acs_form_widgets;
drop table acs_view_attributes;
drop table acs_views;

drop sequence acs_form_widget_param_seq;

alter table acs_datatypes drop column database_type;
alter table acs_datatypes drop column column_size;
alter table acs_datatypes drop column column_check_expr;
alter table acs_datatypes drop column column_output_function;

drop function content_type__create_type (varchar,varchar,varchar,varchar,varchar,varchar,varchar);
drop function content_type__create_attribute (varchar,varchar,varchar,varchar,varchar,integer,varchar,varchar);
drop function acs_datatype__date_output_function(text);
drop function acs_datatype__timestamp_output_function(text);
drop function acs_view__drop_sql_view (varchar);
drop function acs_view__create_sql_view (varchar);
drop function acs_object_type__refresh_view (varchar);
drop function acs_object_type__create_type (varchar,varchar,varchar,varchar,varchar,varchar,varchar,boolean,varchar,varchar, boolean, boolean);
drop function acs_object_type__create_type (varchar,varchar,varchar,varchar,varchar,varchar,varchar,boolean,varchar,varchar);
drop function acs_attribute__create_attribute (varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,integer,integer,integer,varchar,boolean,boolean,varchar,varchar,boolean,varchar,varchar,varchar);
drop function acs_attribute__create_attribute (varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,integer,integer,integer,varchar,boolean);
drop function acs_attribute__create_attribute (varchar,varchar,varchar,varchar,varchar,varchar,varchar,integer,integer,integer,integer,varchar,boolean);
drop function acs_object_type__drop_type (varchar,boolean,boolean,boolean);
drop function acs_object_type__drop_type (varchar,boolean);
drop function acs_attribute__drop_attribute (varchar,varchar,boolean);
drop function acs_attribute__drop_attribute (varchar,varchar);
