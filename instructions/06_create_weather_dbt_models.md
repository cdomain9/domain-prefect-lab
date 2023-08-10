# dbt Model Development
This section should be pretty brief if you're already familiar with dbt. If you're not, we recommend going through the dbt trainings available [here](https://github.com/analytics8/dbt/tree/main/Training) if you're interested.

If you wish to skip this step because you just want to learn orchestration, feel free to copy the models found in the `/answer_key/models/` directory to your `/models/` directory.

## Create Source Definitions
Create a source yaml file for the `weather_raw` table you land the API data in Snowflake from the `insert_csv_data_to_snowflake` task defined in earlier steps. You can name this file `weather.yml` and place it in the `models/00_sources/weather` directory.

## Create Staging Model
Next step is to create a staging model that does some light transformation like column renaming. We might rename the `time` column to `weather_timestamp`. Define a model yaml for this too.

## Transform Staging to Weather Fact
Create a model that transforms the staging model into a weather fact table. Here we might do a few things like cast `weather_timestamp` to a date, define our city column as whatever city you request API data from (in our case `'London'`), and casting the temperature to a number. Define a model yaml for this too.

## Create Mart Model to Aggregate Sales with Weather Data
We'll select from a few refs to do this:
- ref( 'fact_sales_order_detail')
- ref( 'dim_address')
- ref( 'fact_weather')


Here we'll aggregate `sales_order_line_total` and `sales_order_quantity` by the `sales_order_date` along with the address id. Then we can select only address IDs from `dim_address` that are in London. Finally, we can join the weather data where sales date equals weather date. Define a model yaml for this too.

[Previous Page](05_deployments.md) | [Next Page](07_trigger_pipeline.md)