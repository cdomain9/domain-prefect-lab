from prefect import flow
from prefect_dbt import DbtCoreOperation, DbtCliProfile, SnowflakeTargetConfigs

@flow
def trigger_dbt_flow(commands: list) -> str:
    snowflake_target_configs = SnowflakeTargetConfigs.load("snowflake-dbt-profile")
    dbt_cli_profile = DbtCliProfile(
        name="a8snowflake",
        target="dev",
        target_configs=snowflake_target_configs,
    )
    result = DbtCoreOperation(
        commands=commands,
        profiles_dir=".",
        dbt_cli_profile=dbt_cli_profile
    ).run()
    return result
