# Document how to deploy prefect flow code to Prefect Cloud
Now that you've written all of your flows, we need to deploy them to Prefect Cloud so that they can be scheduled and run. In order to do that, we use something called a deployment which effectively shares the information needed to trigger your flow from Prefect Cloud.

## Create a deployment
To create a deployment, we'll use the `prefect deployment build` command. This command will create a deployment for each flow in the `flows/` directory. 

```bash
prefect deployment build flows/weather/weather_flow.py:weather_flow --name "Parent Weather Flow from API" --apply
```

Or, if you prefer more pythonic syntax, you can add the following to the bottom of your `weather_flow.py` file and run it with `python3 flows/weather/weather_flow.py`:

```python
from prefect.deployments import Deployment

# ... my parent weather flow code here ...

def deploy():
    deployment = Deployment.build_from_flow(
        flow=weather_flow,
        name="Parent Weather Flow from API"
    )
    deployment.apply()

if __name__ == "__main__":
    deploy()
```

When you run either of the above commands, you'll produce a yaml file with the necessary information Prefect Cloud needs to trigger your flow(s). Put this file in the `/deployments/` directory. Open this file and add some parameters to the `parameters` key. The purpose of this is to define our parameters that we'll use to scope our API request. You can use whatever values you wish, but the default ones we can enter here are:

```yaml
parameters: {"latitude": 51.51,"longitude": -0.13,"start_date": "2011-06-01","end_date": "2014-06-30","daily": "temperature_2m_max","timezone": "Europe/London","temperature_unit": "fahrenheit"}
```

## Trigger a flow run from Prefect Cloud
Once you've done this, you should see a new deployment in the Prefect Cloud UI by going to your deployments page. You can trigger a flow run by clicking on the deployment, and hitting the `Run` button in the top right of the Parent Weather Flow from API deployment page.

[Previous Page](04_flows.md) | [Next Page](06_create_weather_dbt_models.md)