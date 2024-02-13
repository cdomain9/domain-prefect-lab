with salesterritoryhistory as (
    select * from {{source('aw_sales','salesterritoryhistory') }}

),

final as (
    select
      businessentityid || '~' || territoryid as sales_territory_history_sk,
      businessentityid as business_entity_id,
      territoryid as sales_territory_id,
      to_timestamp_ntz(startdate) as sales_person_territory_start_date,
      to_timestamp_ntz(enddate) as sales_person_territory_end_date,
      rowguid as row_guid,
      modifieddate as last_update
    from salesterritoryhistory
)

select * from final