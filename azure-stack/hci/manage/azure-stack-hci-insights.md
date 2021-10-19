---
title: Monitor multiple clusters with Azure Stack HCI Insights
description: How to use Azure Stack HCI Insights to monitor the health, performance, and usage of multiple Azure Stack HCI clusters.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 06/16/2021
---

# Monitor multiple clusters with Azure Stack HCI Insights (preview)

> Applies to: Azure Stack HCI, version 21H2

Azure Stack HCI Insights provides health, performance, and usage insights about registered Azure Stack HCI, version 21H2 clusters that are connected to Azure and are [enrolled in monitoring](monitor-azure-portal.md). This article explains the benefits of this new Azure Monitor experience, as well as how to modify and adapt the experience to fit the unique needs of your organization.

Azure Stack HCI Insights stores its data in a Log Analytics workspace, which allows it to deliver powerful aggregation and filtering and analyze data trends over time. There is no direct cost for Azure Stack HCI Insights. Users are billed based on the amount of data ingested and the data retention settings of their Log Analytics workspace.

You can view the monitoring data for a single cluster from your Azure Stack HCI resource page, or you can use Azure Monitor to see an aggregated view of multiple clusters.

Watch the video for a quick introduction:

> [!VIDEO https://www.youtube.com/embed/mcgmAsNricw]

## Benefits of Azure Stack HCI Insights

Azure Stack HCI Insights offers three primary benefits:

- It's managed by Azure and accessed from Azure portal, so it's always up to date, and there's no database or special software setup required.

- It's highly scalable, capable of loading more than 400 cluster information sets across multiple subscriptions at a time, with no boundary limitations on cluster, domain, or physical location.

- It's highly customizable. The user experience is built on top of Azure Monitor workbook templates, allowing users to change the views and queries, modify or set thresholds that align with the users limits, and save these customizations into a workbook. Charts in the workbooks can then be pinned to Azure dashboards.

## Prerequisites

To use Azure Stack HCI Insights, make sure you've completed the following:

1.	Have an Azure Owner or User Access Administrator [register your cluster with Azure](../deploy/register-with-azure.md), which will automatically make sure every server in your cluster is Azure Arc-enabled. This allows Azure Monitor to fetch the details of not only the cluster, but also the nodes. If you registered your cluster prior to June 15, 2021, you'll need to re-register to Arc-enable the servers.
2. [Enable Log Analytics](monitor-azure-portal.md#configure-the-log-analytics-agent-extension) to link the cluster to a Log Analytics workspace where the log data required for monitoring will be saved.
3. [Enable Monitoring](monitor-azure-portal.md#enable-monitoring-visualizations) to allow Azure Monitor to start collecting the events that are required for monitoring.

## View health, performance, and usage insights

Once the prerequisites are met, you can access Azure Stack HCI Insights from **Azure Monitor > Insights hub > Azure Stack HCI**. You will see the following tabs to toggle between views: **Get started**, **Overview**, **Virtual machines**, **Storage**, **Cluster performance**.

### Filtering results

The visualization can be filtered across subscriptions. You can filter the results based on the following drop-down menus:

- **Time range:** This filter allows you to select a range for trend view. The default value is **Last 24 hours**.
- **Subscriptions:**  Shows the subscriptions that have registered Azure Stack HCI clusters. You can select multiple subscriptions in this filter.
- **HCI clusters:** Lists the registered Azure Stack HCI clusters that have Logs and Monitoring capabilities enabled in the selected time range. You can select multiple clusters from this filter.

### Get started

The **Get started** view calls out the prerequisites to use Azure Stack HCI Insights and displays the number of registered Azure Stack HCI clusters that have Log Analytics and Monitoring enabled. It also shows a list of unmonitored clusters across subscriptions that are connected to Azure or have recently connected to Azure.

:::image type="content" source="media/azure-stack-hci-insights/get-started.png" alt-text="The Get started view displays the number of registered Azure Stack HCI clusters that have Log Analytics and Monitoring enabled and shows a list of unmonitored clusters" lightbox="media/azure-stack-hci-insights/get-started.png":::

### Overview

This view provides an overview of server health and performance, and usage of selected clusters. This view is built using the [server event ID 3000](#server-event-3000-rendereddescription-column-value) of the Microsoft-Windows-SDDC-Management/Operational Windows Event Log Channel. Each row can be further expanded to see the node health status. You can interact with the cluster and server resource to navigate to the respective resource page.

:::image type="content" source="media/azure-stack-hci-insights/overview.png" alt-text="This view provides an overview of server health and performance, and usage of selected clusters." lightbox="media/azure-stack-hci-insights/overview.png":::

### Virtual machines

This view provides the state of all the VMs in the selected cluster. This view is built using the [virtual machine event ID 3003](#virtual-machine-event-3003-rendereddescription-column-value) of the Microsoft-Windows-SDDC-Management/Operational Windows Event Log Channel. Each row can be further expanded to view the distribution of VMs across servers in the cluster. You can interact with the cluster and node resource to navigate to the respective resource page.

:::image type="content" source="media/azure-stack-hci-insights/virtual-machines.png" alt-text="This view provides the state of all the VMs in the selected cluster. " lightbox="media/azure-stack-hci-insights/virtual-machines.png":::

### Storage

This view provides two things:

**Volume health, usage, and performance information.** This view is built using the [volume event ID 3002](#volume-event-3002-rendereddescription-column-value) of the Microsoft-Windows-SDDC-Management/Operational Windows Event Log Channel.

:::image type="content" source="media/azure-stack-hci-insights/volume-health.png" alt-text="Volume health, usage, and performance information" lightbox="media/azure-stack-hci-insights/volume-health.png":::

**Drive health information.** This view is built using the [drive event ID 3001](#drive-event-3001-rendereddescription-column-value) of the Microsoft-Windows-SDDC-Management/Operational Windows Event Log Channel.

:::image type="content" source="media/azure-stack-hci-insights/drive-health.png" alt-text="Drive health information" lightbox="media/azure-stack-hci-insights/drive-health.png":::

### Cluster performance

This view provides four cluster performance trends:

-	CPU usage
-	Average volume latency
-	Volume IOPS
-	Volume throughput

The views are built using the [cluster event ID 3004](#cluster-event-3004-rendereddescription-column-value) of the Microsoft-Windows-SDDC-Management/Operational Windows Event Log Channel.

The screenshot below displays CPU usage and average volume latency trends.

:::image type="content" source="media/azure-stack-hci-insights/cluster-performance-cpu-latency.png" alt-text="CPU usage and average volume latency" lightbox="media/azure-stack-hci-insights/cluster-performance-cpu-latency.png":::

The screenshot below displays volume IOPS and throughput trends.

:::image type="content" source="media/azure-stack-hci-insights/cluster-performance-iops-throughput.png" alt-text="Volume IOPS and throughput" lightbox="media/azure-stack-hci-insights/cluster-performance-iops-throughput.png":::

## Customize Azure Stack HCI Insights

Because the user experience is built on top of Azure Monitor workbook templates, users can edit the visualizations and queries and save them as a customized workbook.

If you are using the visualization from **Azure Monitor > Insights hub > Azure Stack HCI**, select **Customize > Edit > Save As** to save a copy of your modified version into a custom workbook.

Workbooks are saved within a resource group. Everyone with access to the resource group will be able to access the customized workbook.

Most queries are written using Kusto Query Language (KQL). Some queries are written using Resource Graph Query.

For more information, see the following:

- [Azure Monitor Workbooks](/azure/azure-monitor/visualize/workbooks-overview)
- [Getting started with Kusto](/azure/data-explorer/kusto/concepts/)
- [Starter Resource Graph query samples](/azure/governance/resource-graph/samples/starter?tabs=azure-cli)

## Support

To open a support ticket for Azure Stack HCI Insights, please use the service type **Insights for Azure Stack HCI** under **Monitoring & Management**.

## Event Log Channel

Azure Stack HCI Insights and monitoring views are based on Microsoft-Windows-SDDC-Management/Operational Windows Event Log Channel. When monitoring is enabled, the data from this channel is saved to a Log Analytics workspace.

### Viewing and changing the dump cache interval

The default interval to dump the cache is set to 3600 seconds (1 hour).

Use the following PowerShell cmdlets to view the cache dump interval value:

```PowerShell
Get-ClusterResource "sddc management" | Get-ClusterParameter
```

Use the following cmdlets to change the frequency of cache dump. If set to 0 it will stop publishing events:

```PowerShell
Get-ClusterResource "sddc management" | Set-ClusterParameter -Name CacheDumpIntervalInSeconds -Value <value in seconds>
```

### Windows events in the log channel

This channel includes five events. Each event has cluster name and Azure Resource Manager ID as EventData.

| **Event ID** | **Event type**  |
|:-------------|-----------------|
| 3000         | Server          |
| 3001         | Drive           |
| 3002         | Volume          |
| 3003         | Virtual machine |
| 3004         | Cluster         |

### Server event 3000 RenderedDescription column value

```json
{
   "m_servers":[
      {
         "m_statusCategory":"Integer",
         "m_status":[
            "Integer",
            "…"
         ],
         "m_id":"String",
         "m_name":"String",
         "m_totalPhysicalMemoryInBytes":"Integer",
         "m_usedPhysicalMemoryInBytes":"Integer",
         "m_totalProcessorsUsedPercentage":"Integer",
         "m_totalClockSpeedInMHz":"Integer",
         "m_uptimeInSeconds":"Integer",
         "m_InboundNetworkUsage":"Double (Bits/sec)",
         "m_OutboundNetworkUsage":"Double (Bits/sec)",
         "m_InboundRdmaUsage":"Double (Bits/sec)",
         "m_OutboundRdmaUsage":"Double (Bits/sec)",
         "m_site":"String",
         "m_location":"String",
         "m_vm":{
            "m_totalVmsUnknown":"Integer",
            "m_totalVmsRunning":"Integer",
            "m_totalVmsStopped":"Integer",
            "m_totalVmsFailed":"Integer",
            "m_totalVmsPaused":"Integer",
            "m_totalVmsSuspended":"Integer",
            "m_totalVmsStarting":"Integer",
            "m_totalVmsSnapshotting":"Integer",
            "m_totalVmsSaving":"Integer",
            "m_totalVmsStopping":"Integer",
            "m_totalVmsPausing":"Integer",
            "m_totalVmsResuming":"Integer"
         }
      },
      "…"
   ],
   "m_alerts":{
      "m_totalUnknown":"Integer",
      "m_totalHealthy":"Integer",
      "m_totalWarning":"Integer",
      "m_totalCritical":"Integer"
   }
}
```

Most variables are self-explanatory from the above JSON information. However, the table below lists a few variables which are a bit harder to understand.

| **Variable**     | **Description**                                                                                                                                 |
|:-----------------|:------------------------------------------------------------------------------------------------------------------------------------------------|
| m_servers        | Array of server nodes.                                                                                                                          |
| m_statusCategory | Health status of the server.                                                                                                                    | 
| m_status         | State of the server. It is an array that can contain one or two values. The first value is mandatory (0-4). The second value is optional (5-9). | 


Values for the **m_statusCategory** variable are as follows:

| **Value** | **Meaning**     |
|:----------|-----------------|
| 0         | Healthy         |
| 1         | Warning         |
| 2         | Unhealthy       |
| 255       | Other           |

Values for the **m_status** variable are as follows:

| **Value** | **Meaning**     |
|:----------|-----------------|
| 0         | Up              |
| 1         | Down            |
| 2         | In maintenance  |
| 3         | Joining         |
| 4         | Normal          |
| 5         | Isolated        |
| 6         | Quarantined     |
| 7         | Draining        |
| 8         | Drain completed |
| 9         | Drain failed    |
| 0xffff    | Unknown         |   

### Drive event 3001 RenderedDescription column value

```json
{
   "m_totalDrivesUnknown":"Integer",
   "m_totalDrivesHealthy":"Integer",
   "m_totalDrivesWarning":"Integer",
   "m_totalDrivesUnhealthy":"Integer",
   "m_alerts":{
      "m_totalUnknown":"Integer",
      "m_totalHealthy":"Integer",
      "m_totalWarning":"Integer",
      "m_totalCritical":"Integer"
   }
}
```

### Volume event 3002 RenderedDescription column value

```json
{
   "VolumeList":[
      {
         "m_Id":"String",
         "m_Label":"String",
         "m_Path":"String",
         "m_StatusCategory":"Integer",
         "m_Status":[
            "Integer",
            "…"
         ],
         "m_Size":"Integer (Bytes)",
         "m_SizeUsed":"Integer (Bytes)",
         "m_TotalIops":"Double (Count/second)",
         "m_TotalThroughput":"Double (Bytes/Second)",
         "m_AverageLatency":"Double (Seconds)"
      },
      "…"
   ],
   "m_Alerts":{
      "m_totalUnknown":"Integer",
      "m_totalHealthy":"Integer",
      "m_totalWarning":"Integer",
      "m_totalCritical":"Integer"
   }
}
```

Most variables are self-explanatory from the above JSON information. However, the table below lists a few variables which are a bit harder to understand.

| **Variable**     | **Description** |
|:-----------------|:----------------|
| VolumeList | Array of volumes. |
| m_StatusCategory | Health status of volume. |
| m_Status | State of the volume. It is an array that can contain one or two values. The first value is mandatory (0-4). The second value is optional (5-9). |


Values for the **m_statusCategory** variable are as follows:

| **Value** | **Meaning**     |
|:----------|-----------------|
| 0         | Healthy         |
| 1         | Warning         |
| 2         | Unhealthy       |
| 255       | Other           |

Values for the **m_status** variable are as follows:

| **Value** | **Meaning**                |
|:----------|----------------------------|
| 0         | Unknown                    |
| 1         | Other                      |
| 2         | OK                         |
| 3         | Needs repair               |
| 4         | Stressed                   |
| 5         | Predictive failure         |
| 6         | Error                      |
| 7         | Non-recoverable error      |
| 8         | Starting                   |
| 9         | Stopping                   |
| 10        | Stopped                    |
| 11        | In service                 |
| 12        | No contact                 |
| 13        | Lost communication         |
| 14        | Aborted                    |
| 15        | Dormant                    |
| 16        | Supporting entity in error |
| 17        | Completed                  |
| 18        | Power mode                 |
| 19        | Relocating                 |
| 0xD002    | Down                       |
| 0xD003    | Needs resync               |

### Virtual machine event 3003 RenderedDescription column value

```json
{
   "m_totalVmsUnknown":"Integer",
   "m_totalVmsRunning":"Integer",
   "m_totalVmsStopped":"Integer",
   "m_totalVmsFailed":"Integer",
   "m_totalVmsPaused":"Integer",
   "m_totalVmsSuspended":"Integer",
   "m_totalVmsStarting":"Integer",
   "m_totalVmsSnapshotting":"Integer",
   "m_totalVmsSaving":"Integer",
   "m_totalVmsStopping":"Integer",
   "m_totalVmsPausing":"Integer",
   "m_totalVmsResuming":"Integer",
   "m_alerts":{
      "m_totalUnknown":"Integer",
      "m_totalHealthy":"Integer",
      "m_totalWarning":"Integer",
      "m_totalCritical":"Integer"
   }
}
```

### Cluster event 3004 RenderedDescription column value

```json
{
   "m_cpuUsage":"Double (%)",
   "m_totalVolumeIops":"Double",
   "m_averageVolumeLatency":"Double (Seconds)",
   "m_totalVolumeThroughput":"Double (Bytes/Second)",
   "m_totalVolumeSizeInBytes":"Double",
   "m_totalVolumeSizeInBytes":"Integer",
   "m_usedVolumeSizeInBytes":"Integer",
   "m_totalMemoryInBytes":"Integer",
   "m_usedMemoryInBytes":"Integer",
   "m_isStretch":"Boolean",
   "m_alerts":{
      "m_totalUnknown":"Integer",
      "m_totalHealthy":"Integer",
      "m_totalWarning":"Integer",
      "m_totalCritical":"Integer"
   }
}
```

## Next steps

For related information, see also:

- [Configure Azure portal to monitor Azure Stack HCI clusters](monitor-azure-portal.md)
- [Monitor Azure Stack HCI clusters from Windows Admin Center](monitor-cluster.md)
- [Troubleshooting workbook-based insights](/azure/azure-monitor/insights/troubleshoot-workbooks)
