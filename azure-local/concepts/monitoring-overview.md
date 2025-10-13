---
title: Overview of Azure Local monitoring
description: This article provides an overview of the Azure Local monitoring solution.
ms.author: alkohli
ms.topic: concept-article
author: alkohli
ms.date: 10/10/2025
---

# What is Azure Local monitoring?

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article provides an overview of Azure Local monitoring.

Monitoring Azure Local involves the regular collection and analysis of data from all components of your system to promptly identify and address any potential issues. Routine monitoring is crucial for maintaining the health and functionality of your Azure Local system.

To understand the current performance patterns, identify performance anomalies, and develop methods to address issues, it's important to set baseline performance metrics for your system under different times and load conditions.
  
Azure Local utilizes Azure Monitor tools, such as Insights, Metrics, Logs, Workbooks, and Alerts. These tools help collect data, analyze, and proactively respond to consistent or trending variances from your established baseline.  

## Monitoring capabilities in Azure Local

Azure Local provides monitoring capabilities fully integrated with Azure Monitor. These capabilities provide insights, helps visualize and analyze data, and empower you to respond to incoming monitoring data. The following sections provide an overview of what capabilities are available and the benefits they provide.

### Insights

Azure Local Insights collects key performance and health logs and visualizes this collected data in predefined dashboards. These dashboards provide you with a comprehensive visual representation of the overall health of your Azure Local system, including nodes, virtual machines (VMs), and storage. It gives performance and usage visibility into the Azure Local system through CPU and memory usage, network usage, and storage performance like IOPS, throughput, and latency. With Insights for Azure Local, you also get access to specialized workbooks created for monitoring key features of Azure Local, such as Resilient File System (ReFS) deduplication and compression and hardware monitoring for Dell. You can also customize existing workbooks to create new workbooks. To learn more about these feature workbooks, see [Monitor Azure Local features with Insights](../manage/monitor-features.md).

You can use Insights to monitor either a single Azure Local system or multiple systems simultaneously. Insights collects data using Azure Monitor Agent and then stores the data in a Log Analytics workspace. It uses the Kusto Query Language (KQL) to query the Log Analytics workspace, and the results are visualized using Azure Workbooks. To learn about using Insights to monitor one or more Azure Local systems, see [Monitor a single Azure Local system with Insights](../manage/monitor-single-23h2.md) or [Monitor multiple Azure Local systems with Insights](../manage/monitor-multi-23h2.md).

### Metrics

Azure Local Metrics collects over 60 key metrics for monitoring your infrastructure, available out-of-the-box and at no extra cost. These metrics include CPU and memory usage, storage performance metrics, such as IOPS, latency and throughput, network throughput, and VM performance metrics. You can view these metrics in Azure Monitor through predefined charts. You can also create custom charts to visualize these metrics based on your preferences.

Metrics enables you to store numeric data from your clusters in a dedicated time-series database. This data is collected using Telemetry and Diagnostics Arc extension and then analyzed using Metrics Explorer. To learn more about Metrics, see [Monitor Azure Local with Azure Monitor Metrics](../manage/monitor-cluster-with-metrics.md).

### Alerts

Azure Local provides alerting capabilities through Azure Monitor Alerts. Alerts proactively notify you when important conditions are found in your monitoring data. Alerts can be raised based on predefined health faults from the OS health service, or you can create custom alerts based on metrics or logs you collect. To simplify custom alert creation, a set of recommended alerts is available that you can use as templates.

Alerts allow you to identify and address issues before the users of your system notice them. The response could be a text or email to an administrator, or an automated process that attempts to correct an error condition.

For more information on alerting, see [What are Azure Monitor alerts?](/azure/azure-monitor/alerts/alerts-overview)

#### Types of alerts

The following table provides a brief description and setup instructions for each alert type in Azure Local:

| Alert type | Description | How to configure |
| --- | --- | --- |
| Health alerts | The OS health service monitors for more than 80 health issues, including storage volume capacity, storage QoS, physical disk and network adapter hardware issues, server CPU and memory usage, and cluster configuration. <br>These alerts are system-generated and have no extra cost. You don’t need to set up Log Analytics or manually create any alert rules. | See [Configure health alerts for Azure Local](../manage/health-alerts-via-azure-monitor-alerts.md#configure-health-alerts-for-azure-local). |
| Log based alerts | These alerts are customer-defined and are used to perform advanced logic operations on your log data. These alerts allow you to use Log Analytics query to evaluate resource logs at a predefined frequency. <br> Predefined templates are available to get you started with Log alerts.| See [Set up log alerts for Azure Local](../manage/setup-system-alerts.md).  |
| Metric based alerts | These alerts are customer-defined and are used to evaluate metrics of your Azure Local system at regular intervals. Metric alerts are useful when you want to be alerted about data that requires little or no manipulation. | See [Set up metric alerts for Azure Local](../manage/setup-metric-alerts.md). |
| Recommended alerts | These are predefined metric-based alerts for your Azure Local system resource. These alerts provide you with initial monitoring for a common set of metrics including CPU percentage and available memory. | See [Enable recommended alert rules for Azure Local](../manage/set-up-recommended-alert-rules.md). |

## High-level architecture

Broadly, the architecture of Azure Local monitoring comprises the following key components:

- Deploying extensions to collect log, metrics, telemetry, and alerts.
- Using Azure Monitor tools, such as Insights, Metrics, Logs, Workbooks, and Alerts to analyze, visualize, and respond to the data effectively.

The following diagram is an architectural representation of Azure Local monitoring implementation.

:::image type="content" source="./media/monitoring-overview/monitoring-architecture.png" alt-text="High-level architecture diagram of Azure Local monitoring. This diagram shows an Azure Local system with three nodes. Each node is installed with extensions for monitoring." lightbox="./media/monitoring-overview/monitoring-architecture.png" :::

## Next steps

- [Monitor a single Azure Local system with Insights](../manage/monitor-single-23h2.md)
- [Monitor multiple Azure Local systems with Insights](../manage/monitor-multi-23h2.md)
- [Monitor Azure Local with Azure Monitor Metrics](../manage/monitor-cluster-with-metrics.md)
