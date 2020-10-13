---
title: Taking an Azure Stack HCI server offline for maintenance
description: This topic provides guidance on how to properly pause and resume servers running the Azure Stack HCI operating system using Windows PowerShell and Windows Admin Center.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/13/2020
---

# Taking an Azure Stack HCI server offline for maintenance

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

With Azure Stack HCI, taking a server offline (bringing it down) also means taking offline portions of the storage that is shared across all servers in the cluster. Doing so requires pausing the server you want to take offline, moving roles to other servers in the cluster, and verifying that all data is available on the other servers in the cluster so that the data remains safe and accessible throughout the maintenance period.

Use the following procedures to properly pause a server in a Azure Stack HCI cluster before taking it offline.

   > [!IMPORTANT]
   > To install updates on a Azure Stack HCI cluster, use Cluster-Aware Updating (CAU), which automatically performs the procedures in this topic when installing updates. For more info, see [Update Azure Stack HCI clusters](update-cluster.md).

## Verifying it's safe to take the server offline

Before taking a server offline for maintenance, verify that all your volumes are healthy.

To do so, open a Windows PowerShell session with administrator permissions, and then run the following command:

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

Verify that the **HealthStatus** property for every volume is **Healthy**.

To view this in Windows Admin Center, connect to the server and select **Storage** from the **Tools** menu in Server Manager. 

Verify that the **Status** column for every virtual disk shows **Online**.

## Pausing and draining the server

Before restarting or shutting down the server, pause and drain (move off) any roles such as virtual machines (VMs) running on it. This gives Azure Stack HCI an opportunity to gracefully flush and commit data to ensure the shutdown is transparent to any applications running on that server.

   > [!IMPORTANT]
   > Always pause and drain clustered servers before restarting or shutting them down.

In PowerShell, run the following cmdlet as administrator to pause and drain.

```PowerShell
Suspend-ClusterNode -Drain
```

To do this in Windows Admin Center, connect to the cluster and then select **Compute > Nodes** from the **Tools** menu in Cluster Manager. Then, click on the name of the server you wish to pause and drain, and click **Pause**. You should see the following prompt:

If you pause this node, all clustered roles move to other nodes and no roles can be added to this node until it's resumed. Are you sure you want to pause cluster node?

Click **yes**, and all VMs will begin live migrating to other servers in the cluster. This can take a few minutes.

   > [!NOTE]
   > When you pause and drain the cluster node properly, Azure Stack HCI performs an automatic safety check to ensure it is safe to proceed. If there are unhealthy volumes, it will stop and alert you that it's not safe to proceed.

## Shutting down the server

Once the server has completed draining, it will show as **Paused** in Windows Admin Center and PowerShell.

You can now safely restart or shut it down, just like you would normally (for example, by using the Restart-Computer or Stop-Computer PowerShell cmdlets).

```PowerShell
Get-VirtualDisk

FriendlyName ResiliencySettingName OperationalStatus HealthStatus IsManualAttach Size
------------ --------------------- ----------------- ------------ -------------- ----
MyVolume1    Mirror                Incomplete        Warning      True           1 TB
MyVolume2    Mirror                Incomplete        Warning      True           1 TB
MyVolume3    Mirror                Incomplete        Warning      True           1 TB
```

Incomplete or Degraded operational status is normal when nodes are shutting down or starting/stopping the cluster service on a node and should not cause concern. All your volumes remain online and accessible.

## Resuming the server

When you are ready for the server to begin hosting workloads again, resume it.

In PowerShell, run the following cmdlet as administrator to resume.

```PowerShell
Resume-ClusterNode
```

To move the roles that were previously running on this server back, use the optional **-Failback** flag.

```PowerShell
Resume-ClusterNode –Failback Immediate
```

To do this in Windows Admin Center, select **Compute > Nodes** from the **Tools** menu at the left in Cluster Manager. Then, click on the name of the server you wish to resume and click **resume**.

## Waiting for storage to resync

When the server resumes, any new writes that happened while it was unavailable need to resync. This happens automatically. Using intelligent change tracking, it's not necessary for *all* data to be scanned or synchronized; only the changes. This process is throttled to mitigate impact to production workloads. Depending on how long the server was paused, and how much new data as written, it may take many minutes to complete.

You must wait for re-syncing to complete before taking any others servers in the cluster offline.

In PowerShell, run the following cmdlet (as Administrator) to monitor progress.

```PowerShell
Get-StorageJob
```

Here's some example output, showing the resync (repair) jobs:

```
Name   IsBackgroundTask ElapsedTime JobState  PercentComplete BytesProcessed BytesTotal
----   ---------------- ----------- --------  --------------- -------------- ----------
Repair True             00:06:23    Running   65              11477975040    17448304640
Repair True             00:06:40    Running   66              15987900416    23890755584
Repair True             00:06:52    Running   68              20104802841    22104819713
```

The **BytesTotal** shows how much storage needs to resync. The **PercentComplete** displays progress.

   > [!WARNING]
   > It's not safe to take another server offline until these repair jobs finish.

During this time, your volumes will continue to show as **Warning**, which is normal.

For example, if you use the `Get-VirtualDisk` cmdlet, you might see the following output:

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

## How to update Azure Stack HCI nodes offline
Use the following steps to patch your Azure Stack HCI system quickly. It involves scheduling a maintenance window and taking the system down for patching. If there is a critical security update that you need applied quickly or you need to ensure patching completes in your maintenance window, this method may be for you. This process brings down the Azure Stack HCI cluster, patches it, and brings it all up again. The trade-off is downtime to the hosted resources.

1. Plan your maintenance window.
2. Take the virtual disks offline.
3. Stop the cluster to take the storage pool offline. Run the  **Stop-Cluster** cmdlet or use Failover Cluster Manager to stop the cluster.
4. Set the cluster service to **Disabled** in Services.msc on each node. This prevents the cluster service from starting up while being patched.
5. Apply the Windows Server Cumulative Update and any required Servicing Stack Updates to all nodes. (You can update all nodes at the same time, no need to wait since the cluster is down).
6. Restart the nodes, and ensure everything looks good.
7. Set the cluster service back to **Automatic** on each node.
8. Start the cluster. Run the **Start-Cluster** cmdlet or use Failover Cluster Manager.

   Give it a few minutes.  Make sure the storage pool is healthy.

9. Bring the virtual disks back online.
10. Monitor the status of the virtual disks by running the **Get-Volume** and **Get-VirtualDisk** cmdlets.

## Next steps

For related information, see also:

- [Storage Spaces Direct overview](/windows-server/storage/storage-spaces/storage-spaces-direct-overview)
- [Update Azure Stack HCI clusters](update-cluster.md)