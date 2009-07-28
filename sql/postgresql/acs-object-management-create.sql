\i acs-kernel-changes-create.sql
\i acs-content-repository-changes-create.sql

select acs_object_type__refresh_view('acs_object');
