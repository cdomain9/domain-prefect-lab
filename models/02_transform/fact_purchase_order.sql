with purchaseorderdetail as (

    select * from {{ref('stg_purchase_order_detail')}}
),

purchaseorderheader as (
    select * from {{ ref('stg_purchase_order_header')}}
),

shipmethod as (
    select * from {{ ref('stg_ship_method')}}
),

final as (
    select
      pod.purchase_order_id || '~' || pod.purchase_order_detail_id as purchase_order_sk,
      pod.purchase_order_id,
      pod.purchase_order_detail_id,
      pod.purchase_order_due_date,
      pod.purchase_order_quantity,
      pod.material_product_id,
      pod.material_unit_price,
      pod.purchase_order_detail_line_total,
      pod.received_material_quantity,
      pod.rejected_material_quantity,
      pod.stocked_material_quantity,
      poh.purchase_order_revision_number,
      poh.purchase_order_status,
      poh.employee_id,
      poh.material_vendor_id,
      poh.material_ship_method_id,
      poh.material_ship_date,
      poh.purchase_order_sub_total,
      poh.purchase_order_tax_amount,
      poh.material_freight,
      poh.purchase_order_total_due,
      sm.ship_base,
      sm.ship_rate

      from purchaseorderdetail pod
      left join purchaseorderheader poh on (poh.purchase_order_id=pod.purchase_order_id)
      left join shipmethod sm on (sm.ship_method_id = poh.material_ship_method_id)
)

select * from final