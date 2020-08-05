---
title: Monitor Azure Stack HCI clusters
description: How to monitor Azure Stack HCI clusters, servers, virtual machines, drives, and volumes using Windows Admin Center and PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 08/04/2020
---

# Monitor Azure Stack HCI clusters

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

There are three ways to monitor Azure Stack HCI clusters and its underlying components: Windows Admin Center, [Azure Monitor](azure-monitor.md), and PowerShell.

## Monitor using Windows Admin Center dashboard

[Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management PC or server, and then add and connect to the Azure Stack HCI cluster that you wish to monitor. Critical alerts are prominently displayed at the top of the Windows Admin Center dashboard as soon as you log in. For example, the screenshot below indicates that updates need to be installed, and that the cluster has one critical drive error:

:::image type="content" source="media/monitor-cluster/dashboard-alert.png" alt-text="Example of Windows Admin Center dashboard alerts":::

## Monitor virtual machines

It's critical to understand the health of the virtual machines (VMs) on which your applications and databases run. If a VM is not assigned enough CPU or memory for the workloads running on it, performance could slow, or the application could become unavailable.

To monitor virtual machines in Windows Admin Center, click **Virtual machines** from the **Tools** menu at the left. To view a complete inventory of virtual machines running on the cluster, click **Inventory** at the top of the page. You'll see a table with information about each VM, including:

- **Name:** The name of the VM.
- **State:** Indicates if the VM is running or stopped.
- **Host server:** Indicates which server in the cluster the VM is running on.
- **CPU usage:** The percentage of the host server's CPU resources that the VM is consuming. **(Is this true?)**
- **Memory pressure:** The percentage of available memory resources that the VM is consuming.
- **Memory demand:** The amount of assigned memory (GB or MB) that the VM is consuming.
- **Assigned memory:** The total amount of memory assigned to the VM.
- **Uptime:** How long the VM has been running in days:hours:minutes:seconds.
- **Heartbeat:** Indicates whether the cluster can communicate with the VM.
- **Disaster recovery status:** Shows whether the VM is signed into Azure disaster recovery. **(Is this true?)**

## Monitor servers

You can monitor the host servers that comprise an Azure Stack HCI cluster directly from Windows Admin Center. If host servers are not configured with sufficient CPU or memory to provide the resources VMs require, they can be a performance bottleneck.

To monitor servers in Windows Admin Center, click **Servers** from the **Tools** menu at the left. To view a complete inventory of servers in the cluster, click **Inventory** at the top of the page. You'll see a table with information about each server, including:

- **Name:** The name of the host server in the cluster.
- **Status:** Indicates if the server is up or down.
- **Uptime:** How long the server has been up.
- **Manufacturer:** The hardware manufacturer of the server.
- **Model:** The model of the server.
- **Serial number:** The serial number of the server.
- **CPU usage:** The percentage of the host server's CPU that is being utilized.
- **Memory usage:** The percentage of the host server's memory that is being utilized.

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
2. Click **blank workspace** to start a new workspace, or **restore previous** to restore a previous workspace.
3. If creating a new workspace, click the **Add counter** button and select one or more source servers to monitor, or select the entire cluster.
4. Select the object and instance you wish to monitor, as well as the counter and graph type to view dynamic performance information.
5. Save the workspace by choosing **Save > Save As** from the top menu.
 
For example, the screenshot below shows a performance counter called "Memory usage" that displays information about memory across a two-node cluster.

:::image type="content" source="media/monitor-cluster/performance-monitor.png" alt-text="Example of a real-time performance counter in Windows Admin Center":::

## Monitor using Windows PowerShell

You can also monitor Azure Stack HCI clusters using PowerShell cmdlets that return information about the cluster and its components. Here are some common scenarios and how to troubleshoot them.

### CPU utilization

server (over 85% for 10 mins)

### Disk capacity utilization

server (over 80% for 10 mins)

### Memory utilization

server (available memory less than 100MB for 10 mins)

### Heartbeat (VM unavailable)

server (fewer than 2 beats for 5 mins)

### System critical error

(cluster) any critical alert in the cluster system event log

### Health service alert

(cluster) - any health service fault on the cluster

## Query and process performance history

## Use the Health Service feature in Windows Server

## Troubleshoot health and operational states

## Monitor health using storage QoS


## Next steps

For related information, see also:

- [Get started with Azure Stack HCI and Windows Admin Center](../get-started.md)
- [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md)