use database se_eval;

select
    table_name,
    SUM(ACTIVE_BYTES + TIME_TRAVEL_BYTES + FAILSAFE_BYTES + RETAINED_FOR_CLONE_BYTES) / 1024 / 1024 AS STORAGE_SIZE_MB

from 
    "INFORMATION_SCHEMA"."TABLE_STORAGE_METRICS" 
where 
    table_catalog = 'SE_EVAL' and table_schema = 'SQL_PROBLEMS' and table_dropped is null
group by
    table_name;

create or replace table se_eval.sql_problems.leading_causes_of_death_clone  clone se_eval.sql_problems.leading_causes_of_death_relational

-- TABLE_NAME	                            STORAGE_SIZE_MB
-- LEADING_CAUSES_OF_DEATH	                   0.158203125
-- LEADING_CAUSES_OF_DEATH_RELATIONAL	       0.15087890625
-- LEADING_CAUSES_OF_DEATH_CLONE	           0