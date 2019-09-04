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
ms.date: 09/04/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 09/04/2019

---
# Microsoft Azure Stack troubleshooting

This document provides troubleshooting information for Azure Stack. 


## Frequently asked questions

These sections include links to docs that cover common questions sent to Microsoft Customer Support Services (CSS).

### Purchase considerations

* [How to buy](https://azure.microsoft.com/overview/azure-stack/how-to-buy/)
* [Azure Stack Overview](azure-stack-overview.md)

### Azure Stack Development Kit (ASDK)

For help with the [Azure Stack Development Kit](../asdk/asdk-what-is.md), reach out to the experts on the [Azure Stack MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack). The ASDK is offered as an evaluation environment without support through CSS. Support cases opened for ASDK are referred to the MSDN Forum.

### Updates and diagnostics

* [How to use diagnostics tools in Azure Stack](azure-stack-diagnostics.md)
* [How to validate Azure Stack system state](azure-stack-diagnostic-test.md)
* [Update package release cadence](azure-stack-servicing-policy.md#update-package-release-cadence)

### Supported operating systems and sizes for guest VMs

* [Guest operating systems supported on Azure Stack](azure-stack-supported-os.md)
* [VM sizes supported in Azure Stack](../user/azure-stack-vm-sizes.md)

### Azure Marketplace

* [Azure Marketplace items available for Azure Stack](azure-stack-marketplace-azure-items.md)

### Manage Capacity

#### Memory

To increase the total available memory capacity for Azure Stack, you can add additional memory. In Azure Stack, your physical server is also referred to as a scale unit node. All scale unit nodes that are members of a single scale unit must have [the same amount of memory](azure-stack-manage-storage-physical-memory-capacity.md).

#### Retention Period

The retention period setting allows a cloud operator to specify a time period in days (between 0 and 9999 days) during which any deleted account can potentially be recovered. The default retention period is set to 0 days. Setting the value to "0" means that any deleted account is immediately out of retention and marked for periodic garbage collection.

* [Set the retention period](azure-stack-manage-storage-accounts.md#set-the-retention-period)

### Security, compliance & Identity  

#### Manage RBAC

A user in Azure Stack can be a reader, owner, or contributor for each instance of a subscription, resource group, or service.

* [Azure Stack Manage RBAC](azure-stack-manage-permissions.md)

If the built-in roles for Azure resources don't meet the specific needs of your organization, you can create your own custom roles. For this tutorial, you create a custom role named Reader Support Tickets using Azure PowerShell.

* [Tutorial: Create a custom role for Azure resources using Azure PowerShell](https://docs.microsoft.com/azure/role-based-access-control/tutorial-custom-role-powershell)

### Manage usage and billing as a CSP

* [Manage usage and billing as a CSP](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription)
* [Create a CSP or APSS Subscription](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription)

Choose the type of shared services account that you use for Azure Stack. The types of subscriptions that can be used for registration of a multi-tenant Azure Stack are:

* Cloud Service Provider
* Partner Shared Services subscription


## Troubleshoot deployment 
### General deployment failure
If you experience a failure during installation, you can restart the deployment from the failed step by using the -rerun option of the deployment script.  

### At the end of ASDK deployment, the PowerShell session is still open and doesn't show any output.
This behavior is probably just the result of the default behavior of a PowerShell command window, when it has been selected. The development kit deployment has succeeded but the script was paused when selecting the window. You can verify setup has completed by looking for the word "select" in the titlebar of the command window. Press the ESC key to unselect it, and the completion message should be shown after it.

### Deployment fails due to lack of external access
When deployment fails at stages where external access is required, an exception like the following example will be returned:

```
An error occurred while trying to test identity provider endpoints: System.Net.WebException: The operation has timed out.
   at Microsoft.PowerShell.Commands.WebRequestPSCmdlet.GetResponse(WebRequest request)
   at Microsoft.PowerShell.Commands.WebRequestPSCmdlet.ProcessRecord()at, <No file>: line 48 - 8/12/2018 2:40:08 AM
```
If this error occurs, check to be sure all minimum networking requirements have been met by reviewing the [deployment network traffic documentation](deployment-networking.md). A network checker tool is also available for partners as part of the Partner Toolkit.

Deployment failures with the above exception are typically due to problems connecting to resources on the Internet.

To verify this is your issue, you can perform the following steps:

1. Open Powershell
2. Enter-PSSession to the WAS01 or any of the ERCs VMs
3. Run the commandlet: Test-NetConnection login.windows.net -port 443

If this command fails, verify the TOR switch and any other network devices are configured to [allow network traffic](azure-stack-network.md).

## Troubleshoot virtual machines
### Default image and gallery item
A Windows Server image and gallery item must be added before deploying VMs in Azure Stack.

### After restarting my Azure Stack host, some VMs may not automatically start.
After rebooting your host, you may notice Azure Stack services are not immediately available.  This is because Azure Stack [infrastructure VMs](../asdk/asdk-architecture.md#virtual-machine-roles ) and resource providers take some time to check consistency, but will eventually start automatically.

You may also notice that tenant VMs don't automatically start after a reboot of the Azure Stack development kit host. This is a known issue, and just requires a few manual steps to bring them online:

1.  On the Azure Stack development kit host, start **Failover Cluster Manager** from the Start Menu.
2.  Select the cluster **S-Cluster.azurestack.local**.
3.  Select **Roles**.
4.  Tenant VMs appear in a *saved* state. Once all Infrastructure VMs are running, right-click the tenant VMs and select **Start** to resume them.

### I have deleted some virtual machines, but still see the VHD files on disk. Is this behavior expected?
Yes, this is expected behavior. It was designed this way because:

* When you delete a VM, VHDs are not deleted. Disks are separate resources in the resource group.
* When a storage account gets deleted, the deletion is visible immediately through Azure Resource Manager, but the disks it may contain are still kept in storage until garbage collection runs.

If you see "orphan" VHDs, it is important to know if they are part of the folder for a storage account that was deleted. If the storage account was not deleted, it's normal they are still there.

You can read more about configuring the retention threshold and on-demand reclamation in [manage storage accounts](azure-stack-manage-storage-accounts.md).

## Troubleshoot storage
### Storage reclamation
It may take up to 14 hours for reclaimed capacity to show up in the portal. Space reclamation depends on various factors including usage percentage of internal container files in block blob store. Therefore, depending on how much data is deleted, there is no guarantee on the amount of space that could be reclaimed when garbage collector runs.

