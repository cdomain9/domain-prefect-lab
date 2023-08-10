with address as (
    select * from {{ source('aw_person','address')}}

),

final as (
    select 
      addressid as address_id,
      addressline1 as address_line_1,
      addressline2 as address_line_2,
      city,
      stateprovinceid as state_province_id,
      postalcode as postal_code,
      spatiallocation as spatial_location,
      rowguid as row_guid,
      modifieddate as last_update
    from address  
)

select * from final