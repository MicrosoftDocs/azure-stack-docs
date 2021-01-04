---
title: Use Docker to run PowerShell in Azure Stack Hub 
description: Use Docker to run PowerShell in Azure Stack Hub
author: mattbriggs

ms.topic: how-to
ms.date: 12/16/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 12/16/2020

# Intent: As an Azure Stack Hub user, I want to run my Azure Stack Hub PowerShell modules in a Docker container to keep them isolated from other processes.
# Keyword: Azure Stack Hub AzureRM Az PowerShell Docker

---

# Use Docker to run PowerShell for Azure Stack Hub

In this article, you can use Docker to create a container on which to run the version of PowerShell that's required for working with the various interfaces. You can find instructions for using both AzureRM modules and the latest Az modules. AzureRM requires a Windows-based container. Az uses a Linux-based container.

## Docker prerequisites

### Install Docker

1. Install [Docker](https://docs.docker.com/install/).

1. In a command-line program, such as PowerShell or Bash, enter:

    ```bash
    docker --version
    ```

### Set up a service principal for using PowerShell

To use PowerShell to access resources in Azure Stack Hub, you need a service principal in your Azure Active Directory (Azure AD) tenant. You delegate permissions with user role-based access control (RBAC). You may need to request the service principal from your cloud operator.

1. To set up your service principal, follow the instructions in [Give applications access to Azure Stack Hub resources by creating service principals](../operator/azure-stack-create-service-principals.md?view=azs-2002).

2. Note the application ID, the secret, your tenant ID, and object ID for later use.

## Run PowerShell in Docker

### [Az modules](#tab/az)

In these instructions, you will run a Linux-based container image that contains the PowerShell and the required modules for Azure Stack Hub.

1. You need to run Docker by using Linux container. When you run Docker, switch to Linux containers.

1. Run Docker from a machine that's joined to the same domain as Azure Stack Hub. If you are using the Azure Stack Development Kit (ASDK), you need to install [the VPN on your remote machine](azure-stack-connect-azure-stack.md#connect-to-azure-stack-hub-with-vpn).


## Install Azure Stack Hub Az module on a Linux container

1. From your command line, run the following Docker command to run PowerShell in an Ubuntu container:

    ```bash
    docker run -it mcr.microsoft.com/azurestack/powershell
    ```

    You can run Ubuntu, Debian, or Centos. You can find the following Docker files in the GitHub repository, [azurestack-powershell](https://github.com/Azure/azurestack-powershell). Refer to the GitHub repository for the latest changes to the Docker files. Each OS is tagged. Replace the tag, the section after the colon, with the tag for the desired OS.

    | Linux | Docker image |
    | --- | --- |
    | Ubuntu | `docker run -it mcr.microsoft.com/azurestack/powershell:ubuntu-18.04` |
    | Debian | `docker run -it mcr.microsoft.com/azurestack/powershell:debian-9` |
    | Centos | `docker run -it mcr.microsoft.com/azurestack/powershell:centos-7` |

2. The shell is ready for your cmdlets. Test your shell connectivity by signing in and then running `Test-AzureStack.ps1`.

    First, create your service principal credentials. You will need the **secret** and **application ID**. You will also need the **object ID** when running the `Test-AzureStack.ps1` to check your container. You may need to request a service principal from your cloud operator.

    Type the following cmdlets to create a service principle object:

    ```powershell  
    $passwd = ConvertTo-SecureString <Secret> -AsPlainText -Force
    $pscredential = New-Object System.Management.Automation.PSCredential('<ApplicationID>', $passwd)
    ```

5. Connect to your environment by running the following script with the following values from your Azure Stack Hub instance.

    | Value | Description |
    | --- | --- |
    | The name of the environment. | The name of your Azure Stack Hub environment. |
    | Resource Manager Endpoint | The URL for the Resource Manager. Contact your cloud operator if you don't know it. It will look something like `https://management.region.domain.com`. | 
    | Directory Tenant ID | The ID of your Azure Stack Hub tenant directory. | 
    | Credential | An object containing your service principal. In this case `$pscredential`.  |

    ```powershell
    ./Login-Environment.ps1 -Name <String> -ResourceManagerEndpoint <resource manager endpoint> -DirectoryTenantId <String> -Credential $pscredential
    ```

   PowerShell returns your account object.

7. Test your environment by running the `Test-AzureStack.ps1` script in the container. Specify the service principal **object ID**. If you do not indicate the object ID, the script will still run but it will just test tenant (user) modules and fail on modules that require administrator privileges.

    ```powershell  
    ./Test-AzureStack.ps1 <Object ID>
    ```

### [AzureRM modules](#tab/rm)

In these instructions, you will run a Windows-based container image and install the PowerShell and the required modules for Azure Stack Hub. If you plan to run Docker with Windows, you will need to run Docker on a physical machine. Nested virtualization is not supported on Hyper-V.

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

    Make note of your container name. You can use the same container, rather than creating a new container each time, by running the following Docker command:

    ```bash  
        docker exec -it "Container name" powershell
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
    Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint <Your Azure Resource Manager endoint>
    Add-AzureRmAccount -EnvironmentName "AzureStackUser" -TenantId <TenantID> -ServicePrincipal -Credential $pscredential
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

---

## Next steps

- Read an overview of [Azure Stack Hub PowerShell in Azure Stack Hub](azure-stack-powershell-overview.md).
- Read about [API profiles for PowerShell](azure-stack-version-profiles.md) in Azure Stack Hub.
- Install [Azure Stack Hub PowerShell](../operator/azure-stack-powershell-install.md).
- Read about creating [Azure Resource Manager templates](azure-stack-develop-templates.md) for cloud consistency.
