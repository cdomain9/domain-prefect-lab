from prefect_snowflake import SnowflakeCredentials, SnowflakeConnector
import os

credentials = SnowflakeCredentials(
    account=os.environ.get("ACCOUNT"),
    user=os.environ.get("USERNAME"),
    password=os.environ.get("PASSWORD"),
    role=os.environ.get("ROLE")
)
credentials.save("snowflake-credentials", overwrite=True)

connector = SnowflakeConnector(
    credentials=credentials,
    database=os.environ.get("DATABASE"),
    schema=os.environ.get("SCHEMA"),
    warehouse=os.environ.get("WAREHOUSE"),
)
connector.save("snowflake-connector", overwrite=True)
