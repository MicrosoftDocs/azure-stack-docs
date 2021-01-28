---
title: Azure Stack 1904 known issues | Microsoft Docs
description: Learn about known issues in Azure Stack 1904.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/31/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 05/31/2019
---

# Azure Stack 1904 known issues

This article lists known issues in the 1904 release of Azure Stack. The list is updated as new issues are identified.

> [!IMPORTANT]  
> Review this section before applying the update.

## Update process

- Applicable: This issue applies to all supported releases.
- Cause: When attempting to install an Azure Stack update, the status for the update might fail and change state to **PreparationFailed**. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing.
- Remediation: Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update now** again (not **Resume**). The URP then cleans up the files from the previous attempt, and starts the download again.
- Occurrence: Common

## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

### Subscription resources

- Applicable: This issue applies to all supported releases.
- Cause: Deleting user subscriptions results in orphaned resources.
- Remediation: First delete user resources or the entire resource group, and then delete the user subscriptions.
- Occurrence: Common

### Subscription permissions

- Applicable: This issue applies to all supported releases.
- Cause: You cannot view permissions to your subscription using the Azure Stack portals.
- Remediation: Use [PowerShell to verify permissions](/powershell/module/azurerm.resources/get-azurermroleassignment).
- Occurrence: Common

### Docker extension

- Applicable: This issue applies to all supported releases.
- Cause: In both the administrator and user portals, if you search for **Docker**, the item is incorrectly returned. It is not available in Azure Stack. If you try to create it, an error is displayed.
- Remediation: No mitigation.
- Occurrence: Common

### Marketplace management

- Applicable: This is a new issue with release 1904.
- Cause: The marketplace management screen is not visible when you sign in to the administrator portal.
- Remediation: Refresh the browser.
- Occurrence: Intermittent

### Marketplace management

- Applicable: This issue applies to 1904.
- Cause: When you filter results in the **Add from Azure** blade in the Marketplace management tab in the administrator portal, you may see incorrect filtered results.
- Remediation: Sort results by the Name column and the results will be corrected.
- Occurrence: Intermittent

### Marketplace management

- Applicable: This issue applies to 1904.
- Cause: When you filter results in Marketplace management in the administrator portal, you will see duplicated publisher names under the publisher drop-down. 
- Remediation: Select all the duplicates to have the correct list of all the Marketplace products that are available under that publisher.
- Occurrence: Intermittent

### Docker extension

- Applicable: This issue applies to all supported releases.
- Cause: In both the administrator and user portals, if you search for **Docker**, the item is incorrectly returned. It is not available in Azure Stack. If you try to create it, an error is displayed.
- Remediation: No mitigation.
- Occurrence: Common

### Upload blob

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the OAuth(preview) option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

### Template

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the template deployment UI does not populate parameters for the template names beginning with "_" (the underscore character).
- Remediation: Remove the "_" (underscore character) from the template name.
- Occurrence: Common

## Networking

### Load balancer

#### Add backend pool

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, if you attempt to add a **Backend Pool** to a **Load Balancer**, the operation fails with the error message **Failed to update Load Balancer...**.
- Remediation: Use PowerShell, CLI, or an Azure Resource Manager template to associate the backend pool with a load balancer resource.
- Occurrence: Common

#### Create inbound NAT

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, if you attempt to create an **Inbound NAT Rule** for a **Load Balancer**, the operation fails with the error message **Failed to update Load Balancer...**.
- Remediation: Use PowerShell, CLI, or an Azure Resource Manager template to associate the backend pool with a load balancer resource.
- Occurrence: Common

#### Create load balancer

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Create Load Balancer** window shows an option to create a **Standard** load balancer SKU. This option is not supported in Azure Stack.
- Remediation: Use the Basic load balancer options instead.
- Occurrence: Common

#### Public IP address

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Create Public IP Address** window shows an option to create a **Standard** SKU. The **Standard** SKU is not supported in Azure Stack.
- Remediation: Use the **Basic** SKU instead for public IP addresses.
- Occurrence: Common

## Compute

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new Windows Virtual Machine (VM), the following error may be displayed:
**Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'**.
The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### Virtual machine scale set

#### CentOS

- Applicable: This issue applies to all supported releases.
- Cause: The virtual machine scale set creation experience provides CentOS-based 7.2 as an option for deployment. CentOS 7.2 is not available on Azure Stack Marketplace which will cause deployment failures calling out that the image is not found.
- Remediation: Select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.
- Occurrence: Common

#### Remove scale set

- Applicable: This issue applies to all supported releases.
- Cause: You cannot remove a scale set from the **Virtual Machine Scale Sets** blade.
- Remediation: Select the scale set that you want to remove, then click the **Delete** button from the **Overview** pane.
- Occurrence: Common

#### Create failures during patch and update on 4-node Azure Stack environments

- Applicable: This issue applies to all supported releases.
- Cause: Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack environment.
- Remediation: You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack.

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases.
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled does not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

### Compute host agent alert

- Applicable: This is a new issue with release 1904.
- Cause: A **Compute host agent** warning appears after restarting a node in the scale unit. The restart changes the default startup setting for the compute host agent service. This alert looks similar to the following example:

   ```shell
   NAME  
   Compute Host Agent is not responding to calls.
   SEVERITY  
   Warning
   STATE  
   Active
   CREATED TIME  
   5/16/2019, 10:08:23 AM
   UPDATED TIME  
   5/22/2019, 12:27:27 PM
   COMPONENT  
   M#####-NODE02
   DESCRIPTION  
   Could not communicate with the Compute Host Agent running on node: M#####-NODE02
   REMEDIATION  
   Please disable Compute Host Agent feature flag and collect logs for further diagnosis.
   ```

- Remediation:
  - This alert can be ignored. The agent not responding does not have any impact on operator and user operations or user applications. The alert will reappear after 24 hours if it is closed manually.
  - The issue is fixed in the latest [Azure Stack hotfix for 1904](https://support.microsoft.com/help/4505688).
- Occurrence: Common

### Virtual machine scale set instance view

- Applicable: This issue applies to the 1904 and 1905 releases.
- Cause: The instance view blade of a scale set located on the Azure Stack portal, in **Dashboard** > **Virtual machine scale sets** > **AnyScaleSet - Instances** > **AnyScaleSetInstance** fails to load.
- Remediation: There is currently no remediation and we are working on a fix. Until then, please use the CLI cmdlet `az vmss get-instance-view` to get the instance view of a virtual machine scale set.

### User image service
- Applicable: This issue applies to all supported releases.
- Cause: Failed user image creation will put the user image service into a bad state. User image creation and deletion operations will start to fail. User image deletion may fail with error: "Error: An internal disk management error occurred."
- Remediation: No mitigation. Open a support ticket with Microsoft.

## Storage

- Applicable: This issue applies to all supported releases.
- Cause: [ConvertTo-AzureRmVMManagedDisk](/powershell/module/azurerm.compute/convertto-azurermvmmanageddisk) is not supported in Azure Stack and results in creating a disk with **$null** ID. This prevents you from performing operations on the VM, such as start and stop. The disk does not appear in the UI, nor does it appear via the API. The VM at that point cannot be repaired and must be deleted.
- Remediation: To convert your disks correctly, follow the [convert to managed disks guide](../../user/azure-stack-managed-disk-considerations.md#convert-to-managed-disks).

## App Service

- Tenants must register the storage resource provider before creating their first Azure Function in the subscription.
- Some tenant portal user experiences are broken due to an incompatibility with the portal framework in 1903; principally, the UX for deployment slots, testing in production and site extensions. To work around this issue, use the [Azure App Service PowerShell module](/azure/app-service/deploy-staging-slots#automate-with-powershell) or the [Azure CLI](/cli/azure/webapp/deployment/slot?view=azure-cli-latest). The portal experience will be restored by upgrading your deployment of [Azure App Service on Azure Stack to 1.6 (Update 6)](../azure-stack-app-service-release-notes-update-six.md).

<!-- ## Storage -->
<!-- ## SQL and MySQL-->
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->

## Next steps

- [Review update activity checklist](../release-notes-checklist.md)
- [Review list of security updates](../release-notes-security-updates.md)
