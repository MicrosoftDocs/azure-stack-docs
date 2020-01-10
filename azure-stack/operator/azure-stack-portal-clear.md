---
title: Clear portal user data on demand from Azure Stack Hub. | Microsoft Docs
description: As an Azure Stack Hub operator, learn how to clear portal user data when requested by Azure Stack Hub users.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.custom: mvc
ms.date: 09/10/2019
ms.author: sethm
ms.reviewer: troettinger
ms.lastreviewed: 09/10/2019
monikerRange: 'azs-1802'
---

# Clear portal user data from Azure Stack Hub

Azure Stack Hub operators can clear portal user data on demand, when Azure Stack Hub users request it. As an Azure Stack Hub user, the portal can be customized by pinning tiles and changing the dashboard layout. Users can also change the theme and adjust the default language to match personal preferences. 

Portal user data includes favorites and recently accessed resources in the Azure Stack Hub user portal. This article describes how to clear the portal user data.

Removing portal user settings should only be done after the user subscription has been deleted.

> [!NOTE]
> Some user data can still exist in the system section of event logs after following the guidance in this article. This data can remain for several days until the logs automatically roll over.

## Requirements

- [Install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).
- [Download the latest Azure Stack Hub tools](azure-stack-powershell-download.md) from GitHub.
- The user account must still exist in the directory.
- Azure Stack Hub admin credentials to access the admin Resource Manager endpoint.

> [!NOTE]
> If you attempt to delete portal user information from a user that was invited from a guest directory, (multi-tenancy), you must have read permission in that directory. For more information, see the [CSP scenario later in this article](#clear-portal-user-data-in-guest-directory).

## Clear portal user data using a user principal name

This scenario assumes that either the default provider subscription and the user are part of the same directory, or that you have read access to the directory in which the user resides.

Make sure to [download the latest version of the Azure Stack Hub tools](azure-stack-powershell-download.md) from GitHub before you proceed.

For this procedure, use a computer that can communicate with the admin Resource Manager endpoint of Azure Stack Hub.

1. Open an elevated Windows PowerShell session (run as administrator), navigate to the root folder in the **AzureStack-Tools-master** directory, and import the required PowerShell module:

   ```powershell
   Import-Module .\DatacenterIntegration\Portal\PortalUserDataUtilities.psm1
   ```

2. Run the following commands. Make sure to substitute the placeholders with values that match your environment.

   ```powershell
   ## The following Azure Resource Manager endpoint is for the ASDK. If you are in a multinode environment, contact your operator or service provider to get the endpoint.

   $adminARMEndpoint = "https://adminmanagement.local.azurestack.external"

   ## Replace the following value with the Azure Stack Hub directory tenant ID.
   $azureStackDirectoryTenantId = "f5025bf2-547f-4b49-9693-6420c1d5e4ca"

   ## Replace the following value with the user directory tenant ID.
   $userDirectoryTenantId = " 7ddf3648-9671-47fd-b63d-eecd82ed040e"

   ## Replace the following value with name of the user principal whose portal user data is to be cleared.
   $userPrincipalName = "myaccount@contoso.onmicrosoft.com"

   Clear-AzsUserDataWithUserPrincipalName -AzsAdminArmEndpoint $adminARMEndpoint `
    -AzsAdminDirectoryTenantId $azureStackDirectoryTenantId `
    -UserPrincipalName $userPrincipalName `
    -DirectoryTenantId $userDirectoryTenantId
   ```

   > [!NOTE]
   > `azureStackDirectoryTenantId` is optional. If you do not specify this value, the script searches for the user principal name in all tenant directories registered in Azure Stack Hub, and then clears the portal data for all matched users.

## Clear portal user data in guest directory

In this scenario, the Azure Stack Hub operator has no access to the guest directory in which the user resides. This is a common scenario when you are a Cloud Solution Provider (CSP).

For an Azure Stack Hub operator to remove the portal user data, at a minimum the user object ID is required.

The user must query the object ID and provide it to the Azure Stack Hub operator. The operator does not have access to the directory in which the user resides.

### User retrieves the user object ID

1. Open an elevated Windows PowerShell session (run as administrator), navigate to the root folder in the **AzureStack-Tools-master** directory, and then import the necessary PowerShell module.

   ```powershell
   Import-Module .\DatacenterIntegration\Portal\PortalUserDataUtilities.psm1
   ```

2. Run the following commands. Make sure to substitute the placeholders with values that match your environment.

   ```powershell
   ## The following Azure Resource Manager endpoint is for the ASDK. If you are in a multinode environment, contact your operator or service provider to get the endpoint.
   $userARMEndpoint = "https://management.local.azurestack.external"

   ## Replace the following value with the directory tenant ID, which contains the user account.
   $userDirectoryTenantId = "3160cbf5-c227-49dd-8654-86e924c0b72f"

   ## Replace the following value with the name of the user principal whose portal user data is to be cleared.
   $userPrincipleName = "myaccount@contoso.onmicrosoft.com"

   Get-UserObjectId -DirectoryTenantId $userDirectoryTenantId `
    -AzsArmEndpoint $userARMEndpoint `
    -UserPricinpalName $userPrincipleName
   ```

   > [!NOTE]
   > As a user, you must provide the user object ID, which is the output of the previous script, to the Azure Stack Hub operator.

## Azure Stack Hub operator removes the portal user data

After receiving the user object ID as an Azure Stack Hub operator, run the following commands to remove the portal user data:

1. Open an elevated Windows PowerShell session (run as administrator), navigate to the root folder in the **AzureStack-Tools-master** directory, and then import the necessary PowerShell module.

   ```powershell
   Import-Module .\DatacenterIntegration\Portal\PortalUserDataUtilities.psm1
   ```

2. Run the following commands, making sure you adjust the parameter to match your environment:

   ```powershell
   ## The following Azure Resource Manager endpoint is for the ASDK. If you are in a multinode environment, contact your operator or service provider to get the endpoint.
   $AzsAdminARMEndpoint = "https://adminmanagement.local.azurestack.external"

   ## Replace the following value with the Azure Stack Hub directory tenant ID.
   $AzsAdminDirectoryTenantId = "f5025bf2-547f-4b49-9693-6420c1d5e4ca"
   
   ## Replace the following value with the directory tenant ID of the user to clear.
   $DirectoryTenantId = "3160cbf5-c227-49dd-8654-86e924c0b72f"

   ## Replace the following value with the name of the user principal whose portal user data is to be cleared.
   $userObjectID = "s-1-*******"
   Clear-AzsUserDataWithUserObject -AzsAdminArmEndpoint $AzsAdminARMEndpoint `
    -AzsAdminDirectoryTenantId $AzsAdminDirectoryTenantId `
    -DirectoryTenantID $DirectoryTenantId `
    -UserObjectID $userObjectID `
   ```

## Next steps

- [Register Azure Stack Hub with Azure](azure-stack-registration.md) and populate the [Azure Stack Hub marketplace](azure-stack-marketplace.md) with items to offer your users.
