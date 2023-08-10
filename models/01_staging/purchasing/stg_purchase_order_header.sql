with purchaseorderheader as (
    select * from {{ source('aw_purchasing','purchaseorderheader')}}

),

final as (
    select 
      purchaseorderid as purchase_order_id,
      revisionnumber as purchase_order_revision_number,
      status as purchase_order_status,
      employeeid as employee_id,
      vendorid as material_vendor_id,
      shipmethodid as material_ship_method_id,
      to_timestamp_ntz(orderdate) as purchase_order_date,
      to_timestamp_ntz(shipdate) as material_ship_date,
      subtotal as purchase_order_sub_total,
      taxamt as purchase_order_tax_amount,
      freight as material_freight,
      totaldue as purchase_order_total_due,
      modifieddate as last_update

    from purchaseorderheader  
)

select * from final