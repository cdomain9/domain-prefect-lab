with salesorderdetail as (
    select
      sales_order_id,
      sales_order_detail_id,
      carrier_tracking_number,
      sales_order_quantity,
      product_id,
      special_offer_id,
      product_unit_price,
      product_unit_price_discount,
      sales_order_line_total,
      row_guid,
      last_update
    from {{ ref ('stg_sales_order_detail')}}

),  salesorderheader as (

    select
      sales_order_id,
      revision_number,
      sales_order_date,
      sales_order_due_date,
      sales_order_ship_date,
      sales_order_status,
      online_order_flag,
      sales_order_number,
      customer_purchase_order_number,
      customer_account_number,
      customer_id,
      sales_person_id,
      sales_territory_id,
      bill_to_address_id,
      ship_to_address_id,
      ship_method_id,
      credit_card_id,
      credit_card_approval_code,
      currency_rate_id,
      sub_total,
      tax_amount,
      freight,
      total_due,
      comment,
      row_guid,
      last_update
    from {{ref('stg_sales_order_header')}}

), customer as (
   select
     customer_id
    from {{ref('stg_customer')}}

),  salesterritory as (
    select
      sales_territory_id,
      sales_year_to_date,
      sales_last_year
    from {{ref('stg_sales_territory')}}
),

salesperson as (
    select
      business_entity_id,
      sales_quota,
      sales_person_bonus,
      sales_commission_percent,
      sales_year_to_date,
      sales_last_year
    from {{ ref('stg_sales_person')}}
),

shipmethod as (
    select
      ship_method_id,
      ship_base,
      ship_rate
    from {{ref('stg_ship_method')}}

),

final as (

  select
    {{ dbt_utils.generate_surrogate_key(['sod.sales_order_id', 'sod.sales_order_detail_id'])}} as sales_order_detail_sk,
    IFNULL(soh.customer_id,-1) as business_entity_id,
    sod.sales_order_detail_id,
    soh.sales_order_id,
    sod.product_id,
    sod.special_offer_id,
    soh.online_order_flag,
    soh.customer_account_number,
    soh.customer_id,
    IFNULL(soh.sales_person_id,-1) as sales_person_id,
    soh.sales_territory_id,
    soh.bill_to_address_id,
    soh.ship_to_address_id,
    soh.ship_method_id,
    to_timestamp_ntz(sod.last_update) as sales_order_detail_last_update,
    to_timestamp_ntz(soh.sales_order_date) as sales_order_date,
    to_timestamp_ntz(soh.Sales_order_due_date) as sales_order_due_date,
    to_timestamp_ntz(soh.sales_order_ship_date) as sales_order_ship_date,
    to_timestamp_ntz(soh.last_update) as sales_order_header_last_update,
    sod.sales_order_quantity,
    sod.product_unit_price,
    sod.product_unit_price_discount,
    sod.sales_order_line_total,
    soh.sub_total,
    soh.tax_amount,
    soh.freight,
    soh.total_due,
    st.sales_year_to_date as st_sales_ytd,
    st.sales_last_year as st_sales_last_year,
    sp.sales_quota,
    sp.sales_person_bonus,
    sp.sales_commission_percent,
    sp.sales_year_to_date as sp_sales_ytd,
    sp.sales_last_year as sp_sales_last_year,
    sm.ship_base,
    sm.ship_rate

  from salesorderdetail sod
    left join salesorderheader soh on sod.sales_order_id=soh.sales_order_id
    left join customer c on c.customer_id = soh.customer_id
    left join salesterritory st on st.sales_territory_id = soh.sales_territory_id
    left join salesperson sp on sp.business_entity_id = soh.sales_person_id
    left join shipmethod sm on sm.ship_method_id = soh.ship_method_id

)

select * from final