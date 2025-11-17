---
title: Monitor Multi-rack Deployments of Azure Local with Azure Monitor Metrics (Preview)
description: Learn how to monitor multi-rack deployments of Azure Local with Azure Monitor Metrics. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/14/2025
---

# Monitor multi-rack deployments of Azure Local with Azure Monitor Metrics (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to monitor your multi-rack deployments of Azure Local with [Azure Monitor Metrics](/azure/azure-monitor/essentials/data-platform-metrics). It also describes the Performance Metrics dashboard and lists metrics collected for compute, storage, and network resources in multi-rack deployments of Azure Local.

When you have critical applications and business processes that rely on Azure resources, it's important to monitor those resources for their availability, performance, and operation. The integration of Azure Monitor Metrics with Azure Local enables you to store numeric data from your clusters in a dedicated time-series database. This database is automatically created for each Azure subscription. Use [metrics explorer](/azure/azure-monitor/essentials/tutorial-metrics) to analyze data from your system and assess its health and utilization.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Benefits

- **No extra cost**. These metrics are standard, out-of-the-box features that are automatically collected and provided to you at no extra cost.

- **Near real-time insights**. You have the capability to observe out-of-the-box metrics and correlate trends using near real-time data.  

- **Customization**. You can create your own graphs and customize them through aggregation and filter functionality. The task of saving and sharing your metric charts via Excel, workbooks, or sending them to Grafana is straightforward.

- **Custom alert rules**. You can write custom alert rules on the metrics to efficiently monitor the health of your system.

## Prerequisites

- You must have access to a multi-rack Azure Local system that's deployed, registered, and connected to Azure.

## Monitor Azure Local through the Monitoring tab

<!--Commenting out all screenshots as they need replacement.-->

In the Azure portal, you can monitor platform health and utilization of your cluster by navigating to the **Monitoring** tab on your cluster's **Overview** page. This tab offers a quick way to view graphs for different platform metrics. You can select any of the graphs to further analyze the data in metrics explorer.

Follow these steps to monitor metrics of your system in the Azure portal:

1. Go to your Azure Local cluster resource page and select your multi-rack cluster.

1. On the **Overview** page of your cluster, select the **Monitoring** tab.

    :::image type="content" source="media/multi-rack-monitor-cluster-with-metrics/monitoring-tab.png" alt-text="Screenshot showing the Monitoring tab for your cluster." lightbox="media/multi-rack-monitor-cluster-with-metrics/monitoring-tab.png":::

1. Review the graphs displaying current utilization of the cluster under **Performance and Utilization pane**.

## Analyze metrics

You can use [metrics explorer](/azure/azure-monitor/essentials/metrics-charts) to interactively analyze the data in your metric database and chart the values of multiple metrics over time. To open the metrics explorer in the Azure portal, select **Metrics** under the **Monitoring** section.

:::image type="content" source="media/multi-rack-monitor-cluster-with-metrics/monitor-metrics.png" alt-text="Screenshot showing the Select a scope pane." lightbox="media/multi-rack-monitor-cluster-with-metrics/monitor-metrics.png":::


With **Metrics**, you can create charts from metric values and visually correlate trends. You can also create a metric alert rule or pin a chart to an Azure dashboard to view them with other visualizations. For a tutorial on using this tool, see [Analyze metrics for an Azure resource](/azure/azure-monitor/essentials/tutorial-metrics).

Platform metrics are stored for 93 days, however, you can only query (in the **Metrics** tile) for a maximum of 30 days' worth of data on any single chart. To know more about data retention, see [Metrics in Azure Monitor](/azure/azure-monitor/essentials/data-platform-metrics#platform-and-custom-metrics).

### Analyze metrics for a specific cluster

Follow these steps to analyze metrics for a specific cluster in the Azure portal:

1. Go to your Azure Local multi-rack cluster and navigate to the **Monitoring** section.

1. To analyze metrics, select the **Metrics** option. Your cluster will already be populated in the scope section. Select the metric you want to analyze.

    <!--:::image type="content" source="media/multi-rack-monitor-cluster-with-metrics/cluster-metrics.png" alt-text="Screenshot showing the metrics for your cluster." lightbox="media/multi-rack-monitor-cluster-with-metrics/cluster-metrics.png":::-->

    To create alerts, select the **Alerts** option.