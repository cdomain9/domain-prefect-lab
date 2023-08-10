# Development

- [Lab Overview](#lab-overview)
- [Folder Structure](#folder-structure)
- [Prefect-specific Concepts](#prefect-specific-concepts)
- [Blocks](#blocks)
  - [Credential handling in Codespaces](#credential-handling-in-codespaces)
  - [Snowflake Block](#snowflake-block)
  - [Github](#github)
  - [dbt](#dbt)
  - [Register Blocks](#register-blocks)

## Lab Overview
In this lab, we're going to create a data flow that pulls data from an API, inserts it into Snowflake, and then runs a dbt model dependent on data being inserted into Snowflake before running. This may evolve in the future, but we wish to start with a basic flow to get your feet wet in Orchestration.

### A Caveat
It's not generally recommended to use an orchestrator to actually process data that is meant to land in a warehouse, but for the purpose of keeping this lab simple, we'll develop some python code that takes data from the API and inserts it into Snowflake. In a production type setting, it's highly recommended you use something like Apache Spark/Apache Beam or a dedicated EL tool (Airbyte, Meltano etc.) to perform this processing while using an orchestrator to kick off those jobs and operate on success/failure statuses of each job.

## Folder Structure
Next, let's familiarize ourselves with the folder structure. You'll notice we have some folders similar to those that you might find in a dbt project (macros, models, snapshots, tests) along with some new ones (blocks, deployments, flows). We've prepopulated the dbt-specific folders with models that you'd have created having gone through A8's dbt Cloud and Core trainings. While those labs aren't necessarily prerequisites, it will be helpful if you're familiar with dbt to complete this lab.

## Prefect-specific Concepts

We're going to introduce a few concepts specific to Prefect with each of these folders, but rest assured there are analogies to other orchestrators.

- `blocks`: [Blocks](https://docs.prefect.io/2.11.0/concepts/blocks/?h=blo) are where we store connection configuration information, much like you would in dbt's `profiles.yml` file. This includes storing credential information specific to authenticating to a service defined by this block. For example, we'll define a Snowflake block that allows us to authenticate and connect to Snowflake with a desired warehouse to insert our API data.
- `flows`: [Flows](https://docs.prefect.io/2.11.0/concepts/flows/?h=flows) are the most basic Prefect object. Flows are the only Prefect abstraction that can be interacted with, displayed, and run without needing to reference any other aspect of the Prefect engine. A flow is a container for workflow logic and allows users to interact with and reason about the state of their workflows. It is represented in Python as a single function.
- `deployments`: [Deployments](https://docs.prefect.io/2.11.0/concepts/deployments/?h=deplo) encapsulate a `flow` and it's tasks into a set of configurations necessary to share with Prefect Cloud so we can trigger the pipeline from the UI. Creating a deployment for a Prefect workflow means packaging workflow code, settings, and infrastructure configuration so that the workflow can be managed via the Prefect API and run remotely by a Prefect agent.

To assist in your understanding of these components, it's important to know that Prefect Cloud never actually "sees" your pipeline code. The only information the Cloud has access to is what it needs to know to be able to kick off a pipeline run via API to an "agent" (in this case the agent is the computer running your codespace!). The general process for how a flow runs is this: Trigger run in Cloud UI -> Cloud UI posts API call to an agent (compute) -> Agent receives request -> Agent clones your code repository (Github etc.) -> Agent executes flow code -> Agent returns flow information (success/failure) to Cloud UI

## Blocks
Now that we've got the lay of the land and have connected our codespace to Prefect Cloud, we can begin developing! To start, we're going to register blocks. We'll need to register a block for the following systems:

- Snowflake
- dbt (so dbt can connect to Snowflake)
- Github (so any agent can pull our flow code and execute it)

### Credential handling in Codespaces
Be aware that the code we write to define blocks will use credentials you inputted to Github when you created the codespace as these values are stored as environment variables in our codespace. To check, you could run the following in your codespace terminal:

```
$ echo $ACCOUNT
analytics8.us-east-1
```

These secrets are stored across all codespaces you create, if you need to update them you can do so at this [link](https://github.com/settings/codespaces).

### Snowflake Block
We'll start by defining the Snowflake block. Start by creating a `snowflake_block.py` file in the `/blocks/` directors. In this file, we'll need both the [SnowflakeCredentials](https://prefecthq.github.io/prefect-snowflake/credentials/#prefect_snowflake.credentials.SnowflakeCredentials) class and the [SnowflakeConnector](https://prefecthq.github.io/prefect-snowflake/database/#prefect_snowflake.database.SnowflakeConnector) class.

In the [examples catalog](https://prefecthq.github.io/prefect-snowflake/examples_catalog/) for prefect-snowflake package, you'll find code that looks like this:

```
from prefect_snowflake.credentials import SnowflakeCredentials
from prefect_snowflake.database import SnowflakeConnector

snowflake_credentials = SnowflakeCredentials(
    account="account",
    user="user",
    password="password",
)
snowflake_connector = SnowflakeConnector(
    database="database",
    warehouse="warehouse",
    schema="schema",
    credentials=snowflake_credentials
)
```

This is precisely what we want to have, except we want to load our environment variables instead of hardcoding credentials in a script. Do you know how to load environment variables in python? (hint: you'll need to import the `os` package)

### Github
Let's define all our blocks before we register them with Prefect Cloud. Next we'll define the Github block in a `github_block.py` file within the `/blocks/` directory. This is necessary so that the agent (compute) that's executing our pipeline can access the code that actually defines the pipeline in the first place.

Defining this one is pretty straightfoward if you find the [documentation](https://docs.prefect.io/2.11.0/concepts/filesystems/#github) for this filesystem type.

### dbt
This block will be the most challenging! This is because we're going to load our `SnowflakeConnector` that we defined in the `snowflake_block.py` file and pass it to prefect-dbt's [SnowflakeTargetConfigs](https://prefecthq.github.io/prefect-dbt/cli/configs/snowflake/#prefect_dbt.cli.configs.snowflake.SnowflakeTargetConfigs) class. You'll want to:

- create a file `dbt_block.py`
- import the `SnowflakeConnector` class like you did in `snowflake_block.py`
- import the `SnowflakeTargetConfigs` class from prefect-dbt
- use the `.load()` method to load the `SNOWFLAKE_CONNECTOR` block
- take that loaded block and pass it to the definition of the `SnowflakeTargetConfigs` class
- save the block

As always, if you're having trouble figuring it out, you can check the `answer_key` folder.

### Register Blocks
To register our blocks with Prefect Cloud, we'll run the following command once for each file we've created:

```
prefect block register --file ./blocks/<file_name>.py
```

If you go to the Prefect Cloud UI and navigate to the `Blocks` page, you should see the blocks you just registered.

Congrats! You completed our first step of development.

[Previous Page](./02_codespace.md) | [Next Page](04_flows.md)
