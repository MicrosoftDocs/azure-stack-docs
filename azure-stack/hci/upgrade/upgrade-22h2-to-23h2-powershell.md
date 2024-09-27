---
title: Upgrade Azure Stack HCI  to latest version 23H2 via PowerShell
description: Learn how to use PowerShell to upgrade Azure Stack HCI to latest version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 08/19/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Upgrade Azure Stack HCI operating system via PowerShell

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to upgrade the Azure Stack HCI, version 22H2 Operating System (OS) to version 23H2, which is the latest generally available software, via PowerShell. Upgrade using PowerShell is the recommended method to upgrade the OS.

There are other methods to upgrade the OS that include using Windows Admin Center and the Server Configuration tool (SConfig). For more information about these methods, see [Upgrade your Azure Stack HCI to new OS via Windows Admin Center](./upgrade-22h2-to-23h2-windows-admin-center.md) and [Upgrade your Azure Stack HCI to new OS using other methods](./upgrade-22h2-to-23h2-other-methods.md).

Throughout this article, we refer to Azure Stack HCI, version 23H2 as the *new* version and Azure Stack HCI, version 22H2 as the *old* version.

> [!IMPORTANT]
> To keep your Azure Stack HCI service in a supported state, you have up to six months to install this new OS version. The update is applicable to all Azure Stack HCI, version 22H2 clusters. We strongly recommend that you install this version as soon as it becomes available.

## High-level workflow for the OS upgrade

The Azure Stack HCI operating system update is available via the Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your cluster, follow these high-level steps:

1. [Complete the prerequisites.](#complete-prerequisites)
1. [Connect to the Azure Stack HCI, version 22H2 cluster.](#step-1-connect-to-the-azure-stack-hci-cluster)
1. [Check for the available updates using PowerShell.](#step-1-connect-to-the-azure-stack-hci-cluster)
1. [Install new OS using PowerShell.](#step-2-install-new-os-using-powershell)
1. [Check the status of the updates.](#step-3-check-the-status-of-an-update)
1. [After the OS is upgraded, perform post-OS upgrade steps.](#next-steps)

## Complete prerequisites

Before you begin, make sure that:

- You have access to an Azure Stack HCI, version 22H2 cluster.
- The cluster should be registered in Azure.
- Make sure that all the nodes in your Azure Stack HCI, version 22H2 cluster are healthy and show as **Online**.
- You have access to the Azure Stack HCI, version 23H2 OS software update. This update is available via Windows Update or as a downloadable media. The media is an ISO file that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- You have access to a client that can connect to your Azure Stack HCI cluster. This client should be running PowerShell 5.0 or later.

> [!NOTE]
> The ISO file is only required if the cluster nodes do not have access to Windows Update to download the OS feature update.  If using this method, after you [Connect to the Azure Stack HCI, version 22H2 cluster](#step-1-connect-to-the-azure-stack-hci-cluster), skip to step 6 under [Step 2: Install new OS using PowerShell](#step-2-install-new-os-using-powershell) and perform the remaining steps.

## Step 1: Connect to the Azure Stack HCI cluster

Follow these steps on your client to connect to one of the servers of your Azure Stack HCI cluster.

1. Run PowerShell as Administrator on the client that you're using to connect to your cluster.
1. Open a remote PowerShell session to a server on your Azure Stack HCI cluster. Run the following command and provide the credentials of your server when prompted:

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

To install new OS using PowerShell, follow these steps:

> [!NOTE]
> The following steps require the Cluster-Aware Updating (CAU) role to be installed and enabled on the cluster.  For information on how to install and enable this feature on your Azure Stack HCI cluster, see [Cluster-Aware Updating overview](/windows-server/failover-clustering/cluster-aware-updating#installing-cluster-aware-updating).

1. Run the following cmdlets on every server in the cluster: <!--ASK-->

   ```PowerShell
   Set-WSManQuickConfig
   Enable-PSRemoting
   ```

1. To test whether the cluster is properly set up to apply software updates using Cluster-Aware Updating (CAU), run the `Test-CauSetup` cmdlet, which notifies you of any warnings or errors:

   ```PowerShell
   Test-CauSetup -ClusterName <Cluster name>
   ```

1. Validate the cluster's hardware and settings by running the `Test-Cluster` cmdlet on one of the servers in the cluster. If any of the condition checks fail, resolve them before proceeding to the next step. <!--ASK-->

   ```PowerShell
   Test-Cluster
   ```

1. Check for the available updates:

   ```PowerShell
   Invoke-CauScan -ClusterName <ClusterName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose | fl *
   ```

   Inspect the output of the above cmdlet and verify that each server is offered the same Feature Update, which should be the case. <!--ASK-->

1. You need a separate server or VM outside the cluster to run the `Invoke-CauRun` cmdlet from. A separate server ensures that orchestration isn't interrupted when the nodes are rebooted.

    > [!IMPORTANT]
    > The system on which you run `Invoke-CauRun` must be running Windows Server 2022. <!--ASK-->

   ```PowerShell
   Invoke-CauRun -ClusterName <ClusterName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose -EnableFirewallRules -Force
   ```

1. If the cluster isn't connected to Windows Update and the Azure Stack HCI install media is available on a local share, CAU can also be used to upgrade the cluster. Be sure to update the `'PathToSetupMedia'` parameter with the share path to the ISO image.

   ```powershell
   Invoke-CauRun –ClusterName <ClusterName> -CauPluginName Microsoft.RollingUpgradePlugin -CauPluginArguments @{ 'WuConnected'='false';'PathToSetupMedia'='\some\path\'; 'UpdateClusterFunctionalLevel'='true'; } -Force
   ```

1. Check for any further updates and install them.

Wait for the update to complete and check the status of the update.

## Step 3: Check the status of an update

To get the summary information about an update in progress, run the `Get-CauRun` cmdlet:

```PowerShell
Get-CauRun -ClusterName <ClusterName>
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

You're now ready to perform the post-OS upgrade steps for your cluster.

## Next steps

- [Learn how to perform the post-OS upgrade steps for your Azure Stack HCI cluster.](./post-upgrade-steps.md)
