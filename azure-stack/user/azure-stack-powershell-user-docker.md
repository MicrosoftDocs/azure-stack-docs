---
title: Use Docker to run PowerShell in Azure Stack Hub 
description: Use Docker to run PowerShell in Azure Stack Hub
author: mattbriggs

ms.topic: how-to
ms.date: 7/20/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 7/20/2020

# Intent: As an Azure Stack Hub user, I want to run my Azure Stack Hub PowerShell modules in a Docker container to keep them isolated from other processes.
# Keyword: Azure Stack Hub AzureRM Az PowerShell Docker

---

# Use Docker to run PowerShell in Azure Stack Hub

In this article, you can use Docker to create a container on which to run the version of PowerShell that's required for working with the various interfaces. You can find instructions for using both AzureRM modules and the latest Az modules. AzureRM requires a Windows-based container. Az uses a Linux-based container.

## Docker prerequisites

### Install Docker

1. Install [Docker](https://docs.docker.com/install/).

1. In a command-line program, such as Powershell or Bash, enter:

    ```bash
    docker --version
    ```

### Set up a service principal for using PowerShell

To use PowerShell to access resources in Azure Stack Hub, you need a service principal in your Azure Active Directory (Azure AD) tenant. You delegate permissions with user role-based access control (RBAC).

1. To set up your service principal, follow the instructions in [Give applications access to Azure Stack Hub resources by creating service principals](azure-stack-create-service-principals.md).

2. Note the application ID, the secret, and your tenant ID for later use.


## Run PowerShell in Docker

### [AzureRM modules](#tab/rm)

In these instructions, you will run a Windows-based container image and install the PowerShell and the required modules for Azure Stack Hub.

1. You need to run Docker by using Windows containers that require Windows 10. When you run Docker, switch to Windows containers. The images supporting the Az module will require Docker 17.05 or newer.

1. Run Docker from a machine that's joined to the same domain as Azure Stack Hub. If you are using the Azure Stack Development Kit (ASDK), you need to install [the VPN on your remote machine](azure-stack-connect-azure-stack.md#connect-to-azure-stack-hub-with-vpn).

### Install Azure Stack Hub AzureRM module on a windows container

The Dockerfile opens the Microsoft image *microsoft/windowsservercore*, which has Windows PowerShell 5.1 installed. The file then loads NuGet and the Azure Stack Hub PowerShell modules, and downloads the tools from Azure Stack Hub Tools.

1. [Download the azure-stack-powershell repository](https://github.com/Azure-Samples/azure-stack-hub-powershell-in-docker.git) as a ZIP file, or clone the repository.

2. Open the repository folder from your terminal.

3. Open a command-line interface in your repository, and then enter the following command:

    ```bash  
    docker build --tag azure-stack-powershell .
    ```

4. When the image has been built, start an interactive container by entering:

    ```bash  
        docker run -it azure-stack-powershell powershell
    ```

5. The shell is ready for your cmdlets.

    ```bash
    Windows PowerShell
    Copyright (C) 2016 Microsoft Corporation. All rights reserved.

    PS C:\>
    ```

6. Connect to your Azure Stack Hub instance by using the service principal. You are now using a PowerShell prompt in Docker. 

    ```powershell
    $passwd = ConvertTo-SecureString <Secret> -AsPlainText -Force
    $pscredential = New-Object System.Management.Automation.PSCredential('<ApplicationID>', $passwd)
    Connect-AzureRmAccount -ServicePrincipal -Credential $pscredential -TenantId <TenantID>
    ```

   PowerShell returns your account object:

    ```powershell  
    Account    SubscriptionName    TenantId    Environment
    -------    ----------------    --------    -----------
    <AccountID>    <SubName>       <TenantID>  AzureCloud
    ```

7. Test your connectivity by creating a resource group in Azure Stack Hub.

    ```powershell  
    New-AzureRmResourceGroup -Name "MyResourceGroup" -Location "Local"
    ```

### [Az modules](#tab/az)

In these instructions, you will run a Linux-based container image that contains the PowerShell and the required modules for Azure Stack Hub.

1. You need to run Docker by using Linux container. When you run Docker, switch to Linux containers.

1. Run Docker from a machine that's joined to the same domain as Azure Stack Hub. If you are using the Azure Stack Development Kit (ASDK), you need to install [the VPN on your remote machine](azure-stack-connect-azure-stack.md#connect-to-azure-stack-hub-with-vpn).


## Install Azure Stack Hub Az module on a Linux container

1. From your command line, run the following Docker command to run PowerShell in an Ubuntu container:

    ```bash
    docker run -it mcr.microsoft.com/azurestack/powershell
    ```

    You can run Ubuntu, Debian, or Centos. You can find the following Docker files in the GitHub repository, [azurestack-powershell](https://github.com/Azure/azurestack-powershell). Refer to the GitHub repository for the latest changes to the Docker files. Each OS is tagged. Replace the tag, the section after the colon, with the tag.

    | Linux | Docker image |
    | --- | --- |
    | Ubuntu | `docker run -it mcr.microsoft.com/azurestack/powershell:ubuntu-18.04` |
    | Debian | `docker run -it mcr.microsoft.com/azurestack/powershell:debian-9` |
    | Centos | `docker run -it mcr.microsoft.com/azurestack/powershell:centos-7` |

2. Check that that $HOME/.Azure is present. In the container, type:

    ```Powershell  
    $HOME/.Azure
    ```

3. Grant access this location for the docker process. Type the following command:

    ```PowerShell  
    docker run -it -v ~/.Azure/AzureRmContext.json:/root/.Azure/AzureRmContext.json -v ~/.Azure/TokenCache.dat:/root/.Azure/TokenCache.dat mcr.microsoft.com/azurestack/powershell pwsh 
    ```

4. Verify the host authentication:

    ```bash  
    docker run -it --rm -v ~/.Azure/AzureRmContext.json:/root/.Azure/AzureRmContext.json -v ~/.Azure/TokenCache.dat:/root/.Azure/TokenCache.dat mcr.microsoft.com/azurestack/powershell pwsh -c Get-AzContext
    ```

5. The shell is ready for your cmdlets. Test your shell connectivity by signing in and then creating a resource group. You will need the following values:

    | Value | Description |
    | --- | --- |
    | The name of the environment. | The name of your Azure Stack Hub environment. |
    | Resource Manager Endpoint | The URL for the Resource Manager. Contact your cloud operator if you don't know it. | 
    | Directory Tenant ID | The ID your Azure Stack Hub directory. | 
    | Credential | The password for your Azure Stack Hub account. | 
    | Subscription ID | The numeric ID of your subscription. |

    ```powershell
    ./Login-Environment.ps1 
    [-Name <String>]  
    -ResourceManagerEndpoint <System.Uri>  
    -DirectoryTenantId <String>  
    -Credential <PSCredential>  
    [-SubscriptionId <String>]
    ```

   PowerShell returns your account object:

    ```powershell  
    Account    SubscriptionName    TenantId    Environment
    -------    ----------------    --------    -----------
    <AccountID>    <SubName>       <TenantID>  AzureCloud
    ```

7. Test your connectivity by creating a resource group in Azure Stack Hub. Add your Azure Stack Hub instance location. If you are using the ASDK, use 'Local.'

    ```powershell  
    New-AzResourceGroup -Name "MyResourceGroup" -Location "Local"
    ```

## Next steps

- Read an overview of [Azure Stack Hub PowerShell in Azure Stack Hub](azure-stack-powershell-overview.md).
- Read about [API profiles for PowerShell](azure-stack-version-profiles.md) in Azure Stack Hub.
- Install [Azure Stack Hub Powershell](../operator/azure-stack-powershell-install.md).
- Read about creating [Azure Resource Manager templates](azure-stack-develop-templates.md) for cloud consistency.
