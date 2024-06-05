{% snapshot snap_stg_merchants %}
 
{{
    config(
        target_schema='intermediate',
        unique_key='merchant_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
 
select * from {{ ref('stg_merchants') }}
 
{% endsnapshot %}