---
title: Use the Azure web apps deploy action to Azure Stack Hub 
description: Use the Azure web apps deploy action to create a continuous integration, continuous deployment (CI/CD) workflow to Azure Stack Hub
author: mattbriggs
ms.topic: how-to
ms.date: 2/03/2021
ms.author: mabrigg
ms.reviewer: gara
ms.lastreviewed: 2/03/2021

# Intent: As a developer, I want to create a continuous integration, continuous deployment workflow on Azure Stack Hub so I can easily validate, integrate, and publish my solution on Azure Stack Hub.
# Keyword: GitHub Actions Azure Stack Hub web app deploy

---

# Use the Azure web app deploy action to Azure Stack Hub

You can set up GitHub Actions to xxx. This article will help you get up and running with automated deployment using GitHub Actions and Azure Stack Hub.

GitHub Actions are workflows composed of actions that enable automation right inside of your code repository. You can trigger the workflows with events in your GitHub development process. You can perform common DevOps automation tasks such as testing, deployment, and continuous integration.

To use GitHub Actions with Azure Stack Hub, you must use a service principal (SPN) with specific requirements. In this article, you will create a *self-hosted runner*. GitHub allows you to use any machine that can be reached by GitHub in your GitHub Actions. You can create you a virtual machine (VM) as your runner in Azure, in Azure Stack Hub, or elsewhere.

This example workflow includes:
- Instructions on creating and validating your SPN.
- Instructions on creating your web app publication profile
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

3. Use the `register` command for a new environment or the `update` command if you using an existing environment. Use the following command.

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

    If you do not have cloud operator privileges, you can also login with the SPN provided to you by your cloud operator. You will need the the client ID, the secret, and your tenant ID. With these values you can use the following Azure CLI commands to create the JSON object you can add to your GitHub repository as a secret.

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

stub

## Add service principal to repository

You can use GitHub secrets to encrypt sensitive information to use in your actions. You will create a secret to contain your SPN so that the action can sign in to your Azure Stack Hub instance.

1. Open or create a GitHub repository. If you need guidance on creating a repository in GitHub, you can find [instructions in the GitHub docs](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/create-a-repo).
1. Set your repository to private.
    1. Select **Settings** > **Change repository visibility**.
    1. Select **Make private**.
    1. Type the name of your repository.
    1. Select **I understand, change the repository visibility**.
1. Select **Settings**.
1. Select **Secrets**.
1. Select **New repository secret**.
    ![Add your GitHub Actions secret](.\media\ci-cd-github-action-login-cli\github-action-secret.png)
1. Name your secret `AZURE_CREDENTIALS`.
1. Paste the JSON object that represents your SPN.
1. Select **Add secret**.

## Add a runtime workflow

select the runtime based on your runtime.
Add the runtime file to `.github/workflows/`.

## Add the web app deploy action

Create a new workflow using the yaml in this section to create your workflow.

1. Open your GitHub repository.
2. Select **Actions**.
3. Create a new workflow.
    - If this is your first workflow, select **set up a workflow yourself** under **Choose a workflow template**.
    - If you have existing workflows, select **New workflow** > **Set up a workflow yourself**.

4. In the path, name the file `workflow.yml`.
5. Copy and paste the workflow yml.
    ```yaml  
    This will be the yaml file.
    ```

6. Select **Start commit**.
7. Add the commit title and optional details, and then select **Commit new file**.

## Trigger your deployment

When the action runs, verify that it has run successfully.

1. Open your GitHub repository. You can trigger the workflow by pushing to the repository.
1. Select **Actions**.
1. Select the name of the commit under **All workflows**.
1. Select the name of the job, **azurestack-test**.
1. Expand the sections to review the return values for your PowerShell and CLI commands.

## Make a change and commit

stub

## Next steps

- Find more actions in the [GitHub Marketplace](https://github.com/marketplace).
- Learn about [Common deployments for Azure Stack Hub](azure-stack-dev-start-deploy-app.md)  
- Learn about [Use Azure Resource Manager templates in Azure Stack Hub](azure-stack-arm-templates.md)  
- Review the DevOps hybrid cloud pattern, [DevOps pattern](https://docs.microsoft.com/hybrid/app-solutions/pattern-cicd-pipeline)
