-- create an xsmall snowflake warehouse with auto suspend and auto resume enabled

create or replace warehouse wh__se_eval__xs with auto_resume = true, warehouse_size = 'XSMALL', AUTO_SUSPEND = 60;


-- create database for the project
create or replace database se_eval;

-- create two schemas, one for the sql problem related objects and one for the python problem related objects

create or replace schema se_eval.sql_problems;

create or replace schema se_eval.python_problems;
