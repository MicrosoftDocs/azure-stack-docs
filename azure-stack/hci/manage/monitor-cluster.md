---
title: Monitor Azure Stack HCI clusters
description: How to monitor Azure Stack HCI clusters, servers, virtual machines, drives, and volumes using Windows Admin Center and PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/12/2020
---

# Monitor Azure Stack HCI clusters

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

There are three ways to monitor Azure Stack HCI clusters and its underlying components: Windows Admin Center, [Azure Monitor](azure-monitor.md), and PowerShell.

## Monitor using Windows Admin Center dashboard

[Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management PC or server, and then add and connect to the Azure Stack HCI cluster that you wish to monitor. Critical alerts are prominently displayed at the top of the Windows Admin Center dashboard as soon as you log in. For example, the screenshot below indicates that updates need to be installed, and that the cluster has one critical drive error:

:::image type="content" source="media/monitor-cluster/dashboard-alert.png" alt-text="Example of Windows Admin Center dashboard alerts":::

## Monitor virtual machines

It's important to understand the health of the virtual machines (VMs) on which your applications and databases run. If a VM is not assigned enough CPU or memory for the workloads running on it, performance could slow, or the application could become unavailable. If a VM responds to less than three heartbeats for a period of five minutes or longer, there may be a problem.

To monitor VMs in Windows Admin Center, click **Virtual machines** from the **Tools** menu at the left. To view a complete inventory of VMs running on the cluster, click **Inventory** at the top of the page. You'll see a table with information about each VM, including:

- **Name:** The name of the VM.
- **State:** Indicates if the VM is running or stopped.
- **Host server:** Indicates which server in the cluster the VM is running on.
- **CPU usage:** The percentage of the cluster's total CPU resources that the VM is consuming.
- **Memory pressure:** The percentage of available memory resources that the VM is consuming.
- **Memory demand:** The amount of assigned memory (GB or MB) that the VM is consuming.
- **Assigned memory:** The total amount of memory assigned to the VM.
- **Uptime:** How long the VM has been running in days:hours:minutes:seconds.
- **Heartbeat:** Indicates whether the cluster can communicate with the VM.
- **Disaster recovery status:** Shows whether the VM is signed into Azure Site Recovery.

## Monitor servers

You can monitor the host servers that comprise an Azure Stack HCI cluster directly from Windows Admin Center. If host servers are not configured with sufficient CPU or memory to provide the resources VMs require, they can be a performance bottleneck. 

To monitor servers in Windows Admin Center, click **Servers** from the **Tools** menu at the left. To view a complete inventory of servers in the cluster, click **Inventory** at the top of the page. You'll see a table with information about each server, including:

- **Name:** The name of the host server in the cluster.
- **Status:** Indicates if the server is up or down.
- **Uptime:** How long the server has been up.
- **Manufacturer:** The hardware manufacturer of the server.
- **Model:** The model of the server.
- **Serial number:** The serial number of the server.
- **CPU usage:** The percentage of the host server's CPU that is being utilized. No server in the cluster should use more than 85 percent of its CPU for longer than 10 minutes. 
- **Memory usage:** The percentage of the host server's memory that is being utilized. If a server has less than 100MB of memory available for 10 minutes or longer, consider adding memory.

## Monitor volumes

Storage volumes can fill up quickly, making it important to monitor them on a regular basis to avoid any application impact. To monitor volumes in Windows Admin Center, click **Volumes** from the **Tools** menu at the left. To view a complete inventory of storage volumes on the cluster, click **Inventory** at the top of the page. You'll see a table with information about each volume, including:

- **Name:** The name of the volume.
- **Status:** "OK" indicates that the volume is healthy; otherwise, a warning or error is reported.
- **File system:** File system on the volume (ReFS, CSVFS).
- **Resiliency:** Indicates whether the volume is a two-way mirror, three-way mirror, or mirror-accelerated parity.
- **Size:** Size of the volume (TB/GB)
- **Storage pool:** The storage pool the volume belongs to.
- **Storage usage:** The percentage of the volume's storage capacity that is being used.
- **IOPS:** Number of input/output operations per second.

## Monitor drives

Azure Stack HCI virtualizes storage in such a way that losing an individual drive will not significantly impact the cluster. However, failed drives will [need to be replaced](replace-drives.md), and drives can impact performance by filling up or introducing latency. If the operating system cannot communicate with a drive, the drive may be loose or disconnected, its connector may have failed, or the drive itself may have failed. Windows automatically retires drives after 15 minutes of lost communication. 

To monitor drives in Windows Admin Center, click **Drives** from the **Tools** menu at the left. To view a complete inventory of drives on the cluster, click **Inventory** at the top of the page. You'll see a table with information about each drive, including:

- **Serial number:** The serial number of the drive.
- **Status:** "OK" indicates that the drive is healthy; otherwise, a warning or error is reported.
- **Model:** The model of the drive.
- **Size:** The total capacity of the drive (TB/GB).
- **Type:** Drive type (SSD, HDD).
- **Used for:** Indicates whether the drive is used for cache or capacity.
- **Location:** The storage adapter and port the drive is connected to.
- **Server:** The name of the server the drive is connected to.
- **Storage pool:** The storage pool the drive belongs to.
- **Storage usage:** The percentage of the drive's storage capacity that is being used.

## Add performance counters

Use the Performance Monitor tool in Windows Admin Center to view and compare performance counters for Windows, apps, or devices in real-time.

1. Select **Performance Monitor** from the **Tools** menu on the left.
1. Click **blank workspace** to start a new workspace, or **restore previous** to restore a previous workspace.
1. If creating a new workspace, click the **Add counter** button and select one or more source servers to monitor, or select the entire cluster.
1. Select the object and instance you wish to monitor, as well as the counter and graph type to view dynamic performance information.
1. Save the workspace by choosing **Save > Save As** from the top menu.
 
For example, the screenshot below shows a performance counter called "Memory usage" that displays information about memory across a two-node cluster.

:::image type="content" source="media/monitor-cluster/performance-monitor.png" alt-text="Example of a real-time performance counter in Windows Admin Center":::

## Query and process performance history with PowerShell

You can also monitor Azure Stack HCI clusters using PowerShell cmdlets that return information about the cluster and its components. See [Performance history for Storage Spaces Direct](/windows-server/storage/storage-spaces/performance-history).

## Use the Health Service feature

Any Health Service fault on the cluster should be investigated. See [Health Service in Windows Server](/windows-server/failover-clustering/health-service-overview) to learn how to run reports and identify faults.

## Troubleshoot health and operational states

To understand the health and operational states of storage pools, virtual disks, and drives, see [Troubleshoot Storage Spaces and Storage Spaces Direct health and operational states](/windows-server/storage/storage-spaces/storage-spaces-states).

## Monitor performance using storage QoS

Storage Quality of Service (QoS) provides a way to centrally monitor and manage storage I/O for VMs to mitigate noisy neighbor issues and provide consistent performance. See [Storage Quality of Service](/windows-server/storage/storage-qos/storage-qos-overview).

## Set up alerts in Azure Monitor

Azure Stack HCI integrates with Azure Monitor to allow users to [set up alerts](azure-monitor.md#setting-up-alerts-using-windows-admin-center) and be notified if CPU, disk capacity, and memory utilization thresholds are exceeded, if VM heartbeats are not returned, or if there is a system critical error or health service fault.

## Next steps

For related information, see also:

- [Get started with Azure Stack HCI and Windows Admin Center](../get-started.md)
- [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md)