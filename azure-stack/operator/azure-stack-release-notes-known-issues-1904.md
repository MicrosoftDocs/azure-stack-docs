---
title: Azure Stack release notes - known issues | Microsoft Docs
description: Learn about known issues in Azure Stack.
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

<!-- EXAMPLE -->
## Infrastructure backup

<!--Bug 3615401 - scheduler config lost; new issue in YYMM;  hectorl-->
After enabling automatic backups, the scheduler service goes into disabled state unexpectedly. The backup controller service will detect that automatic backups are disabled and raise a warning in the administrator portal. This warning is expected when automatic backups are disabled.

- Applicable: This is a new issue with release 1904.
- Cause: This issue is due to a bug in the service that results in loss of scheduler configuration. This bug does not change the storage location, user name, password, or encryption key.
- Remediation: To mitigate this issue, open the backup controller settings blade in the Infrastructure Backup resource provider and select **Enable Automatic Backups**. Make sure to set the desired frequency and retention period.
- Occurrence: Low

<!-- TEMPLATE -->
<!-- ### (Feature area) -->

<!--Bug xxxxxxx: bug title; new issue or existing issue,  PM owner-->
<!-- Issues that drop off this list better make it in as an improvement or a fix on release notes page -->
<!-- (Detailed customer facing description of the issue)   -->

<!-- PICK ONE
- Applicable: (All supported releases of Azure Stack - carry over); (Starting in YYMM release of Azure Stack, new issue)
- Cause: (cause of the issue)
- Remediation: (how to work around this, if there is one)
- Occurrence: (rate of occurrence) -->

<!-- ### Portal -->
<!-- ### Compute -->
<!-- ### Storage -->
<!-- ### Networking -->
<!-- ### SQL and MySQL-->
<!-- ### App Service -->
<!-- ### Usage -->
<!-- #### Identity -->
<!-- #### Marketplace -->

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
 
### Access policies

- Applicable: This issue applies to all supported releases
- Cause: In the user portal, when you navigate to a blob within a storage account and try to open Access Policy from the navigation tree, the subsequent window fails to load.
- Remediation: the following PowerShell cmdlets enable creating, retrieving, setting and deleting access policies, respectively:
  - New-AzureStorageContainerStoredAccessPolicy
  - Get-AzureStorageContainerStoredAccessPolicy
  - Set-AzureStorageContainerStoredAccessPolicy
  - Remove-AzureStorageContainerStoredAccessPolicy
- Occurrence: Common

### Upload blob

- Applicable: This issue applies to all supported releases
- Cause: In the user portal, when you try to upload a blob using the OAuth(preview) option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

### Notifications

- Applicable: This issue applies to all supported releases
- Cause: When logged into the Azure Stack portals you might see notifications about the global Azure portal.
- Remediation: You can safely ignore these notifications, as they do not currently apply to Azure Stack (for example, "1 new update - The following updates are now available: Azure portal April 2019 update").
- Occurrence: Common

### Feedback

- Applicable: This issue applies to all supported releases
- Cause: In the user portal dashboard, when you select the Feedback tile, an empty browser tab opens.
- Remediation: you can use Azure Stack User Voice to file a User Voice request.
- Occurrence: Common

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

### Static IP warning

- Applicable: This issue applies to all supported releases
- Cause: In the Azure Stack portal, when you change a static IP address for an IP configuration that is bound to a network adapter attached to a VM instance, you will see a warning message that states
The virtual machine associated with this network interface will be restarted to utilize the new private IP address...
- Remediation: You can safely ignore this message; the IP address will be changed even if the VM instance does not restart.
- Occurrence: Common

### Inbound security rules

- Applicable: This issue applies to all supported releases
- Cause: In the portal, if you add an inbound security rule and select Service Tag as the source, several options are displayed in the Source Tag list that are not available for Azure Stack. The only options that are valid in Azure Stack are as follows.
  - Internet
  - VirtualNetwork
  - AzureLoadBalancer
- Remediation: The other options are not supported as source tags in Azure Stack. Similarly, if you add an outbound security rule and select Service Tag as the destination, the same list of options for Source Tag is displayed. The only valid options are the same as for Source Tag, as described in the previous list. 
- Occurrence: Common

### Network Security Groups

- Applicable: This issue applies to all supported releases
- Cause: Network security groups (NSGs) do not work in Azure Stack in the same way as global Azure. In Azure, you can set multiple ports on one NSG rule (using the portal, PowerShell, and Resource Manager templates). In Azure Stack however, you cannot set multiple ports on one NSG rule via the portal.
- Remediation: To work around this issue, use a Resource Manager template or PowerShell to set these additional rules. 
- Occurrence: Common

### Network interfaces

- Applicable: This issue applies to all supported releases
- Cause: Azure Stack does not support attaching more than 4 Network Interfaces (NICs) to a VM instance today, regardless of the instance size.
- Remediation: No mitigation.
- Occurrence: Common

## Syslog

### Syslog configuration

- Applicable: This issue applies to all supported releases
- Cause: The syslog configuration is not persisted through an update cycle, causing the syslog client to lose its configuration, and the syslog messages to stop being forwarded.
- Remediation: Reconfigure the syslog client after applying an Azure Stack update.
- Occurrence: Common

## Next steps

- [Review update activity checklist](azure-stack-release-notes-checklist.md)
- [Review list of security updates](azure-stack-release-notes-security-updates-1904.md)
