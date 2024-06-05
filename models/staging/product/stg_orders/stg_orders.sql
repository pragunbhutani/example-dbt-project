with
 
--
source as (
    select * from {{ source('product', 'orders') }}
)
 
--
renamed as (
    select
        order_id,
        customer_id as user_id,
        store_id as merchant_id,
        date as order_placed_at,
        created_at,
        updated_at
 
    from
        source
)
 
--
select * from renamed
