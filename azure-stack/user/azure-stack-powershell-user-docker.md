---
title: Use Docker to run PowerShell for Azure Stack | Microsoft Docs
description: Use Docker to run PowerShell on Azure Stack
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: powershell
ms.topic: article
ms.date: 04/25/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 04/24/2019

---
# Use Docker to run PowerShell

You can use Docker to create Windows-based containers on which to run the specific version of PowerShell needed to work the different interfaces. You must use Windows-based containers in Docker.

## Docker prerequisites

1. Install [Docker](https://docs.docker.com/install/).
2. Open a command line, such as Powershell or Bash and type:

    ```bash
        Docker –version
    ```

3. You need to run Docker using Windows containers that require Windows 10. When running Docker, switch to Windows containers.

4. You must run Docker from a machine joined to the same domain as Azure Stack. If you are using the ASDK, you need to install [the VPN on your remote machine](azure-stack-connect-azure-stack.md#connect-to-azure-stack-with-vpn).

## Service principals for using PowerShell

You need a service principal in your Azure AD tenant to use PowerShell to access resource in Azure Stack. You delegate permissions with user role-based access control.

1. Set up your principal by following the instructions in the article [Give applications access to Azure Stack resources by creating service principals](azure-stack-create-service-principals.md).
2. Make note of the application ID, secret, and your tenant ID.

## Docker - Azure Stack API Profiles module

The Dockerfile opens the Microsoft image microsoft/windowsservercore, which has Windows PowerShell 5.1 installed. The file then loads NuGet, the Azure Stack PowerShell modules, and downloads the tools from Azure Stack Tools.

1. Download this repository as a ZIP or clone the repository:  
[https://github.com/mattbriggs/azure-stack-powershell](https://github.com/mattbriggs/azure-stack-powershell)

2. Open the repository folder from your terminal.

3. Open a command-line interface in your repository and type:

    ```bash  
    docker build --tag azure-stack-powershell .
    ```

4. When the image has been built, you can start an interactive container. Type:

    ```bash  
        docker run -it azure-stack-powershell powershell
    ```

5. The shell is ready for your cmdlets.

    ```bash
    Windows PowerShell
    Copyright (C) 2016 Microsoft Corporation. All rights reserved.

    PS C:\>
    ```

6. Connect to your Azure Stack using the service principal. You are now using a PowerShell prompt in Docker. 

    ```Powershell
    $passwd = ConvertTo-SecureString <Secret> -AsPlainText -Force
    $pscredential = New-Object System.Management.Automation.PSCredential('<ApplicationID>', $passwd)
    Connect-AzureRmAccount -ServicePrincipal -Credential $pscredential -TenantId <TenantID>
    ```

   PowerShell returns your account object:

    ```PowerShell  
    Account    SubscriptionName    TenantId    Environment
    -------    ----------------    --------    -----------
    <AccountID>    <SubName>       <TenantID>  AzureCloud
    ```

7. Test your connectivity by creating a resource group in Azure Stack.

    ```PowerShell  
    New-AzureRmResourceGroup -Name "MyResourceGroup" -Location "Local"
    ```

## Next steps

-  Read an overview of [Azure Stack PowerShell on Azure Stack](azure-stack-powershell-overview.md).
- Read about [API Profiles for PowerShell](azure-stack-version-profiles.md) on Azure Stack.
- [Install Azure Stack Powershell](../operator/azure-stack-powershell-install.md).
- Read about creating [Azure Resource Manager templates](azure-stack-develop-templates.md) for cloud consistency.