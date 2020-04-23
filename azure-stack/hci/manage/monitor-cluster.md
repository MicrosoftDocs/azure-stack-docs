---
title: Monitor Azure Stack HCI clusters
description: How to monitor Azure Stack HCI clusters, servers, virtual machines, drives, and volumes using Windows Admin Center and PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 04/23/2020
---

# Monitor Azure Stack HCI clusters

> Applies to: Windows Server 2019

There are a variety of ways to monitor Azure Stack HCI clusters and its underlying components, including Storage Spaces Direct. The easiest way to monitor cluster health at a glance is by using the Windows Admin Server dashboard, which provides alerts and health information about servers, drives, and volumes, as well as details about CPU, memory, and storage usage. The dashboard also displays cluster performance information such as IOPS and latency by hour, day, week, month, or year. Azure users can also monitor on-premises Azure Stack HCI clusters using [Azure Monitor](azure-monitor.md).

## Monitor using Windows Admin Center

First, install Windows Admin Center on a domain controller or Windows 10 management PC that is a member of the local administrator's group. Add and connect to one or more Azure Stack HCI clusters that you wish to monitor.

### Monitor virtual machines

It's critical to understand the health of the virtual machines (VMs) on which your applications and databases run. If a VM is not assigned enough CPU or memory for the workloads running on it, performance could slow, or the application could become unavailable.

### Monitor servers

You can monitor the host servers that comprise an Azure Stack HCI cluster directly from Windows Admin Center. If host servers are not configured with sufficient CPU or memory to provide the resources VMs require, they can be a performance bottleneck.

### Monitor volumes

Storage volumes can fill up quickly, making it important to monitor them on a regular basis to avoid any application impact.

### Monitor drives

Azure Stack HCI virtualizes storage in such a way that losing an individual drive will not significantly impact the cluster. However, failed drives will need to be replaced, and drives can impact performance by filling up or introducing latency. 

### Add counters

Use the Performance Monitor tool in Windows Admin Center to view and compare performance counters for Windows, apps, or devices in real-time.

1. Select **Performance Monitor** from the **Tools** menu on the left.
2. Click **blank workspace** to start a new workspace, or **restore previous** to restore a previous workspace.
3. If creating a new workspace, click the **Add counter** button and select one or more source servers to monitor, or select the entire cluster.
4. Select the object and instance you wish to monitor, as well as the counter and graph type to view dynamic performance information.
5. Save the workspace by choosing **Save > Save As** from the top menu.

## Monitor using Windows PowerShell

You can also monitor Azure Stack HCI clusters using PowerShell cmdlets that return information about the cluster and its components. 

## Query and process performance history

## Use the Health Service feature in Windows Server

## Troubleshoot health and operational states

## Monitor health using storage QoS


## Next steps

For related information, see also:

- [Get started with Azure Stack HCI and Windows Admin Center](../get-started.md)
- [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md)
