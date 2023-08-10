from prefect import flow
from prefect.deployments import Deployment
from dbt import trigger_dbt_flow
from api_to_snowflake import api_to_snowflake_flow

@flow(name="Parent Flow from API")
def weather_flow(params: dict = None):
    api_to_snowflake_flow(params=params)
    trigger_dbt_flow(commands=['dbt deps','dbt run -s +mart_sales_vs_weather'])

# optional: add a deploy function to deploy the flow
def deploy():
    deployment = Deployment.build_from_flow(
        flow=weather_flow,
        name="prefect-parent-flow-deployment-from-api"
    )
    deployment.apply()

if __name__ == "__main__":
    deploy()
