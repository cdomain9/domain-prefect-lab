import requests
import logging
from prefect_snowflake.database import SnowflakeConnector
import csv
from prefect import task, flow

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Step 1: Get weather history data from a weather API (London)
@task
def save_response_to_csv(url="https://archive-api.open-meteo.com/v1/archive", params=None, filename="data/weather_data.csv"):
    if params is None:
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

    if response.status_code == 200:
        data = response.json()
        print("Parameters:")
        for key, value in params.items():
            print(f"{key}: {value}")

        # Write the response data to a CSV file
        with open(filename, "w", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(data["daily_units"].keys())  # Write the header row
            writer.writerows(zip(*data["daily"].values()))  # Write the data rows
        print(f"Response data saved to {filename}")
    else:
        print("Failed to retrieve data. Status code:", response.status_code)

@task
def insert_csv_data_to_snowflake(csv_file_path="data/weather_data.csv", table_name="weather_raw"):
    # Step 2: Establish a connection to Snowflake
    logging.info("Establishing a connection to Snowflake...")
    conn = SnowflakeConnector.load("SNOWFLAKE_CONNECTOR")
    logging.info("Connection to Snowflake established successfully.")

    try:
        # Step 3: Begin a transaction
        conn.execute('BEGIN')

         # Step 4: Drop the table if it exists
        drop_table_command = f"DROP TABLE IF EXISTS {table_name}"
        conn.execute(drop_table_command)
        logging.info(f"Dropped table {table_name} if it exists.")

        # Step 5: Recreate the table
        create_table_command = f"""CREATE TABLE {table_name} (
            TIME VARCHAR(16777216),
            TEMPERATURE VARCHAR(16777216)
        )"""
        conn.execute(create_table_command)
        logging.info(f"Recreated table {table_name}.")

        # Step 6: Upload the CSV file to a Snowflake internal user stage using PUT command
        put_command = f"PUT file://{csv_file_path} @~"
        conn.execute(put_command)

        # Step 7: Prepare the COPY INTO statement to load the CSV data into the table
        copy_command = f"COPY INTO {table_name} FROM @~ FILE_FORMAT=(TYPE=CSV SKIP_HEADER=1)"

        # Step 8: Execute the COPY INTO command
        conn.execute(copy_command)

        # Step 9: Commit the transaction
        conn.execute('COMMIT')

        logging.info(f"CSV data inserted successfully into {table_name}.")

    finally:
        # Step 10: Remove the csv file from the user stage after the COPY INTO command
        purge_command = "REMOVE @~ PATTERN='.*.csv.gz';"
        conn.execute(purge_command)
        logging.info("Purged the user stage.")

        # Step 11: Close the connection
        conn.close()
        logging.info("Data insertion into the table is successful.")


@flow(name="API to Snowflake")
def api_to_snowflake_flow():
    save_response_to_csv()
    insert_csv_data_to_snowflake()
