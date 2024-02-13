# Flows

- [Create API to Snowflake Flow](#create-api-to-snowflake-flow)
  - [Creating a task in Prefect](#creating-a-task-in-prefect)
  - [`save_response_to_csv`](#save_response_to_csv)
  - [`insert_csv_data_to_snowflake`](#insert_csv_data_to_snowflake)
- [Create dbt Flow](#create-dbt-flow)
- [Create Parent Weather Flow](#create-parent-weather-flow)

You've made it to the fun part of developing on an orchestration platform, writing actual tasks to be completed in a flow/pipeline!

In this lab, we're going to develop three flows. 

1. Request data from API and insert into Snowflake (https://open-meteo.com/)
2. Run dbt job to transform API data after it's been inserted to Snowflake
3. A parent flow to run the above two tasks in succession

We're going to request some weather data from the API in order to build some dbt models that help us understand the relationship between our bike sales and the weather.

You might be wondering, why define the API -> Snowflake flow separately from the dbt job flow? The reason we do this is to try and be DRY-er in our approach. When developing orchestration code for a client, it will be important to not repeat yourself and reuse components that are commonly executed, just with different variables/parameters. Executing a dbt job is something you'd likely reuse over and over again, just passing in a different dbt command with each call. So, we'll define it once and write it such that it can be used by a future parent flow we might write to perform a different process from the one outlined in this lab.

## Create API to Snowflake Flow
Request data from weather api as a task, insert into snowflake as a task. Put this in a directory like `/flows/weather/`. To do this, we'll likely require a couple tasks:

- `save_response_to_csv`: This task will take the response from the API call and save it to a csv file. We'll use this csv file as the source for our Snowflake table.
- `insert_csv_data_to_snowflake`: This task will take the csv file and insert it into a Snowflake table. We'll use the `snowflake.connector` library to do this.

We can load our `SnowflakeConnector` block that we defined earlier to interact with the Snowflake warehouse. We'll also need to load the `requests` library to make the API call.

### Creating a task in Prefect
[Tasks](https://docs.prefect.io/2.11.0/concepts/tasks/?h=tasks) in prefect are defined as functions along with a [decorator](https://pythonbasics.org/decorators/). The decorator is used to define the task's inputs and outputs. The function itself is the task's logic. 

```python
from prefect import task

@task
def example_task(inputs):
    # do something with inputs
    return something
```

Tasks can be strung together using [Flows](https://docs.prefect.io/2.11.0/concepts/flows/?h=flows) to execute tasks in a specific order, and pass results from one task to another.

```python
from prefect import flow

@flow(name="example_flow")
def example_flow():
    result = example_task_1()
    example_task_2(result)
```

### `save_response_to_csv`
For this we'll use the archive API from [open-meteo](https://open-meteo.com/) located at https://archive-api.open-meteo.com/v1/archive. You can make a request using this url and the following parameters:

```python
params = {
    "latitude": 51.51,
    "longitude": -0.13,
    "start_date": "2011-06-01",
    "end_date": "2014-06-30",
    "daily": "temperature_2m_max",
    "timezone": "Europe/London",
    "temperature_unit": "fahrenheit"
}

response = requests.get(url, params=params)
```

The API should respond with `time` and `temperature` data between the start and end dates.

You should parse this data and save this data to a csv file, or alternatively pass the data to your next task to insert it into Snowflake. We write these tasks separately as Prefect will handle errors and allow us to restart from a failure point in our process.

### `insert_csv_data_to_snowflake`
We'll need to load our `SnowflakeConnector` block that we defined earlier to interact with the Snowflake warehouse. You can load it with the following code:

```python
from prefect_snowflake.database import SnowflakeConnector
conn = SnowflakeConnector.load("snowflake-connector")
```

From here, it'll be a good idea to create a table in Snowflake to insert the data into. You can do this with the following code:

```python
create_table_command = f"""CREATE TABLE {table_name} (
    TIME VARCHAR(16777216),
    TEMPERATURE VARCHAR(16777216)
)"""
conn.execute(create_table_command)
```

If you've saved the data to a csv or similar, we can upload the CSV file to a Snowflake internal user stage using PUT command.

```python
put_command = f"PUT file://{csv_file_path} @~"
conn.execute(put_command)
```

And then you may copy the data into the table using the COPY command.

```python
copy_command = f"COPY INTO {table_name} FROM @~ FILE_FORMAT=(TYPE=CSV SKIP_HEADER=1)"
conn.execute(copy_command)
```

As always, if you need help figuring out what code to write exactly, there is help in the `answer_key` directory. Of course, be resourceful and use Prefect's [documentation](https://docs.prefect.io/2.11.0/) for help, and understand that there are many ways to develop code to accomplish the same task.

## Create dbt Flow
We'll put this in a separate subfolder of the `/flows/` directory, something like `/flows/templates` as this will be reused by other parent flows.

For simplicity, since the dbt task really only requires one task in total, we can just skip writing of a task and put logic straight in a flow definition.

```python
@flow
def trigger_dbt_flow(commands: list) -> str:
    # call your flow tasks here to run dbt!
    pass
```

In this flow we'll want to:
- Load the `SnowflakeConnector` block that we defined earlier to interact with the Snowflake warehouse.
- Define a [DbtCliProfile](https://prefecthq.github.io/prefect-dbt/cli/credentials/) class
- Execute a [DbtCoreOperation](https://prefecthq.github.io/prefect-dbt/cli/commands/#prefect_dbt.cli.commands.DbtCoreOperation) that takes your commands and executes them using a `.run()` method.

## Create Parent Weather Flow
Call it `weather_flow.py` in the `/flows/weather/` directory. This flow will be quite simple as well. We'll want to import our api to snowflake flow and our dbt flow. In our flow definition we can define parameters such that we can pass in different ones at each run of our parent flow, defined in the Prefect UI.

```python
@flow(name="Parent Flow from API")
def weather_flow(params: dict = None):
    api_to_snowflake_flow(params=params)
    trigger_dbt_flow(commands=['dbt deps','dbt run -s +mart_sales_vs_weather'])
```

[Previous Page](./03_development_and_blocks.md) | [Next Page](05_deployments.md)