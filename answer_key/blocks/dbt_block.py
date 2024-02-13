from prefect_dbt.cli.configs import SnowflakeTargetConfigs
from prefect_snowflake import SnowflakeConnector

connector = SnowflakeConnector.load("snowflake-connector")

dbt_profiles = SnowflakeTargetConfigs(
    connector=connector
)
dbt_profiles.save("snowflake-dbt-profile", overwrite=True)
