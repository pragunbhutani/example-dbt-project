with
 
--
source as (
    select * from {{ ref('snapshot_stg_promotions') }}
),
 
--
renamed as (
    select
        dbt_scd_id as dim_promotions_key,
        promotion_id,
 
        item_id,
        discount_percentage,
 
        created_at,
 
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
 
        (valid_to is null) as is_current
 
    from
        source
)
 
--
select * from renamed