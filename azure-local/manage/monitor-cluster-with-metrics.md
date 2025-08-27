---
title: Monitor Azure Local with Azure Monitor Metrics
description: Learn how to monitor Azure Local with Azure Monitor Metrics.
author: alkohli
ms.author: alkohli
ms.reviewer: saniyaislam
ms.topic: how-to
ms.service: azure-local
ms.date: 03/20/2025
ms.custom: sfi-image-nochange
---

# Monitor Azure Local with Azure Monitor Metrics

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to monitor your Azure Local system with [Azure Monitor Metrics](/azure/azure-monitor/essentials/data-platform-metrics). It also describes the Performance Metrics dashboard and lists metrics collected for compute, storage, and network resources in Azure Local.

When you have critical applications and business processes that rely on Azure resources, it's important to monitor those resources for their availability, performance, and operation. The integration of Azure Monitor Metrics with Azure Local enables you to store numeric data from your clusters in a dedicated time-series database. This database is automatically created for each Azure subscription. Use [metrics explorer](/azure/azure-monitor/essentials/tutorial-metrics) to analyze data from your Azure Local system and assess its health and utilization.

Take a few moments to watch the video walkthrough on creating metric charts in metrics explorer and alerts using Metrics:

> [!VIDEO https://www.youtube.com/embed/ll3GByNvcdY]

## Benefits

Here are the benefits of using Metrics for Azure Local:

- **No extra cost**. These metrics are standard, out-of-the-box features that are automatically collected and provided to you at no extra cost.

- **Near real-time insights**. You have the capability to observe out-of-the-box metrics and correlate trends using near real-time data.  

- **Customization**. You can create your own graphs and customize them through aggregation and filter functionality. The task of saving and sharing your metric charts via Excel, workbooks, or sending them to Grafana is straightforward.

- **Custom alert rules**. You can write custom alert rules on the metrics to efficiently monitor the health of your Azure Local system.

## Prerequisites

Here are the prerequisites of using Metrics for Azure Local:

- You must have access to an Azure Local system that's deployed, registered, and connected to Azure.

- The `AzureEdgeTelemetryAndDiagnostics` extension must be installed to collect telemetry and diagnostics information from your Azure Local system. For more information about the extension, see [Azure Local telemetry and diagnostics extension overview](../concepts/telemetry-and-diagnostics-overview.md).

## Monitor Azure Local through the Monitoring tab

In the Azure portal, you can monitor platform metrics of your cluster by navigating to the **Monitoring** tab on your cluster's **Overview** page. This tab offers a quick way to view graphs for different platform metrics. You can select any of the graphs to further analyze the data in metrics explorer.

Follow these steps to monitor platform metrics of your system in the Azure portal:

1. Go to your Azure Local cluster resource page and select your cluster.

1. On the **Overview** page of your cluster, select the **Monitoring** tab.

   :::image type="content" source="media/monitor-cluster-with-metrics/monitoring-tab.png" alt-text="Screenshot showing the Monitoring tab for your cluster." lightbox="media/monitor-cluster-with-metrics/monitoring-tab.png":::

1. On the **Platform metrics** pane, review the graphs displaying platform metrics. To know the metrics that Azure Monitor collects to populate these graphs, see [Metrics for the Monitoring tab graphs](#metrics-for-the-monitoring-tab-graphs).

   - At the top of the pane, select a duration to change the time range for the graphs.
   - Select the **See all metrics** link to analyze metrics using metrics explorer. See [Analyze metrics](#analyze-metrics).
   - Select any of the graphs to open them in metrics explorer to drill down further or to create an alert rule. See [Create metrics alerts](./setup-metric-alerts.md#create-metrics-alerts).

       :::image type="content" source="media/monitor-cluster-with-metrics/platform-metrics.png" alt-text="Screenshot showing the platform metrics for your cluster." lightbox="media/monitor-cluster-with-metrics/platform-metrics.png":::

## Analyze metrics

You can use [metrics explorer](/azure/azure-monitor/essentials/metrics-charts) to interactively analyze the data in your metric database and chart the values of multiple metrics over time. To open the metrics explorer in the Azure portal, select **Metrics** under the **Monitoring** section.

:::image type="content" source="media/monitor-cluster-with-metrics/monitor-metrics.png" alt-text="Screenshot showing the Select a scope pane." lightbox="media/monitor-cluster-with-metrics/monitor-metrics.png":::

You can also access **Metrics** directly from the menu for the Azure Local services.

:::image type="content" source="media/monitor-cluster-with-metrics/metrics-page.png" alt-text="Screenshot of the Metrics page." lightbox="media/monitor-cluster-with-metrics/metrics-page.png":::

With **Metrics**, you can create charts from metric values and visually correlate trends. You can also create a metric alert rule or pin a chart to an Azure dashboard to view them with other visualizations. For a tutorial on using this tool, see [Analyze metrics for an Azure resource](/azure/azure-monitor/essentials/tutorial-metrics).

Platform metrics are stored for 93 days, however, you can only query (in the **Metrics** tile) for a maximum of 30 days' worth of data on any single chart. To know more about data retention, see [Metrics in Azure Monitor](/azure/azure-monitor/essentials/data-platform-metrics#platform-and-custom-metrics).

### Analyze metrics for a specific cluster

Follow these steps to analyze metrics for a specific Azure Local cluster in the Azure portal:

1. Go to your Azure Local cluster and navigate to the **Monitoring** section.

1. To analyze metrics, select the **Metrics** option. Your cluster will already be populated in the scope section. Select the metric you want to analyze.

    :::image type="content" source="media/monitor-cluster-with-metrics/cluster-metrics.png" alt-text="Screenshot showing the metrics for your cluster." lightbox="media/monitor-cluster-with-metrics/cluster-metrics.png":::

    To create alerts, select the **Alerts** option and set up alerts as described in [Create metric alerts](./setup-metric-alerts.md#create-metrics-alerts).

## Monitor performance metrics

The performance metrics dashboard provides a comprehensive view of performance metrics across all Azure Local systems within a subscription or for a specific system. It collects over 60 metrics at no additional cost via the `AzureEdgeTelemetryAndDiagnostics` extension. These metrics form the basis of the charts displayed in the dashboard, offering insights into infrastructure performance and health.

There are two types of performance metrics dashboards:

- **Single Cluster Performance Metrics**, which offers drilled-down views for a specific system, split by unique logical unit number (LUN).

- **Multi Cluster Performance Metrics**, which monitors multiple systems at scale and provides detailed view of performance metrics across all systems within a subscription.

### Benefits

- Requires no extra setup to view your data, provided the [`AzureEdgeTelemetryAndDiagnostics`](../concepts/telemetry-and-diagnostics-overview.md) extension is installed.

- Consolidates all available metrics into a single view, eliminating the need to select individual metrics.

- Built using Azure Workbooks, highly customizable and user-friendly.

- Includes multiple filters, such as a time filter for viewing data up to the past 30 days.

- Allows viewing metrics for multiple clusters across various subscriptions, with filters for subscription, resource groups, or clusters. For a specific cluster, a drilled-down view of metrics at the node, volume, and netadapter levels is available.

### Access the performance metrics dashboard

You can access the performance metrics dashboard through Azure Monitor or the Azure Local system.

#### Access the dashboard via Azure Monitor

To access the dashboard via Azure Monitor, follow these steps:

1. Navigate to Azure Monitor and select **Workbooks**.

1. Under the **Azure Local** section, select the **Multi Cluster Performance Metrics** workbook.

    :::image type="content" source="media/monitor-cluster-with-metrics/access-via-azure-monitor.png" alt-text="Screenshot of the Workbooks gallery when accessed via Azure Monitor." lightbox="media/monitor-cluster-with-metrics/access-via-azure-monitor.png":::

#### Access the dashboard via the Azure Local system

To access the dashboard via the Azure Local system, follow these steps:

1. In the Azure portal, go to your Azure Local system.

1. Under **Monitoring**, select **Workbooks**.

1. Select one of the following workbooks based on whether you want to view performance metrics for a single cluster or multiple clusters:

    - **Single Cluster Performance Metrics**
    
    - **Multi Cluster Performance Metrics**

        :::image type="content" source="media/monitor-cluster-with-metrics/access-via-system.png" alt-text="Screenshot of the Workbooks gallery when accessed via Azure Local system." lightbox="media/monitor-cluster-with-metrics/access-via-system.png":::

### View the dashboard charts

The performance metrics dashboard is organized into three tabs, each focusing on different aspects of system performance. Select the relevant tab to view the metrics related to the selected system performance category.

### [Storage Performance](#tab/storage-performance)

Monitoring storage performance helps optimize storage utilization, allocation, and configuration according to resources and business needs.

The **Storage Performance** tab presents three types of metrics:

- **Volume Usage Metrics.** This section displays metrics related to volume usage, such as disk read/write operations per second, disk read/write bytes per second, and volume latency.

    Here's a sample screenshot of Volume Usage Metrics:

    :::image type="content" source="media/monitor-cluster-with-metrics/storage-performance-volume-usage.png" alt-text="Screenshot of the Storage Performance dashboard showing the Volume Usage metrics." lightbox="media/monitor-cluster-with-metrics/storage-performance-volume-usage.png":::

- **VHD Metrics.** This section displays metrics related to VHD, such as VHD read/write operations per second, VHD read/write bytes per second, VHD latency, and VHD current and maximum size.

    Here's a sample screenshot of VHD Metrics:

    :::image type="content" source="media/monitor-cluster-with-metrics/storage-performance-vhd.png" alt-text="Screenshot of the Storage Performance dashboard showing the VHD metrics." lightbox="media/monitor-cluster-with-metrics/storage-performance-vhd.png":::

- **Physical Disk Metrics.** This section displays metrics related to physical disk read/write operations per second, physical disk read/write bytes per second, latency read and write, total capacity size, and capacity size used.

    Here's a sample screenshot of Physical Disk Metrics:

    :::image type="content" source="media/monitor-cluster-with-metrics/storage-performance-physical-disk.png" alt-text="Screenshot of the Storage Performance dashboard showing the Physical Disk metrics." lightbox="media/monitor-cluster-with-metrics/storage-performance-physical-disk.png":::

In a **Single Cluster Performance Metrics** dashboard, you can drill down further to view metrics split by LUN, which is a unique identifier for storage resources.

### [Network Performance](#tab/network-performance)

Monitoring network performance metrics ensure network availability for users, help identify and troubleshoot problems, and improve network performance.

This section provides network performance metrics, including netadapter bytes sent/received per second, RDMA inbound/outbound bytes per second, and VM netadapter bytes sent/received per second.

Here's a sample screenshot of Network Metrics:

:::image type="content" source="media/monitor-cluster-with-metrics/network-performance-network.png" alt-text="Screenshot of the Network Performance dashboard showing the Network metrics." lightbox="media/monitor-cluster-with-metrics/network-performance-network.png":::

In a **Single Cluster Performance Metrics** dashboard, you can drill down Network metrics to see performance for each netadapter available on different servers within a cluster by its unique LUN.

### [Compute](#tab/compute)

Monitoring compute metrics, including memory and CPU, ensures proper resource allocation and utilization. It identifies usage patterns for appropriate actions, helps detect issues, optimizes system performance, and ensures smooth operation of resources.

The **Compute** tab presents two types of metrics:

- **Memory Metrics.** This section provides information on memory used, available, percentage usage for host and guest, VM memory available, used, memory assigned, pressure, maximum, minimum, startup, and more.

    Here's a sample screenshot of Memory Metrics:

    :::image type="content" source="media/monitor-cluster-with-metrics/compute-memory.png" alt-text="Screenshot of the Compute Performance dashboard showing the Memory metrics." lightbox="media/monitor-cluster-with-metrics/compute-memory.png":::

- **CPU Metrics.** This section offers metrics, such as Total CPU percentage, host vs guest CPU percentage, and VM CPU percentage.

    Here's a sample screenshot of CPU Metrics:

    :::image type="content" source="media/monitor-cluster-with-metrics/compute-cpu.png" alt-text="Screenshot of the Compute Performance dashboard showing the CPU metrics." lightbox="media/monitor-cluster-with-metrics/compute-cpu.png":::

In a **Single Cluster Performance Metrics** dashboard, you can view Memory and CPU metrics for each server within a cluster.

---

## What metrics are collected?

This section lists the platform metrics that are collected for the Azure Local cluster, the aggregation types, and the dimensions available for each metric. For more information about metric dimensions, see [Multi-dimensional metrics](/azure/azure-monitor/essentials/data-platform-metrics#multi-dimensional-metrics).

### Metrics for the Monitoring tab graphs

The following table lists the metrics that Azure Monitor collects to populate the graphs on the **Monitoring** tab:

| Metrics | Unit |
|--|--|
| Percentage CPU | Percent |
| Network In/Sec | BytesPerSecond |
| Network Out/Sec | BytesPerSecond |
| Disk Read Bytes/Sec | BytesPerSecond |
| Disk Write Bytes/Sec | BytesPerSecond |
| Disk Read Operations/Sec | CountPerSecond |
| Disk Write Operations/Sec | CountPerSecond |
| Used Memory Bytes | Bytes |

### Metrics for nodes

| Metric | Description | Unit | Default Aggregation Type | Supported Aggregation Type | Dimensions |
|--|--|--|--|--|--|
| Percentage CPU | Percentage of processor time that isn't idle. | Percent | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node |
| Percentage CPU Guest | Percentage of processor time used for guest (virtual machine) demand. | Percent | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node |
| Percentage CPU Host | Percentage of processor time used for host demand. | Percent | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node |
| Cluster node Memory Total | The total physical memory of the node. | Bytes | Sum | Minimum, Maximum, Average | Cluster, Node |
| Cluster node Memory Available | The available memory of the node. | Bytes | Maximum | Minimum, Maximum, Average | Cluster, Node |
| Cluster node Memory Used | The used memory of the node. | Bytes | Maximum | Minimum, Maximum | Cluster, Node |
| Percentage Memory | The allocated (not available) memory of the node. | Percent | Maximum | Minimum, Maximum, Sum, Count | Cluster, Node |
| Percentage Memory Guest | The memory allocated to guest (virtual machine) demand. | Percent | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN, VM |
| Percentage Memory Host | The memory allocated to host demand. | Percent | Maximum | Minimum, Maximum, Sum, Count | Cluster, Node |
| Cluster node Csv cache Read Hit | Cache hit PerSecond for read operations. | CountPerSecond | Maximum | Minimum, Maximum, Sum, Count | Cluster, Node, LUN |
| Cluster node Csv cache Read Hit rate | Cache hit rate for read operations. | Percent | Maximum | Minimum, Maximum, Sum, Count | Cluster, Node, LUN |
| Cluster node Csv cache Read Miss | Cache missPerSecond for read operations. | CountPerSecond | Maximum | Minimum, Maximum, Sum, Count | Cluster, Node, LUN |
| Cluster node Storage Degraded | Total number of failed or missing drives in the storage pool. | Bytes | Sum | Minimum, Maximum, Sum, Count | Cluster, Node |

### Metrics for drives

| Metric | Description | Unit | Default Aggregation Type | Supported Aggregation Type | Dimensions |
|--|--|--|--|--|--|
| Physicaldisk Read Operations/Sec | Number of read operations per second completed by the drive. | CountPerSecond | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Physicaldisk Write Operations/Sec | Number of write operations per second completed by the drive. | CountPerSecond | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Physicaldisk Read and Write Operations/Sec | Total number of read or write operations per second completed by the drive. | CountPerSecond | Sum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Physicaldisk Read Bytes/Sec | Quantity of data read from the drive per second. | BytesPerSecond | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Physicaldisk Write Bytes/Sec | Quantity of data written to the drive per second. | BytesPerSecond | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Physicaldisk Read and Write | Total quantity of data read from or written to the drive per second. | BytesPerSecond | Sum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Physicaldisk Latency Read | Average latency of read operations from the drive. | Seconds | Maximum | Minimum, Maximum, Average, Sum | Cluster, Node, LUN |
| Physicaldisk Latency Write | Average latency of write operations to the drive. | Seconds | Maximum | Minimum, Maximum, Average, Sum | Cluster, Node, LUN |
| Physicaldisk Latency Average | Average latency of all operations to or from the drive. | Seconds | Maximum | Minimum, Maximum, Average, Sum | Cluster, Node, LUN |
| Physicaldisk Capacity Size Total | The total storage capacity of the drive. | Bytes | Sum | Minimum, Maximum, Average | Cluster, Node, LUN |
| Physicaldisk Capacity Size Used | The used storage capacity of the drive. | Bytes | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |

### Metrics for network adapters

| Metric | Description | Unit | Default Aggregation Type | Supported Aggregation Type | Dimensions |
|--|--|--|--|--|--|
| Network In/Sec | Rate of data received by the network adapter. | Bytes Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, Network Adapter, LUN |
| Network Out/Sec | Rate of data sent by the network adapter. | Bytes Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, Network Adapter, LUN |
| Network Total/Sec | Total rate of data received or sent by the network adapter. | Bytes Per Second | Sum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, Network Adapter, LUN |
| Netadapter Bandwidth Rdma Inbound | Rate of data received over RDMA by the network adapter. | Bytes Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, Network Adapter, LUN |
| Netadapter Bandwidth Rdma Outbound | Rate of data sent over RDMA by the network adapter. | Bytes Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, Network Adapter, LUN |
| Netadapter Bandwidth Rdma Total | Total rate of data received or sent over RDMA by the network adapter. | Bytes Per Second | Sum | Minimum, Maximum, Sum, Count | Cluster, Node, Network Adapter, LUN |

### Metrics for VHDs

| Metric | Description | Unit | Default Aggregation Type | Supported Aggregation Type | Dimensions |
|--|--|--|--|--|--|
| VHD Read Operations/Sec | Number of read operations per second completed by the virtual hard disk. | Count Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, VHD |
| VHD Write Operations/Sec | Number of write operations per second completed by the virtual hard disk. | Count Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, VHD |
| VHD Read and Write Operations/Sec | Total number of read or write operations per second completed by the virtual hard disk. | Count Per Second | Sum | Minimum, Maximum, Sum, Count | Cluster, Node, VHD |
| VHD Read Bytes/Sec | Quantity of data read from the virtual hard disk per second. | Bytes Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, VHD |
| VHD Write Bytes/Sec | Quantity of data written to the virtual hard disk per second. | Bytes Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, VHD |
| VHD Read and Write Bytes/Sec | Total quantity of data read from or written to the virtual hard disk per second. | Bytes Per Second | Sum | Minimum, Maximum, Sum, Count | Cluster, Node, VHD |
| VHD Latency Average | Average latency of all operations to or from the virtual hard disk. | Seconds | Maximum | Minimum, Maximum, Average, Sum | Cluster, Node, VHD |
| VHD Size Current | The current file size of the virtual hard disk, if dynamically expanding. If fixed, the series isn't collected. | Bytes | Maximum | Minimum, Maximum, Average | Cluster, Node, Instance |
| VHD Size Maximum | The maximum size of the virtual hard disk, if dynamically expanding. | Bytes | Maximum | Minimum, Maximum, Average | Cluster, Node, VHD |

### Metrics for VMs

| Metric | Description | Unit | Default Aggregation Type | Supported Aggregation Type | Dimensions |
|--|--|--|--|--|--|
| VM Percentage CPU | Percentage the virtual machine is using of its host node's processor(s). | Percent | Maximum | Minimum, Maximum, Sum, Count | Cluster, Node, VM |
| VM Memory Assigned | The quantity of memory assigned to the virtual machine. | Bytes | Sum | Minimum, Maximum | Cluster, Node, LUN, VM |
| VM Memory Available | The quantity of memory that remains available, of the amount assigned. | Bytes | Maximum | Minimum, Maximum, Sum, Count | Cluster, Node, VM, LUN |
| VM Memory Used | VM Memory Used | Bytes | Maximum | Minimum, Maximum | Cluster, Node, VM, LUN |
| VM Memory Maximum | If using dynamic memory, this is the maximum quantity of memory that might be assigned to the virtual machine. | Bytes | Maximum | Minimum, Maximum, Average | Cluster, Node, LUN, VM |
| VM Memory Minimum | If using dynamic memory, this is the minimum quantity of memory that might be assigned to the virtual machine. | Bytes | Minimum | Minimum, Maximum, Average | Cluster, Node, LUN, VM |
| VM Memory Pressure | The ratio of memory demanded by the virtual machine over memory allocated to the virtual machine. | Bytes | Maximum | Minimum, Maximum, Average | Cluster, Node, LUN, VM |
| VM Memory Startup | The quantity of memory required for the virtual machine to start. | Bytes | Maximum | Minimum, Maximum, Average | Cluster, Node, LUN, VM |
| VM Memory Total | Total memory. | Bytes | Maximum | Minimum, Maximum, Average | Cluster, Node, VM, LUN |
| VM network adapter Network In/Sec | Rate of data received by the virtual machine across all its virtual network adapters. | Bits Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, Virtual Network Adapter |
| VM network adapter Network Out/Sec | Rate of data sent by the virtual machine across all its virtual network adapters. | Bits Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, Virtual Network Adapter |
| VM network adapter Network In and Out/Sec | Total rate of data received or sent by the virtual machine across all its virtual network adapters. | Bits Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, Virtual Network Adapter |

### Metrics for volumes

| Metric | Description | Unit | Default Aggregation Type | Supported Aggregation Type | Dimensions |
|--|--|--|--|--|--|
| Disk Read Operations/Sec | Number of read operations per second completed by this volume. | Count Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Disk Write Operations/Sec | Number of write operations per second completed by this volume. | Count Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Disk Read and Write Operations/Sec | Total number of read or write operations per second completed by this volume. | Count Per Second | Sum | Minimum, Maximum, Sum, Count | Cluster, Node, LUN |
| Disk Read Bytes/Sec | Quantity of data read from this volume per second. | Bytes Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Disk Write Bytes/Sec | Quantity of data written to this volume per second. | Bytes Per Second | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |
| Disk Read and Write | Total quantity of data read from or written to this volume per second. | Bytes Per Second | Sum | Minimum, Maximum, Sum, Count | Cluster, Node, LUN |
| Volume Latency Read | Average latency of read operations from this volume. | Seconds | Maximum | Minimum, Maximum, Average, Sum | Cluster, Node, LUN |
| Volume Latency Write | Average latency of write operations to this volume. | Seconds | Maximum | Minimum, Maximum, Average, Sum | Cluster, Node, LUN |
| Volume Latency Average | Average latency of all operations to or from this volume. | Seconds | Maximum | Minimum, Maximum, Sum | Cluster, Node, LUN |
| Volume Size Total | The total storage capacity of the volume. | Bytes | Sum | Minimum, Maximum, Average | Cluster, Node, LUN |
| Volume Size Available | The available storage capacity of the volume. | Bytes | Maximum | Minimum, Maximum, Average, Sum, Count | Cluster, Node, LUN |

To see in-depth information about how these metrics are collected, see [Performance history for Storage Spaces Direct](/windows-server/storage/storage-spaces/performance-history).

## Next steps

- [Monitor a single Azure Local system with Insights](./monitor-single-23h2.md)
- [Monitor multiple Azure Local systems with Insights](./monitor-multi-23h2.md)
