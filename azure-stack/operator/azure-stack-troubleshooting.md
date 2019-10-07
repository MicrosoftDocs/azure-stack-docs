---
title: Microsoft Azure Stack troubleshooting | Microsoft Docs
description: Azure Stack troubleshooting.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid: a20bea32-3705-45e8-9168-f198cfac51af
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 09/30/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 09/30/2019

---
# Microsoft Azure Stack troubleshooting

This document provides troubleshooting information for Azure Stack integrated environments. For help with the Azure Stack Development Kit, see [ASDK Troubleshooting](../asdk/asdk-troubleshooting.md) or get help from experts on the [Azure Stack MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack). 

## Frequently asked questions

These sections include links to docs that cover common questions sent to Microsoft Customer Support Services (CSS).

### Purchase considerations

* [How to buy](https://azure.microsoft.com/overview/azure-stack/how-to-buy/)
* [Azure Stack overview](azure-stack-overview.md)

### Updates and diagnostics

* [How to use diagnostics tools in Azure Stack](azure-stack-diagnostics.md)
* [How to validate Azure Stack system state](azure-stack-diagnostic-test.md)
* [Update package release cadence](azure-stack-servicing-policy.md#update-package-release-cadence)

### Supported operating systems and sizes for guest VMs

* [Guest operating systems supported on Azure Stack](azure-stack-supported-os.md)
* [VM sizes supported in Azure Stack](../user/azure-stack-vm-sizes.md)

### Azure Marketplace

* [Azure Marketplace items available for Azure Stack](azure-stack-marketplace-azure-items.md)

### Manage capacity

#### Memory

To increase the total available memory capacity for Azure Stack, you can add additional memory. In Azure Stack, your physical server is also referred to as a scale unit node. All scale unit nodes that are members of a single scale unit must have [the same amount of memory](azure-stack-manage-storage-physical-memory-capacity.md).

#### Retention period

The retention period setting allows a cloud operator to specify a time period in days (between 0 and 9999 days) during which any deleted account can potentially be recovered. The default retention period is set to **0** days. Setting the value to **0** means that any deleted account is immediately out of retention and marked for periodic garbage collection.

* [Set the retention period](azure-stack-manage-storage-accounts.md#set-the-retention-period)

### Security, compliance, and identity  

#### Manage RBAC

A user in Azure Stack can be a reader, owner, or contributor for each instance of a subscription, resource group, or service.

* [Azure Stack Manage RBAC](azure-stack-manage-permissions.md)

If the built-in roles for Azure resources don't meet the specific needs of your organization, you can create your own custom roles. For this tutorial, you create a custom role named Reader Support Tickets using Azure PowerShell.

* [Tutorial: Create a custom role for Azure resources using Azure PowerShell](https://docs.microsoft.com/azure/role-based-access-control/tutorial-custom-role-powershell)

### Manage usage and billing as a CSP

* [Manage usage and billing as a CSP](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription)
* [Create a CSP or APSS subscription](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription)

Choose the type of shared services account that you use for Azure Stack. The types of subscriptions that can be used for registration of a multi-tenant Azure Stack are:

* Cloud Solution Provider
* Partner Shared Services subscription


## Troubleshoot deployment 
### General deployment failure
If you experience a failure during installation, you can restart the deployment from the failed step by using the -rerun option of the deployment script.  

### Template validation error parameter osProfile is not allowed

If you get an error message during template validation that the parameter 'osProfile' is not allowed, make sure you are using the correct versions of the APIs for these components:

- [Compute](https://docs.microsoft.com/azure-stack/user/azure-stack-profiles-azure-resource-manager-versions#microsoftcompute)
- [Network](https://docs.microsoft.com/azure-stack/user/azure-stack-profiles-azure-resource-manager-versions#microsoftnetwork)

To copy a VHD from Azure to Azure Stack, use [AzCopy 7.3.0](https://docs.microsoft.com/azure-stack/user/azure-stack-storage-transfer#download-and-install-azcopy). Work with your vendor to resolve issues with the image itself. For more information about the WALinuxAgent requirements for Azure Stack, see [Azure LinuX Agent](azure-stack-linux.md#azure-linux-agent).

### Deployment fails due to lack of external access
When deployment fails at stages where external access is required, an exception like the following example will be returned:

```
An error occurred while trying to test identity provider endpoints: System.Net.WebException: The operation has timed out.
   at Microsoft.PowerShell.Commands.WebRequestPSCmdlet.GetResponse(WebRequest request)
   at Microsoft.PowerShell.Commands.WebRequestPSCmdlet.ProcessRecord()at, <No file>: line 48 - 8/12/2018 2:40:08 AM
```
If this error occurs, make sure all minimum networking requirements have been met by reviewing the [deployment network traffic documentation](deployment-networking.md). A network checker tool is also available for partners as part of the Partner Toolkit.

Other deployment failures are typically due to problems connecting to resources on the Internet.

To verify connectivity to resources on the Internet, you can perform the following steps:

1. Open PowerShell.
2. Enter-PSSession to the WAS01 or any of the ERCs VMs.
3. Run the following cmdlet: 
   ```powershell
   Test-NetConnection login.windows.net -port 443
   ```

If this command fails, verify the TOR switch and any other network devices are configured to [allow network traffic](azure-stack-network.md).

## Troubleshoot virtual machines
### Default image and gallery item
A Windows Server image and gallery item must be added before deploying VMs in Azure Stack.


### I have deleted some virtual machines, but still see the VHD files on disk
This behavior is by design:

* When you delete a VM, VHDs are not deleted. Disks are separate resources in the resource group.
* When a storage account gets deleted, the deletion is visible immediately through Azure Resource Manager, but the disks it may contain are still kept in storage until garbage collection runs.

If you see "orphan" VHDs, it is important to know if they are part of the folder for a storage account that was deleted. If the storage account was not deleted, it's normal they are still there.

You can read more about configuring the retention threshold and on-demand reclamation in [manage storage accounts](azure-stack-manage-storage-accounts.md).

## Troubleshoot storage
### Storage reclamation
It may take up to 14 hours for reclaimed capacity to show up in the portal. Space reclamation depends on various factors including usage percentage of internal container files in block blob store. Therefore, depending on how much data is deleted, there is no guarantee on the amount of space that could be reclaimed when garbage collector runs.

## Troubleshooting App Service
### Create-AADIdentityApp.ps1 script fails

If the Create-AADIdentityApp.ps1 script that is required for App Service fails, be sure to include the required -AzureStackAdminCredential parameter when running the script. For more information, see [Prerequisites for deploying App Service on Azure Stack](azure-stack-app-service-before-you-get-started.md#create-an-azure-active-directory-app).

