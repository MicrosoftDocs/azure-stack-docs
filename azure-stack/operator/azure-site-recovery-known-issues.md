---
title: Known issues for Azure Site Recovery
description: Learn how to troubleshoot known issues for Azure Site Recovery.
author: ronmiab
ms.author: robess
ms.topic: troubleshooting
ms.reviewer: rtiberiu
ms.lastreviewed: 03/07/2023
ms.date: 03/07/2023
---

# Known issues - Azure Site Recovery on Azure Stack Hub

This article describes known issues for Azure Site Recovery on Azure Stack Hub. Use the following sections for details about the current known issues and limitations related to Azure Site Recovery on Azure Stack Hub features.

## Reprotection: available data disk slots on appliance

1. Ensure the appliance VM has enough data disk slots, as the replica disks for reprotect is attached to the appliance.

2. The initial allowed number of disks being reprotected at the same time is 31. The default size of the appliance created from the marketplace item is Standard DS4 v2, which supports up to 32 data disks, and the appliance itself uses one data disk.

3. If the sum of the protected VMs is greater than 31, perform one of the following actions:
    - Split the VMs that require reprotection into smaller groups to ensure that the number of disks reprotected, at the same time, doesn't exceed the maximum number of data disks the appliance supports.
    - Increase the size of the Azure Site Recovery appliance VM.

    >[!NOTE]
    > We do not test and validate large VM SKUs for the appliance VM.

4. If you're trying to reprotect a VM, but there aren't enough slots on the appliance to hold the replication disks, **An internal error occurred** message displays. You can check the number of the data disks currently on the appliance, or sign in to the appliance, go to **Event Viewer**, and open logs for **Azure Site Recovery** under **Applications and Services Logs**:

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/event-viewer.png" alt-text="Sample screenshot of Event Viewer for Azure Site Recovery."lightbox="media/azure-site-recovery/known-issues/event-viewer.png":::

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/azure-site-recovery-logs.png" alt-text="Sample screenshot of Azure Site Recovery logs."lightbox="media/azure-site-recovery/known-issues/azure-site-recovery-logs.png":::

    - Find the latest warning to identify the issue.

## Linux VM kernel version not supported

1. Check your kernel version with `uname -r`.

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/linux-kernel-version.png" alt-text="Sample screenshot of Linux Kernel version."lightbox="media/azure-site-recovery/known-issues/linux-kernel-version.png":::

    For more information on supported Linux kernel versions, see [Azure to Azure support matrix](/azure/site-recovery/azure-to-azure-support-matrix#linux).

2. With a supported kernel version, the failover, which causes the VM to perform a restart, can cause the failed-over VM to be updated to a newer kernel version that may not be supported.
    - To avoid an update due to a failover VM restart, run this command: `sudo apt-mark hold linux-image-azure linux-headers-azure` so that the kernel version update can proceed.

3. For an unsupported kernel version, check for an older kernel version that you can roll back to by running the appropriate command for your VM:
    - Debian / Ubuntu: `dpkg --list | grep linux-image`
    - RedHat / CentOS / RHEL: `rpm -qa kernel`

    Here's an example in an Ubuntu VM on version 5.4.0-1103-azure, which is unsupported. After running the command we can see a supported version, 5.4.0-1077-azure, which is already installed on the VM. With this information, we can take the next step and roll back to the supported version.

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/kernel-version-rollback.png" alt-text="Sample screenshot of an Ubuntu VM kernel version check."lightbox="media/azure-site-recovery/known-issues/kernel-version-rollback.png":::

4. Roll back to a supported kernel version using these steps:
    1. First, make a copy of /etc/default/grub in case there's any error. For example, `sudo cp /etc/default/grub /etc/default/grub.bak`
    1. Then modify `/etc/default/grub` to set GRUB_DEFAULT to the previous version that you want to use. You might have something similar to this `GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 5.4.0-1077-azure"`.

        :::image type="content" source="../operator/media/azure-site-recovery/known-issues/grub-default.png" alt-text="Sample screenshot of an Ubuntu VM kernel version rollback."lightbox="media/azure-site-recovery/known-issues/grub-default.png":::

    1. **Save** the file and **Exit**.
    1. Then run `sudo update-grub` to update the grub.
    1. Finally, reboot the VM and continue with the rollback to a supported kernel version.

5. If you don't have an old kernel version to roll back to, wait for the mobility agent update so that your kernel can be supported. The update is completed automatically, if it's ready, and you can check the version on the portal to confirm:

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/mobility-agent-update.png" alt-text="Sample screenshot of mobility agent update check."lightbox="media/azure-site-recovery/known-issues/mobility-agent-update.png":::

## Reprotect manual resync isn't supported yet

After the reprotect job is complete, the initial replication and replication is started in sequence. During replication, there may be cases that require a resync, which means a new initial replication is triggered to synchronize all the changes.

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

1. If you leave `$failbackPolicyName` and `$failbackExtensionName` empty or null, the reprotect can fail. See the following examples:

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/reprotect-fail-error-1.png" alt-text="Sample screenshot of a VM failed to perform operation error."lightbox="media/azure-site-recovery/known-issues/reprotect-fail-error-1.png":::

    :::image type="content" source="../operator/media/azure-site-recovery/known-issues/reprotect-fail-error-2.png" alt-text="Sample screenshot of second operation error on a different VM."lightbox="media/azure-site-recovery/known-issues/reprotect-fail-error-2.png":::

    - Always specify the `$failbackPolicyName` and `$failbackExtensionName`, as shown in the preceding example:

        ```powershell
        $failbackPolicyName = "failback-default-replication-policy"
        $failbackExtensionName = "default-failback-extension"
        ```

        ```powershell
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
        ```

        ```powershell
        $result = Invoke-AzureRmResourceAction -Action "reprotect" ` -ResourceId $protectedItemId ` -Force -Parameters $parameters 
        ```

## Mobility service agent warning

When replicating multiple VMs, you might see the **Protected item health changed to Warning** error in the Site Recovery jobs.

:::image type="content" source="../operator/media/azure-site-recovery/known-issues/mobility-service-agent-warning.png" alt-text="Sample screenshot of the Protected item health change warning."lightbox="media/azure-site-recovery/known-issues/mobility-service-agent-warning.png":::

This error message should only be a warning and is not a blocking issue for the actual replication or failover processes.

>[!TIP]
>You can check the the state of the respective VM to ensure it's healthy.
