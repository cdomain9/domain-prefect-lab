with salesorderdetail as (

  select * from {{ ref( 'fact_sales_order_detail') }}
),

dim_date as (

  select * from {{ ref('dim_date') }}
),

dim_customer as (

  select * from {{ ref('dim_customer') }}
),

dim_sales_person as (

  select * from {{ ref('dim_sales_person') }}
),

dim_ship_method as (

  select * from {{ ref('dim_ship_method') }}
),

dim_product as (

  select * from {{ ref('dim_product') }}
),

dim_sales_territory as (

  select * from {{ ref('dim_sales_territory') }}
),

final as (

select
    sod.*,
    d.last_day_of_week as order_is_last_day_of_week,
    d.date_actual as order_date_day,
    {{ dbt_utils.star(from=ref('dim_customer'), relation_alias = 'c', except=["business_entity_id"], prefix="customer_") }},
    {{ dbt_utils.star(from=ref('dim_date'), relation_alias='d', except = ["business_entity_id"], prefix="date_") }},
    {{ dbt_utils.star(from=ref('dim_product'), relation_alias='pr', except=["product_id", "product_weight", "product_list_price", "product_standard_cost", "last_update"], prefix="product_") }},
    {{ dbt_utils.star(from=ref('dim_sales_person'), relation_alias='sp', except=["business_entity_id", "territory_id", "last_update"], prefix="sales_per_") }},
    {{ dbt_utils.star(from=ref('dim_sales_territory'), relation_alias='st', except=["sales_territory_id", "last_update"], prefix="territory_") }},
    {{ dbt_utils.star(from=ref('dim_ship_method'), relation_alias='sm', except=["ship_method_id", "last_update"], prefix="ship_method_") }}

from salesorderdetail sod
    left join dim_customer c
        on c.customer_id = sod.business_entity_id
    left join dim_date d
        on d.date_actual = sod.sales_order_date
    left join dim_product pr
        on pr.product_id = sod.product_id
    left join dim_sales_person sp
        on sp.business_entity_id = sod.business_entity_id
    left join dim_sales_territory st
        on st.sales_territory_id = sod.sales_territory_id
    left join dim_ship_method sm
        on sm.ship_method_id = sod.ship_method_id
)

select * from final