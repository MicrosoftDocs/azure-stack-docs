---
title: Troubleshoot Azure Stack Hub
titleSuffix: Azure Stack
description: Learn how to troubleshoot Azure Stack Hub, including issues with VMs, storage, and App Service.
author: justinha

ms.topic: article
ms.date: 11/05/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 11/05/2019

# Intent: As an Azure Stack operator, I want to troubleshoot Azure Stack issues.
# Keyword: toubleshoot azure stack

---

# Troubleshoot issues in Azure Stack Hub

This document provides troubleshooting information for Azure Stack Hub integrated environments. For help with the Azure Stack Development Kit, see [ASDK Troubleshooting](../asdk/asdk-troubleshooting.md) or get help from experts on the [Azure Stack Hub MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack).

## Frequently asked questions

These sections include links to docs that cover common questions sent to Microsoft Customer Support Services (CSS).

### Purchase considerations

* [How to buy](https://azure.microsoft.com/overview/azure-stack/how-to-buy/)
* [Azure Stack Hub overview](azure-stack-overview.md)

### Updates and diagnostics

* [How to use diagnostics tools in Azure Stack Hub](azure-stack-diagnostics.md)
* [How to validate Azure Stack Hub system state](azure-stack-diagnostic-test.md)
* [Update package release cadence](azure-stack-servicing-policy.md#update-package-release-cadence)

### Supported operating systems and sizes for guest VMs

* [Guest operating systems supported on Azure Stack Hub](azure-stack-supported-os.md)
* [VM sizes supported in Azure Stack Hub](../user/azure-stack-vm-sizes.md)

### Azure Marketplace

* [Azure Marketplace items available for Azure Stack Hub](azure-stack-marketplace-azure-items.md)

### Manage capacity

#### Memory

To increase the total available memory capacity for Azure Stack Hub, you can add additional memory. In Azure Stack Hub, your physical server is also referred to as a scale unit node. All scale unit nodes that are members of a single scale unit must have [the same amount of memory](azure-stack-manage-storage-physical-memory-capacity.md).

#### Retention period

The retention period setting lets a cloud operator to specify a time period in days (between 0 and 9999 days) during which any deleted account can potentially be recovered. The default retention period is set to **0** days. Setting the value to **0** means that any deleted account is immediately out of retention and marked for periodic garbage collection.

* [Set the retention period](azure-stack-manage-storage-accounts.md#set-the-retention-period)

### Security, compliance, and identity  

#### Manage RBAC

A user in Azure Stack Hub can be a reader, owner, or contributor for each instance of a subscription, resource group, or service.

* [Azure Stack Hub Manage RBAC](azure-stack-manage-permissions.md)

If the built-in roles for Azure resources don't meet the specific needs of your organization, you can create your own custom roles. For this tutorial, you create a custom role named Reader Support Tickets using Azure PowerShell.

* [Tutorial: Create a custom role for Azure resources using Azure PowerShell](https://docs.microsoft.com/azure/role-based-access-control/tutorial-custom-role-powershell)

### Manage usage and billing as a CSP

* [Manage usage and billing as a CSP](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription)
* [Create a CSP or APSS subscription](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription)

Choose the type of shared services account that you use for Azure Stack Hub. The types of subscriptions that can be used for registration of a multi-tenant Azure Stack Hub are:

* Cloud Solution Provider
* Partner Shared Services subscription

### Get scale unit metrics

You can use PowerShell to get stamp utilization information without help from CSS. To obtain stamp utilization:

1. Create a PEP session.
2. Run `test-azurestack`.
3. Exit PEP session.
4. Run `get-azurestacklog -filterbyrole seedring` using an invoke-command call.
5. Extract the seedring .zip. You can obtain the validation report from the ERCS folder where you ran `test-azurestack`.

For more information, see [Azure Stack Hub Diagnostics](azure-stack-configure-on-demand-diagnostic-log-collection.md#use-the-privileged-endpoint-pep-to-collect-diagnostic-logs).

## Troubleshoot virtual machines (VMs)

### Default image and gallery item

A Windows Server image and gallery item must be added before deploying VMs in Azure Stack Hub.

### I've deleted some VMs, but still see the VHD files on disk

This behavior is by design:

* When you delete a VM, VHDs aren't deleted. Disks are separate resources in the resource group.
* When a storage account gets deleted, the deletion is visible immediately through Azure Resource Manager. But the disks it may contain are still kept in storage until garbage collection runs.

If you see "orphan" VHDs, it's important to know if they're part of the folder for a storage account that was deleted. If the storage account wasn't deleted, it's normal that they're still there.

You can read more about configuring the retention threshold and on-demand reclamation in [manage storage accounts](azure-stack-manage-storage-accounts.md).

## Troubleshoot storage

### Storage reclamation

It may take up to 14 hours for reclaimed capacity to show up in the portal. Space reclamation depends on different factors including usage percentage of internal container files in block blob store. Therefore, depending on how much data is deleted, there's no guarantee on the amount of space that could be reclaimed when garbage collector runs.

### Azure Storage Explorer not working with Azure Stack Hub

If you're using an integrated system in a disconnected scenario, it's recommended to use an Enterprise Certificate Authority (CA). Export the root certificate in a Base-64 format and then import it in Azure Storage Explorer. Make sure that you remove the trailing slash (`/`) from the Resource Manager endpoint. For more information, see [Prepare for connecting to Azure Stack Hub](/azure-stack/user/azure-stack-storage-connect-se).

## Troubleshooting App Service

### Create-AADIdentityApp.ps1 script fails

If the Create-AADIdentityApp.ps1 script that's required for App Service fails, be sure to include the required `-AzureStackAdminCredential` parameter when running the script. For more information, see [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md#create-an-azure-active-directory-app).
