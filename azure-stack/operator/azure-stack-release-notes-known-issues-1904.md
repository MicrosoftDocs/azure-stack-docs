---
title: Azure Stack release notes - known issues in 1904 | Microsoft Docs
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
ms.date: 04/27/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 04/27/2019
---

# Azure Stack known issues

This article lists known issues with supported releases of Azure Stack. The list is updated as new releases and hotfixes are released.

> [!IMPORTANT]  
> Review this section before applying the update.

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

### Upload blob

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the OAuth(preview) option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

### Load Balancer

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, if you attempt to add a **Backend Pool** to a **Load Balancer**, the operation fails with the error message 'failed to update Load Balancer...'.
- Remediation: Use PowerShell, CLI or a Resource Manager template to associate the backend pool with a load balancer resource.
- Occurrence: Common

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, if you attempt to create an **Inbound NAT Rule** for a **Load Balancer**, the operation fails with the error message 'Failed to update Load Balancer...'.
- Remediation: Use PowerShell, CLI or a Resource Manager template to associate the backend pool with a load balancer resource.
- Occurrence: Common

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Create Load Balancer** window shows an option to create a **Standard** Load Balancer SKU. This option is not supported in Azure Stack.
- Remediation: Use the Basic Load Balancer options instead.
- Occurrence: Common

### Public IP Address

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Create Public IP Address** window shows an option to create a **Standard** SKU. The **Standard** SKU is not supported in Azure Stack.
- Remediation: Use Basic SKU instead for public IP address.
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

- Applicable: This issue applies to all supported releases.
- Cause: The Virtual Machine Scale Set (VMSS) creation experience provides CentOS-based 7.2 as an option for deployment. CentOS 7.2 is not available on Azure Stack.
- Remediation: Select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.
- Occurrence: Common

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases.
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled does not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

## Infrastructure backup

<!--Bug 3615401 - scheduler config lost; new issue in YYMM;  hectorl-->
After enabling automatic backups, the scheduler service goes into disabled state unexpectedly. The backup controller service will detect that automatic backups are disabled and raise a warning in the administrator portal. This warning is expected when automatic backups are disabled.

- Applicable: This is a new issue with release 1904.
- Cause: This issue is due to a bug in the service that results in loss of scheduler configuration. This bug does not change the storage location, user name, password, or encryption key.
- Remediation: To mitigate this issue, open the backup controller settings blade in the Infrastructure Backup resource provider and select **Enable Automatic Backups**. Make sure to set the desired frequency and retention period.
- Occurrence: Low

<!-- ## Storage -->
<!-- ## SQL and MySQL-->
<!-- ## App Service -->
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->

## Next steps

- [Review update activity checklist](azure-stack-release-notes-checklist.md)
- [Review list of security updates](azure-stack-release-notes-security-updates-1904.md)
