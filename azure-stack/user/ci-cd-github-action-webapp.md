---
title: Use the Azure web apps deploy action with Azure Stack Hub 
description: Use the Azure web apps deploy action to create a continuous integration, continuous deployment (CI/CD) workflow to Azure Stack Hub
author: mattbriggs
ms.topic: how-to
ms.date: 2/08/2021
ms.author: mabrigg
ms.reviewer: gara
ms.lastreviewed: 2/08/2021

# Intent: As a developer, I want to create a continuous integration, continuous deployment workflow on Azure Stack Hub so I can easily validate, integrate, and publish my solution on Azure Stack Hub.
# Keyword: GitHub Actions Azure Stack Hub web app deploy

---

# Use the Azure web app deploy action with Azure Stack Hub

You can set up GitHub Actions to deploy a web app to your Azure Stack Hub instance. This allows you to set up continuous integration and deployment for your app. This article will help you get up and running with automated deployment using GitHub Actions and Azure Stack Hub. You will create a web app and use the publish profile to create the web app to host your app.

GitHub Actions are workflows composed of actions that enable automation right inside of your code repository. You can trigger the workflows with events in your GitHub development process. You can perform common DevOps automation tasks such as testing, deployment, and continuous integration.

This example workflow includes:
- Instructions on creating and validating your SPN.
- Instructions on creating your web app publish profile
- Adding a runtime-specific workflow
- Adding a matching workflow with web app deploy
## Get service principal

An SPN provides role-based credentials so that processes outside of Azure can connect to and interact with resources. You will need an SPN with contributor access and the attributes specified in these instructions to use with your GitHub Actions.

As a user of Azure Stack Hub you do not have the permission to create the SPN. You will need to request this principle from your cloud operator. The instructions are being provided here so you can create the SPN if you are a cloud operator, or you can validate the SPN if you are a developer using an SPN in your workflow provided by a cloud operator.

The cloud operator will need to create the SPN using Azure CLI.

The following code snippets are written for a Windows machine using the PowerShell prompt with Azure CLI. If you are using CLI on a Linux machine and bash, either remove the line extension or replace them with a `\`.

1. Prepare the values of the following parameters used to create the SPN:

    | Parameter | Example | Description |
    | --- | --- | --- |
    endpoint-resource-manager | "https://management.orlando.azurestack.corp.microsoft.com"  | The resource management endpoint. |
    suffix-storage-endpoint | "orlando.azurestack.corp.microsoft.com"  | The endpoint suffix for storage accounts. |
    suffix-keyvault-dns | ".vault.orlando.azurestack.corp.microsoft.com"  | The Key Vault service dns suffix. |
    endpoint-active-directory-graph-resource-id | "https://graph.windows.net/"  | The Active Directory resource ID. |
    endpoint-sql-management | https://notsupported  | The sql server management endpoint. Set this to `https://notsupported` |
    profile | 2019-03-01-hybrid | Profile to use for this cloud. |

2. Open your command-line tool such as Windows PowerShell or Bash and sign in. Use the following command:

    ```azurecli  
    az login
    ```

3. Use the `register` command for a new environment or the `update` command if you are using an existing environment. Use the following command.

    ```azurecli  
    az cloud register `
        -n "AzureStackUser" `
        --endpoint-resource-manager "https://management.<local>.<FQDN>" `
        --suffix-storage-endpoint ".<local>.<FQDN>" `
        --suffix-keyvault-dns ".vault.<local>.<FQDN>" `
        --endpoint-active-directory-graph-resource-id "https://graph.windows.net/" `
        --endpoint-sql-management https://notsupported  `
        --profile 2019-03-01-hybrid
    ```

4. Get your subscription ID and resource group that you want to use for the SPN.

5. Create the SPN with the following command with the subscription ID and resource group:

    ```azurecli  
    az ad sp create-for-rbac --name "myApp" --role contributor `
        --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} `
        --sdk-auth
    ```

    If you do not have cloud operator privileges, you can also sign in with the SPN provided to you by your cloud operator. You will need the client ID, the secret, and your tenant ID. With these values, you can use the following Azure CLI commands to create the JSON object you can add to your GitHub repository as a secret.

    ```azurecli  
    az login --service-principal -u "<client-id>" -p "<secret>" --tenant "<tenant-ID>" --allow-no-subscriptions
    az account show --sdk-auth
    ```

6. Check the resulting JSON object. You will use the JSON object to create your secret in your GitHub repository that contains your action. The JSON object should have the following attributes:

    ```json
    {
      "clientId": <Application ID for the SPN>,
      "clientSecret": <Client secret for the SPN>,
      "subscriptionId": <Subscription ID for the SPN>,
      "tenantId": <Tenant ID for the SPN>,
      "activeDirectoryEndpointUrl": "https://login.microsoftonline.com/",
      "resourceManagerEndpointUrl": "https://management.<FQDN>",
      "activeDirectoryGraphResourceId": "https://graph.windows.net/",
      "sqlManagementEndpointUrl": "https://notsupported",
      "galleryEndpointUrl": "https://providers.<FQDN>:30016/",
      "managementEndpointUrl": "https://management.<FQDN>"
    }
    ```

## Create the web app publish profile

### Open the create web app blade

1. Sign in to your Azure Stack Hub portal.
1. Select **Create a resource** > **Web + Mobile** > **Web App**.
    ![Create a web app in Azure Stack Hub](\media\ci-cd-github-action-webapp\create-web-app.png)
### To create your web app

1. Select your **Subscription**.
1. Create or select a **Resource Group**.
1. Type the **Name** of your app. The name of the app will appear in the URL for your app, for example, `yourappname.appservice.<region>.<FQDN>`
1. Select the **Runtime stack** for your app. The runtime must match the workflow you use to target your publish profile.
1. Select the **Operating System** (OS) that will host your runtime and app.
1. Select or type the **Region** for your Azure Stack Hub instance.
1. Select the plan based on your Azure Stack Hub instance, region, and app OS.
1. Select **Review + Create**.
1. Review your Web app. Select **Create**.
    ![Review web app in Azure Stack Hub](\media\ci-cd-github-action-webapp\review-azure-stack-hub-web-app.png)
1. Select **Go to resource**.
    ![Get publish profile in Azure Stack Hub](\media\ci-cd-github-action-webapp\get-azure-stack-hub-web-app-publish-profile.png)
1. Select **Get publish profile**. Your publish profile downloads and is named `<yourappname>.PublishSettings`. The file contains an XML with the target values of your web app.
1. Store your publish profile so that you can access it when you create the secrets for your repository.

## Add your secrets to the repository

You can use GitHub secrets to encrypt sensitive information to use in your actions. You will create a secret to contain your SPN and another secret to contain your web app publish profile so that the action can sign in to your Azure Stack Hub instance and build your app to the web app target.

1. Open or create a GitHub repository. If you need guidance on creating a repository in GitHub, you can find [instructions in the GitHub docs](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/create-a-repo).
1. Select **Settings**.
1. Select **Secrets**.
1. Select **New repository secret**.
    ![Add your GitHub Actions secret](.\media\ci-cd-github-action-login-cli\github-action-secret.png)
1. Name your secret `AZURE_CREDENTIALS`.
1. Paste the JSON object that represents your SPN.
1. Select **Add secret**.
1. Select **New repository secret**.
1. Name your secret `AZURE_WEBAPP_PUBLISH_PROFILE`.
1. Open your `<yourappname>.PublishSettings` in a text editor, and then copy and paste the XML into the repository secret.
1. Select **Add secret**.

## Add a runtime workflow

1. Choose a template from the table for your web app runtime.

    | Runtime | Template |
    | --- | --- |
    | DotNet | [dotnet.yml](https://github.com/Azure/actions-workflow-samples/tree/master/AppService/asp.net-core-webapp-on-azure.yml) |
    | NodeJS | [node.yml](https://github.com/Azure/actions-workflow-samples/tree/master/AppService/node.js-webapp-on-azure.yml) |
    | Java | [java_jar.yml](https://github.com/Azure/actions-workflow-samples/tree/master/AppService/java-jar-webapp-on-azure.yml) |
    | Java | [java_war.yml](https://github.com/Azure/actions-workflow-samples/tree/master/AppService/java-war-webapp-on-azure.yml) |
    | Python | [python.yml](https://github.com/Azure/actions-workflow-samples/tree/master/AppService/python-webapp-on-azure.yml) |
    | PHP | [php.yml](https://github.com/Azure/actions-workflow-samples/blob/master/AppService/php-webapp-on-azure.yml) |
    | DOCKER | [docker.yml](https://github.com/Azure/actions-workflow-samples/blob/master/AppService/docker-webapp-container-on-azure.yml) |

2. Place the template GitHub action workflow directory in your project repository: `.github/workflows/<runtime.yml>` Your workflow directory will contain two workflows.

## Add the web app deploy action

Create a second workflow using the yaml in this section. In this example, you are deploying a Python web app. You would need to select a setup action based on your workflow.

1. Open your GitHub repository. If you have not already added your web app application resources, add them now. In this example, I am using the [Python Flask Hello World](https://github.com/Azure-Samples/python-docs-hello-world) sample, and I added the Python `.gitignore`, `app.py`, and `requirements.txt` files.

    ![Exmaple of the repo using Python Flask with Azure Stack Hub](\media\ci-cd-github-action-webapp\example-of-repo.png)
1. Select **Actions**.
1. Select **New workflow**.
    - If this is your first workflow, select **set up a workflow yourself** under **Choose a workflow template**.
    - If you have existing workflows, select **New workflow** > **Set up a workflow yourself**.

4. In the path, name the file `workflow.yml`.
5. Copy and paste the workflow yml.
    ```yaml  
    # .github/workflows/worfklow.yml
    on: push

    jobs:
      build-and-deploy:
        runs-on: ubuntu-latest
        steps:
        # checkout the repo
        - name: 'Checkout Github Action' 
          uses: actions/checkout@master
    
        - name: Setup Python 3.6
          uses: actions/setup-node@v1
          with:
            python-version: '3.6'
        - name: 'create a virtual environment and install dependencies'
          run: |
            python3 -m venv .venv
            source .venv/bin/activate
            pip install -r requirements.txt
    
        - name: 'Run Azure webapp deploy action using publish profile credentials'
          uses: azure/webapps-deploy@v2
          with:
            app-name: <YOURAPPNAME>
            publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}
    ```

6. In the workflow.yaml update `<YOURAPPNAME>` with your app name.
7. Select **Start commit**.
8. Add the commit title and optional details, and then select **Commit new file**.

## Trigger your deployment

When the action runs, verify that it has run successfully.

1. Open your GitHub repository. You can trigger the workflow by pushing to the repository.
1. Select **Actions**.
1. Select the name of the commit under **All workflows**. Both workflows have logged their status.
    ![Review the status of your GitHub action](\media\ci-cd-github-action-webapp\workflow-success.png)
1. Select the name of the job for the deployment, `.github/workflows/workflow.yml`.
1. Expand the sections to review the return values for your workflow actions. Find the URL for your deployed web app.
    ![Find your Azure Stack Hub web app URL](\media\ci-cd-github-action-webapp\review-cli-log-and-get-url.png)
1. Open a web browser and load the URL.
## Next steps

- Find more actions in the [GitHub Marketplace](https://github.com/marketplace).
- Learn about [Common deployments for Azure Stack Hub](azure-stack-dev-start-deploy-app.md)  
- Learn about [Use Azure Resource Manager templates in Azure Stack Hub](azure-stack-arm-templates.md)  
- Review the DevOps hybrid cloud pattern, [DevOps pattern](https://docs.microsoft.com/hybrid/app-solutions/pattern-cicd-pipeline)
