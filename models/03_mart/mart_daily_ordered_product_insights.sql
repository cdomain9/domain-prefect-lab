with product_summations as (

select
    material_product_id as product_id,
    purchase_order_due_date,
    sum(received_material_quantity) received_material_quantity,
    sum(rejected_material_quantity) as rejected_material_quantity,
    sum(stocked_material_quantity) as stocked_material_quantity,
    sum(purchase_order_quantity) as total_ordered_quantity
from {{ref('fact_purchase_order')}}
group by 1,2
)
,

percents_calcs as (
select
    product_id,
    purchase_order_due_date,
    (received_material_quantity/total_ordered_quantity) as percent_delivered,
    (rejected_material_quantity/received_material_quantity) as percent_rejected,
    (stocked_material_quantity/received_material_quantity) as percent_stocked
from product_summations
)
,

final_indicators as (

select
    product_id || '~' || purchase_order_due_date as product_date_sk,
    product_id,
    purchase_order_due_date,
    percent_delivered,
    case 
        when percent_delivered <= .90 then 1
        else 0
    end as late_delivery_flag,
    percent_rejected,
    percent_stocked,
    case 
        when percent_rejected >= .05 then 1
        else 0
    end as quality_issue_flag
from percents_calcs

)

select * from final_indicators