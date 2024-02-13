with shipmethod as (
    select
      ship_method_id,
      ship_method_name,
      ship_base,
      ship_rate,
      row_guid,
      last_update
    from {{ ref('stg_ship_method')}}
)

select * from shipmethod