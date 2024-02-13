with salesterritory as (
    select * from {{source('aw_sales','salesterritory') }}

),

final as (
    select
      territoryid as sales_territory_id,
      name as sales_territory_name,
      countryregioncode as sales_country_region_code,
      "GROUP" as sales_territory_group,
      salesytd as sales_year_to_date,
      saleslastyear as sales_last_year,
      costytd as sales_cost_year_to_date,
      costlastyear as sales_cost_last_year,
      rowguid as row_guid,
      modifieddate as last_update
    from salesterritory
)

select * from final