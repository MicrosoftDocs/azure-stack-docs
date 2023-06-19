---
title: Known issues for Azure Site Recovery (preview)
description: Learn how to troubleshoot known issues for Azure Site Recovery.
author: ronmiab
ms.author: robess
ms.topic: troubleshooting
ms.date: 06/19/2023
ms.reviewer: rtiberiu
ms.lastreviewed: 03/07/2023

---

# Known issues - Azure Site Recovery on Azure Stack Hub (preview)

This article describes known issues for Azure Site Recovery on Azure Stack Hub. Use the following sections for details about the current known issues and limitations in Azure Site Recovery on Azure Stack Hub.

## Re-protection: available data disk slots on appliance

1. Ensure the appliance VM has enough data disk slots, as the replica disks for re-protection are attached to the appliance.

2. The initial allowed number of disks being re-protected at the same time is 31. The default size of the appliance created from the marketplace item is [Standard_DS4_v2](../user/azure-stack-vm-sizes.md#dsv2-series), which supports up to 32 data disks, and the appliance itself uses one data disk.

3. If the sum of the protected VMs is greater than 31, perform one of the following actions:
    - Split the VMs that require re-protection into smaller groups to ensure that the number of disks re-protected at the same time doesn't exceed the maximum number of data disks the appliance supports.
    - Increase the size of the Azure Site Recovery appliance VM.

    >[!NOTE]
    > We do not test and validate large VM SKUs for the appliance VM.

4. If you're trying to re-protect a VM, but there aren't enough slots on the appliance to hold the replication disks, the error message **An internal error occurred** displays. You can check the number of the data disks currently on the appliance, or sign in to the appliance, go to **Event Viewer**, and open logs for **Azure Site Recovery** under **Applications and Services Logs**:

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/event-viewer.png" alt-text="Sample screenshot of Event Viewer for Azure Site Recovery."lightbox="media/azure-site-recovery/known-issues/event-viewer.png":::

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/azure-site-recovery-logs.png" alt-text="Sample screenshot of Azure Site Recovery logs."lightbox="media/azure-site-recovery/known-issues/azure-site-recovery-logs.png":::

    Find the latest warning to identify the issue.

## Linux VM kernel version not supported

1. Check your kernel version by running the command `uname -r`.

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/linux-kernel-version.png" alt-text="Sample screenshot of Linux Kernel version."lightbox="media/azure-site-recovery/known-issues/linux-kernel-version.png":::

    For more information about supported Linux kernel versions, see [Azure to Azure support matrix](/azure/site-recovery/azure-to-azure-support-matrix#linux).

2. With a supported kernel version, the failover, which causes the VM to perform a restart, can cause the failed-over VM to be updated to a newer kernel version that may not be supported. To avoid an update due to a failover VM restart, run the command `sudo apt-mark hold linux-image-azure linux-headers-azure` so that the kernel version update can proceed.

3. For an unsupported kernel version, check for an older kernel version to which you can roll back, by running the appropriate command for your VM:
    - Debian/Ubuntu: `dpkg --list | grep linux-image`
    - RedHat/CentOS/RHEL: `rpm -qa kernel`

    The following image shows an example in an Ubuntu VM on version 5.4.0-1103-azure, which is unsupported. After the command runs, you can see a supported version, 5.4.0-1077-azure, which is already installed on the VM. With this information, you can roll back to the supported version.

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/kernel-version-rollback.png" alt-text="Sample screenshot of an Ubuntu VM kernel version check."lightbox="media/azure-site-recovery/known-issues/kernel-version-rollback.png":::

4. Roll back to a supported kernel version using these steps:
    1. First, make a copy of **/etc/default/grub** in case there's an error; for example, `sudo cp /etc/default/grub /etc/default/grub.bak`.
    1. Then, modify **/etc/default/grub** to set **GRUB_DEFAULT** to the previous version that you want to use. You might have something similar to **GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 5.4.0-1077-azure"**.

        :::image type="content" source="../operator/media/azure-site-recovery/known-issues/grub-default.png" alt-text="Sample screenshot of an Ubuntu VM kernel version rollback."lightbox="media/azure-site-recovery/known-issues/grub-default.png":::

    1. Select **Save** to save the file, then select **Exit**.
    1. Run `sudo update-grub` to update the grub.
    1. Finally, reboot the VM and continue with the rollback to a supported kernel version.

5. If you don't have an old kernel version to which you can roll back, wait for the mobility agent update so that your kernel can be supported. The update is completed automatically, if it's ready, and you can check the version on the portal to confirm:

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/mobility-agent-update.png" alt-text="Sample screenshot of mobility agent update check."lightbox="media/azure-site-recovery/known-issues/mobility-agent-update.png":::

## Re-protect manual resync isn't supported yet

After the re-protect job is complete, the replication is started in sequence. During replication, there may be cases that require a resync, which means a new initial replication is triggered to synchronize all the changes.

There are two types of resync:

- Automatic resync. Requires no user action and is done automatically. Users can see some events shown on the portal:

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/automatic-resync-portal.png" alt-text="Sample screenshot of Automatic resync on the Users portal."lightbox="media/azure-site-recovery/known-issues/automatic-resync-portal.png":::

- Manual resync. Requires user action to trigger the resync manually and is needed in the following instances:
  - The storage account chosen for the reprotect is missing.
  - The replication disk on the appliance is missing.
  - The replication write exceeds the capacity of the replication disk on the appliance.

    >[!TIP]
    > You can also find the manual resync reasons in the events blade to help you decide whether a manual resync is required.

## Known issues in PowerShell automation

- If you leave `$failbackPolicyName` and `$failbackExtensionName` empty or null, the re-protect can fail. See the following examples:

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/reprotect-fail-error-1.png" alt-text="Sample screenshot of a VM failed to perform operation error."lightbox="media/azure-site-recovery/known-issues/reprotect-fail-error-1.png":::

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/reprotect-fail-error-2.png" alt-text="Sample screenshot of second operation error on a different VM."lightbox="media/azure-site-recovery/known-issues/reprotect-fail-error-2.png":::

- Always specify the `$failbackPolicyName` and `$failbackExtensionName`, as shown in the following example:

  ```powershell
  $failbackPolicyName = "failback-default-replication-policy"
  $failbackExtensionName = "default-failback-extension"
  $parameters = @{
      "properties" = @{
          "customProperties" = @{
              "instanceType" = "AzStackToAzStackFailback"
              "applianceId" = $applianceId
              "logStorageAccountId" = $LogStorageAccount.Id
              "policyName" = $failbackPolicyName
              "replicationExtensionName" = $failbackExtensionName
          }
      }
  }
  $result = Invoke-AzureRmResourceAction -Action "reprotect" ` -ResourceId $protectedItemId ` -Force -Parameters $parameters 
  ```

## Mobility service agent warning

When replicating multiple VMs, you might see the **Protected item health changed to Warning** error in the Site Recovery jobs.

:::image type="content" source="../operator/media/azure-site-recovery/known-issues/mobility-service-agent-warning.png" alt-text="Sample screenshot of the Protected item health change warning."lightbox="media/azure-site-recovery/known-issues/mobility-service-agent-warning.png":::

This error message should only be a warning and is not a blocking issue for the actual replication or failover processes.

>[!TIP]
>You can check the the state of the respective VM to ensure it's healthy.

## Next steps

- [Azure Site Recovery on Azure Stack Hub](azure-site-recovery-overview.md)
- [Azure Site Recovery on Azure Stack Hub capacity planning](azure-site-recovery-capacity-planning.md)
