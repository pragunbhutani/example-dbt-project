{% snapshot snap_stg_items %}
 
{{
    config(
        target_schema='intermediate',
        unique_key='item_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
 
select * from {{ ref('stg_items') }}
 
{% endsnapshot %}