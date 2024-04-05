create or replace warehouse wh__se_eval__xs with auto_resume = true, warehouse_size = 'XSMALL', AUTO_SUSPEND = 60;

create or replace database se_eval;

create or replace schema se_eval.sql_problems;

create or replace schema se_eval.python_problems;

create or replace file format se_eval.public.se_eval_json_format type = json;

create or replace stage se_eval.public.stg_sales_eng_takehome file_format = se_eval.public.se_eval_json_format;

--put file:///Users/christopher.fraleigh/Desktop/Files/LeadingCausesofDeath_noOA.json @stg_sales_eng_takehome;

create or replace table se_eval.sql_problems.leading_causes_of_death (
    cause_of_death_json variant);
copy into se_eval.sql_problems.leading_causes_of_death from @se_eval.public.stg_sales_eng_takehome file_format = se_eval.public.se_eval_json_format;

create or replace table se_eval.sql_problems.leading_causes_of_death_relational as 
    select 
        cause_of_death_json:aadr::string as aadr,
        cause_of_death_json:_113_cause_name::string as cause_name_codes,
        cause_of_death_json:cause_name::string as cause_name,
        cause_of_death_json:deaths::integer as deaths,
        cause_of_death_json:state::string as state,
        cause_of_death_json:year::string as year,
    from 
        se_eval.sql_problems.leading_causes_of_death;


--###################
--#### questions ####
--###################

-- what years do we have data for?
select distinct year from se_eval.sql_problems.leading_causes_of_death_relational order by 1 desc;

--###############################

-- what state has the most deaths in 2010?

with ordered_death_totals as (
select
    state,
    row_number() over (order by sum(deaths) desc) as ranking,
    sum(deaths) as deaths 
from
    se_eval.sql_problems.leading_causes_of_death_relational
where
    year = '2010' and state != 'United States'
group by
    state
    )
select state from ordered_death_totals where ranking = 1

;

--#################################

-- What is the top cause of death in 2015 for each state

with ordered_death_totals as (
select
    state,
    cause_name,
    row_number() over (partition by state order by sum(deaths) desc ) as ranking,
    sum(deaths) as deaths 
from
    se_eval.sql_problems.leading_causes_of_death_relational
where
    lower(cause_name) != 'all causes' and lower(state) != 'united states'
group by
    state,
    cause_name
    )

select state, cause_name from ordered_death_totals where ranking = 1 order by state ;

