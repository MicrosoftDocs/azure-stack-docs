---
title: Upgrade Azure Stack HCI OS, version 22H2 to version 23H2 via PowerShell
description: Learn how to use PowerShell to upgrade Azure Stack HCI OS, version 22H2 to version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 07/16/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
zone_pivot_groups: upgrade-os
---

# Upgrade Azure Stack HCI OS, version 22H2 to version 23H2 via PowerShell

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

::: zone pivot="os-23h2"

This article describes how to upgrade the operating system (OS) for Azure Local from version 22H2 to version 23H2 via PowerShell, which is the recommended method to upgrade the OS. This is the first step in the upgrade process, which upgrades only the OS.

There are other methods to upgrade the OS that include using Windows Admin Center and the Server Configuration tool (SConfig). For more information about these methods, see [Upgrade the Azure Stack HCI OS, version 22H2 OS via Windows Admin Center](./upgrade-22h2-to-23h2-windows-admin-center.md) and [Upgrade Azure Local to new OS using other methods](./upgrade-22h2-to-23h2-other-methods.md).

Throughout this article, we refer to OS version 23H2 as the *new* version and version 22H2 as the *old* version.

> [!IMPORTANT]
> To keep your Azure Local service in a supported state, you have up to six months to install this new OS version. The update is applicable to all Azure Local instances running version 22H2. We strongly recommend that you install this version as soon as it becomes available.

::: zone-end

::: zone pivot="os-24h2"


This article describes how to upgrade the Azure Stack HCI operating system (OS) via PowerShell. Supported upgrade paths include:

- From OS version 20349.xxxx to 26100.xxxx.

- From OS version 25398.xxxx to 26100.xxxx.

> [!IMPORTANT]
> - This article covers OS upgrades only. Do not proceed if solution upgrade is complete or Azure Local 2311.2 or later is deployed. To check if your system is already running the solution, run the `Get-StampInformation` cmdlet. If it returns output, your system is already running the solution, and you should skip these steps.
> - The solution upgrade isn't yet supported on OS version 26100.xxxx.

::: zone-end

## High-level workflow for the OS upgrade

::: zone pivot="os-23h2"

The Azure Stack HCI operating system update is available via the Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your system, follow these high-level steps:

1. [Complete the prerequisites.](#complete-prerequisites)
1. [Update registry keys.](#step-0-update-registry-keys)
1. [Connect to Azure Local, version 22H2.](#step-1-connect-to-azure-local)
1. [Check for the available updates using PowerShell.](#step-1-connect-to-azure-local)
1. [Install new OS using PowerShell.](#step-2-install-new-os-using-powershell)
1. [Check the status of the updates.](#step-3-check-the-status-of-an-update)
1. [After the OS is upgraded, perform post-OS upgrade steps.](#next-steps)

::: zone-end

::: zone pivot="os-24h2"

The Azure Stack HCI OS update is available only via the Azure portal.

To upgrade the OS on your system, follow these high-level steps:

1. [Complete the prerequisites.](#complete-prerequisites)
1. [Update registry keys.](#update-registry-keys)
1. [Install new OS using PowerShell.](#install-new-os-using-powershell)
1. [Check the status of the updates.](#check-the-status-of-an-update)
1. [After the OS is upgraded, perform post-OS upgrade steps.](#next-steps)

::: zone-end


## Complete prerequisites

::: zone pivot="os-23h2"

Before you begin, make sure that:

- You have access to an Azure Local running version 22H2.
- The system is registered in Azure.
- All the machines  in your Azure Local, version 22H2 instance are healthy and show as **Online**.
- You shut down virtual machines (VMs). We recommend shutting down VMs before performing the OS upgrade to prevent unexpected outages and damages to databases.
- You have access to the Azure Stack HCI, version 23H2 OS software update for Azure Local. This update is available via Windows Update or as a downloadable media. The media must be version **2503** ISO file that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- You have access to a client that can connect to your Azure Local instance. This client should be running PowerShell 5.0 or later.
- You run the `RepairRegistration` cmdlet only if both of the following conditions apply:

   - The *identity* property is either missing or doesn’t contain `type = "SystemAssigned"`.
      - Check this in the Resource JSON in the Azure portal
      - Or run the `Get-AzResource -Name <cluster_name>` PowerShell cmdlet
   - The **Cloud Management** cluster group is not present. Check it by running the `Get-ClusterGroup` PowerShell cmdlet.

   If both these conditions are met, run the `RepairRegistration` cmdlet:

   ```powershell
   Register-AzStackHCI -TenantId "<tenant_ID>" -SubscriptionId "<subscription_ID>" -ComputerName "<computer_name>" -RepairRegistration
   ```

- (Recommended) You enable [Secure Boot](/windows-hardware/design/device-experiences/oem-secure-boot) on Azure Local machines before you upgrade the OS.
   To enable Secure Boot, follow these steps:
   1. Drain the cluster node.
   1. Restart the OS.
   1. Enter the BIOS/UEFI menu.
   1. Review the **Boot** or **Security** section of the UEFI configuration options Locate the Secure Boot option.
   1. Set the option to **Enabled** or **On**.
   1. Save the changes and restart your computer.

   Consult with your hardware vendor for assistance if required.

> [!NOTE]
> The **2503** ISO file is only required if the machines do not have access to Windows Update to download the OS feature update. If using this method, after you [Connect to Azure Local, version 22H2](#step-1-connect-to-azure-local), skip to step 6 under [Step 2: Install new OS using PowerShell](#step-2-install-new-os-using-powershell) and perform the remaining steps.
> Use of 3rd party tools to install upgrades is not supported.

::: zone-end

::: zone pivot="os-24h2"

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

::: zone-end

## Update registry keys

::: zone pivot="os-23h2"

To ensure Resilient File System (ReFS) and live migrations function properly during and after OS upgrade, follow these steps on each machine in the system to update registry keys. Reboot each machine for the changes to take effect.

1. Set `RefsEnableMetadataValidation` to `0`:

   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" -Value 0 -Type DWord  -ErrorAction Stop
   ```

1. Create the parameters key if it doesn't exist. If it already exists, the command may fail with an error, which is expected.

   ```powershell
   New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\Vid\Parameters
   ```

1. Set `SkipSmallLocalAllocations` to `0`:

   ```powershell
   New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Vid\Parameters -Name SkipSmallLocalAllocations -Value 0 -PropertyType DWord
   ```

1. Restart the machine for the changes to take effect. On machine restart, if the `RefsEnableMetadataValidation` key gets overridden and ReFS volumes fail to come online, toggle the key by first setting `RefsEnableMetadataValidation` to `1` and then back to `0` again.

1. Update and verify that the registry keys have been applied on each machine in the system before moving to the next step.

::: zone-end

::: zone pivot="os-24h2"

To ensure Resilient File System (ReFS) functions properly during and after OS upgrade, follow these steps on each machine in the system to update registry keys. Reboot each machine for the changes to take effect.

1. Set `RefsEnableMetadataValidation` to `0`:

   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" -Value 0 -Type DWord  -ErrorAction Stop
   ```

1. Restart the machine to apply changes. If ReFS volumes fail to come online after reboot and the `RefsEnableMetadataValidation` key is reset, toggle the key. Set `RefsEnableMetadataValidation` to **1** and then back to **0**. To check volume status, run the `Get-ClusterSharedVolumeState` command.

1. Update and verify that the registry keys have been applied on each machine in the system before moving to the next step.

::: zone-end

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

::: zone pivot="os-23h2"

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

1. Check for the available updates:

   ```PowerShell
   Invoke-CauScan -ClusterName <SystemName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose | fl *
   ```

   Inspect the output of the above cmdlet and verify that each machine is offered the same Feature Update, which should be the case. <!--ASK-->

1. You need a separate machine or VM outside the system to run the `Invoke-CauRun` cmdlet from. A separate machine ensures that orchestration isn't interrupted when the machines are rebooted.

    > [!IMPORTANT]
    > The system on which you run `Invoke-CauRun` must be running Windows Server 2022. <!--ASK-->

   ```PowerShell
   Invoke-CauRun -ClusterName <SystemName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose -EnableFirewallRules -Force
   ```

1. If the system isn't connected to Windows Update and the Azure Local install media is available on a local share, CAU can also be used to upgrade the system. Be sure to update the `'PathToSetupMedia'` parameter with the share path to the ISO image.

   ```powershell
   Invoke-CauRun –ClusterName <SystemName> -CauPluginName Microsoft.RollingUpgradePlugin -CauPluginArguments @{ 'WuConnected'='false';'PathToSetupMedia'='\some\path\'; 'UpdateClusterFunctionalLevel'='true'; } -Force
   ```

1. Check for any further updates and install them.

Wait for the update to complete and check the status of the update.

::: zone-end

::: zone pivot="os-24h2"

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

::: zone-end


## Check the status of an update


[!INCLUDE [verify-update](../includes/azure-local-verify-update.md)]

## Next steps

- [Learn how to perform the post-OS upgrade steps for your Azure Local.](./post-upgrade-steps.md)
