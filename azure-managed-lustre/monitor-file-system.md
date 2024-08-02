---
title: Monitor Azure Managed Lustre
description: Start here to learn how to monitor Azure Managed Lustre.
ms.date: 08/12/2024
ms.custom: horz-monitor
ms.topic: conceptual
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-managed-lustre
---

# Monitor Azure Managed Lustre

[!INCLUDE [horz-monitor-intro](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-intro.md)]

[!INCLUDE [horz-monitor-resource-types](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-resource-types.md)]

For more information about the resource types for Azure Managed Lustre, see [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md).

[!INCLUDE [horz-monitor-data-storage](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-data-storage.md)]

[!INCLUDE [horz-monitor-platform-metrics](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-platform-metrics.md)]

For a list of available metrics for Azure Managed Lustre, see [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md#metrics).

[!INCLUDE [horz-monitor-resource-logs](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-resource-logs.md)]

For the available resource log categories, their associated Log Analytics tables, and the log schemas for Azure Managed Lustre, see [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md#resource-logs).

[!INCLUDE [horz-monitor-activity-log](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-activity-log.md)]

[!INCLUDE [horz-monitor-analyze-data](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-analyze-data.md)]

[!INCLUDE [horz-monitor-external-tools](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-external-tools.md)]

[!INCLUDE [horz-monitor-kusto-queries](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-kusto-queries.md)]

Here are some queries that you can enter in the **Log search** bar to help you monitor your Managed Lustre. These queries work with the [new language](../../azure-monitor/logs/log-query-overview.md).

- To list the 10 most common errors over the last three days.

    ```kusto
    StorageBlobLogs
    | where TimeGenerated > ago(3d) and StatusText !contains "Success"
    | summarize count() by StatusText
    | top 10 by count_ desc
    ```

- To list the top 10 operations that caused the most errors over the last three days.

    ```kusto
    StorageBlobLogs
    | where TimeGenerated > ago(3d) and StatusText !contains "Success"
    | summarize count() by OperationName
    | top 10 by count_ desc
    ```

- To list the top 10 operations with the longest end-to-end latency over the last three days.

    ```kusto
    StorageBlobLogs
    | where TimeGenerated > ago(3d)
    | top 10 by DurationMs desc
    | project TimeGenerated, OperationName, DurationMs, ServerLatencyMs, ClientLatencyMs = DurationMs - ServerLatencyMs
    ```

- To list all operations that caused server-side throttling errors over the last three days.

    ```kusto
    StorageBlobLogs
    | where TimeGenerated > ago(3d) and StatusText contains "ServerBusy"
    | project TimeGenerated, OperationName, StatusCode, StatusText
    ```

- To list all requests with anonymous access over the last three days.

    ```kusto
    StorageBlobLogs
    | where TimeGenerated > ago(3d) and AuthenticationType == "Anonymous"
    | project TimeGenerated, OperationName, AuthenticationType, Uri
    ```

- To create a pie chart of operations used over the last three days.

    ```kusto
    StorageBlobLogs
    | where TimeGenerated > ago(3d)
    | summarize count() by OperationName
    | sort by count_ desc
    | render piechart
    ```

[!INCLUDE [horz-monitor-alerts](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-alerts.md)]

### Azure Managed Lustre alert rules

The following table lists some suggested alert rules for Azure Managed Lustre. These alerts are just examples. You can set alerts for any metric, log entry, or activity log entry listed in the [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md).

| Alert type | Condition | Description  |
| --- | --- | --- |
| | | |
| | | |

[!INCLUDE [horz-monitor-advisor-recommendations](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-advisor-recommendations.md)]

## Related content

- See [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md) for a reference of the metrics, logs, and other important values created for Azure Managed Lustre.
- See [Monitoring Azure resources with Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource) for general details on monitoring Azure resources.
