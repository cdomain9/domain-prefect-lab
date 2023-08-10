with salesperson as (
    select
      business_entity_id,
      territory_id,
      sales_quota,
      sales_person_bonus,
      sales_commission_percent,
      sales_year_to_date,
      sales_last_year,
      row_guid,
      last_update
    from {{ref('stg_sales_person')}}
)

select * from salesperson