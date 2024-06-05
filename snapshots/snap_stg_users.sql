{% snapshot snap_stg_users %}
 
{{
    config(
        target_schema='intermediate',
        unique_key='user_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
 
select * from {{ ref('stg_users') }}
 
{% endsnapshot %}