---
title: Upgrade Azure Stack HCI OS to version 26100.xxxx using PowerShell
description: Learn how to use PowerShell to upgrade Azure Stack HCI OS to version 26100.xxxx.
author: alkohli
ms.topic: how-to
ms.date: 06/11/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Upgrade Azure Stack HCI OS to version 26100.xxxx using PowerShell

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

This article describes how to upgrade the Azure Stack HCI operating system (OS) via PowerShell. Supported upgrade paths include:

- From OS version 20349.xxxx to 26100.xxxx.

- From OS version 25398.xxxx to 26100.xxxx.

> [!IMPORTANT]
> - This article covers OS upgrades only. Do not proceed if solution upgrade is complete or Azure Local 2311.2 or later is deployed. To check if your system is already running the solution, run the `Get-StampInformation` cmdlet. If it returns output, your system is already running the solution, and you should skip these steps.
> - The solution upgrade isn't yet supported on OS version 26100.xxxx.

## High-level workflow for the OS upgrade

The Azure Stack HCI OS update is available only via the Azure portal.

To upgrade the OS on your system, follow these high-level steps:

1. [Complete the prerequisites.](#complete-prerequisites)
1. [Update registry keys.](#update-registry-keys)
1. [Install new OS using PowerShell.](#install-new-os-using-powershell)
1. [Check the status of the updates.](#check-the-status-of-an-update)
1. [After the OS is upgraded, perform post-OS upgrade steps.](#next-steps)

## Complete prerequisites

- Make sure your Azure Local system is running either OS version 20349.3692 or OS version greater than 25398.1611.
- Make sure the system is registered in Azure and all the machines in the system are healthy and online.
- Make sure to shut down virtual machines (VMs). We recommend shutting down VMs before performing the OS upgrade to prevent unexpected outages and damages to databases.
- Confirm that you have access to the Azure Local **2505** ISO file, which you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_ArcCenterUX/ArcCenterMenuBlade/~/hciGetStarted).
- Consult your hardware OEM to verify driver compatibility. Confirm that all drivers compatible with Windows Server 2025 or Azure Stack HCI OS, 26100.xxxx are installed before the upgrade.
- Make sure the Network Interface Card (NIC) driver currently installed on your system is newer than the version included by default (inbox) with Azure Stack HCI OS, version 26100.xxxx. The following table compares the current and recommended versions of NIC drivers for two manufacturers:

   | NIC manufacturer | Inbox driver version | Recommended latest compatible driver |
   |--|--|--|
   | Intel | 1.15.121.0 | 1.17.73.0 |
   | NVIDIA | 24.4.26429.0 | 25.4.50020 |

- Ensure the instance is properly registered. If the *identity* property is missing or doesn’t contain `type = "SystemAssigned"`, run the following command to repair the registration:

   ```powershell
   Register-AzStackHCI -TenantId "<tenant_ID>" -SubscriptionId "<subscription_ID>" -ComputerName "<computer_name>" -RepairRegistration
   ```
   You can verify the *identity* property in the Azure portal in resource's JSON or by running the following cmdlet:
   
   ```powershell
   Get-AzResource -Name <cluster_name> -ResourceGroupName <name of the resource group> -ResourceType "Microsoft.AzureStackHCI/clusters" -ExpandProperties
   ```
- (Recommended) Enable [Secure Boot](/windows-hardware/design/device-experiences/oem-secure-boot) on Azure Local machines before you upgrade the OS. To enable Secure Boot, follow these steps:
   1. Drain the cluster node.
   1. Restart the OS.
   1. Enter the BIOS/UEFI menu.
   1. Review the **Boot** or **Security** section of the UEFI configuration options Locate the Secure Boot option.
   1. Set the option to **Enabled** or **On**.
   1. Save the changes and restart your computer.

   Consult with your hardware vendor for assistance if required.

## Update registry keys

To ensure Resilient File System (ReFS) functions properly during and after OS upgrade, follow these steps on each machine in the system to update registry keys. Reboot each machine for the changes to take effect.

1. Set `RefsEnableMetadataValidation` to `0`:

   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" -Value 0 -Type DWord  -ErrorAction Stop
   ```

1. Restart the machine to apply changes. If ReFS volumes fail to come online after reboot and the `RefsEnableMetadataValidation` key is reset, toggle the key. Set `RefsEnableMetadataValidation` to **1** and then back to **0**. To check volume status, run the `Get-ClusterSharedVolumeState` command.

1. Update and verify that the registry keys have been applied on each machine in the system before moving to the next step.

## Install new OS using PowerShell

To install the new OS using PowerShell, follow these steps:

> [!NOTE]
> The following steps require the Cluster-Aware Updating (CAU) role to be installed and enabled on the system.  For information on how to install and enable this feature on your Azure Local, see [Cluster-Aware Updating overview](/windows-server/failover-clustering/cluster-aware-updating#installing-cluster-aware-updating).

1. Run the following cmdlets on every machine in the system.

   ```PowerShell
   Set-WSManQuickConfig
   Enable-PSRemoting
   ```

1. To test whether the system is properly set up to apply software updates using Cluster-Aware Updating (CAU), run the `Test-CauSetup` cmdlet, which notifies you of any warnings or errors:

   ```PowerShell
   Test-CauSetup -ClusterName <System name>
   ```

1. Validate the hardware and settings by running the `Test-Cluster` cmdlet on one of the machines in the system. If any of the condition checks fail, resolve them before proceeding to the next step. <!--ASK-->

   ```PowerShell
   Test-Cluster
   ```

1. Extract the contents of the ISO image and copy them to the local system drive on each machine. Ensure that the local path is the same on each machine. Then, update the `PathToSetupMedia` parameter with the local path to the ISO image.

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
   Copy-Item -Path "${driveLetter}:\*" -Destination $destinationPath –Recurse 
   # Dismount the ISO file 
   Dismount-DiskImage -ImagePath $isoFilePath
   ```

1. Upgrade the system.

   ```powershell
   Invoke-CauRun –ClusterName <SystemName> -CauPluginName Microsoft.RollingUpgradePlugin  -EnableFirewallRules -CauPluginArguments @{ 'WuConnected'='false';'PathToSetupMedia'='\some\path\'; 'UpdateClusterFunctionalLevel'='true'; } -ForceSelfUpdate -Force 
   ```

1. Wait for the update to complete and check the status of the update.

## Check the status of an update

[!INCLUDE [verify-update](../includes/azure-local-verify-update.md)]

## Known issues

If the system is configured with Network ATC prior to performing the OS upgrade, the Network ATC management intent may fail with error `PhysicalAdapterNotFound` after upgrading the OS. For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Upgrade/Known%252Dissue-%252D-Network-ATC-management-intent-fails-with-%E2%80%98PhysicalAdapterNotFound%E2%80%99-after-upgrading-OS-from-22H2-to-23H2.md).


## Next steps

- [Learn how to perform the post-OS upgrade steps for your Azure Local.](./post-upgrade-steps.md)
