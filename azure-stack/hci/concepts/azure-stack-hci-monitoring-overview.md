---
title: Overview of Azure Stack HCI monitoring
description: This article provides an overview of the Azure Stack HCI monitoring solution.
ms.author: alkohli
ms.topic: article
author: alkohli
ms.date: 01/24/2024
---

# What is Azure Stack HCI monitoring?

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article provides an overview of Azure Stack HCI monitoring.

Monitoring Azure Stack HCI involves the regular collection and analysis of data from all components of your system to promptly identify and address any potential issues. Routine monitoring is crucial for maintaining the health and functionality of your Azure Stack HCI system.

To understand the current performance patterns, identify performance anomalies, and develop methods to address issues, it's important to set baseline performance metrics for your system under different times and load conditions.
  
Azure Stack HCI utilizes [Azure Monitor](/azure/azure-monitor/overview) tools, such as Insights, Metrics, Logs, Workbooks, and Alerts. These tools help collect data, analyze, and proactively respond to consistent or trending variances from your established baseline.  

## High-level architecture

Broadly, the architecture of Azure Stack HCI monitoring comprises the following key components:

- Deploying Azure Monitor Agent and Telemetry and Diagnostics extensions on every node within the cluster. These extensions are responsible for collecting log and metric data from each node, respectively.
- Storing log data in the Log Analytics workspace based on the instructions specified in Data Collection Rules, while storing metrics data in a dedicated time-series database.
- Using Azure Monitor tools, such as Insights, Metrics, Logs, Workbooks, and Alerts to analyze, visualize, and respond to the data effectively.

The following diagram is an architectural representation of Azure Stack HCI monitoring implementation.

:::image type="content" source="./media/monitoring-overview/monitoring-architecture.png" alt-text="High-level architecture diagram of Azure Stack HCI monitoring." lightbox="./media/monitoring-overview/monitoring-architecture.png" :::

This diagram shows an Azure Stack HCI cluster with three cluster nodes. Each cluster node is installed with Azure Monitor Windows Agent and Telemetry and Diagnostics extensions.

The Azure Monitor Windows Agent extension collects logs and performance counters and sends them to a Log Analytics workspace based on the instructions defined in Data Collection Rules. Insights for Azure Stack HCI uses the Kusto Query Language (KQL) to query the Log Analytics workspace, and the results are visualized in Azure Workbooks.

On the other hand, the Telemetry and Diagnostics extension collects telemetry and diagnostics data from each node and sends it to Azure Monitor via Azure Stack HCI services. You can then analyze this data in Azure Monitor using different monitoring tools, including Metrics Explorer, Dashboards, Workbooks, and Alerts.

## Monitoring capabilities in Azure Stack HCI

This section describes the monitoring capabilities in Azure Stack HCI.

### Insights

Insights is a feature of Azure Monitor that quickly gets you started monitoring your Azure Stack HCI cluster using logs. You can use Insights to monitor a single cluster or multiple clusters simultaneously. Insights for Azure Stack HCI collects data in the form of logs using Azure Monitor Agent and then stores the data in a Log Analytics workspace. This data is then visualized using Azure workbooks. For more information, see [Monitor multiple Azure Stack HCI clusters with Insights](../manage/monitor-hci-multi.md) and [Monitor a single Azure Stack HCI cluster with Insights](../manage/monitor-hci-single.md).

With Insights for Azure Stack HCI, you get access to default workbooks with basic metrics, along with specialized workbooks created for monitoring key features of Azure Stack HCI. To learn more about these feature workbooks, see [Monitor HCI features with Insights](../manage/monitor-features.md).

### Metrics

Azure Stack HCI enables you to store numeric data from your clusters in a dedicated time-series database. This data is collected using Telemetry and Diagnostics Arc extension and then analyzed using Metrics Explorer. To learn more about Metrics, see [Monitor Azure Stack HCI with Azure Monitor Metrics](../manage/monitor-cluster-with-metrics.md).

### Alerts

An effective monitoring solution proactively responds to critical events, without the need for an individual or team to notice the issue. The response could be a text or email to an administrator, or an automated process that attempts to correct an error condition. Azure Monitor Alerts notify you of critical conditions.

#### Types of alerts

The following table provides a brief description and setup instructions for each alert type:

| Alert type | Description | How to configure |
| --- | --- | --- |
| Health alerts | These are system-generated alerts and have no additional cost. You don’t need to set up Log Analytics or manually create any alert rules. | See [Configure health alerts for Azure Stack HCI](../manage/health-alerts-via-azure-monitor-alerts.md#configure-health-alerts-for-azure-stack-hci). |
| Log based alerts | These are customer-defined alerts that are used to perform advanced logic operations on your log data. These alerts allow you to use Log Analytics query to evaluate resource logs at a predefined frequency. | See [Set up log alerts for Azure Stack HCI](../manage/setup-hci-system-alerts.md).  |
| Metric based alerts | These are customer-defined alerts that are used to evaluate metrics of your Azure Stack HCI system at regular intervals. Metric alerts are useful when you want to be alerted about data that requires little or no manipulation. | See [Set up metric alerts for Azure Stack HCI](../manage/setup-metric-alerts.md). |