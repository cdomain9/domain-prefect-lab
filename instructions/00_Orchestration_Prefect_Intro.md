# What is orchestration?

Orchestration is the automation and management of data workflow execution between various sources and components of a data pipeline. In today's landscape of the modern data stack, which consists of a variety of tools that integrate together, orchestration tools are an important part of helping businesses create, automate and monitor end-to-end worfklows across the entire data pipeline no matter what tech stack is being used. 

Some key components of orchestration tools today include:
  - Workflow Management
  - Task Dependency Management
  - Data Extraction
  - Data Transformation
  - Data Loading
  - Scheduling and Monitoring
  - Error Handling and Retry Mechanisms
  - Scalability

Major cloud providers have their own orchestration tools, but there are also some popular open-source orchestration tools, such as Airflow, Dagster, and this lab's orchestration tool...

## Prefect

Prefect is a flexible, modern workflow orchestration tool that allows you to create, schedule and observe data flows using Python code. You can run prefect in your local environment, or in a hosted environment through Prefect Cloud. Access to Prefect Cloud is free using a personal account that limits number of users, workspaces, and how much workflow history is saved. 

Prefect Cloud provides additional features to using Prefect locally, such as:
- User Accounts
- Workflows
- Automations
- Email notifications
- Organizations
- Service accounts
- Custom role-based access controls
- Single Sign-on
- Audit Log
- Collaborators 

We will be utilizing Prefect Cloud some of these features in the lab, but to read more about what all of these features entail, see the documentation on [Prefect Cloud features](https://docs.prefect.io/latest/cloud/).

Here's a look at an example of how Prefect's Cloud UI can make tracking different scheduled flows easy and clear:

![image](https://github.com/analytics8/prefect-dbt-starter/assets/111780069/06124ab9-4eb5-4eab-8d1d-54a1f45dc442)


## Additional Readings

[Prefect Docs](https://docs.prefect.io/latest/)

[Why Prefect?](https://www.prefect.io/guide/blog/why-prefect/)

[Next Page](./01_Prefect_Cloud_Setup.md)
