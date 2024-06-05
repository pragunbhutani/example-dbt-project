with
 
--
order_items as (
    select * from {{ ref('fct_order_items') }}
),
 
--
orders as (
    select * from {{ ref('stg_orders') }}
),
 
--
users as (
    select * from {{ ref('dim_users_history') }}
),
 
--
merchants as (
    select * from {{ ref('dim_merchants_history') }}
),
 
--
order_items_aggregated as (
    select
        order_id,
        sum(total_selling_price_usd) as total_selling_price_usd,
        sum(total_cost_price_usd) as total_cost_price_usd,
        sum(total_margin_usd) as total_margin_usd
 
    from
        order_items
 
    group by
        1
),
 
--
final as (
    select
        o.order_id,
        o.user_id,
        o.merchant_id,
        u.dim_user_key,
        m.dim_merchant_key,
        o.order_placed_at,
        oi.total_selling_price_usd,
        oi.total_cost_price_usd,
        oi.total_margin_usd,
        o.created_at,
        o.updated_at
 
    from
        order_items_aggregated as oi
    join
        orders as o
            on o.order_id = oi.order_id
    join
        users as u
            on o.user_id = u.user_id
            and o.created_at between u.valid_from and u.valid_to
    join
        merchants as m
            on o.merchant_id = m.merchant_id
            and o.created_at between m.valid_from and m.valid_to
)
 
--
select * from final