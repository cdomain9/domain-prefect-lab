with stateprovince as (
    select * from {{ source('aw_person','stateprovince')}}

),

final as (
    select 
      stateprovinceid as state_province_id,
      stateprovincecode as state_province_code,
      countryregioncode as country_region_abbv,
      isonlystateprovinceflag as is_only_state_province_flag,
      name as state_province_name,
      territoryid as territory_id,
      rowguid as row_guid,
      modifieddate as last_update

    from stateprovince  
)

select * from final