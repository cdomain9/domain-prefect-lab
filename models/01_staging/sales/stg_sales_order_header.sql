with salesorderheader as (
    select * from {{source('aw_sales','salesorderheader') }}

),

final as (
    select
      salesorderid as sales_order_id,
      revisionnumber as revision_number,
      to_timestamp_ntz(orderdate) as sales_order_date,
      to_timestamp_ntz(duedate) as sales_order_due_date,
      to_timestamp_ntz(shipdate) as sales_order_ship_date,
      status as sales_order_status,
      onlineorderflag as online_order_flag,
      salesordernumber as sales_order_number,
      purchaseordernumber as customer_purchase_order_number,
      accountnumber as customer_account_number,
      customerid as customer_id,
      salespersonid as sales_person_id,
      territoryid as sales_territory_id,
      billtoaddressid as bill_to_address_id,
      shiptoaddressid as ship_to_address_id,
      shipmethodid as ship_method_id,
      creditcardid as credit_card_id,
      creditcardapprovalcode as credit_card_approval_code,
      currencyrateid as currency_rate_id,
      subtotal as sub_total,
      taxamt as tax_amount,
      freight as freight,
      totaldue as total_due,
      comment as comment,
      rowguid as row_guid,
      modifieddate as last_update
    from salesorderheader
)

select * from final