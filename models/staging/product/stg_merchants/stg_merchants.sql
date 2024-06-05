with
 
--
source as (
    select * from {{ source('product', 'merchants') }}
),
 
--
renamed as (
    select
        merchant_id,
        name AS merchant_name,
        split(geo_loc, '/')[0] as latitude,
        split(geo_loc, '/')[1] as longitude,
        createdAt as created_at,
        updatedAt as updated_at
 
    from
        source
)
 
--
select * from renamed