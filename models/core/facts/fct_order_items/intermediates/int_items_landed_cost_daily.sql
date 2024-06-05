with
 
--
inventory as (
    select * from {{ ref('stg_inventory') }}
),
 
--
orders as (
    select * from {{ ref('stg_orders') }}
),
 
--
order_items as (
    select * from {{ ref('stg_order_items') }}
),
 
--
daily_sales as (
    select
        o.order_date as report_date,
        o.merchant_id,
        oi.item_id,
        sum(oi.quantity) as quantity_sold
 
    from
        orders as o
    join
        order_items as oi
            on o.order_id = oi.order_id
 
    group by
        1, 2, 3
),
 
--
daily_data as (
    select
        coalesce(i.acquisition_date, ds.report_date) as report_date,
        coalesce(i.merchant_id, ds.merchant_id) as merchant_id,
        coalesce(i.item_id, ds.item_id) as item_id,
        coalesce(i.quantity, 0) as quantity_acquired,
        coalesce(i.unit_cost_usd, 0) as unit_cost_usd,
        coalesce(ds.daily_quantity_sold, 0) AS quantity_sold
 
    from
        inventory as i
    full outer join
        daily_sales as ds
            on i.merchant_id = ds.merchant_id
            and i.item_id = ds.item_id
            and i.date_acquired = ds.report_date
),
 
--
daily_summary as (
    select
        *,
 
        quantity_acquired * unit_cost_usd as total_cost_usd,
 
        sum(quantity_acquired) over (
            partition by merchant_id, item_id
            order by report_date
        ) as cumulative_quantity_acquired,
 
        sum(total_cost_usd) over (
            partition by merchant_id, item_id
            order by report_date
        ) as cumulative_acquisition_cost_usd,
 
        cumulative_acquisition_cost_usd / cumulative_quantity_acquired as landed_unit_cost_usd
 
    from
        daily_data
)
 
--
select * from daily_summary
 