with
 
--
source as (
    select * from {{ source('product', 'users') }}
),
 
--
renamed as (
    select
        user_id,
        name as user_name,
        email_address as user_email,
        lat as latitude,
        long as longitude,
        createdAt as created_at,
        updatedAt as updated_at
    from
        source
)
 
--
select * from renamed