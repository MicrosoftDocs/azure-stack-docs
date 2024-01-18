---
title: About Azure Stack HCI monitoring
description: This article provides an overview of the Azure Stack HCI monitoring solution.
ms.author: alkohli
ms.topic: article
author: alkohli
ms.date: 01/18/2024
---
# About Azure Stack HCI monitoring

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the monitoring solution in Azure Stack HCI.

Regular monitoring of your Azure Stack HCI system is crucial for maintaining its health and optimal functionality. Collect monitoring data from all parts of your system to quickly identify and fix any issues that might arise.

To understand your Azure Stack HCI system's current performance patterns, identify performance anomalies, and formulate methods to address issues, set baseline performance metrics for different times and load conditions.
  
Azure Stack HCI utilizes Azure Monitor features like Insights, Metrics, Logs, Workbooks, and Alert to help you collect data, analyze and react to consistent or trending variances from your baseline.  

## High-level architechture

The following diagram shows a high-level architecture view of monitoring solution in Azure Stack HCI.

:::image type="content" source="./media/monitoring-overview/monitoring-architecture.png" alt-text="High-level architecture diagram of Azure Stack HCI monitoring." lightbox="./media/monitoring-overview/monitoring-architecture.png" :::

This is an architectural representation of Azure Stack HCI Monitoring implementation.

Here is an Azure Stack HCI cluster with 3 cluster nodes. Azure Monitor Windows Agent and Telemetry and Diagnostics Agent is installed on each cluster node which collects logs and metrics respectively from the machines. The logs or performance counters which are collected are specified in a Data collection rule. AMA agent then sends these logs to a Log analytics workspace. This workspace is like a database to store logs. HCI Insights uses Kusto query language to query the LAW which is then used in Azure workbooks to visualize the data. This is how pre-built workbook templates are provided for the collected logs and performance counters.
On the other hand, Telemetry and Diagnostics Agent collects performance counters from the host and send it to Geneva through Geneva Ingestion Service, which are then send to Shoebox where customers can use them to analyze the data using Metrics Explorer, Dashboards, Azure workbooks and Alerts.

## Monitoring capabilities in Azure Stack HCI

### Insights

Insights is a feature of Azure Monitor that quickly gets you started monitoring your Azure Stack HCI cluster using Logs. You can monitor a single cluster or multiple clusters at the same time. Azure Stack HCI Insights collects data in the form of logs using Azure Monitor Agent and stores the data in a Log analytics workspace. Once the data is stored, it is visualized using Azure workbooks. Navigate to Insights for Azure Stack HCI for more information.

With Azure Stack HCI Insights, you benefit from the default workbooks with basic metrics alongwith some additional workbooks for new features of Azure Stack HCI. To learn more about these feature workbooks and how to enable it, navigate to Monitor HCI features with Insights.

### Metrics

Azure Stack HCI enables you to store numeric data from your clusters in a dedicated time-series database. This data is collected using TelemetryAndDiagnostics Agent and then analyzed using Metrics Explorer. To learn more about Metrics navigate to Azure Stack HCI Metrics.

### Alerts

An effective monitoring solution proactively responds to critical events, without the need for an individual or team to notice the issue. The response could be a text or email to an administrator, or an automated process that attempts to correct an error condition. Azure Monitor Alerts notify you of critical conditions.

You can configure alerts in following  ways:

- Customer defined Azure Monitor Alerts using metric or log data
    
    - Log alerts: You can use log alerts to perform advanced logic operations on your data. If the data you want to monitor is available in logs, or requires advanced logic, you can use the robust features of Kusto Query Language (KQL) for data manipulation by using log alerts. For more information on creating log alerts, visit: Set up alerts for Azure Stack HCI systems.

    - Metric alert data is stored in the system already pre-computed. Metric alerts are useful when you want to be alerted about data that requires little or no manipulation. Use metric alerts if the data you want to monitor is available in metric data. For more information on creating log alerts, visit: Set up alerts for Azure Stack HCI systems

- Health alerts have no additional cost, don’t need to set up Log Analytics or manually create any alert rules, and offer near real-time monitoring. For more information, refer Use Azure Monitor alerts for Azure Stack HCI health alerts (preview).

## Next steps