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
ms.date: 04/22/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 04/22/2019
---

# Azure Stack known issues

This article lists known issues with supported releases of Azure Stack. The list is updated as new releases and hotfixes are released.

> [!IMPORTANT]  
> Review this section before applying the update.

## Portal

### Add-on plans

- Applicable: This issue applies to all supported releases
- Cause: Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted.
- Remediation: No mitigation.
- Occurrence: Common

### Administrative Subscriptions

- Applicable: This issue applies to all supported releases
- Cause: The two administrative subscription types that were introduced with version 1804 should not be used. The subscription types are Metering subscription, and Consumption subscription.
- Remediation: These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the Default Provider subscription type.
- Occurrence: Common

### Subscription resources

- Applicable: This issue applies to all supported releases
- Cause: Deleting user subscriptions results in orphaned resources.
- Remediation: First delete user resources or the entire resource group, and then delete the user subscriptions.
- Occurrence: Common

### Subscription permissions

- Applicable: This issue applies to all supported releases
- Cause: You cannot view permissions to your subscription using the Azure Stack portals.
- Remediation: Use PowerShell to verify permissions.
- Occurrence: Common

### Upload blob

- Applicable: This issue applies to all supported releases
- Cause: In the user portal, when you try to upload a blob using the OAuth(preview) option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

### Load Balancer

- Applicable: This issue applies to all supported releases
- Cause: In the user portal, if you attempt to add a **Backend Pool** to a Load Balancer the operation fails with error message 'failed to update Load Balancer...'
- Remediation: Use PowerShell, CLI or ARM Template to associate Backend Pool with a Load Balancer resource.
- Occurence: Common

- Applicable: This iss applies to all supported releases
- Cause: In the user portal, if you attempt to create an **Inbound NAT Rule** for a **Load Balancer** the operation will fail with the error message 'Failed to update Load Balancer...'
- Remediation: Use PowerShell, CLI or ARM Template to associate Backend Pool with a Load Balancer resource.
- Occurence: Common

- Applicable: This iss applies to all supported releases
- Cause: In the user portal, the **Create Load Balancer** blade show an option to create a **Standard** Load Balancer SKU.  This option is not supported in Azure Stack.
- Remediation: Use Basic Load Balancer option instead.
- Occurence: Common

### Public IP Address

- Applicable: This iss applies to all supported releases
- Cause: In the user portal, the **Create Public IP Address** blade shows an option to create a **Standard** SKU.  The **Standard** SKU is not supported in Azure Stack.
- Remediation: Use Basic SKU instead for Public IP Address.
- Occurence: Common

### Network Interface 

- Applicable: This iss applies to all supported releases
- Cause: In the user portal, if you attempt to **Attach Network Interface** to an existing VM via the **Networking** blade the operation fails with the error message: 'Failed to attach network interface...'
- Remediation: Use PowerShell, CLI or ARM Template to associate the network interface with the VM.
- Occurence: Common

## Compute

### VM boot diagnostics

- Applicable: This issue applies to all supported releases
- Cause: When creating a new Windows Virtual Machine (VM), the following error may be displayed:
'Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'
The error occurs if you enable boot diagnostics on a VM but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name as you used previously.
- Occurrence: Common

### Virtual machine scale set

- Applicable: This issue applies to all supported releases
- Cause: The Virtual Machine Scale Set creation experience provides CentOS-based 7.2 as an option for deployment. CentOS 7.2 is not available on Azure Stack.
- Remediation: Select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.
- Occurrence: Common

### Managed disks

- Applicable: This issue applies to all supported releases
- Cause: If the subscription was created before the 1808 update, deploying a VM with Managed Disks might fail with an internal error message.
- Remediation: Follow these steps for each subscription:
  - In the Tenant portal, go to Subscriptions and find the subscription. Select Resource Providers, then select Microsoft.Compute, and then click Re-register.
  - Under the same subscription, go to Access Control (IAM), and verify that Azure Stack – Managed Disk is listed.
- Occurrence: Common

### Managed disks with multi-tenancy

- Applicable: This issue applies to all supported releases
- Cause: If you have configured a multi-tenant environment, deploying VMs in a subscription associated with a guest directory might fail with an internal error message.
- Remediation: follow these steps in this article to reconfigure each of your guest directories.
- Occurrence: Common

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled will not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

## Networking

### Network interfaces

- Applicable: This issue applies to all supported releases
- Cause: Azure Stack does not support attaching more than 4 Network Interfaces (NICs) to a VM instance today, regardless of the instance size.
- Remediation: No mitigation.
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
