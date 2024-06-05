with
 
--
source as (
    select * from {{ source('product', 'order_items') }}
),
 
--
renamed as (
    select
        order_item_id,
        order_id,
        product_id as item_id,
        qty as quantity,
        created_at,
        updated_at
 
    from
        source
)
 
--
select * from renamed