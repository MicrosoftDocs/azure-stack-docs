---
title: Upgrade stretched clusters from Azure Stack HCI OS, version 22H2 to 23H2
description: Learn how to upgrade stretched clusters from Azure Stack HCI OS, version 22H2 to 23H2, including prerequisites, PowerShell steps, and post-upgrade verification.
author: ronmiab
contributors: null
ms.topic: how-to
ms.date: 09/22/2025
ms.author: robess
ms.reviewer: mindydiep
ms.custom:
  - ai-gen-docs-bap
  - ai-gen-title
  - ai-seo-date:08/15/2025
---

# Upgrade stretched clusters from Azure Stack HCI OS, version 22H2 to 23H2

::: moniker range=">=azloc-2509"

[!INCLUDE [applies-to](../includes/hci-applies-to-22h2.md)]

> [!IMPORTANT]
> Azure Stack HCI OS, version 22H2 is already out of support.
>
> - Monthly security and quality updates have stopped.
>
> - Your system continues to work, including registration and repair.
>
> - Billing has continued.
>
> - Microsoft Support is available only for upgrade assistance.
>
> These steps in this article are the only supported method to upgrade the OS for Azure Stack HCI stretched clusters from version 20349.xxxx (22H2) to version 25398.xxxx (23H2).
>
> - This version is supported until April 2026.
>
> - You can't upgrade the OS to version 26100.xxxx (24H2) or upgrade the solution after this.
>
> - After April 2026, stretched clusters aren't supported.

This article explains how to upgrade the operating system (OS) for Azure Stack HCI stretched clusters from version 20349.xxxx (22H2) to version 25398.xxxx (23H2). In this article, OS version 25398.xxxx (23H2) is the *new* version, and version 20349.xxxx (22H2) is the *old* version.

If you completed the OS upgrade to version 23H2 and experience issues with your volumes, see the [Troubleshoot volumes](#troubleshoot-volumes) section for remediation steps.

## Prerequisites

Before you begin, make sure:

- You have an Azure Local instance running OS version 20349.xxxx.

- The system is registered in Azure.

- All the machines in your Azure Local, version 22H2 instance are healthy and show as **Online**.

- You shut down virtual machines (VMs). We recommend shutting down VMs before performing the OS upgrade to prevent unexpected outages and damage to databases.

- You have the Azure Local version [2509 ISO file download](https://aka.ms/hcireleaseimage/11.2509).

- You run the `RepairRegistration` cmdlet only if both of the following conditions apply:

  - The *identity* property is either missing or doesn’t contain `type = "SystemAssigned"`.
    - Check this in the **Resource JSON** in the Azure portal or run the `Get-AzResource -Name <cluster_name>` PowerShell cmdlet.
  - The **Cloud Management** cluster group isn't present. Check it by running the `Get-ClusterGroup` PowerShell cmdlet.

  - If both conditions are met, run the `RepairRegistration` cmdlet:

   ```powershell
   Register-AzStackHCI -TenantId "<tenant_ID>" -SubscriptionId "<subscription_ID>" -ComputerName "<computer_name>" -RepairRegistration
   ```

- (Recommended) Enable [Secure Boot](/windows-hardware/design/device-experiences/oem-secure-boot) on Azure Local machines before you upgrade the OS. To enable Secure Boot, follow these steps:

   1. Drain the cluster node.
   1. Restart the OS.
   1. Enter the BIOS/UEFI menu.
   1. Review the **Boot** or **Security** section of the UEFI configuration options to find the **Secure Boot** option.
   1. Set the option to **Enabled** or **On**.
   1. Save the changes and restart your computer.

Consult with your hardware vendor for assistance if needed.

## High-level workflow for the OS upgrade

To upgrade the OS on your system, follow these steps:

1. [Complete the prerequisites.](#prerequisites)

1. [Update registry keys.](#update-registry-keys)

1. [Install the new OS using PowerShell.](#install-the-new-os-using-powershell)

1. [Check the status of the updates.](#check-the-status-of-an-update)

1. [Check that the stretched cluster is ready.](#check-that-the-stretched-cluster-is-ready)

1. [Perform post-upgrade steps.](post-upgrade-steps.md)

## Update registry keys

To ensure Resilient File System (ReFS) and live migrations function properly during and after the OS upgrade, follow these steps on each machine in the system to update registry keys. Reboot each machine for the changes to take effect.

1. Set `RefsEnableMetadataValidation` to `0`.

   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" -Value 0 -Type DWord -ErrorAction Stop
   ```

1. Create the parameters key if it doesn't exist. If it already exists, the command might fail with an error, which is expected.

   ```powershell
   New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\Vid\Parameters
   ```

1. Set `SkipSmallLocalAllocations` to `0`.

   ```powershell
   New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Vid\Parameters -Name SkipSmallLocalAllocations -Value 0 -PropertyType DWord
   ```

1. Restart the machine for the changes to take effect.

   If the `RefsEnableMetadataValidation` key is overridden and ReFS volumes fail to come online after you restart, set the key to `1` and then back to `0`.

## Install the new OS using PowerShell

> [!NOTE]
> The following steps require the Cluster-Aware Updating (CAU) role to be installed and enabled on the system. For information on how to install and enable this feature on your Azure Local instance, see [Cluster-Aware Updating overview](https://github.com/MicrosoftDocs/azure-stack-docs/blob/main/windows-server/failover-clustering/cluster-aware-updating#installing-cluster-aware-updating).

To install the new OS using PowerShell, follow these steps:

1. On every machine in the system, run these cmdlets:

   ```powershell
   Set-WSManQuickConfig
   Enable-PSRemoting
   ```

1. To test whether the system is properly set up to apply software updates using Cluster-Aware Updating (CAU), run the `Test-CauSetup` cmdlet. This notifies you of any warnings or errors.

   ```powershell
   Test-CauSetup -ClusterName <System name>
   ```

1. On one of the machines in the system, validate the hardware and settings by running the `Test-Cluster` cmdlet. If any of the condition checks fail, resolve them before proceeding to the next step.

   ```powershell
   Test-Cluster
   ```

1. On each machine, extract the contents of the ISO image and copy them to the local system drive.

   - Make sure the local path is the same on each machine.
   - Then, update the `PathToSetupMedia` parameter with the local path to the ISO image.

   ```powershell
    
   # Define ISO and destination paths
   $isoFilePath = "C:\SetupFiles\WindowsServer\ISOs\example.iso"
   $destinationPath = "C:\SetupFiles\WindowsServer\Files"
    
   # Mount the ISO file
   $iso = Mount-DiskImage -ImagePath $isoFilePath
    
   # Get the drive letter
   $driveLetter = ($iso | Get-Volume).DriveLetter
    
   # Create the destination directory
   New-Item -ItemType Directory -Path $destinationPath
    
   # Copy contents to the local directory
   Copy-Item -Path "$($driveLetter):\" -Destination $destinationPath -Recurse
    
   # Dismount the ISO file
   Dismount-DiskImage -ImagePath $isoFilePath
   ```

1. Upgrade the system.

   ```powershell
   Invoke-CauRun –ClusterName <SystemName> -CauPluginName Microsoft.RollingUpgradePlugin -EnableFirewallRules -CauPluginArguments @{ 'WuConnected'='false';'PathToSetupMedia'='\some\path\';'UpdateClusterFunctionalLevel'='true'; } -ForceSelfUpdate -Force
   ```

1. Check for any further updates and install them. Wait for the update to complete and check the status of the update.

## Check the status of an update

To get the summary information about an update in progress, run the `Get-CauRun` cmdlet:

```powershell
Get-CauRun -ClusterName <SystemName>
```

Here's a sample output:

```console
RunId : <Run ID>
RunStartTime : 10/13/2024 1:35:39 PM
CurrentOrchestrator : NODE1
NodeStatusNotifications : {
   Node : NODE1
   Status : Waiting
   Timestamp : 10/13/2024 1:35:49 PM
}
NodeResults : {
   Node : NODE2
   Status : Succeeded
   ErrorRecordData :
   NumberOfSucceededUpdates : 0
   NumberOfFailedUpdates : 0
   InstallResults :
   Microsoft.ClusterAwareUpdating.UpdateInstallResult[]
}
```

## Check that the stretched cluster is ready

After you update your stretched cluster from version 22H2 to 23H2, check that the stretched cluster is ready by following these steps:

1. Make sure all volumes are up. To check volume status, run the `Get-ClusterSharedVolumeState` command.

1. Make sure the partnerships are set correctly. The replication status in all groups (from the output of `Get-SRGroup`) should show `ContinuouslyReplicating` or `ContinuouslyReplicating_InRpo`.

1. Complete the post-upgrade steps described in [Perform post operating system upgrade steps on Azure Local via PowerShell](post-upgrade-steps.md).

## Troubleshoot volumes

If you updated your stretched cluster from version 22H2 to 23H2 before this release, you might encounter issues with your volumes. To remediate these issues, follow these steps:

1. Stop the Storage Replica partnership.

   1. Use the [PowerShell module](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Upgrade/scripts/SRClusterConfiguration.psm1) to get the **SRPartnership** and **SRGroup** information. Save this information before removing the Storage Replica partnership on the stretched cluster, so you can recreate it after the OS upgrade.

   1. Use `Get-SRPartnership | Remove-SRPartnership` to remove all partnerships.

      ```powershell
      Get-SRPartnership | Remove-SRPartnerships

      Confirm
      Are you sure you want to perform this action?
      This action will remove partnership between source group Test1-Group and destination group Test1-Replica-Group. Are you sure you want to continue?
      [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
      ```

   1. Use `Get-SRPartnership` to ensure the partnership is removed.

1. Update to the new version using the [2509 ISO file download](https://aka.ms/hcireleaseimage/11.2509).

   1. Mount the ISO inside the OS and run the setup. Choose the **Upgrade** option and keep files, settings, and applications.

1. Recreate the Storage Replica partnership.

   1. Use `New-SRPartnership` to create the SR partnership. Modify this command using your saved **SRPartnership** and **SRGroup** information from step 1.

      ```powershell
      New-SRPartnership -SourceComputerName "VIN-SiteA-1" -SourceRGName "Test1-Group" -SourceVolumeName "C:\ClusterStorage\Test1" -SourceLogVolumeName "\\?\Volume{f0XXXXXX-XXXX-XXXX-XXXX-XXXXXXXX0d64}" -DestinationComputerName "VIN-SiteB-1" -DestinationRGName "Test1-Replica-Group"
      ```

   1. Validate the new partnership using [PowerShell module](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Upgrade/scripts/SRClusterConfiguration.psm1). Compare the output with the saved information from step 1.

      > [!NOTE]
      > You can set up and validate each partnership one at a time, making sure the initial sync completes before creating the next. Use the SR partnership details saved from the PowerShell module in step 1 to restore the original configuration.

1. [Check that the stretched cluster is ready](#check-that-the-stretched-cluster-is-ready).

## Frequently asked questions

Here are some frequently asked questions about upgrading stretched clusters.

### Are stretched clusters supported in Azure Local, version 23H2 and beyond?

No. Stretched clusters aren't supported in Azure Local, version 23H2 and beyond. The only supported case is installing the version 23H2 OS upgrade on your version 22H2 stretched cluster. After you install the OS upgrade, you can't upgrade the solution. You continue to get monthly security and quality updates until April 2026. After April 2026, stretched clusters aren't supported.

You can't upgrade stretched clusters to version 24H2.

### Is Storage Replica supported in Azure Local 23H2 and beyond?

No. Storage Replica isn't supported in Azure Local, version 23H2 and beyond. The only supported case is installing the version 23H2 OS upgrade on your version 22H2 stretched cluster.

### Can I upgrade my version 22H2 stretched cluster to version 24H2 directly to skip the version 23H2 OS upgrade?

No. You can only upgrade your version 22H2 stretched cluster to the version 23H2 OS as described in this article.

## Next steps

- [Learn how to perform the post-OS upgrade steps for your Azure Local.](post-upgrade-steps.md)

::: moniker-end

::: moniker range="<=azloc-2508"

This feature is available only in Azure Local 2509 or later.

::: moniker-end
