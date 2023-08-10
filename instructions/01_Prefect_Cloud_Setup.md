1. [Set up account on Prefect Cloud](#set-up-account-on-prefect-cloud)
2. [Create a workspace](#create-a-workspace)
3. [Create an API Key](#create-api-key)

# Set up account on Prefect Cloud

Go to Prefect Cloud's website, [https://www.prefect.io/cloud/](https://www.prefect.io/cloud/), and click Get Started in the upper-right corner of the screen.

![image](https://github.com/analytics8/prefect-dbt-starter/assets/111780069/3f0e9475-c8e0-4635-a0b8-56b8e5e6609e)

You'll be prompted to sign in with Google, Microsoft, or even Github. Select a personal email or personal Github account to set up an account with. 

![image](https://github.com/analytics8/prefect-dbt-starter/assets/111780069/b6b907a1-f494-4c2a-88b2-5bbafae10958)

## Create a workspace

A workspace is a discrete environment within Prefect Cloud for your flows and deployments. Workspaces are only available to Prefect Cloud accounts. With the free, personal tier of Prefect Cloud, you are only allowed one free workspace.

Once you create your Prefect account, you should be brought to this screen:

![image](https://github.com/analytics8/prefect-dbt-starter/assets/111780069/917e5b0d-7a3d-4be2-835d-09bc6267d753)

Click Create Workspace, enter a name for your workspace, and select Create. You should see your workspace created and the following tabs on the left-hand side:

![image](https://github.com/analytics8/prefect-dbt-starter/assets/111780069/a17a99d2-bf7f-4db9-ac97-3f1df5a264c6)

## Create API Key

API Keys allow you to authenticate a local environment to work with Prefect Cloud. 

To create an API Key for your Prefect Cloud account, click on your account icon image in the lower left-hand corner of your workspace screen to bring up account settings, and then select your name to bring up your profile settings:

![image](https://github.com/analytics8/prefect-dbt-starter/assets/111780069/f78dd025-e650-420c-8f4f-57823abadf5a)

Once in your profile settings, select API Keys:

![image](https://github.com/analytics8/prefect-dbt-starter/assets/111780069/8216cf51-e352-4c1b-8599-984970758ead)

Create an API Key by giving it a name and expiration date (ideally enough time to complete this lab):

![image](https://github.com/analytics8/prefect-dbt-starter/assets/111780069/ca29aa11-335d-45ef-9375-628ee51912cd)

Once you create your API Key, a screen will pop up that gives you your key or gives you an option to save your key to your active profile. 

**Make sure you copy the key somewhere before closing the screen. You will not be able to view it after closing the screen.**


[Previous Page](./00_Orchestration_Prefect_Intro.md) | [Next Page](02_codespace.md)