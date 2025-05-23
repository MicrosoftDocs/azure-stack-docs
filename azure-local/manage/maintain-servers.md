---
title: Failover cluster maintenance procedures for Azure Stack HCI and Windows Server
description: This article provides guidance about how to properly pause, drain, and resume clustered servers running Azure Stack HCI or Windows Server operating systems by using Windows Admin Center and PowerShell.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 05/06/2025
ROBOTS: NOINDEX, NOFOLLOW
---

# Failover cluster maintenance procedures

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

[!INCLUDE [azure-local-banner-22h2](../includes/azure-local-banner-22h2.md)]

This article assumes that you need to power down a physical server to perform maintenance, or restart it for some other reason. To install updates on an Azure Stack HCI cluster without taking servers offline, see [Update Azure Stack HCI clusters](update-cluster.md).

Taking a server offline for maintenance requires taking portions of storage offline that are shared across all servers in a failover cluster. This requires pausing the server that you want to take offline, putting the server's disks in maintenance mode, moving clustered roles and virtual machines (VMs) to other servers in the cluster, and verifying that all data is available on the other servers in the cluster. This process ensures that the data remains safe and accessible throughout the maintenance period.

You can use either Windows Admin Center or PowerShell to take a server offline for maintenance. This article covers both methods.

## Take a server offline using Windows Admin Center

The simplest way to prepare to take a server offline is by using Windows Admin Center.

### Verify it's safe to take the server offline

1. Using Windows Admin Center, connect to the server you want to take offline. Select **Storage > Disks** from the **Tools** menu, and verify that the **Status** column for every virtual disk shows **Online**.

2. Then, select **Storage > Volumes** and verify that the **Health** column for every volume shows **Healthy** and that the **Status** column for every volume shows **OK**.

### Pause and drain the server

Before either shutting down or restarting a server, you should pause the server and drain (move off) any clustered roles such as VMs running on it. Always pause and drain clustered servers before taking them offline for maintenance.

1. Using Windows Admin Center, connect to the cluster and then select **Compute > Servers** from the **Tools** menu in Cluster Manager.

2. Select **Inventory**, then select the name of the server you wish to pause and drain, and then select **Pause**. You should see the following prompt:

   *Pause server(s) for maintenance: Are you sure you want to pause server(s)? This moves workloads, such as virtual machines, to other servers in the cluster.​*

3. Select **yes** to pause the server and initiate the drain process. The server status shows as **In maintenance, Draining**, and roles such as Hyper-V and VMs immediately begin live migrating to other server(s) in the cluster. This can take a few minutes. No roles can be added to the server until it resumes. When the draining process is finished, the server status shows as **In maintenance, Drain completed**. The operating system performs an automatic safety check to ensure it's safe to proceed. If there are unhealthy volumes, it stops and alerts you that it's not safe to proceed.

### Shut down the server

Once the server completes draining, you can safely shut it down for maintenance or reboot it.

   > [!WARNING]
   > If the server is running Azure Stack HCI, version 20H2, Windows Server 2019, or Windows Server 2016, you must [put the disks in maintenance mode](#put-disks-in-maintenance-mode) before shutting down the server and [take the disks out of maintenance mode](#take-disks-out-of-maintenance-mode) before resuming the server into the cluster.

### Resume the server

When you're ready for the server to begin hosting clustered roles and VMs again, turn on the server, wait for it to boot up, and resume the server using the following steps.

1. In Cluster Manager, select **Compute > Servers** from the **Tools** menu at the left.

2. Select **Inventory**, select the name of the server you wish to resume, and then select **Resume**.

Clustered roles and VMs immediately begin live migrating back to the server. This can take a few minutes.

### Wait for storage to resync

When the server resumes, any new writes that happened while it was unavailable need to resync. This happens automatically, using intelligent change tracking. It's not necessary for *all* data to be scanned or synchronized; only the changes. This process is throttled to mitigate impact to production workloads. Depending on how long the server was paused and how much new data was written, it may take many minutes to complete.

   > [!IMPORTANT]
   > You must wait for resyncing to complete before taking any other servers in the cluster offline.

To check if storage resync is complete:

1. Connect to the cluster using Windows Admin Center and select **Storage > Volumes**.
1. Select **Inventory**.
1. Check the **Status** column for every volume. If it shows **OK**, storage resync is complete. It's now safe to take other servers in the cluster offline.

## Take a server offline using PowerShell

Use the following procedures to properly pause, drain, and resume a server in a failover cluster using PowerShell.

### Verify it's safe to take the server offline

To verify that all your volumes are healthy, run the following cmdlet as an administrator:

```PowerShell
Get-VirtualDisk
```

Here's an example of what the output might look like:

```
FriendlyName              ResiliencySettingName FaultDomainRedundancy OperationalStatus HealthStatus    Size FootprintOnPool StorageEfficiency
------------              --------------------- --------------------- ----------------- ------------    ---- --------------- -----------------
Mirror II                 Mirror                1                     OK                Healthy         4 TB         8.01 TB            49.99%
Mirror-accelerated parity                                             OK                Healthy      1002 GB         1.96 TB            49.98%
Mirror                    Mirror                1                     OK                Healthy         1 TB            2 TB            49.98%
ClusterPerformanceHistory Mirror                1                     OK                Healthy        24 GB           49 GB            48.98%
```

Verify that the **HealthStatus** property for every volume is **Healthy** and the **OperationalStatus** shows OK.

To do this using Failover Cluster Manager, go to **Storage** > **Disks**.

### Pause and drain the server

To pause and drain the server, run the following cmdlet as an administrator:

```PowerShell
Suspend-ClusterNode -Drain
```

To do this in Failover Cluster Manager, go to **Nodes**, right-click the node, and then select **Pause** > **Drain Roles**.

If the server is running Azure Stack HCI, version 21H2 or Windows Server 2022, pausing and draining the server puts the server's disks into maintenance mode. If the server is running Azure Stack HCI, version 20H2, Windows Server 2019, or Windows Server 2016, you'll have to do this manually (see next step).

### Put disks in maintenance mode

In Azure Stack HCI, version 20H2, Windows Server 2019, and Windows Server 2016, putting the server's disks in maintenance mode gives Storage Spaces Direct an opportunity to gracefully flush and commit data to ensure that the server shutdown doesn't affect application state. As soon as a disk goes into maintenance mode, it no longer allows writes. To minimize storage resynch times, we recommend putting the disks into maintenance mode right before the reboot and bringing them out of maintenance mode as soon as the system is up again.

   > [!NOTE]
   > If the server is running Azure Stack HCI, version 21H2 or Windows Server 2022, you can skip this step because the disks are automatically put into maintenance mode when the server is paused and drained. These operating systems have a granular repair feature that makes resyncs faster and less impactful on system and network resources, making it feasible to have server and storage maintenance done together.

If the server is running Windows Server 2019 or Azure Stack HCI, version 20H2, run the following cmdlet as administrator:

```PowerShell
Get-StorageScaleUnit -FriendlyName "Server1" | Enable-StorageMaintenanceMode
```

If the server is running Windows Server 2016, use the following syntax instead:

```PowerShell
Get-StorageFaultDomain -Type StorageScaleUnit | Where-Object {$_.FriendlyName -eq "Server1"} | Enable-StorageMaintenanceMode
```

### Shut down the server

Once the server completes draining, it shows as **Paused** in PowerShell and Failover Cluster Manager.

You can now safely shut down the server or restart it by using the `Stop-Computer` or `Restart-Computer` PowerShell cmdlets, or by using Failover Cluster Manager.

   > [!NOTE]
   > When running a `Get-VirtualDisk` command on servers that are shutting down or starting/stopping the cluster service, the server's Operational Status may be reported as incomplete or degraded, and the Health Status column may list a warning. This is normal and shouldn't cause concern. All your volumes remain online and accessible.

### Take disks out of maintenance mode

If the server is running Azure Stack HCI, version 20H2, Windows Server 2019, or Windows Server 2016, you must disable storage maintenance mode on the disks before resuming the server into the cluster. To minimize storage resynch times, we recommend bringing them out of maintenance mode as soon as the system is up again.

   > [!NOTE]
   > If the server is running Azure Stack HCI, version 21H2 or Windows Server 2022, you can skip this step because the disks are automatically taken out of maintenance mode when the server is resumed.

If the server is running Windows Server 2019 or Azure Stack HCI, version 20H2, run the following cmdlet as administrator to disable storage maintenance mode:

```PowerShell
Get-StorageScaleUnit -FriendlyName "Server1" | Disable-StorageMaintenanceMode
```

If the server is running Windows Server 2016, use the following syntax instead:

```PowerShell
Get-StorageFaultDomain -Type StorageScaleUnit | Where-Object {$_.FriendlyName -eq "Server1"} | Disable-StorageMaintenanceMode
```

### Resume the server

Resume the server into the cluster. To return the clustered roles and VMs that were previously running on the server, use the optional **-Failback** flag:

```PowerShell
Resume-ClusterNode –Failback Immediate
```

To do this in Failover Cluster Manager, go to **Nodes**, right-click the node, and then select **Resume** > **Fail Roles Back**.

Once the server resumes, it shows as **Up** in PowerShell and Failover Cluster Manager.

### Wait for storage to resync

When the server resumes, you must wait for resyncing to complete before taking any other servers in the cluster offline.

To monitor progress, run the following cmdlet as administrator:

```PowerShell
Get-StorageJob
```

If resyncing is already complete, you won't get any output.

Here's some example output showing resync (repair) jobs still running:

```
Name   IsBackgroundTask ElapsedTime JobState  PercentComplete BytesProcessed BytesTotal
----   ---------------- ----------- --------  --------------- -------------- ----------
Repair True             00:06:23    Running   65              11477975040    17448304640
Repair True             00:06:40    Running   66              15987900416    23890755584
Repair True             00:06:52    Running   68              20104802841    22104819713
```

The **BytesTotal** column shows how much storage needs to resync. The **PercentComplete** column displays progress.

   > [!WARNING]
   > It's not safe to take another server offline until these repair jobs finish.

During this time, under **HealthStatus**, your volumes continue to show as **Warning**, which is normal.

For example, if you use the `Get-VirtualDisk` cmdlet while storage is resyncing, you might see the following output:

```
FriendlyName ResiliencySettingName OperationalStatus HealthStatus IsManualAttach Size
------------ --------------------- ----------------- ------------ -------------- ----
MyVolume1    Mirror                InService         Warning      True           1 TB
MyVolume2    Mirror                InService         Warning      True           1 TB
MyVolume3    Mirror                InService         Warning      True           1 TB
```

Once the jobs complete, verify that volumes show **Healthy** again by using the `Get-VirtualDisk` cmdlet. Here's some example output:

```
FriendlyName ResiliencySettingName OperationalStatus HealthStatus IsManualAttach Size
------------ --------------------- ----------------- ------------ -------------- ----
MyVolume1    Mirror                OK                Healthy      True           1 TB
MyVolume2    Mirror                OK                Healthy      True           1 TB
MyVolume3    Mirror                OK                Healthy      True           1 TB
```

It's now safe to pause and restart other servers in the cluster.

## Next steps

For related information, see also:

- [Storage Spaces Direct overview](/windows-server/storage/storage-spaces/storage-spaces-direct-overview)
- [Update Azure Stack HCI clusters](update-cluster.md)
