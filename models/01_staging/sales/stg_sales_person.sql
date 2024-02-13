with salesperson as (
    select * from {{source('aw_sales','salesperson') }}

),

final as (
    select
      businessentityid as business_entity_id,
      territoryid as territory_id,
      salesquota as sales_quota,
      bonus as sales_person_bonus,
      commissionpct as sales_commission_percent,
      salesytd as sales_year_to_date,
      saleslastyear as sales_last_year,
      rowguid as row_guid,
      modifieddate as last_update
    from salesperson
)

select * from final