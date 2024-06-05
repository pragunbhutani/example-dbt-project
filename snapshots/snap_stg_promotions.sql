{% snapshot snap_stg_promotions %}
 
{{
    config(
        target_schema='intermediate',
        unique_key='promotion_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
 
select * from {{ ref('stg_promotions') }}
 
{% endsnapshot %}