with purchaseorderdetail as (
    select * from {{ source('aw_purchasing','purchaseorderdetail')}}

),

final as (
    select 
      purchaseorderid as purchase_order_id,
      purchaseorderdetailid as purchase_order_detail_id,
      duedate as purchase_order_due_date,
      orderqty as purchase_order_quantity,
      productid as material_product_id,
      unitprice as material_unit_price,
      linetotal as purchase_order_detail_line_total,
      receivedqty as received_material_quantity,
      rejectedqty as rejected_material_quantity,
      stockedqty as stocked_material_quantity,
      modifieddate as last_update
    from purchaseorderdetail  
)

select * from final