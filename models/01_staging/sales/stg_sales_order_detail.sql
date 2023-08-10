with salesorderdetail as (
    select * from {{source('aw_sales','salesorderdetail') }}

),

final as (
    select
      salesorderid as sales_order_id,
      salesorderdetailid as sales_order_detail_id,
      carriertrackingnumber as carrier_tracking_number,
      orderqty as sales_order_quantity,
      productid as product_id,
      specialofferid as special_offer_id,
      unitprice as product_unit_price,
      unitpricediscount as product_unit_price_discount,
      linetotal as sales_order_line_total,
      rowguid as row_guid,
      modifieddate as last_update
    from salesorderdetail
)

select * from final