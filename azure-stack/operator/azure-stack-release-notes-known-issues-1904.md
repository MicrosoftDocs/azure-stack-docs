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
ms.date: 05/15/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 05/15/2019
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

### Add-on plans

- Applicable: This issue applies to all supported releases.
- Cause: Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan remains until the subscriptions that reference the add-on plan are also deleted.
- Remediation: No mitigation.
- Occurrence: Common

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: These subscriptions will be suspended starting with 1905 and eventually deleted. If you have resources running on these two subscriptions, recreate them in user subscriptions prior to 1905.
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

### Marketplace management

- Applicable: This is a new issue with release 1904.
- Cause: The marketplace management screen is not visible when you sign in to the administrator portal.
- Remediation: Refresh the browser.
- Occurrence: Intermittent

### Marketplace management

- Applicable: This issue applies to 1904.
- Cause: When you filter results on "Add from Azure" blade in Marketplace management tab in administrator portal, you may see incorrect filtered results. 
- Remediation: Sort results by Name column and the results will be corrected. 
- Occurrence: Intermittent


### Upload blob

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the OAuth(preview) option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
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

### Virtual Machine Scale Set

#### CentOS

- Applicable: This issue applies to all supported releases.
- Cause: The Virtual Machine Scale Set (VMSS) creation experience provides CentOS-based 7.2 as an option for deployment. CentOS 7.2 is not available on Azure Stack.
- Remediation: Select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.
- Occurrence: Common

#### Remove scale set

- Applicable: This issue applies to all supported releases.
- Cause: You cannot remove a scale set from the **Virtual Machine Scale Sets** blade.
- Remediation: Select the scale set that you want to remove, then click the **Delete** button from the **Overview** pane.
- Occurrence: Common

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases.
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled does not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

### Compute host agent alert

- Applicable: This is a new issue with release 1904.
- Cause: A **Compute host agent** warning appears after restarting a node in the scale unit. The restart changes the default startup setting for the compute host agent service.
- Remediation:
  - This alert can be ignored. The agent not responding does not have any impact on operator and user operations or user applications. The alert will reappear after 24 hours if it is closed manually.
  - Microsoft support can remediate the issue by changing the startup setting for the service. This requires opening a support ticket. If the node is restarted again, a new alert appears.
- Occurrence: Common

<!-- ## Storage -->
<!-- ## SQL and MySQL-->
## App Service

<!-- 2352906 - IS ASDK -->
- You must register the storage resource provider before you create your first Azure Function in the subscription.
- Some tenant portal user experiences are broken due to an incompatibility with the portal framework shipped in 1903. Principally the UX for Deployment Slots, Testing in Production and Site Extensions. To work around this issue please make use of the Azure App Service PowerShell module or the Azure CLI. The portal experience will be restored in the upcoming release of Azure App Service on Azure Stack 1.6 (Update 6).
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->

## Next steps

- [Review update activity checklist](azure-stack-release-notes-checklist.md)
- [Review list of security updates](azure-stack-release-notes-security-updates-1904.md)
