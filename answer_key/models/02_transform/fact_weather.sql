select
  to_date(weather_timestamp) as weather_date,
  'London' as city,
  to_number(temperature, '99.9', 9, 5) as temperature
from {{ ref('stg_weather')}}