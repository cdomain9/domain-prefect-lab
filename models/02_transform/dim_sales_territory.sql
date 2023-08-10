with salesterritory as (
    select
      sales_territory_id,
      sales_territory_name,
      sales_country_region_code,
      sales_territory_group,
      sales_year_to_date,
      sales_last_year,
      sales_cost_year_to_date,
      sales_cost_last_year,
      row_guid,
      last_update
    from {{ref ('stg_sales_territory') }}
)

select * from salesterritory