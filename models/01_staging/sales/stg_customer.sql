with customer as (
    select * from {{source('aw_sales','customer') }}

),

final as (
    select
      customerid as customer_id,
      personid as person_id,
      storeid as store_id,
      territoryid as territory_id,
      accountnumber as account_number,
      rowguid as row_guid,
      modifieddate as last_update
    from customer
)

select * from final