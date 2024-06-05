with
 
--
source as (
    select * from {{ ref('snap_stg_users') }}
),
 
--
renamed as (
    select
        dbt_scd_id as dim_users_key,d
        user_id,
 
        user_name,
        user_email,
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