---
title: Upgrade Azure Stack HCI OS to version 24H2 via PowerShell
description: Learn how to use PowerShell to upgrade Azure Stack HCI OS to version 24H2.
author: ronmiab
ms.topic: how-to
ms.date: 05/01/2026
ms.author: robess
ms.service: azure-local
ms.subservice: hyperconverged
---

# Upgrade Azure Stack HCI OS via PowerShell

This article describes how to upgrade the Azure Stack HCI operating system (OS) to version 26100.xxxx (24H2), via PowerShell. There are two upgrade paths available:

- Upgrade from version 20349.xxxx (22H2) to version 26100.xxxx (24H2).
- Upgrade from version 25398.xxxx (23H2) to version 26100.xxxx (24H2). This includes the 25398.xxxx (23H2) clusters that were upgraded from version 20349.xxxx (22H2) and the solution upgrade is not yet applied.

With the 2505 release, a direct upgrade path from version 20349.xxxx (22H2) to version 26100.xxxx (24H2) is available. Skipping the upgrade to the version 26100.xxxx is one less upgrade hop and helps reduce reboots and maintenance planning prior to the solution upgrade.

- Make sure to consult with your hardware vendor to determine if version 26100.xxxx OS is supported before performing the upgrade.
- After the OS upgrade, you can apply the solution upgrade.
- There is an exception to the preceding recommendation if you are using stretch clusters. Stretch clusters should wait to directly move to version 26100.xxxx (24H2). <!--2508 - This version contains critical bug fixes.-->

For more information about the various upgrade paths, see the blog post on [Upgrade Azure Local to new OS version](https://techcommunity.microsoft.com/blog/azurearcblog/upgrade-azure-local-operating-system-to-new-version/4423827).

> [!IMPORTANT]
> This article covers OS upgrades only. Do not proceed if the solution upgrade is complete or Azure Local 2311.2 or later is deployed. To check if your system is already running the solution, run the `Get-StampInformation` cmdlet. If it returns output, your system is already running the solution, and you should skip these steps.

## About End of Support (EOS) for previous versions

For information on end of support for various Azure Local versions, see [Azure Local, release information](../release-information-23h2.md#end-of-support-for-azure-local-versions).

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
- If you have AKS enabled by Azure Arc clusters running on your version 22H2 instance, uninstall AKS Arc and all its settings using the [Uninstall-Aks-Hci](/azure/aks/hybrid/reference/ps/uninstall-akshci) command. Once you uninstall AKS Arc, you must uninstall the **AksHci** Powershell module using this command, as this module does not work on version 23H2 and later:

  ```powershell
  Uninstall-Module -Name AksHci -Force
  ```

  To avoid any PowerShell version-related issues in your AKS deployment, you can use this [helper script to delete old AKS-HCI PowerShell modules](https://github.com/Azure/aksArc/blob/main/scripts/samples/uninstall-akshci.ps1). If you used the preview version of AKS Arc on 22H2, run the command `Uninstall-Moc` on an Azure Local node to remove the VM instances created using the preview version.

- Confirm that you have access to the latest Azure Local that you can [download from the Azure portal](../deploy/download-23h2-software.md#download-the-software-from-the-azure-portal).
- Consult your hardware OEM to verify driver compatibility. Confirm that all drivers compatible with Windows Server 2025 or Azure Stack HCI OS, 26100.xxxx are installed before the upgrade.
- Make sure the Network Interface Card (NIC) driver currently installed on your system is newer than the version included by default (inbox) with Azure Stack HCI OS, version 26100.xxxx. The following table compares the current and recommended versions of NIC drivers for two manufacturers:

   | NIC manufacturer | Inbox driver version | Recommended latest compatible driver |
   | -- | -- | -- |
   | Intel | 1.15.121.0 | 1.17.73.0 |
   | NVIDIA | 24.4.26429.0 | 25.4.50020 |

- You run the `RepairRegistration` cmdlet if either of the following conditions apply:

  - The *identity* property is either missing or doesn't contain `type = "SystemAssigned"`.
    - Check this in the Resource JSON in the Azure portal.
    - Or run the `Get-AzResource -Name <cluster_name>` PowerShell cmdlet.
  - The **Cloud Management** cluster group is not present. Check it by running the `Get-ClusterGroup` PowerShell cmdlet.

   If either of these conditions are met, run the `RepairRegistration` cmdlet:

   ```powershell
   Register-AzStackHCI -TenantId "<tenant_ID>" -SubscriptionId "<subscription_ID>" -ComputerName "<computer_name>" -Region "<region_name>" -RepairRegistration
   ```

- (Recommended) Enable [Secure Boot](/windows-hardware/design/device-experiences/oem-secure-boot) on Azure Local machines before you upgrade the OS. To enable Secure Boot, follow these steps:
   1. Drain the cluster node.
   1. Restart the OS.
   1. Enter the BIOS/UEFI menu.
   1. Review the **Boot** or **Security** section of the UEFI configuration options Locate the Secure Boot option.
   1. Set the option to **Enabled** or **On**.
   1. Save the changes and restart your computer.

   Consult with your hardware vendor for assistance if required.

- Clean the Cloud Management cluster group:

    ```PowerShell
    # Check to make sure the Cloud Management group is present and its online.
    Get-ClusterGroup -Name "Cloud Management"
     
    # Stop the Cloud Management group
    Stop-ClusterGroup -Name "Cloud Management"
     
    # Remove all resources in the Cloud Management group
    Get-ClusterGroup -Name "Cloud Management" | Get-ClusterResource | Remove-ClusterResource -Force
     
    # Start the Cloud Management group
    Start-ClusterGroup -Name "Cloud Management"

## Update registry keys

To ensure Resilient File System (ReFS) functions properly during and after OS upgrade, follow these steps on each machine in the system to update registry keys. Reboot each machine for the changes to take effect.

1. Set `RefsEnableMetadataValidation` to `0`:

   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" -Value 0 -Type DWord  -ErrorAction Stop
   ```

1. Restart the machine to apply changes. If ReFS volumes fail to come online after reboot and the `RefsEnableMetadataValidation` key is reset, toggle the key. Set `RefsEnableMetadataValidation` to **1** and then back to **0**. To check volume status, run the `Get-ClusterSharedVolumeState` command.

1. Update and verify that the registry keys have been applied on each machine in the system before moving to the next step.

## Connect to Azure Local

Follow these steps on your client to connect to one of the machines of your Azure Local instance.

1. Run PowerShell as Administrator on the client that you're using to connect to your system.
1. Open a remote PowerShell session to a machine on your Azure Local instance. Run the following command and provide the credentials of your machine when prompted:

   ```powershell
   $cred = Get-Credential
   Enter-PSSession -ComputerName "<Computer IP>" -Credential $cred 
   ```

   Here's a sample output:

   ```Console
   PS C:\Users\Administrator> $cred = Get-Credential
   
   cmdlet Get-Credential at command pipeline position 1
   Supply values for the following parameters:
   Credential
   PS C:\Users\Administrator> Enter-PSSession -ComputerName "100.100.100.10" -Credential $cred 
   [100.100.100.10]: PS C:\Users\Administrator\Documents>
   ```

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

   > [!NOTE]
   > Some warnings reported by `Test-CauSetup` are expected and can be ignored. Review the output and proceed if no critical errors are reported.

1. Validate the hardware and settings by running the `Test-Cluster` cmdlet on one of the machines in the system. If any of the condition checks fail, resolve them before proceeding to the next step. <!--ASK-->

   ```PowerShell
   Test-Cluster
   ```

1. Extract the contents of the ISO image and copy them to the local system drive on each machine. Ensure that the local path is the same on each machine. Then, update the `PathToSetupMedia` parameter with the local path to the extracted ISO contents, not the ISO file.

   ```powershell
   # Define ISO and destination folder for extracted contents 
   $isoFilePath = "C:\SetupFiles\WindowsServer\ISOs\example.iso" 
   $destinationPath = "C:\SetupFiles\WindowsServer\ExtractedFilesFolder" 
   # Mount the ISO file 
   $iso = Mount-DiskImage -ImagePath $isoFilePath 
   # Get the drive letter 
   $driveLetter = ($iso | Get-Volume).DriveLetter 
   # Create the destination directory 
   New-Item -ItemType Directory -Path $destinationPath 
   # Copy contents to the local directory 
   Copy-Item -Path "${driveLetter}:\*" -Destination $destinationPath -Recurse 
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

## Next steps

- Learn how to [Perform the post-OS upgrade steps for Azure Local](./post-upgrade-steps.md).
