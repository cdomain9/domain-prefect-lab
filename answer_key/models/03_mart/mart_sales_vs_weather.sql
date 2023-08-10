with sales_by_day as (
  select 
    bill_to_address_id,
    to_date(sales_order_date) as sales_order_date,
    sum(sales_order_line_total) as total_revenue_of_orders,
    sum(sales_order_quantity) as total_quantity_of_orders
  from {{ ref( 'fact_sales_order_detail') }}
  group by 1,2
),

dim_address as (
  select
    address_id
  from {{ ref( 'dim_address') }}
  where city = 'London'
),

sales_by_day_in_london as (
  select
      s.sales_order_date,
      s.total_revenue_of_orders,
      s.total_quantity_of_orders
    from sales_by_day s
    inner join dim_address a on s.bill_to_address_id = a.address_id
),

weather as (
  select
    *
  from {{ ref( 'fact_weather') }}
),

final as (
  select
    date_trunc("month", sl.sales_order_date) as sales_month,
    sum(sl.total_revenue_of_orders) as total_revenue_of_orders,
    sum(sl.total_quantity_of_orders) as total_quantity_of_orders,
    avg(we.temperature) as temperature -- monthly_average_daily_max
  from sales_by_day_in_london sl
  left join weather we on sl.sales_order_date = we.weather_date
  group by 1
  order by 1
)

select * from final
