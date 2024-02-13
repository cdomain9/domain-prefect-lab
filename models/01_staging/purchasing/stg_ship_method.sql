with shipmethod as (
    select * from {{ source('aw_purchasing','shipmethod')}}

),

final as (
    select 
      shipmethodid as ship_method_id,
      name as ship_method_name,
      shipbase as ship_base,
      shiprate as ship_rate,
      rowguid as row_guid,
      modifieddate as last_update

    from shipmethod  
)

select * from final