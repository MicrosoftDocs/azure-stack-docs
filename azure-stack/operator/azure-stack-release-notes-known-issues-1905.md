---
title: Azure Stack 1905 known issues | Microsoft Docs
description: Learn about known issues in Azure Stack 1905.
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
ms.date: 06/14/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 06/14/2019
monikerRange: 'azs-1905'
---

# Azure Stack 1905 known issues

This article lists known issues in the 1905 release of Azure Stack. The list is updated as new issues are identified.

> [!IMPORTANT]  
> Review this section before applying the update.

## Update process

### Host node update prerequisite failure

- Applicable: This issue applies to the 1905 update.
- Cause: When attempting to install the 1905 Azure Stack update, the status for the update might fail due to **Host Node Update Prerequisite**. This is generally caused by a host node having insufficient free disk space.
- Remediation: Contact Azure Stack support to receive assistance clearing disk space on the host node.
- Occurrence: Uncommon

### Preparation failed

- Applicable: This issue applies to all supported releases.
- Cause: When attempting to install the 1905 Azure Stack update, the status for the update might fail and change state to **PreparationFailed**. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing. The 1905 update package is larger than previous update packages which may make this issue more likely to occur.
- Remediation: Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update now** again (not **Resume**). The URP then cleans up the files from the previous attempt, and restarts the download. If the problem persists, we recommend manually uploading the update package by following the [Import and install updates section](azure-stack-apply-updates.md).
- Occurrence: Common

## Portal

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

### Marketplace management

- Applicable: This issue applies to 1904 and 1905
- Cause: The marketplace management screen is not visible when you sign in to the administrator portal.
- Remediation: Refresh the browser or go to **Settings** and select the option **Reset to default settings**.
- Occurrence: Intermittent

### Docker extension

- Applicable: This issue applies to all supported releases.
- Cause: In both the administrator and user portals, if you search for **Docker**, the item is incorrectly returned. It is not available in Azure Stack. If you try to create it, an error is displayed.
- Remediation: No mitigation.
- Occurrence: Common

### Upload blob

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the **OAuth(preview)** option, the task fails with an error message.
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
- Cause: In the user portal, if you attempt to add a **Backend Pool** to a **Load Balancer**, the operation fails with the error message **failed to update Load Balancer...**.
- Remediation: Use PowerShell, CLI or a Resource Manager template to associate the backend pool with a load balancer resource.
- Occurrence: Common

#### Create inbound NAT

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, if you attempt to create an **Inbound NAT Rule** for a **Load Balancer**, the operation fails with the error message **Failed to update Load Balancer...**.
- Remediation: Use PowerShell, CLI or a Resource Manager template to associate the backend pool with a load balancer resource.
- Occurrence: Common

#### Create load balancer

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Create Load Balancer** window shows an option to create a **Standard** load balancer SKU. This option is not supported in Azure Stack.
- Remediation: Use the **Basic** load balancer options instead.
- Occurrence: Common

### Public IP address

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Create Public IP Address** window shows an option to create a **Standard** SKU. The **Standard** SKU is not supported in Azure Stack.
- Remediation: Use the **Basic** SKU for public IP address.
- Occurrence: Common

## Compute

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new Windows virtual machine (VM), the following error may be displayed:
**Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'**.
The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### VM resize

- Applicable: This issue applies to the 1905 release.
- Cause: Unable to successfully resize a managed disk VM. Attempting to resize the VM generates an error with "code": "InternalOperationError",
  "message": "An internal error occurred in the operation."
- Remediation: We are working to remediate this in the next release. Currently, you must recreate the VM with the new VM size.
- Occurrence: Common

### Virtual machine scale set

#### CentOS

- Applicable: This issue applies to all supported releases.
- Cause: The virtual machine scale set creation experience provides CentOS-based 7.2 as an option for deployment. CentOS 7.2 is not available on Azure Stack Marketplace which will cause deployment failures calling out that the image is not found.
- Remediation: Select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.
- Occurrence: Common

#### Remove scale set

- Applicable: This issue applies to all supported releases.
- Cause: You cannot remove a scale set from the **Virtual machine scale sets** blade.
- Remediation: Select the scale set that you want to remove, then click the **Delete** button from the **Overview** pane.
- Occurrence: Common

#### Create failures during patch and update on 4-node Azure Stack environments

- Applicable: This issue applies to all supported releases.
- Cause: Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack environment.
- Remediation: You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack.

#### Scale set instance view blade doesn't load

- Applicable: This issue applies to 1904 and 1905 release.
- Cause: The instance view blade of a virtual machine scale set located at Azure Stack portal -> Dashboard -> Virtual machine scale sets -> AnyScaleSet - Instances -> AnyScaleSetInstance fails to load, and displays a crying cloud image.
- Remediation: There is currently no remediation and we are working on a fix. Until then, please use the CLI command `az vmss get-instance-view` to get the instance view of a scale set.

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases.
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled does not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

<!-- ## Storage -->
<!-- ## SQL and MySQL-->
<!-- ## App Service -->
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->

## Next steps

- [Review update activity checklist](azure-stack-release-notes-checklist.md)
- [Review list of security updates](azure-stack-release-notes-security-updates.md)
