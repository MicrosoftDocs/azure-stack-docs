---
title: Troubleshoot Azure Stack Hub
titleSuffix: Azure Stack
description: Learn how to troubleshoot Azure Stack Hub, including issues with VMs, storage, and App Service.
author: sethmanheim
ms.topic: troubleshooting-general
ms.date: 03/06/2025
ms.author: sethm
ms.reviewer: prchint
ms.lastreviewed: 12/10/2020

# Intent: As an Azure Stack operator, I want to troubleshoot Azure Stack issues so that I can have a successful deployment.
# Keyword: troubleshoot azure stack

---

# Troubleshoot issues in Azure Stack Hub

This article provides troubleshooting information for Azure Stack Hub integrated environments.

## Common support issues

The following sections include links to documentation that covers common questions sent to Microsoft Support about Azure Stack Hub.

### Purchase considerations

* [Azure Stack Hub pricing](https://azure.microsoft.com/overview/azure-stack/how-to-buy/)
* [Azure Stack Hub overview](azure-stack-overview.md)

### Updates and diagnostics

* [Collect diagnostic logs](./diagnostic-log-collection.md)
* [Validate Azure Stack Hub system state](azure-stack-diagnostic-test.md)
* [Update package release cadence](azure-stack-servicing-policy.md#update-package-release-cadence)
* [Verify and troubleshoot node status](azure-stack-node-actions.md)

### Supported operating systems and sizes for guest VMs

* [Guest operating systems supported on Azure Stack Hub](azure-stack-supported-os.md)
* [VM sizes supported in Azure Stack Hub](../user/azure-stack-vm-sizes.md)

### Microsoft Marketplace

* [Microsoft Marketplace items available for Azure Stack Hub](azure-stack-marketplace-azure-items.md)

### Capacity management

#### Memory

To increase the total available memory capacity for Azure Stack Hub, you can add memory. In Azure Stack Hub, your physical server is also called a *scale unit node*. All scale unit nodes that are members of a single scale unit must have [the same amount of memory](azure-stack-manage-storage-physical-memory-capacity.md).

#### Retention period

A cloud operator can use the retention period setting to specify a time period in days (**0** to **9999**) during which any deleted account can potentially be recovered. The default retention period is **0** days. Setting the value to **0** means that any deleted account is immediately out of retention and marked for periodic garbage collection.

For more information, see [Set the retention period](azure-stack-manage-storage-accounts.md#set-the-retention-period).

### Management of role-based access control

A user in Azure Stack Hub can be a reader, owner, or contributor for each instance of a subscription, resource group, or service. For more information, see [Set access permissions using role-based access control](azure-stack-manage-permissions.md).

If the built-in roles for Azure resources don't meet the specific needs of your organization, you can [create your own custom roles](/azure/role-based-access-control/tutorial-custom-role-powershell).

### Management of usage and billing based on subscription type

Choose the type of shared services account that you use for Azure Stack Hub. The types of subscriptions that you can use for registration of a multitenant Azure Stack Hub deployment are Cloud Solution Provider (CSP) and Azure Partner Shared Services (APSS). For more information, see [Create a CSP or APSS subscription](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription).

### Scale unit metrics

You can use PowerShell to get stamp utilization information without help from Microsoft Support:

1. Create a [privileged endpoint (PEP) session](azure-stack-privileged-endpoint.md).

2. Run the following command:

   ```
   Test-AzureStack
   ```

3. Close the PEP session.

4. Run the following command by using an invoke-command call:

   ```
   Get-AzureStackLog -FilterByRole SeedRing
   ```

5. Extract the **SeedRing.zip** file. You can get the validation report from the **ERCS** folder where you ran `Test-AzureStack`.

For more information, see [Send Azure Stack Hub diagnostic logs by using the privileged endpoint](azure-stack-get-azurestacklog.md).

## Virtual machines

### Reset of a Linux VM password

If you forget the password for a Linux VM and the **Reset password** option isn't working due to problems with the VMAccess extension, you can reset the password by following these steps:

1. Choose a Linux VM to use as a recovery VM.

1. Sign in to the user portal, and then:
   1. Make a note of the VM size, NIC, public IP, network security group, and data disks.
   1. Stop the affected VM.
   1. Remove the affected VM.
   1. Attach the disk from the affected VM as a data disk on the recovery VM. (The disk might take a couple of minutes to become available.)

1. Sign in to the recovery VM and run the following command:

   ```
   sudo su -
   mkdir /tempmount
   fdisk -l
   mount /dev/sdc2 /tempmount /*adjust /dev/sdc2 as necessary*/
   chroot /tempmount/
   passwd root /*substitute root with the user whose password you want to reset*/
   rm -f /.autorelabel /*Remove the .autorelabel file to prevent a time consuming SELinux relabel of the disk*/
   exit /*to exit the chroot environment*/
   umount /tempmount
   ```

1. Sign in to the user portal, and then:

   1. Detach the disk from the recovery VM.
   1. Re-create the VM from the disk.
   1. Transfer the public IP from the previous VM, attach the data disks, and complete related tasks.

You can also take a snapshot of the original disk and create a new disk from it rather than perform the changes directly on the original disk. For more information, see these topics:

* [Reset a local Linux password on Azure VMs](/azure/virtual-machines/troubleshooting/reset-password)
* [Create a disk from a snapshot](/azure/virtual-machines/troubleshooting/troubleshoot-recovery-disks-portal-linux#create-a-disk-from-the-snapshot)
* [Change and reset the root password](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-working_with_the_grub_2_boot_loader#sec-Changing_and_Resetting_the_Root_Password) (Red Hat Enterprise Linux documentation)

### License activation failure for Windows Server 2012 R2 during provisioning

If there's a problem with license activation, Windows fails to activate and a watermark appears on the lower-right corner of the screen. The WaSetup.xml logs located under C:\Windows\Panther contain the following event:

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

To activate the license, copy the Automatic Virtual Machine Activation (AVMA) key for the edition that you want to activate.

|Edition|AVMA key|
|-|-|
|Datacenter|Y4TGP-NPTV9-HTC2H-7MGQ3-DV4TW|
|Standard|DBGBW-NPF86-BJVTX-K3WKJ-MTB6V|
|Essentials|K2XGM-NMBT3-2R6Q8-WF2FK-P36R2|

On the VM, run the following command:

```powershell
slmgr /ipk <AVMA_key>
```

For complete details, see [Automatic Virtual Machine activation in Windows Server](/windows-server/get-started-19/vm-activation-19).

### Default image and gallery item

You must add a Windows Server image and gallery item before you deploy VMs in Azure Stack Hub.

### VHD files on disk after VM deletion

After you delete VMs, you might still see the VHD files on disk. This behavior is by design:

* When you delete a VM, VHDs aren't deleted. Disks are separate resources in the resource group.
* When you delete a storage account, the deletion is visible immediately through Azure Resource Manager. But the disks that it might contain stay in storage until garbage collection runs.

If you see "orphan" VHDs, it's important to know if they're part of the folder for a storage account that was deleted. If the storage account wasn't deleted, it's normal that they're still there.

## Storage

### Storage reclamation

Reclaimed capacity might take up to 14 hours to show up in the portal. Space reclamation depends on various factors, including the usage percentage of internal container files in a block blob store. Depending on how much data is deleted, there's no guarantee on the amount of space that could be reclaimed when the garbage collector runs.

You can read more about configuring the retention threshold and on-demand reclamation in [Manage Azure Stack Hub storage accounts](azure-stack-manage-storage-accounts.md).

### Azure Storage Explorer not working with Azure Stack Hub

If you're using an integrated system in a disconnected scenario, we recommend that you use an enterprise certificate authority. Export the root certificate in a Base64 format and then import it in Azure Storage Explorer. Be sure to remove the trailing slash (`/`) from the Resource Manager endpoint. For more information, see [Prepare for connecting to Azure Stack Hub](../user/azure-stack-storage-connect-se.md#prepare-for-connecting-to-azure-stack-hub).

## App Service

If the Create-AADIdentityApp.ps1 script that's required for App Service fails, be sure to include the required `-AzureStackAdminCredential` parameter when you're running the script. For more information, see [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md).

## <a name = "troubleshoot-azure-stack-hub-updates"></a>Azure Stack Hub patches and updates

The patch and update process for Azure Stack Hub is designed to help operators apply update packages in a consistent, streamlined way. Although problems are uncommon during the patch and update process, they can occur. We recommend the following steps if you encounter a problem.

Before you start, be sure to follow the [update activity checklist](release-notes-checklist.md) and [enable proactive log collection](./diagnostic-log-collection.md#send-logs-proactively).

1. Follow the remediation steps in the failure alert.

2. If you can't resolve your problem, create an [Azure Stack Hub support ticket](./azure-stack-help-and-support-overview.md). Be sure to [collect logs](./diagnostic-log-collection.md#send-logs-now) for the time span when the problem occurred.

If an update fails, either with a critical alert or a warning, it's important that you review the failure and contact Microsoft Customer Support Services as directed in the alert. Leaving a scale unit in a failed update state for a long time can cause additional problems that are more difficult to resolve later.

The following problems and solutions apply to Azure Stack Hub integrated systems.

### PreparationFailed state

**Applicable**: This problem applies to all supported releases.

**Cause**: When you try to install the Azure Stack Hub update, the status for the update might fail and change state to `PreparationFailed`. For internet-connected systems, this state usually indicates that the update package can't be downloaded properly due to a weak internet connection.

**Remediation**: Select **Install now** again. If the problem persists, [manually upload the update package](azure-stack-apply-updates.md?#install-updates-and-monitor-progress).

**Occurrence**: Common.

### Update failed with a warning to check and enforce external key protectors on CSVs

**Applicable**: This problem applies to all supported releases.

**Cause**: The baseboard management controller (BMC) password isn't set correctly.

**Remediation**: [Update the BMC credential](./azure-stack-rotate-secrets.md#update-the-bmc-credential) and resume the update.

### Warnings and errors reported while an update is in progress

**Applicable**: This problem applies to all supported releases.

**Cause**: When an Azure Stack Hub update is in the status **In progress**, warnings and errors might be reported in the portal. Components might time out while waiting for other components during an upgrade. This timeout results in an error. Azure Stack Hub has a mechanism to retry or remediate some of the tasks due to intermittent errors.

**Remediation**: While the Azure Stack Hub update has an **In progress** status, you can ignore warnings and errors reported in the portal.

**Occurrence**: Common.

::: moniker range="azs-2002"

### 2002 update failed

**Applicable**: This problem applies only to the 2002 release.

**Cause**: When you attempt the 2002 update, the update might fail and provide this message: `The private network parameter is missing from cloud parameters. Please use set-azsprivatenetwork cmdlet to set private networkTrace`.

**Remediation**:
[Set up a private internal network](./azure-stack-network.md?view=azs-2002&preserve-view=true#private-network).
::: moniker-end
