with product as (
    select
      product_id,
      product_name,
      product_number,
      product_make_flag,
      finished_goods_flag,
      product_color,
      product_safety_stock_level,
      product_reorder_point,
      product_standard_cost,
      product_list_price,
      product_size,
      product_size_unit_measure_code,
      product_weight_unit_measure_code,
      product_weight,
      product_days_to_manufacture,
      product_line,
      product_class,
      product_style,
      product_sub_category_id,
      product_model_id,
      product_sell_start_date,
      product_sell_end_date,
      product_discontinued_date,
      row_guid,
      last_update

    from {{ ref('stg_product')  }}
)

select * from product