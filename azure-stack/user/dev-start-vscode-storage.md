---
title: Deploy a storage account to Azure Stack Hub in Visual Studio Code
description: As a developer, deploy a storage account to Azure Stack Hub in Visual Studio Code
author: sethmanheim
ms.topic: how-to
ms.date: 7/23/2021
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 7/23/2021

# Intent: As a developer, I want to use VS Code to deploy a storage account to Azure Stack Hub.
# Keyword: VS code storage account extension

---

# Deploy a storage account to Azure Stack Hub in Visual Studio Code

In this article, you can learn how to deploy a storage account to Azure Stack Hub using the Azure Storage extension in Visual Studio Code. You can use Azure directly from Visual Studio Code through extensions. You'll need to update your Visual Studio Code settings.

Visual Studio Code is a light-weight editor for building and debugging cloud applications. Utilizing the Azure Account extension to sign in, you can see their current storage accounts, blobs, and deploy a new one to their Azure Stack Hub subscription. Using this extension, you can:

 - Explore, create, delete Blob containers, queues, tables, and storage accounts
 - Create, edit, and delete block Blobs and files
 - Upload and download Blobs, files, and folders
 - Access connection string and primary key
 - Open in storage explorer for memory or computationally heavy tasks, or for page and append Blob support.

The extension will work with both Azure Active Directory (Azure AD) and Active Directory Federated Services (AD FS) identity managers. 

## Prerequisites for the extension

Prerequisites for the extension
 - Azure Stack Hub environment 2008 or later.
 - [Visual Studio Code](https://code.visualstudio.com/).
 - [Azure Account Extension](https://github.com/Microsoft/vscode-azure-account)
 - Azure Storage extension
 - [An Azure Stack Hub subscription](https://azure.microsoft.com/overview/azure-stack/)
    and credentials with access to Azure Stack Hub.
 - An environment with PowerShell using the AZ modules for Azure Stack Hub. For 
    instructions see [Install PowerShell Az module for Azure Stack Hub](../operator/powershell-install-az-module.md?bc=%2fazure-stack%2fbreadcrumb%2ftoc.json%3fview%3dazs-2008&toc=%2fazure-stack%2fuser%2ftoc.json%3fview%3dazs-2008&preserve-view=true).

## Get your credentials

In this section, you will use your credentials to get your tenant ID. You will need your Azure Stack Hub Resource Manager URL and tenant ID.

The Azure Stack Hub Resource Manager is a management framework that allows you to deploy, manage, and monitor Azure resources.
- The Resource Manager URL for the Azure Stack Development Kit (ASDK) is: `https://management.local.azurestack.external/` 
- The Resource Manager URL for an integrated system is: `https://management.region.<fqdn>/`, where `<fqdn>` is your fully qualified domain name.

1. Open PowerShell with an elevated prompt. And run the following cmdlets:

    ```powershell
    Add-AzEnvironment -Name "<username@contoso.com>" -ArmEndpoint "https://management.region.<fqdn>"
    ```

    ```Output
    Name  Resource Manager Url                            ActiveDirectory Authority
    ----  --------------------                            -------------------------
    username@contoso.com https://management.region.<fqdn> https://login.microsoftonline.com/
    ```

2. Run the following cmdlets in the same session:

    ```powershell
    $AuthEndpoint = (Get-AzEnvironment -Name "username@contoso.com").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantName = "masselfhost.onmicrosoft.com"
    $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
    Add-AzAccount -EnvironmentName "username@contoso.com" -TenantId $TenantId
    ```

    ```Output
    Account               SubscriptionName  TenantId                             Environment
    -------               ----------------  --------                             -----------
    username@contoso.com   azure-stack-sub  6d5ff183-b37f-4a5b-9a2f-19959cb4224a username@contoso.com
    ```

3. Make a note of the tenant ID. You will need to when adding the JSON section that
    that will configure the Azure Account extension.

## Set up the Azure Account extension

1. Open VS Code.
2. Select **Extensions** on the left-side corner.
4. Download and install the Azure Storage extension for Visual Studio Code. Once complete, you will see an Azure icon in the Activity bar.
5.  Connect to Azure Stack Hub using the Azure Account extension. Select **Azure: Sign In to Azure Cloud** to connect to your Azure Stack Hub account.  
    For instructions on how to use the Azure Account extension to connect, follow the instructions at [Connect to Azure Stack Hub using Azure Account Extension in Visual Studio Code](azure-stack-dev-start-vscode-azure.md).
6. Add the URL for your Azure Stack Hub Resource Manager, and then add the Tenant ID.
    ![Use the Azure Storage Extension on Azure Stack Hub](media/dev-start-vscode-storage/use-the-azure-storage-account-extension.png)
7. Select the Azure icon in the Activity bar in Visual Studio Code. Expand the 
storage group.
7. Right-click on the subscription where you would like to create the account, and then select **Create Storage account**.
8. Enter a unique name for the storage account.
9. Select a location for the storage account to be deployed. 
11. Once the storage account is deployed, you can select it to copy the connection string, create Blob containers, queues, and tables. Users can view all of these resources inside of Visual Studio Code.
12. Right-click the storage account and select **Delete Storage Account** to remove it from the subscription. 

## Next steps

[Set up a development environment in Azure Stack Hub](azure-stack-dev-start.md)
