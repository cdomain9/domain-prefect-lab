# Run your Pipeline!
To run your pipeline, we'll first need to start what Prefect calls an agent or work pool. This is basically a computer that "polls" Prefect Cloud for work to do. When it finds work, it will execute it. To start an agent, we'll run the following command:

```bash
prefect worker start --pool 'my-work-pool-name' --type process
```

You should now have a running worker if you go to the Work Pools tab in your Prefect Cloud UI workspace. You should see that the "Last Polled" field on your worker is updating every few seconds. This means that your worker is actively connected and looking for work to do.

In more "production" type settings, we'd likely have a worker running on a server somewhere that's always connected and looking for work to do. For the purposes of this lab, we'll just run a worker locally in the codespace. It's common to use tools like Kubernetes or Docker to run prefect workers in production.

You can now go to your deployments page, click on the deployment you created earlier, and run the deployment! You should see the logs from your flow run in the terminal where you started your worker. You can also see the logs in the Prefect Cloud UI by clicking on the flow run that was triggered by the deployment.

<img width="1440" alt="Screenshot 2023-07-27 at 8 39 29 AM" src="https://github.com/analytics8/prefect-dbt-starter/assets/44027587/a5915967-97e9-412d-8228-b3aae4999a60">

[Previous Page](06_create_weather_dbt_models.md)
