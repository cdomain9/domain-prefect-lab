select 
  time as weather_timestamp,
  temperature
from {{ source('weather', 'weather_raw') }}