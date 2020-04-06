---
title: Monitor Azure Stack HCI clusters with Windows Admin Center
description: Quickly connect to an existing cluster using Windows Admin Center to monitor cluster and storage performance.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 04/06/2020
---

# Quickstart: Monitor Azure Stack HCI clusters with Windows Admin Center

> Applies to: Windows Server 2019

This topic provides instructions for monitoring the performance of an Azure Stack HCI cluster at a glance by using Windows Admin Center, a locally deployed, browser-based app for managing Azure Stack HCI.

## Install Windows Admin Center

The simplest way to install Windows Admin Center is on a local Windows 10 PC, although you must be a member of the local administrator's group to do so.

1. Download [Windows Admin Center](https://www.microsoft.com/evalcenter/evaluate-windows-admin-center) from the Microsoft Evaluation Center. Even though it says "Start your evaluation," this is the generally available version for production use, included as part of your Windows Server license.
2. Run the WindowsAdminCenter.msi file to install.
3. When you start Windows Admin Center for the first time, you'll see an icon in the notification area of your desktop. Right-click this icon and choose Open to open the tool in your default browser. Make sure to select the Windows Admin Center Client certificate when prompted to select a certificate.

## Add and connect to an Azure Stack HCI cluster

After you have completed the installation of Windows Admin Center, you can add a cluster to manage from the main overview page.

1. Click **+ Add** under **All Connections**.

    :::image type="content" source="media/addcluster.png" alt-text="[Add Cluster Screenshot":::

2. Choose to add a Windows Server cluster:
    
    :::image type="content" source="media/chooseconnectiontype.png" alt-text="Choose Connection Type Screenshot":::

3. Type the name of the cluster to manage and click **Add**. The cluster will be added to your connection list on the overview page.

4. Under **All Connections**, click the name of the cluster you just added. Windows Admin Center will start **Cluster Manager** and take you directly to the Windows Admin Center dashboard for that cluster.

## Monitor cluster performance with the Windows Admin Center dashboard

The Windows Admin Center dashboard provides alerts and health information about servers, drives, and volumes, as well as details about CPU, memory, and storage usage.

:::image type="content" source="media/dashboard-alerts.png" alt-text="Dashboard Alerts Screenshot":::

You can scroll down to view cluster performance information such as IOPS and latency by hour, day, week, month, or year.

:::image type="content" source="media/dashboard-performance.png" alt-text="Dashboard Performance Screen Shot":::

## Monitor performance of individual components

The **Tools** menu to the left of the dashboard allows you to drill down on any component of the cluster to view summaries and inventories of virtual machines, servers, volumes, and drives.

### Virtual machines

To view a summary of virtual machines that are running on the cluster, click **Virtual machines** from the **Tools** menu at the left.

:::image type="content" source="media/vms-summary.png" alt-text="Virtual Machine Summary":::

For a complete inventory of virtual machines running on the cluster along with their state, host server, CPU usage, memory pressure, memory demand, assigned memory, and uptime, click **Inventory** at the top of the page.

:::image type="content" source="media/vms-inventory.png" alt-text="Virtual Machine Inventory":::

### Servers

To view a summary of the servers in the cluster, click **Servers** from the **Tools** menu at the left.

:::image type="content" source="media/servers-summary.png" alt-text="Servers Summary":::

For a complete inventory of servers in the cluster including their status, uptime, manufacturer, model, and serial number, click **Inventory** at the top of the page.

:::image type="content" source="media/servers-inventory.png" alt-text="Servers Inventory":::

### Volumes

To view a summary of volumes on the cluster, click **Volumes** from the **Tools** menu at the left.

:::image type="content" source="media/volumes-summary.png" alt-text="Volumes Summary":::

For a complete inventory of volumes on the cluster including their status, file system, resiliency, size, storage usage, and IOPS, click **Inventory** at the top of the page.

:::image type="content" source="media/volumes-inventory.png" alt-text="Volumes Inventory":::

### Drives

To view a summary of drives in the cluster, click **Drives** from the **Tools** menu at the left.

:::image type="content" source="media/drives-summary.png" alt-text="Drives Summary":::

For a complete inventory of drives in the cluster along with their serial number, status, model, size, type, use, location, server, and capacity, click **Inventory** at the top of the page.

:::image type="content" source="media/drives-inventory.png" alt-text="Drives Inventory":::

### Virtual switches

To view the settings for a virtual switch in the cluster, click **Virtual switches** from the **Tools** menu at the left, then click the name of the virtual switch you want to display the settings for. Windows Admin Center will display the network adapters associated with the virtual switch, including their IP addresses, connection state, link speed, and MAC address.

:::image type="content" source="media/virtual-switch-settings.png" alt-text="Virtual Switch Settings":::

## Add counters with the Performance Monitor tool

Use the Performance Monitor tool to view and compare performance counters for Windows, apps, or devices in real-time.

1. Select **Performance Monitor** from the **Tools** menu on the left.
2. Click **blank workspace** to start a new workspace, or **restore previous** to restore a previous workspace.
    :::image type="content" source="media/performance-monitor.png" alt-text="Performance Monitor Screenshot":::
3. If creating a new workspace, click the **Add counter** button and select one or more source servers to monitor, or select the entire cluster.
4. Select the object and instance you wish to monitor, as well as the counter and graph type to view dynamic performance information.
    :::image type="content" source="media/example-counter.png" alt-text="Example Counter Screenshot":::
5. Save the workspace by choosing **Save > Save As** from the top menu.

## Use Azure Monitor for monitoring and alerts

You can also use [Azure Monitor](/windows-server/manage/windows-admin-center/azure/azure-monitor) (requires an Azure subscription) to collect events and performance counters for analysis and reporting, take action when a particular condition is detected, and receive notifications via email. Click **Azure Monitor** from the **Tools** menu to connect directly to Azure from Windows Admin Center. 

## Collect diagnostics information

Select **Diagnostics** from the **Tools** menu to collect information for troubleshooting problems with your cluster. If you call Microsoft Support, they may ask for this information.

## Next steps

For a deeper dive into performance monitoring, see also:

- [Performance history for Storage Spaces Direct](/windows-server/storage/storage-spaces/performance-history)
- Monitor with Azure Monitor
