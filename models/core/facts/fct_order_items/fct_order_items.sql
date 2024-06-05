with
 
--
order_items as (
    select * from {{ ref('stg_order_items') }}
),
 
--
orders as (
    select * from {{ ref('stg_orders') }}
),
 
--
items as (
    select * from {{ ref('dim_items_history') }}
),
 
--
promotions as (
    select * from {{ ref('dim_promotions_history') }}
),
 
--
item_landing_cost as (
    select * from {{ ref('int_items_landed_cost_daily') }}
),
 
--
collected_data as (
    select
        oi.order_item_id,
        oi.order_id,
 
        oi.item_id,
        oi.promotion_id,
 
        i.dim_item_key,
        p.dim_promotion_key,
 
        oi.quantity,
        coalesce(p.discount_percentage_as_float, 0) as discount_percentage_as_float,
        i.base_price_usd as base_unit_selling_price_usd,
        ilc.landed_unit_cost_usd as landed_unit_cost_price_usd,
 
        oi.created_at,
        oi.updated_at
 
    from
        order_items as oi
    join
        orders as o
            on oi.order_id = o.order_id
    join
        items as i
            on oi.item_id = i.item_id
            and oi.created_at between i.valid_from and i.valid_to
    join
        item_landing_cost as ilc
            on oi.item_id = ilc.item_id
            and oi.created_at = ilc.report_date
    left join
        promotions as p
            on oi.item_id = p.item_id
            and oi.created_at between p.valid_from and p.valid_to
),
 
--
final as (
    select
        *,
 
        base_unit_selling_price_usd * (1 - discount_percentage_as_float)
        as effective_unit_selling_price_usd,
 
        landed_unit_cost_price_usd - effective_unit_selling_price_usd
        as unit_margin_usd,
 
        quantity * effective_unit_selling_price_usd as total_selling_price_usd,
        quantity * landed_unit_cost_price_usd as total_cost_price_usd,
        quantity * unit_margin_usd as total_margin_usd
 
    from
        collected_data
)
 
--
select * from final