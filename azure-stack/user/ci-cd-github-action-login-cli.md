---
title: Use the Azure login action with Azure CLI and PowerShell on Azure Stack Hub 
description: Use the Azure login action with Azure CLI and PowerShell to create a continuous integration, continuous deployment (CI/CD) workflow on Azure Stack Hub
author: mattbriggs
ms.topic: overview
ms.date: 1/11/2021
ms.author: mabrigg
ms.reviewer: gara
ms.lastreviewed: 1/11/2021

# Intent: As a developer, I want create a continuous integration, continuous deployment workflow on Azure Stack Hub so that I can easily validate, integrate, and publish my solution on Azure Stack Hub.
# Keyword: GitHub Action Azure Stack Hub login

---

# Use the Azure login action with Azure CLI and PowerShell on Azure Stack Hub

You can set up a GitHub Action to sign in to your Azure Stack Hub instance, run PowerShell, and then run a CLI script. This can enable you to create a continuous integration, continuous deployment (CI/CD) workflow for your solution with Azure Stack Hub

GitHub Actions are workflows composed of actions that enable automation right inside of your code repository. The workflows are triggered in your repository. You can perform common DevOps automation tasks such as testing, deployment, and continuous integration. To use GitHub Actions with Azure Stack Hub, you must use a service principle with specific requirements. 

This example workflow includes:
- Instructions on creating and validating your service principle.
- Configuring a Windows 2016 Server core machine as your self-hosted runner to use with Azure Stack Hub.
- A workflow that uses:
    - The Azure Login action
    - The PowerShell script action

### Azure Stack Hub GitHub action

![Azure Stack Hub Github action](.\media\ci-cd-github-action-login-cli\ash-github-actions-v1d1.svg)
Parts of using the self-hosted runner:

- GitHub Action hosted on GitHub
- Self-hosted runner hosted on Azure
- Azure Stack Hub

The workflow runs in GitHub and must interact with your Azure Stack Hub. For this reason, your Azure Stack Hub must be connected to the internet and accessible to the GitHub's servers. In this article, the processes can connect directly to endpoints accessible on the open web. If your Azure Stack Hub requires a secure connection to a datacenter, for example, via a virtual private network, you will need to use a self-hosted runner that can be reached via the open internet. The self-hosted runner can then use a virtual private network to connect to your Azure Stack Hub behind a firewall. This article will walk you through setting up the self-hosted runner to run your Azure Stack Hub specific PowerShell modules.

A limitation of using GitHub actions with Azure Stack Hub is that the process requires using an Azure Stack Hub connected to the web. The workflow is triggered in a GitHub repository. However, you can use both Azure Active Directory (Azure AD) or Active Directory Federated Services (AD FS) as your identity provider.

## Get service principle

A service principle provides role-based credentials so that processes outside of Azure can connect to and interact with resources. You will need an SPN with contributor access and the attributes specified in these instructions to use with your GitHub action.

As a user of Azure Stack Hub you do not have the permission to create the SPN. You will need to request this principle from your Cloud Operator. The instructions are being provided here so that you can create the SPN if you are a cloud operator, or you can validate the SPN if you are a developer using an SPN in your workflow provided by a cloud operator.

The cloud operator will need to create the SPN using Azure CLI.

The following code snippets are written for a Windows machine using the PowerShell prompt with Azure CLI. If you are using CLI on a Linux machine and bash, either remove the line extension or replace them with a `\`.

1. Prepare the values of the following parameters used to create the SPN:

    | Parameter | Example | Description |
    | --- | --- | --- |
    endpoint-resource-manager | "https://management.orlando.azurestack.corp.microsoft.com"  | The resource management endpoint. |
    suffix-storage-endpoint | "orlando.azurestack.corp.microsoft.com"  | The endpoint suffix for storage accounts. |
    suffix-keyvault-dns | ".vault.orlando.azurestack.corp.microsoft.com"  | The Key Vault service dns suffix. |
    endpoint-active-directory-graph-resource-id | "https://graph.windows.net/"  | The Active Directory resource ID. |
    endpoint-sql-management | https://notsupported  | The sql server management endpoint. This must be set to `https://notsupported` |
    profile | 2019-03-01-hybrid | Profile to use for this cloud. |

2. Open your command-line tool such as Windows PowerShell or Bash and sign in. Use the following command:

    ```azurecli
    az login
    ```

3. Use the `register` command for a new environment or the `update` command if you using an existing environment. Use the following command.

    ```azurecli  
    az cloud register `
        -n "AzureStackUser" `
        --endpoint-resource-manager "https://management.orlando.azurestack.corp.microsoft.com" `
        --suffix-storage-endpoint "orlando.azurestack.corp.microsoft.com" `
        --suffix-keyvault-dns ".vault.orlando.azurestack.corp.microsoft.com" `
        --endpoint-active-directory-graph-resource-id "https://graph.windows.net/" `
        --endpoint-sql-management https://notsupported  `
        --profile 2019-03-01-hybrid
    ```

4. Get your subscription ID and resource group that you want to use for the SPN.

5. Create the service principle with the following command with the subscription ID and resource group:

    ```azureCLI
    az ad sp create-for-rbac --name "myApp" --role contributor `
        --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} `
        --sdk-auth
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

## Add service principle to repository

You can use GitHub secrets to encrypt sensitive information to use in your actions. You will create a secret to contain your SPN so that the action can sign in to your Azure Stack Hub instance.

> [!Warning]  GitHub recommends that you don't use self-hosted runners with public repositories Forks of your public repository can potentially run dangerous code on your self-hosted runner machine by creating a pull request that executes the code in a workflow. For more information, see "[About self-hosted runners](https://docs.github.com/en/free-pro-team@latest/github/automating-your-workflow-with-github-actions/about-self-hosted-runners#self-hosted-runner-security-with-public-repositories)."

1. Open or create a GitHub repository. If you need guidance on creating a repository in GitHub, you can find [instructions in the GitHub docs](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/create-a-repo).
1. Set your repository to private.
    1. Select **Settings** > **Change repository visibility**.
    1. Select **Make private**.
    1. Type the name of your repository.
    1. Select **I understand, change the repository visibility**.
1. Select **Settings**.
1. Select **Secrets**.
1. Select **New repository secret**.
    ![Add your GitHub action secret](.\media\ci-cd-github-action-login-cli\github-action-secret.png)
1. Name your secret `AZURE_CREDENTIALS`.
1. Paste the JSON object that represents your SPN.
1. Select **Add secret**.

## Create a self-hosted runner

You can set up a self-hosted runner in the GitHub Docs. A self-hosted runner can be run on any machine that can connect to GitHub. You may choose to use a self-hosted runner if you have an automation task in your workflow that requires extensive dependencies, specific licensing requirements such as a USB dongle for a software license, or other machine or software-specific needs. Your machine can be a physical machine, a VM, a container and located in your data center or in the cloud.

In this article, we are going to use a Windows VM hosted in Azure that will be configured with Azure Stack Hub specific PowerShell requirements.

For instructions on setting up, configuring, and connecting your self-hosted runner to your repository, see the GitHub Docs, "[About self-hosted runners](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/about-self-hosted-runners)". Once your have your runner added to your repository, you can find instructions on adding the runner as an action in your workflow.

![Self hosted runner connected](.\media\ci-cd-github-action-login-cli\github-actions-self-hosted-runner.png)

Make a note of yourself hosted runner's name.

## Create your VM and install prerequisites

1. Create your self-hosted runner. The runner can be any computer that can be reached by GitHub. You can create you are a VM as your runner in Azure, in Azure Stack Hub, or elsewhere. These instructions create a runner as a Windows VM in Azure. If you need to connect to your Azure Stack Hub hosted in a datacenter, you may require a VPN connection. You can find instructions on enabling the connection in the section [Install Azure Stack Hub Tools on your custom runner][#stall-azure-stack-hub-tools-on-your-custom-runner] that may require a VPN connection.
    - For guidance on creating a Windows VM in Azure, see [Quickstart: Create a Windows virtual machine in the Azure portal](https://docs.microsoft.com/azure/virtual-machines/windows/quick-create-portal). To follow these instructions, install Windows Server 2016 Core.
    - For guidance on creating a Windows VM in Azure Stack Hub, see [Quickstart: Create a Windows server VM with the Azure Stack Hub portal](https://docs.microsoft.com/azure-stack/user/azure-stack-quick-windows-portal). To follow these instructions, install Windows Server 2016 Core.
2. Use remote connection to connect to your Windows 2016 server using the server IP address, username, and password that you defined when creating the machine.
3. Install Chocolatey. Chocolatey is a package manager for Windows that you can use to install and manage dependencies from the command line. From an elevated PowerShell prompt, type:
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    ```
4. Install PowerShell Core. From an elevated PowerShell prompt, type:
    ```powershell  
    choco install powershell-core
    ```
5. Install Azure CLI. From an elevated PowerShell prompt, type:
    ```powershell  
    choco install azure-cli
    ```
6. Install Azure Stack Hub PowerShell. From an elevated PowerShell prompt, type:
    ```powershell  
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Install-Module -Name Az.BootStrapper -Force -AllowPrerelease
    Install-AzProfile -Profile 2019-03-01-hybrid -Force
    Install-Module -Name AzureStack -RequiredVersion 2.0.2-preview -AllowPrerelease
    ```
    For more information about using the Azure Stack Hub Az modules, see [Install PowerShell Az module for Azure Stack Hub](https://docs.microsoft.com/azure-stack/operator/powershell-install-az-module).
7. Restart your computer. From an elevated PowerShell prompt, type:
    ```powershell  
    shutdown /r
    ```
8. Add the machine as a self-hosted runner to your GitHub repository. You can find instructions on adding a self-hosted runner in the GitHub docs. For more information, see [Adding self-hosted runners](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/adding-self-hosted-runners).

    ![Runner is listening](.\media\ci-cd-github-action-login-cli\github-action-runner-listen.png)

9. When you are done, verify that the service is running and listening to your service. Double check by running.`/run.cmd` from the runner's directory.

### Optional: Install Azure Stack Hub Tools on your custom runner

The instructions in this article do not require access to the Azure Stack Hub tools, but as you develop your own workflow you may need to use the tools. The following instructions can help you install the tools on your Windows self-hosted runner. For more information about Azure Stack Hub tools, see [Download Azure Stack Hub tools from GitHub](https://docs.microsoft.com/azure-stack/operator/azure-stack-powershell-download?&tabs=az). These instructions assume you have installed the package manager Chocolatey.

1. Install Git.
    ```powershell  
    choco install git
    ```

2. From an elevated PowerShell prompt, type:
    ```powershell
    # Change directory to the root directory.
    cd \
    
    # Download the tools archive.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
    invoke-webrequest `
      https://github.com/Azure/AzureStack-Tools/archive/az.zip `
      -OutFile az.zip
    
    # Expand the downloaded files.
    expand-archive az.zip `
      -DestinationPath . `
      -Force
    
    # Change to the tools directory.
    cd AzureStack-Tools-az
    ```

3. If you need your runner to connect to your Azure Stack Hub instance, you can use PowerShell. You can find the instructions in the article [Connect to Azure Stack Hub with PowerShell](https://docs.microsoft.com/azure-stack/operator/azure-stack-powershell-configure-admin?&tabs=az1%2Caz2%2Caz3).
### Manual steps for installing PowerShell resources

This section contains the steps you can use to install Azure Stack Hub PowerShell resources on the computer you will use as your self-hosted runner. You can use the instructions in this section to set up a connection from your self-hosted runner to your Azure Stack Hub instance if it is not accessible through the open web.

1. Add a self-hosted runner to your GitHub repository. 

1. PowerShell Core 6.x or later version is needed. For instructions, see [Installing PowerShell on Windows](https://docs.microsoft.com/powershell/scripting/install/installing-powershell-core-on-windows).
1. Configure your runner to run Azure Stack Hub PowerShell. You can find instructions on installing PowerShell for Azure Stack Hub [Install PowerShell Az module for Azure Stack Hub](https://docs.microsoft.com/azure-stack/operator/powershell-install-az-module).
1. You may need the Azure Stack Hub tools on your runner. You can find instructions for installing the Azure Stack Hub PowerShell tools for the Az modules [Download Azure Stack Hub tools from GitHub](https://docs.microsoft.com/azure-stack/operator/azure-stack-powershell-download?&tabs=az)


## Add the workflow to your repository

Create a new workflow using the yaml in this section to create your workflow.

1. Open your GitHub repository.
2. Select **Actions**.
3. Create a new workflow.
    - If this is your first workflow, select **set up a workflow yourself** under **Choose a workflow template**.
    - If you have existing workflows, select **New workflow** > **Set up a workflow yourself**.

4. In the path, name the file `workflow.yml`.
5. Copy and paste the workflow yml.
    ```yml  
    on: [push]
    
    env:
      ACTIONS_ALLOW_UNSECURE_COMMANDS: 'true'
     
    jobs: 
      azurestack-test:
        runs-on: self-hosted
        steps:
    
          - name: Login to AzureStack with Az Powershell
            uses: azure/login@releases/v1
            with:
              creds: ${{ secrets.AZURE_CREDENTIALS }}
              environment: 'AzureStack'
              enable-AzPSSession: true
          
          - name: Run Az PowerShell Script Against AzureStack
            uses: azure/powershell@v1
            with:
              azPSVersion: '3.1.0'
              inlineScript: |
                hostname
                Get-AzContext
                Get-AzResourceGroup
          
          - name: Login to AzureStack with CLI
            uses: azure/login@releases/v1
            with:
              creds: ${{ secrets.AZURE_CREDENTIALS }}
              environment: 'AzureStack'
              enable-AzPSSession: false
          
          - name: Run Azure CLI Script Against AzureStack
            run: |
              hostname
              az group list --output table
    ```
6. Select **Start commit**.
7. Add the commit title and optional details, and then select **Commit new file**.

When the action runs, verify that it has run successfully.

1. Open your GitHub repository.
1. Select Actions.
1. Select the name of the commit under All workflows.
    ![Review commit summary](.\media\ci-cd-github-action-login-cli\github-actions-review-log-summary.png)
1. Select the name of the job, **azurestack-test**.
    ![Review commit summary](.\media\ci-cd-github-action-login-cli\github-action-success-screen.png)
1. Expand the sections to review the return values for your PowerShell and CLI commands.

You can find more Azure Stack Hub actions in the GitHub actions marketplace.

## Next steps

- Learn about [Common deployments for Azure Stack Hub](azure-stack-dev-start-deploy-app.md)  
- Learn about [Use Azure Resource Manager templates in Azure Stack Hub](azure-stack-arm-template.md)  
- Review the DevOps hybrid cloud pattern, [DevOps pattern](https://docs.microsoft.com/hybrid/app-solutions/pattern-cicd-pipeline)