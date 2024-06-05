with
 
--
source as (
    select * from {{ source('product', 'promotions') }}
),
 
--
renamed as (
    select
        promotion_id,
        product_id AS item_id,
        discount / 100 AS discount_percentage_as_float,
        created_at,
        updated_at
 
    FROM
        source
)
 
--
select * from renamed