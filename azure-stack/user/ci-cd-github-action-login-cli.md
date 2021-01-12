---
title: Use the Azure login action with Azure CLI and PowerShell on Azure Stack Hub 
description: Use the Azure login action with Azure CLI and PowerShell to create a continuous integration, continuous deployment (CI/CD) workflow on Azure Stack Hub
author: mattbriggs
ms.topic: how-to
ms.date: 1/11/2021
ms.author: mabrigg
ms.reviewer: gara
ms.lastreviewed: 1/11/2021

# Intent: As a developer, I want to create a continuous integration, continuous deployment workflow on Azure Stack Hub so I can easily validate, integrate, and publish my solution on Azure Stack Hub.
# Keyword: GitHub Actions Azure Stack Hub login

---

# Use the Azure login action with Azure CLI and PowerShell on Azure Stack Hub

You can set up GitHub Actions to sign in to your Azure Stack Hub instance, run PowerShell, and then run an Azure CLI script. You can use this as the basis of a continuous integration, continuous deployment (CI/CD) workflow for your solution with Azure Stack Hub. With this workflow, you can automate building, testing, and deploying your solution so that you can focus on writing code. For example by adding some other actions you might use this workflow along with an Azure Resource Manager template to provision a VM, validate an application repository, and then deploy an application to that VM every time you merge to specific branch in GitHub. For now, this article will help you get oriented with GitHub Actions and Azure Stack Hub.

GitHub Actions are workflows composed of actions that enable automation right inside of your code repository. You can trigger the workflows with events in your GitHub development process. You can perform common DevOps automation tasks such as testing, deployment, and continuous integration.

To use GitHub Actions with Azure Stack Hub, you must use a service principal (SPN) with specific requirements. In this article, you will create a *self-hosted runner*. GitHub allows you to use any machine that can be reached by GitHub in your GitHub Actions. You can create you a virtual machine (VM) as your runner in Azure, in Azure Stack Hub, or elsewhere.

This example workflow includes:
- Instructions on creating and validating your SPN.
- Configuring a Windows 2016 Server core machine as GitHub Actions self-hosted runner to work with Azure Stack Hub.
- A workflow that uses:
    - The Azure Login action
    - The PowerShell script action

### Azure Stack Hub GitHub Actions

The following diagram shows the different environments and their relationships.

![Azure Stack Hub Github action](.\media\ci-cd-github-action-login-cli\ash-github-actions-v1d1.svg)
Parts of using the self-hosted runner:

- GitHub Actions hosted on GitHub
- Self-hosted runner hosted on Azure
- Azure Stack Hub

A limitation of using GitHub Actions with Azure Stack Hub is that the process requires using an Azure Stack Hub connected to the web. The workflow is triggered in a GitHub repository. You can use both Azure Active Directory (Azure AD) or Active Directory Federated Services (AD FS) as your identity provider.

Although this is out of the scope of this article, your self-hosted runner can also use a virtual private network to connect to your Azure Stack Hub behind a firewall.

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
        --suffix-keyvault-dns ".vault..<local>.<FQDN>" `
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

## Add service principal to repository

You can use GitHub secrets to encrypt sensitive information to use in your actions. You will create a secret to contain your SPN so that the action can sign in to your Azure Stack Hub instance.

> [!WARNING]  
> GitHub recommends that you don't use self-hosted runners with public repositories Forks of your public repository might run dangerous code on your self-hosted runner machine by creating a pull request that executes the code in a workflow. For more information, see "[About self-hosted runners](https://docs.github.com/en/free-pro-team@latest/github/automating-your-workflow-with-github-actions/about-self-hosted-runners#self-hosted-runner-security-with-public-repositories)."

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

## Create your VM and install prerequisites

1. Create your self-hosted runner. 

    These instructions create a runner as a Windows VM in Azure. If you need to connect to your Azure Stack Hub hosted in a datacenter, you may require a VPN connection. You can find instructions on enabling the connection in the section [Install Azure Stack Hub Tools on your self-hosted runner](#optional-install-azure-stack-hub-tools-on-your-self-hosted-runner) that may require a VPN connection.
    - For guidance on creating a Windows VM in Azure, see [Quickstart: Create a Windows virtual machine in the Azure portal](https://docs.microsoft.com/azure/virtual-machines/windows/quick-create-portal). When following these instructions, install Windows Server 2016 Core.
    - For guidance on creating a Windows VM in Azure Stack Hub, see [Quickstart: Create a Windows server VM with the Azure Stack Hub portal](https://docs.microsoft.com/azure-stack/user/azure-stack-quick-windows-portal). When following these instructions, install Windows Server 2016 Core.
1. Use a remote connection to connect to your Windows 2016 server using the server IP address, username, and password that you defined when creating the machine.
1. Install Chocolatey. Chocolatey is a package manager for Windows that you can use to install and manage dependencies from the command line. From an elevated PowerShell prompt, type:
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    ```
1. Install PowerShell Core. From an elevated PowerShell prompt, type:
    ```powershell  
    choco install powershell-core
    ```
1. Install Azure CLI. From an elevated PowerShell prompt, type:
    ```powershell  
    choco install azure-cli
    ```
1. Install Azure Stack Hub PowerShell. From an elevated PowerShell prompt, type:
    ```powershell  
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Install-Module -Name Az.BootStrapper -Force -AllowPrerelease
    Install-AzProfile -Profile 2019-03-01-hybrid -Force
    Install-Module -Name AzureStack -RequiredVersion 2.0.2-preview -AllowPrerelease
    ```
    For more information about using the Azure Stack Hub Az modules, see [Install PowerShell Az module for Azure Stack Hub](https://docs.microsoft.com/azure-stack/operator/powershell-install-az-module).
7. Restart your machine. From an elevated PowerShell prompt, type:
    ```powershell  
    shutdown /r
    ```
8. Add the machine as a self-hosted runner to your GitHub repository. You can find instructions on adding a self-hosted runner in the GitHub docs. For more information, see [Adding self-hosted runners](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/adding-self-hosted-runners).

    ![Runner is listening](.\media\ci-cd-github-action-login-cli\github-action-runner-listen.png)

9. When you are done, verify that the service is running and listening to your service. Double check by running `/run.cmd` from the runner's directory.

### Optional: Install Azure Stack Hub Tools on your self-hosted runner

The instructions in this article do not require access to the [Azure Stack Hub Tools](https://docs.microsoft.com/azure-stack/operator/azure-stack-powershell-download?&tabs=az), but as you develop your own workflow you may need to use the tools. The following instructions can help you install the tools on your Windows self-hosted runner. For more information about Azure Stack Hub Tools, see [Download Azure Stack Hub Tools from GitHub](https://docs.microsoft.com/azure-stack/operator/azure-stack-powershell-download?&tabs=az). These instructions assume you have installed the package manager Chocolatey.

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

## Create a self-hosted runner

You can set up a self-hosted runner in the GitHub Docs. A self-hosted runner can run on any machine that can connect to GitHub. You may choose to use a self-hosted runner if you have an automation task in your workflow that requires extensive dependencies, specific licensing requirements such as a USB dongle for a software license, or other machine or software-specific needs. Your machine can be a physical machine, a VM, or a container. You can place the runner in your datacenter or in the cloud.

In this article, you are going to use a Windows VM hosted in Azure that will be configured with Azure Stack Hub specific PowerShell requirements.

For instructions on setting up, configuring, and connecting your self-hosted runner to your repository, see the GitHub Docs, "[About self-hosted runners](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/about-self-hosted-runners)".

![Self hosted runner connected](.\media\ci-cd-github-action-login-cli\github-actions-self-hosted-runner.png)

Make a note of your self-hosted runner's name and tags. The workflow in this article will call it using the tag `self-hosted`.

## Add the workflow to your repository

Create a new workflow using the yaml in this section to create your workflow.

1. Open your GitHub repository.
2. Select **Actions**.
3. Create a new workflow.
    - If this is your first workflow, select **set up a workflow yourself** under **Choose a workflow template**.
    - If you have existing workflows, select **New workflow** > **Set up a workflow yourself**.

4. In the path, name the file `workflow.yml`.
5. Copy and paste the workflow yml.
    ```yaml  
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

1. Open your GitHub repository. You can trigger the workflow by pushing to the repository.
1. Select **Actions**.
1. Select the name of the commit under **All workflows**.

    ![Review commit summary](.\media\ci-cd-github-action-login-cli\github-actions-review-log-summary.png)
1. Select the name of the job, **azurestack-test**.

    ![Review commit detail](.\media\ci-cd-github-action-login-cli\github-action-success-screen.png)
1. Expand the sections to review the return values for your PowerShell and CLI commands.

Notes on the workflow file and the action:

- The workflow contains a single job named `azurestack-test`.
- A push event triggers the workflow.
- The action uses a self-hosted runner that has been set up in the repository, and is called in by the runner's label in the workflow with the line: `runs on: self-hosted`.
- The workflow contains three actions.
- The first action calls the Azure Login action to sign in with PowerShell With GitHub Actions for Azure, you can create workflows that you can set up in your repository to build, test, package, release, and deploy to Azure. This action uses your Azure Stack SPN credentials to connect and open a session to your Azure Stack Hub environment. You can find more information about using the action in GitHub, [Azure Login Action](https://github.com/marketplace/actions/azure-login).
- The second action uses Azure PowerShell. The action uses the Az PowerShell modules and works with both Government and Azure Stack Hub clouds. After you run this workflow, review the job to validate that the script has collected the resource groups in your Azure Stack Hub environment. For more information, see [Azure PowerShell Action](https://github.com/marketplace/actions/azure-powershell-action)
- The third action, uses Azure CLI to sign in and connect to your Azure Stack Hub to collect resource groups. For more information, see [Azure CLI Action](https://github.com/marketplace/actions/azure-cli-action).
- For more information about working with GitHub Actions and self-hosted runner, see the [Gitub Actions](https://github.com/features/actions) documentation.

## Next steps

- Find more actions in the [GitHub Marketplace](https://github.com/marketplace).
- Learn about [Common deployments for Azure Stack Hub](azure-stack-dev-start-deploy-app.md)  
- Learn about [Use Azure Resource Manager templates in Azure Stack Hub](azure-stack-arm-templates.md)  
- Review the DevOps hybrid cloud pattern, [DevOps pattern](https://docs.microsoft.com/hybrid/app-solutions/pattern-cicd-pipeline)