---
title: Upgrade Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2
description: Learn how to upgrade from Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 07/08/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Upgrade Azure Stack HCI, version 22H2 operating system to Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to upgrade the Azure Stack HCI, version 22H2 Operating System (OS) to version 23H2 which is the latest generally available software.

The upgrade from Azure Stack HCI 22H2 to version 23H2 occurs in the following steps:

1. Upgrade the OS.
1. Prepare for the solution update.
1. Apply the solution update.

This article only covers the first step, which is how to upgrade the Azure Stack HCI OS using Windows Admin Center. While you can use Windows Admin Center, PowerShell is the recommended method to upgrade the OS. For more information, see [Upgrade the Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 OS via PowerShell](./upgrade-22h2-to-23h2.md).

There are other methods to upgrade the OS that include using the Server Configuration tool (SConfig), and Cluster Aware Updating (CAU). For more information about these methods, see [Other methods used to upgrade the OS](./upgrade-22h2-to-23h2-other-methods.mds).

> [!IMPORTANT]
> To keep your Azure Stack HCI service in a supported state, you have up to six months to install this new OS version. The update is applicable to all the Azure Stack HCI, version 22H2 clusters. We strongly recommend that you install this version as soon as it becomes available.

## High-level workflow for the OS upgrade

The Azure Stack HCI operating system update is available via the Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your cluster, follow these high-level steps:

1. Complete the prerequisites inculding downloading the Azure Stack HCI, version 23H2 OS software update.
1. Connect to the Azure Stack HCI, version 22H2 cluster.
1. Check for the available updates using PowerShell.
1. Install new OS using PowerShell.
1. Check the status of the updates.
1. After the OS is upgraded, perform post-installation steps for feature updates.
1. Other methods to upgrade the OS include:
   1. Upgrade via Windows Admin Center.
   1. Manual upgrade of a Failover Cluster using SConfig.
   1. Fast, offline upgrade of all servers in a cluster.

<!--## Tools used to upgrade the OS

There are different tools to upgrade the OS that include but aren't limited to builtin tools like Cluster aware updating (CAU) and Server Configuration tool (SConfig). Cluster aware updating orchestrates the process of applying the operating system automatatically to all the cluster members using either Windows Update or ISO media.

For more information about available tools, see:

- [Cluster operating system rolling upgrade](/windows-server/failover-clustering/cluster-operating-system-rolling-upgrade).
- [Configure a Server Core installation of Windows Server and Azure Stack HCI with the Server Configuration tool (SConfig)](/windows-server/administration/server-core/server-core-sconfig).-->

## Complete prerequisites

Before you begin, make sure that:

- You have access to an Azure Stack HCI, version 22H2 cluster that is running XXXX or higher. The cluster should be registered in Azure.
- You have access to a client that can connect to your Azure Stack HCI cluster. This client should be running PowerShell 5.0 or later.
- You have access to the Azure Stack HCI, version 23H2 OS software update. This update is available via Windows Update or as a downloadable media. The media is an ISO file that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- Make sure that all the nodes in your Azure Stack HCI, version 22H2 cluster are healthy and show as **Online**.

## Step 1: Connect to the Azure Stack HCI cluster

Follow these steps on your client to connect to one of the servers of your Azure Stack HCI cluster.

1. Run PowerShell as administrator on the client that you're using to connect to your cluster.
2. Open a remote PowerShell session to a server on your Azure Stack HCI cluster. Run the following command and provide the credentials of your server when prompted:

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

<!--## Step 2: Check for updates using PowerShell

Use the `Invoke-CAUScan` cmdlet to scan the servers for applicable updates and get a list of the initial set of updates that are applied to each server in a specified cluster:

```PowerShell
Invoke-CauScan -ClusterName Cluster1 -CauPluginName Microsoft.WindowsUpdatePlugin -Verbose
```

Generation of the list can take a few minutes to complete. The preview list includes only an initial set of updates; it doesn't include updates that might become applicable after the initial updates are installed. -->


<!--## Step 3: Install OS updates using PowerShell

To scan servers for operating system updates and perform a full update run on the specified cluster, use the `Invoke-CAURun` cmdlet:

```PowerShell
Invoke-CauRun -ClusterName <Cluster Name> -CauPluginName Microsoft.WindowsUpdatePlugin -MaxFailedNodes 1 -MaxRetriesPerNode 3 -RequireAllNodesOnline -EnableFirewallRules -Force
```

This command performs a scan and a full updating run on your Azure Stack HCI.

- This cmdlet uses the **Microsoft.WindowsUpdatePlugin** plug-in and requires that all cluster nodes be online before running this cmdlet. 
- In addition, this cmdlet allows no more than three retries per node before marking the node as **Failed** and allows no more than one node to fail before marking the entire updating run as failed.
- It also enables firewall rules to allow the servers to restart remotely. Because the command specifies the `Force` parameter, the cmdlet runs without displaying the confirmation prompts.

The updating run process includes the following:

- Scanning for and downloading applicable updates on each server in the cluster.
- Moving currently running clustered roles off each server.
- Installing the updates on each server.
- Restarting the server if required by the installed updates.
- Moving the clustered roles back to the original server.

The updating run process also includes ensuring that quorum is maintained, checking for additional updates that can only be installed after the initial set of updates are installed, and saving a report of the actions taken is completed. -->

## Step 3: Install new OS using PowerShell

To install new OS using PowerShell, follow these steps:

1. Run the following cmdlets on every server in the cluster: <!--ASK-->

   ```PowerShell
   Set-WSManQuickConfig
   Enable-PSRemoting
   ```

1. To test whether the cluster is properly set up to apply software updates using Cluster-Aware Updating (CAU), run the `Test-CauSetup` cmdlet, which will notify you of any warnings or errors:

   ```PowerShell
   Test-CauSetup -ClusterName <Cluster name>
   ```

1. Validate the cluster's hardware and settings by running the `Test-Cluster` cmdlet on one of the servers in the cluster. If any of the condition checks fail, resolve them before proceeding to the next step. <!--ASK-->

   ```PowerShell
   Test-Cluster
   ```

1. Check for the feature updates:

   ```PowerShell
   Invoke-CauScan -ClusterName <ClusterName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose | fl *
   ```

   Inspect the output of the above cmdlet and verify that each server is offered the same Feature Update, which should be the case. <!--ASK-->

1. You'll need a separate server or VM outside the cluster to run the `Invoke-CauRun` cmdlet from.

    > [!IMPORTANT]
    > The system on which you run `Invoke-CauRun` must be running Windows Server 2022. <!--ASK-->

   ```PowerShell
   Invoke-CauRun -ClusterName <ClusterName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose -EnableFirewallRules -Force
   ```

1. Check for any further updates and install them.

You're now ready to perform the [post-installation steps for feature updates](#post-installation-steps-for-feature-updates).

## Step 4: Check the status of an update

To get the summary information about an update in progress, run the `Get-CauRun` cmdlet:

```PowerShell
Get-CauRun -ClusterName Cluster1
```

Here's a sample output: <!--ASK-->

```output
RunId                   : 834dd11e-584b-41f2-8d22-4c9c0471dbad 
RunStartTime            : 10/13/2019 1:35:39 PM 
CurrentOrchestrator     : NODE1 
NodeStatusNotifications : { 
Node      : NODE1 
Status    : Waiting 
Timestamp : 10/13/2019 1:35:49 PM 
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

## Step 5: Perform the post-install steps

Once the new OS is installed, you'll need to update the cluster functional level and update the storage pool version using PowerShell in order to enable new features.

1. **Update the cluster functional level.**

   We recommend that you update the cluster functional level as soon as possible. Skip this step if you installed the feature updates with Windows Admin Center and checked the optional **Update the cluster functional level to enable new features** checkbox.

   Run the following cmdlet on any server in the cluster:

   ```PowerShell
   Update-ClusterFunctionalLevel

   You'll see a warning that you can't undo this operation. Confirm **Y** that you want to continue.

   > [!WARNING]
   > After you update the cluster functional level, you can't roll back to the previous operating system version.

1. **Update the storage pool.**

   After the cluster functional level has been updated, use the following cmdlet to update the storage pool. Run `Get-StoragePool` to find the FriendlyName for the storage pool representing your cluster. In this example, the FriendlyName is **S2D on hci-cluster1**:

   ```PowerShell
   Update-StoragePool -FriendlyName "S2D on hci-cluster1"
   ```

   You'll be asked to confirm the action. At this point, new cmdlets will be fully operational on any server in the cluster.

1. **Upgrade VM configuration levels (optional).**

   You can optionally upgrade VM configuration levels by stopping each VM using the `Update-VMVersion` cmdlet and then starting the VMs again.

1. **Verify that the upgraded cluster functions as expected.**

   Roles should fail over correctly and, if VM live migration is used on the cluster, VMs should successfully live migrate.

1. **Validate the cluster.**

   Run the `Test-Cluster` cmdlet on one of the servers in the cluster and examine the cluster validation report.

<!--## Perform a manual feature update of a Failover Cluster using SCONFIG

To do a manual feature update of a failover cluster, use the **SCONFIG** tool and Failover Clustering PowerShell cmdlets. To reference the **SCONFIG** document, see [Configure a Server Core installation of Windows Server and Azure Stack HCI with the Server Configuration tool (SConfig)](/windows-server/administration/server-core/server-core-sconfig)

For each node in the cluster, run these commands on the target node:

1. `Suspend-ClusterNode -Node<node> -Drain`

    Check suspend using `Get-ClusterGroup`--nothing should be running on the target node.

    Run the **SCONFIG** option 6.3 on the target node.

    After the target node has rebooted, wait for the storage repair jobs to complete by running `Get-Storage-Job` until there are no storage jobs or all storage jobs are completed.

2. `Resume-ClusterNode -Node <nodename> -Failback`

When all the nodes are upgraded, run these two cmdlets:

- `Update-ClusterFunctional Level`

- `Update-StoragePool`

## Perform a fast, offline update of all servers in a cluster

This method allows you to take all the servers in a cluster down at once and update them all at the same time. This saves time during the updating process, but the trade-off is downtime for the hosted resources.

If there is a critical security update that you need to apply quickly or you need to ensure that updates complete within your maintenance window, this method may be for you. This process brings down the Azure Stack HCI cluster, updates the servers, and brings it all up again.

1. Plan your maintenance window.
1. Take the virtual disks offline.
1. Stop the cluster to take the storage pool offline. Run the `Stop-Cluster` cmdlet or use Windows Admin Center to stop the cluster.
1. Set the cluster service to **Disabled** in Services.msc on each server. This prevents the cluster service from starting up while being updated.
1. Apply the Windows Server Cumulative Update and any required Servicing Stack Updates to all servers. You can update all servers at the same time: there's no need to wait because the cluster is down.
1. Restart the servers and ensure everything looks good.
1. Set the cluster service back to **Automatic** on each server.
1. Start the cluster. Run the `Start-Cluster` cmdlet or use Windows Admin Center.  
1. Give it a few minutes.  Make sure the storage pool is healthy.
1. Bring the virtual disks back online.
1. Monitor the status of the virtual disks by running the `Get-Volume` and `Get-VirtualDisk` cmdlets.-->


## Next steps

- [Learn how to prepare to apply the solution update.](./prepare-to-apply-23h2-solution-update.md)