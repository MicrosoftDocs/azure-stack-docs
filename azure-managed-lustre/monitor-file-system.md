---
title: Monitor Azure Managed Lustre
description: Start here to learn how to monitor Azure Managed Lustre.
ms.date: 08/16/2024
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

For the available resource log categories, their associated Log Analytics tables, and the log schemas for Azure Managed Lustre, see [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md#supported-resource-logs-for-microsoftstoragecacheamlfilesystems).

[!INCLUDE [horz-monitor-activity-log](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-activity-log.md)]

[!INCLUDE [horz-monitor-analyze-data](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-analyze-data.md)]

[!INCLUDE [horz-monitor-external-tools](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-external-tools.md)]

[!INCLUDE [horz-monitor-kusto-queries](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-kusto-queries.md)]

This section shows queries that you can enter in the **Log search** bar to help you monitor your Managed Lustre file system.

- **Aggregate operations query**: List all the UnsuspendAmlFilesystem requests for a given time duration.

    ```kusto
    AFSAuditLogs
    // The OperationName below can be replaced by obtain other operations such as "RebootAmlFilesystemNode" or "AmlFSRefreshHSMToken".
    | where OperationName has "UnsuspendAmlFilesystem"
    | project TimeGenerated, _ResourceId, ActivityId, ResultSignature, ResultDescription, Location
    | sort by TimeGenerated asc
    | limit 100
    ```

- **Unauthorized requests query**: Count of failed AMLFilesystems requests due to unauthorized access.

    ```kusto
    AFSAuditLogs
    // 401 below could be replaced by other result signatures to obtain different operation results.
    // For example, 'ResultSignature == 202' to obtain accepted requests.
    | where ResultSignature == 401
    | summarize count() by _ResourceId, OperationName
    ```

[!INCLUDE [horz-monitor-alerts](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-alerts.md)]

### Azure Managed Lustre alert rules

The following table lists some suggested alert rules for Azure Managed Lustre. The alerts in this table are just examples. You can set alerts for any metric, log entry, or activity log entry listed in the [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md).

| Alert type | Condition | Description  |
| --- | --- | --- |
| Metric | (**OST Bytes Used** / **OST Bytes Total**) > 0.85 | Storage capacity usage for the file system has exceeded 85% of total|
| Metric | (**OST Files Used** / **OST Files Total**) > 0.85 | Number of files in the file system has exceeded 85% of total |

> [!NOTE]
> The threshold value of 85% is used as an example to show an alert before the file system reaches full capacity. You can adjust the threshold based on your requirements.

[!INCLUDE [horz-monitor-advisor-recommendations](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-advisor-recommendations.md)]

## Related content

- See [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md) for a reference of the metrics, logs, and other important values created for Azure Managed Lustre.
- See [Monitoring Azure resources with Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource) for general details on monitoring Azure resources.
