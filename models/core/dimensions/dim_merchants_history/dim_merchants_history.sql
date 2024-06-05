with
 
--
source as (
    select * from {{ ref('snap_stg_merchants') }}
),
 
--
renamed as (
    select
        dbt_scd_id as dim_merchants_key,
        merchant_id,
 
        merchant_name,
        latitude,
        longitude,
 
        created_at,
 
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
 
        (valid_to is null) as is_current
 
    from
        source
)
 
--
select * from renamed