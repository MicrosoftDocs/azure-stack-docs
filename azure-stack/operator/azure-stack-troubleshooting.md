---
title: Troubleshoot Azure Stack Hub
titleSuffix: Azure Stack
description: Learn how to troubleshoot Azure Stack Hub, including issues with VMs, storage, and App Service.
author: PatAltimore

ms.topic: article
ms.date: 12/10/2020
ms.author: patricka
ms.reviewer: prchint
ms.lastreviewed: 12/10/2020

# Intent: As an Azure Stack operator, I want to troubleshoot Azure Stack issues.
# Keyword: troubleshoot azure stack

---

# Troubleshoot issues in Azure Stack Hub

This document provides troubleshooting information for Azure Stack Hub integrated environments. For help with the Azure Stack Development Kit, see [ASDK Troubleshooting](../asdk/asdk-troubleshooting.md) or get help from experts on the [Azure Stack Hub MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack).

## Frequently asked questions

These sections include links to docs that cover common questions sent to Microsoft Support.

### Purchase considerations

* [How to buy](https://azure.microsoft.com/overview/azure-stack/how-to-buy/)
* [Azure Stack Hub overview](azure-stack-overview.md)

### Updates and diagnostics

* [How to use diagnostics tools in Azure Stack Hub](./azure-stack-diagnostic-log-collection-overview.md)
* [How to validate Azure Stack Hub system state](azure-stack-diagnostic-test.md)
* [Update package release cadence](azure-stack-servicing-policy.md#update-package-release-cadence)
* [Verify and troubleshoot node status](azure-stack-node-actions.md)

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

* [Tutorial: Create a custom role for Azure resources using Azure PowerShell](/azure/role-based-access-control/tutorial-custom-role-powershell)

### Manage usage and billing as a CSP

* [Manage usage and billing as a CSP](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription)
* [Create a CSP or APSS subscription](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription)

Choose the type of shared services account that you use for Azure Stack Hub. The types of subscriptions that can be used for registration of a multi-tenant Azure Stack Hub are:

* Cloud Solution Provider
* Partner Shared Services subscription

### Get scale unit metrics

You can use PowerShell to get stamp utilization information without help from Microsoft Support. To obtain stamp utilization:

1. Create a PEP session.
2. Run `test-azurestack`.
3. Exit PEP session.
4. Run `get-azurestacklog -filterbyrole seedring` using an invoke-command call.
5. Extract the seedring .zip. You can obtain the validation report from the ERCS folder where you ran `test-azurestack`.

For more information, see [Azure Stack Hub Diagnostics](azure-stack-get-azurestacklog.md).

## Troubleshoot virtual machines (VMs)

### Reset Linux VM password

If you forget the password for a Linux VM and the **Reset password** option is not working due to issues with the VMAccess extension, you can perform a reset following these steps:

1. Choose a Linux VM to use as a recovery VM.

1. Sign in to the User portal:
   1. Make a note of the VM size, NIC, Public IP, NSG and data disks.
   1. Stop the impacted VM.
   1. Remove the impacted VM.
   1. Attach the disk from the impacted VM as a data disk on the recovery VM (it may take a couple of minutes for the disk to be available).

1. Sign in to the recovery VM and run the following command:

   ```
   sudo su –
   mkdir /tempmount
   fdisk -l
   mount /dev/sdc2 /tempmount /*adjust /dev/sdc2 as necessary*/
   chroot /tempmount/
   passwd root /*substitute root with the user whose password you want to reset*/
   rm -f /.autorelabel /*Remove the .autorelabel file to prevent a time consuming SELinux relabel of the disk*/
   exit /*to exit the chroot environment*/
   umount /tempmount
   ```

1. Sign in to the User portal:

   1. Detach the disk from the Recovery VM.
   1. Recreate the VM from the disk.
   1. Be sure to transfer the Public IP from the previous VM, attach the data disks, etc.


You may also take a snapshot of the original disk and create a new disk from it rather than perform the changes directly on the original disk. For more information, see these topics:

- [Reset password](/azure/virtual-machines/troubleshooting/reset-password)
- [Create a disk from a snapshot](/azure/virtual-machines/troubleshooting/troubleshoot-recovery-disks-portal-linux#create-a-disk-from-the-snapshot)
- [Changing and resetting the Root password](https://access.redhat.com/documentation/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-terminal_menu_editing_during_boot#sec-Changing_and_Resetting_the_Root_Password)


### License activation fails for Windows Server 2012 R2 during provisioning

In this case, Windows will fail to activate and you will see a watermark on the bottom-right corner of the screen. The WaSetup.xml logs located under C:\Windows\Panther contains the following event:

```xml
<Event time="2019-05-16T21:32:58.660Z" category="ERROR" source="Unattend">
    <UnhandledError>
        <Message>InstrumentProcedure: Failed to execute 'Call ConfigureLicensing()'. Will raise error to caller</Message>
        <Number>-2147221500</Number>
        <Description>Could not find the VOLUME_KMSCLIENT product</Description>
        <Source>Licensing.wsf</Source>
    </UnhandledError>
</Event>
```


To activate the license, copy the Automatic Virtual Machine Activation (AVMA) key for the SKU you want to activate.

|Edition|AVMA Key|
|-|-|
|Datacenter|Y4TGP-NPTV9-HTC2H-7MGQ3-DV4TW|
|Standard|DBGBW-NPF86-BJVTX-K3WKJ-MTB6V|
|Essentials|K2XGM-NMBT3-2R6Q8-WF2FK-P36R2|

On the VM, run the following command:

```powershell
slmgr /ipk <AVMA_key>
```

For complete details, see [VM Activation](/windows-server/get-started-19/vm-activation-19).

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

If you're using an integrated system in a disconnected scenario, it's recommended to use an Enterprise Certificate Authority (CA). Export the root certificate in a Base-64 format and then import it in Azure Storage Explorer. Make sure that you remove the trailing slash (`/`) from the Resource Manager endpoint. For more information, see [Prepare for connecting to Azure Stack Hub](../user/azure-stack-storage-connect-se.md).

## Troubleshoot App Service

### Create-AADIdentityApp.ps1 script fails

If the Create-AADIdentityApp.ps1 script that's required for App Service fails, be sure to include the required `-AzureStackAdminCredential` parameter when running the script. For more information, see [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md#create-an-azure-ad-app).

## Troubleshoot Azure Stack Hub updates

The Azure Stack Hub patch and update process is designed to allow operators to apply update packages in a consistent, streamlined way. While uncommon, issues can occur during patch and update process. The following steps are recommended should you encounter an issue during the patch and update process:

0. **Prerequisites**: Be sure that you have followed the [Update Activity Checklist](release-notes-checklist.md) and [enable proactive log collection](./azure-stack-diagnostic-log-collection-overview.md#send-logs-proactively).

1. Follow the remediation steps in the failure alert created when your update failed.

2. If you have been unable to resolve your issue, create an [Azure Stack Hub support ticket](./azure-stack-help-and-support-overview.md). Be sure you have [logs collected](./azure-stack-diagnostic-log-collection-overview.md#send-logs-now) for the time span when the issue occurred.

## Common Azure Stack Hub patch and update issues

*Applies to: Azure Stack Hub integrated systems*

### PreparationFailed

**Applicable**: This issue applies to all supported releases.

**Cause**: When attempting to install the Azure Stack Hub update, the status for the update might fail and change state to `PreparationFailed`. For internet-connected systems this is usually indicative of the update package being unable to download properly due to a weak internet connection. 

**Remediation**: You can work around this issue by clicking **Install now** again. If the problem persists, we recommend manually uploading the update package by following the [Install updates](azure-stack-apply-updates.md?#install-updates-and-monitor-progress) section.

**Occurrence**: Common

### Warnings and errors reported while update is in progress

**Applicable**: This issue applies to all supported releases.

**Cause**: When Azure Stack Hub update is in status **In progress**, warnings and errors may be reported in the portal. Components may timeout waiting for other components during upgrade resulting in an error. Azure Stack Hub has mechanism to retry or remediate some of the tasks due to intermittent errors.

**Remediation**: While the Azure Stack Hub update is in status **In progress**, warnings and errors reported in the portal can be ignored.

**Occurrence**: Common

::: moniker range="azs-2002"
### 2002 update failed

**Applicable**: This issue applies only to the 2002 release.

**Cause**: When attempting the 2002 update, the update might fail and provide this message: `The private network parameter is missing from cloud parameters. Please use set-azsprivatenetwork cmdlet to set private networkTrace`.

**Remediation**: 
[Set up a private internal network](./azure-stack-network.md?view=azs-2002&preserve-view=true#private-network).
::: moniker-end