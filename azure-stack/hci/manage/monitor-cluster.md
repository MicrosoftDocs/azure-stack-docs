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

## Monitor using Windows Admin Center

[Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management PC or server, and then add and connect to the Azure Stack HCI cluster that you wish to monitor. Critical alerts are prominently displayed at the top of the Windows Admin Center dashboard as soon as you log in. For example, the screenshot below indicates that updates need to be installed, and that the cluster has critical drive errors:

:::image type="content" source="media/monitor-cluster/dashboard-alert.png" alt-text="Example of Windows Admin Center dashboard alerts":::

### Monitor virtual machines

It's critical to understand the health of the virtual machines (VMs) on which your applications and databases run. If a VM is not assigned enough CPU or memory for the workloads running on it, performance could slow, or the application could become unavailable.

To monitor virtual machines in Windows Admin Center, click **Virtual machines** from the **Tools** menu at the left. To view a complete inventory of virtual machines running on the cluster, click **Inventory** at the top of the page. You'll see a table with information about each VM, including:

- **Name:** The name of the VM.
- **State:** Indicates if the VM is running or stopped.
- **Host server:** Indicates which server in the cluster the VM is running on.
- **CPU usage:** The percentage of the host server's CPU resources that the VM is consuming. (Is this true?)
- **Memory pressure:** The percentage of available memory resources that the VM is consuming.
- **Memory demand:** The amount of assigned memory (GB or MB) that the VM is consuming.
- **Assigned memory:** The total amount of memory assigned to the VM.
- **Uptime:** How long the VM has been running in days:hours:minutes:seconds.
- **Heartbeat:** Indicates whether the cluster can communicate with the VM.
- **Disaster recovery status:** Shows whether the VM is signed into Azure disaster recovery.

### Monitor servers

You can monitor the host servers that comprise an Azure Stack HCI cluster directly from Windows Admin Center. If host servers are not configured with sufficient CPU or memory to provide the resources VMs require, they can be a performance bottleneck.

To monitor servers in Windows Admin Center, click **Servers** from the **Tools** menu at the left. To view a complete inventory of virtual machines running on the cluster, click **Inventory** at the top of the page. You'll see a table with information about each server, including:

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