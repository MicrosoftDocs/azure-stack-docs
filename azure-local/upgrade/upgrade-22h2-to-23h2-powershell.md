---
title: Upgrade Azure Stack HCI OS, version 22H2 to version 23H2 via PowerShell
description: Learn how to use PowerShell to upgrade Azure Stack HCI OS, version 22H2 to version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 03/03/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Upgrade Azure Stack HCI OS, version 22H2 via PowerShell

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

This article describes how to upgrade the operating system (OS) for Azure Local from version 22H2 to version 23H2 via PowerShell. Upgrade using PowerShell is the recommended method to upgrade the OS

There are other methods to upgrade the OS that include using Windows Admin Center and the Server Configuration tool (SConfig). For more information about these methods, see [Upgrade the Azure Stack HCI OS, version 22H2 OS via Windows Admin Center](./upgrade-22h2-to-23h2-windows-admin-center.md) and [Upgrade Azure Local to new OS using other methods](./upgrade-22h2-to-23h2-other-methods.md).

Throughout this article, we refer to OS version 23H2 as the *new* version and version 22H2 as the *old* version.

> [!IMPORTANT]
> To keep your Azure Local service in a supported state, you have up to six months to install this new OS version. The update is applicable to all Azure Local instances running version 22H2. We strongly recommend that you install this version as soon as it becomes available.

## High-level workflow for the OS upgrade

The Azure Stack HCI operating system update is available via the Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your system, follow these high-level steps:

1. [Complete the prerequisites.](#complete-prerequisites)
1. [Update registry keys.](#step-0-update-registry-keys)
1. [Connect to Azure Local, version 22H2.](#step-1-connect-to-azure-local)
1. [Check for the available updates using PowerShell.](#step-1-connect-to-azure-local)
1. [Install new OS using PowerShell.](#step-2-install-new-os-using-powershell)
1. [Check the status of the updates.](#step-3-check-the-status-of-an-update)
1. [After the OS is upgraded, perform post-OS upgrade steps.](#next-steps)

## Complete prerequisites

Before you begin, make sure that:

- You have access to an Azure Local running version 22H2.
- The system is registered in Azure.
- Make sure that all the machines  in your Azure Local, version 22H2 instance are healthy and show as **Online**.
- You have access to the Azure Stack HCI, version 23H2 OS software update for Azure Local. This update is available via Windows Update or as a downloadable media. The media is an ISO file that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- You have access to a client that can connect to your Azure Local instance. This client should be running PowerShell 5.0 or later.

> [!NOTE]
> The ISO file is only required if the machines do not have access to Windows Update to download the OS feature update. If using this method, after you [Connect to Azure Local, version 22H2](#step-1-connect-to-azure-local), skip to step 6 under [Step 2: Install new OS using PowerShell](#step-2-install-new-os-using-powershell) and perform the remaining steps.
> Use of 3rd party tools to install upgrades is not supported.

Follow these steps to install the solution upgrade:

## Step 0: Update registry keys

To avoid issues with Resilient File System (ReFS) during OS upgrade, update registry keys on each node to ensure ReFS volume upgrade is disabled and metadata validation is turned off.

Run the following command on each node to update registry keys:

```powershell
# Set RefsDisableVolumeUpgrade to 1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsDisableVolumeUpgrade" -Value 1 -Type DWord -ErrorAction Stop

# Set RefsEnableMetadataValidation to 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" -Value 0 -Type DWord  -ErrorAction Stop
```

## Step 1: Connect to Azure Local

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

## Step 2: Install new OS using PowerShell

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

## Step 3: Check the status of an update

To get the summary information about an update in progress, run the `Get-CauRun` cmdlet:

```PowerShell
Get-CauRun -ClusterName <SystemName>
```

Here's a sample output: <!--ASK-->

```output
RunId                   : <Run ID> 
RunStartTime            : 10/13/2024 1:35:39 PM 
CurrentOrchestrator     : NODE1 
NodeStatusNotifications : { 
Node      : NODE1 
Status    : Waiting 
Timestamp : 10/13/2024 1:35:49 PM 
} 
NodeResults             : { 
Node                     : NODE2 
Status                   : Succeeded 
ErrorRecordData          : 
NumberOfSucceededUpdates : 0 
NumberOfFailedUpdates    : 0 
InstallResults           : Microsoft.ClusterAwareUpdating.UpdateInstallResult[] 
}
```

You're now ready to perform the post-OS upgrade steps for your system.

## Next steps

- [Learn how to perform the post-OS upgrade steps for your Azure Local.](./post-upgrade-steps.md)
