-- Find the top 3 items sold by call center for each month in 1999
with sales_by_date as (
    select 
        month(date_from_parts(date_dim.d_year,date_dim.d_moy,date_dim.d_dom)) as month_of_sale,
        item.i_product_name as product_name,
        sum(catalog_sales.cs_quantity) as sales_quantity,

    from 
        catalog_sales
    join
        item on item.i_item_sk = catalog_sales.cs_item_sk
    join 
        date_dim on date_dim.d_date_sk = catalog_sales.cs_sold_date_sk
        
    where 
        d_year = '1999' and product_name is not null
    group by 1,2
   
    ),

ranked as (
    select 
        sales_quantity,
        month_of_sale,
        product_name,
        row_number() over (partition by month_of_sale order by sales_quantity desc) as ranking
    from 
        sales_by_date
        )

    select * from ranked where ranking = 1 order by month_of_sale;

-- Find the month/year with the highest sales and the lowest sales for each store. Ignore January 2003

    with sales_by_date as (
    select 
        to_char(date_from_parts(date_dim.d_year,date_dim.d_moy,date_dim.d_dom),'YYYY-MM') as sale_month,
        store.s_store_name as store_name,
        store_sales.ss_quantity as sales_quantity,
    from 
        store_sales
    join
        store on store.s_store_sk = store_sales.ss_store_sk
    join 
        date_dim on date_dim.d_date_sk = store_sales.ss_sold_date_sk
    where
        store.s_store_name is not null 
    ),

    total_sales as (

    select 
        sale_month,
        store_name,
        sum(sales_quantity) as total_sales
    from 
        sales_by_date 
    where 
        sale_month != '2003-01'
    group by 1,2
    ),
    min_sales as (
    select 
        store_name,
        min(total_sales) as min_sales,
    from 
        total_sales
    group by 1
    ),
    max_sales as (
    select 
        store_name,
        max(total_sales) as max_sales,
    from 
        total_sales
    group by 1
    ),

    min_max as (

    select
    *
    from 
        total_sales
    join 
        max_sales using(store_name)
    join 
        min_sales using (store_name)
    )

    select 
        store_name,
        sale_month,
        total_sales,
        case when max_sales = total_sales then 'max' else 'min' end as "min/max"
    from 
        min_max 
    where 
        total_sales in (max_sales, min_sales)
    order by store_name;

-- Find daily average store sales on the weekend vs. weekday
    with sales_by_date as (
    select 
        date_dim.d_weekend as is_weekend,
        store_sales.SS_QUANTITY as sales_quantity,
    from 
        store_sales
    join
        store on store.s_store_sk = store_sales.ss_store_sk
    join 
        date_dim on date_dim.D_DATE_SK = store_sales.SS_SOLD_DATE_SK
    where
        store.s_store_name is not null 
    )

    select 
        avg(sales_quantity) as avg_total_sales,
        is_weekend,
    from 
        sales_by_date
    group by 2;
