-- Find the top 3 items sold by call center for each month in 1999
with sales_by_date as (
    select 
        month(date_from_parts(date_dim.d_year,date_dim.d_moy,date_dim.d_dom)) as month_of_sale,
        item.i_product_name as product_name,
        sum(catalog_sales.cs_quantity) as sales_quantity,

    from 
        CATALOG_SALES
    join
        item on item.I_ITEM_SK = catalog_sales.CS_ITEM_SK
    join 
        date_dim on date_dim.D_DATE_SK = catalog_sales.cs_sold_date_sk
        
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
