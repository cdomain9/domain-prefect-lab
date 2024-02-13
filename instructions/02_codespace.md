# Set up Development Environment
This lab makes use of Github's [Codespaces](https://github.com/features/codespaces) which is effectively a hosted VScode notebook in the cloud for your use. We've chosen this as each codespace comes with the necessary dependencies to begin learning immediately. If you haven't already done so, follow [this](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=639686550&skip_quickstart=true&template=false) link to create a codespace. Please enter your Snowflake credentials before creation so you'll be able to connect to a warehouse automatically within the codespace.

Github gives you 60 hours of a running codespace per month for free (no signup required). It's not anticipated that this lab will take that long, but please be cognizant of spinning down the codespace when you step away or complete the lab.

# Connect to Prefect Cloud
Next, we'll want to connect our running codespace to Prefect cloud so we can register our data flows and make them executable via the cloud UI. We can do this through the following command (have your API key handy from the previous step!).

```
prefect cloud login -k <api_key>
```

You should see output signifying a successful connection to the workspace you created in the previous step.

```
Authenticated with Prefect Cloud! Using workspace 'account/workspace-name'.
```

[Previous Page](01_Prefect_Cloud_Setup.md) | [Next Page](03_development_and_blocks.md)
