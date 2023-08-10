with product as (
    select * from {{ source('aw_production','product')}}

),

final as (
    select
      productid as product_id,
      name as product_name,
      productnumber as product_number,
      makeflag as product_make_flag,
      finishedgoodsflag as finished_goods_flag,
      color as product_color,
      safetystocklevel as product_safety_stock_level,
      reorderpoint as product_reorder_point,
      standardcost as product_standard_cost,
      listprice as product_list_price,
      size as product_size,
      sizeunitmeasurecode as product_size_unit_measure_code,
      weightunitmeasurecode as product_weight_unit_measure_code,
      weight as product_weight,
      daystomanufacture as product_days_to_manufacture,
      productline as product_line,
      class as product_class,
      style as product_style,
      productsubcategoryid as product_sub_category_id,
      productmodelid as product_model_id,
      sellstartdate as product_sell_start_date,
      sellenddate as product_sell_end_date,
      discontinueddate as product_discontinued_date,
      rowguid as row_guid,
      modifieddate as last_update
    from product
    qualify row_number() over (partition by product_id order by last_update desc)=1
)

select * from final