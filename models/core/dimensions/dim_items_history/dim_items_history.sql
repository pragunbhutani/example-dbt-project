with
 
--
source as (
    select * from {{ ref('snapshot_stg_items') }}
),
 
--
renamed as (
    select
        dbt_scd_id as dim_items_key,
        item_id,
 
        item_name,
        item_category,
        base_price_usd,
 
        created_at,
 
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
 
        (valid_to is null) as is_current
 
    from
        source
)
 
--
select * from renamed