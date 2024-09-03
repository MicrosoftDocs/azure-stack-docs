---
title: Upgrade Azure Stack HCI, version 22H2 OS to version 23H2 via other manual methods
description: Learn how to upgrade from Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 using other manual methods.
author: alkohli
ms.topic: how-to
ms.date: 08/19/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Upgrade Azure Stack HCI, version 22H2 operating system to Azure Stack HCI, version 23H2 via other methods

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to upgrade the Azure Stack HCI, version 22H2 Operating System (OS) to version 23H2, which is the latest generally available software, using manual methods such as [SConfig](/windows-server/administration/server-core/server-core-sconfig) and performing an offline upgrade.

While you can use these other methods, PowerShell is the recommended method to upgrade the OS. For more information, see [Upgrade the Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 OS via PowerShell](./upgrade-22h2-to-23h2-powershell.md).

Throughout this article, we refer to Azure Stack HCI, version 23H2 as the new version and Azure Stack HCI, version 22H2 as the old version.

> [!IMPORTANT]
> To keep your Azure Stack HCI service in a supported state, you have up to six months to install this new OS version. The update is applicable to all Azure Stack HCI, version 22H2 clusters. We strongly recommend that you install this version as soon as it becomes available.

## High-level workflow for the OS upgrade

The Azure Stack HCI operating system update is available via the Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your cluster, follow these high-level steps:

1. [Complete the prerequisites including downloading the Azure Stack HCI, version 23H2 OS software update.](#complete-prerequisites)
1. [Connect to the Azure Stack HCI, version 22H2 cluster.](#step-1-connect-to-the-azure-stack-hci-cluster)
1. Install new OS using one of the other methods:
   1. [Manual upgrade of a Failover Cluster using SConfig.](#method-1-perform-a-manual-os-update-of-a-failover-cluster-using-sconfig)
   1. [Offline manual upgrade of all servers in a cluster.](#method-2-perform-a-fast-offline-os-update-of-all-servers-in-a-cluster)
1. Check the status of the updates.
1. [Perform post-upgrade steps, after the OS is upgraded.](#next-steps)


## Complete prerequisites

Before you begin, make sure that:

- You have access to an Azure Stack HCI, version 22H2 cluster.
- The cluster should be registered in Azure.
- Make sure that all the nodes in your Azure Stack HCI, version 22H2 cluster are healthy and show as **Online**.
- You have access to the Azure Stack HCI, version 23H2 OS software update. This update is available via Windows Update or as a downloadable media. The media is an ISO file that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- You have access to a client that can connect to your Azure Stack HCI cluster. This client should be running PowerShell 5.0 or later.

## Step 1: Connect to the Azure Stack HCI cluster

Follow these steps on your client to connect to one of the servers of your Azure Stack HCI cluster.

> [!IMPORTANT]
> To perform a manual upgrade using SConfig, you must log in directly to the cluster nodes.  You can use remote PowerShell to control cluster actions, or you can run the commands directly from each node when performing the update.

1. Run PowerShell as Administrator on the client that you're using to connect to your cluster.
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

## Step 2: Install new OS using other methods

Depending upon your requirements, you can manually update the OS using SConfig or update all the servers of the cluster at the same time. Each of these methods is discussed in the following sections.


## Method 1: Perform a manual OS update of a Failover Cluster using SCONFIG

To do a manual feature update of a failover cluster, use the **SConfig** tool and Failover Clustering PowerShell cmdlets. For more information about **SConfig**, see [Configure a Server Core installation of Windows Server and Azure Stack HCI with the Server Configuration tool (SConfig)](/windows-server/administration/server-core/server-core-sconfig).

For each node in the cluster, run these commands on the target node:

1. `Suspend-ClusterNode -Node <Node Name> -Drain`

    1. Check suspend using `Get-ClusterGroup`. Nothing should be running on the target node.

    1. Run the **SCONFIG** option 6.3 on the target node.

    1. After the target node has rebooted, wait for the storage repair jobs to complete by running `Get-Storage-Job` until there are no storage jobs or all storage jobs are completed.

1. `Resume-ClusterNode -Node <Node Name> -Failback`

When all the nodes are upgraded, you can perform the post-installation steps.

## Method 2: Perform a fast, offline OS update of all servers in a cluster

This method allows you to take all the servers in a cluster down at once and update the OS on all of them at the same time. This saves time during the update process, but the tradeoff is downtime for the hosted resources.

If there's a critical security update <!--ASK-->that you need to apply quickly or you need to ensure that updates complete within your maintenance window, this method could be for you. This process brings down the Azure Stack HCI cluster, updates the servers, and brings it all up again.

1. Plan your maintenance window.
1. Take the virtual disks offline.
1. Stop the cluster to take the storage pool offline. Run the `Stop-Cluster` cmdlet or use Windows Admin Center to stop the cluster.
1. Set the cluster service to **Disabled** by running the PowerShell command below on each server. This prevents the cluster service from starting up while being updated.

   ```
   Set-Service -Name clussvc -StartupType Disabled
   ```
   
1. <!--ASK-->Apply the Windows Server Cumulative Update and any required Servicing Stack Updates to all servers. You can update all servers at the same time: there's no need to wait because the cluster is down.
1. Restart the servers and ensure everything looks good.
1. Set the cluster service back to **Automatic** by running the PowerShell command below on each server.

   ```
   Set-Service -Name clussvc -StartupType Automatic
   ```
   
1. Start the cluster. Run the `Start-Cluster` cmdlet or use Windows Admin Center.  
1. Give it a few minutes. Make sure the storage pool is healthy.  Run `Get-StorageJob` to ensure all jobs complete successfully.
1. Bring the virtual disks back online.
1. Monitor the status of the virtual disks by running the `Get-Volume` and `Get-VirtualDisk` cmdlets.

<!--ASK-->

You're now ready to perform the post-upgrade steps for your cluster.

## Next steps

- [Learn how to perform the post-upgrade steps for your Azure Stack HCI cluster.](./post-upgrade-steps.md)
