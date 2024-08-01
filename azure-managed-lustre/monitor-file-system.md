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

[!INCLUDE [horz-monitor-intro](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-intro.md)]

[!INCLUDE [horz-monitor-insights](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-insights.md)]

Azure Storage insights offer a unified view of storage performance, capacity, and availability. See [Monitor storage with Azure Monitor Storage insights](../common/storage-insights-overview.md).

[!INCLUDE [horz-monitor-resource-types](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-resource-types.md)]

[!INCLUDE [horz-monitor-data-storage](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-data-storage.md)]

[!INCLUDE [horz-monitor-platform-metrics](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-platform-metrics.md)]
For a list of available metrics for Azure Managed Lustre, see [Azure Managed Lustre monitoring data reference](monitor-file-system-reference.md#metrics).

<a name="collection-and-routing"></a>
[!INCLUDE [horz-monitor-resource-logs](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-resource-logs.md)]
For the available resource log categories, their associated Log Analytics tables, and the logs schemas for Azure Managed Lustre, see [Azure Managed Lustre monitoring data reference](monitor-managed-lustre-reference.md#resource-logs).

#### Destination limitations

For general destination limitations, see [Destination limitations](/azure/azure-monitor/essentials/diagnostic-settings#destination-limitations).

[!INCLUDE [horz-monitor-activity-log](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-activity-log.md)]

<a name="analyzing-logs"></a>

[!INCLUDE [horz-monitor-analyze-data](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-analyze-data.md)]

[!INCLUDE [horz-monitor-external-tools](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-external-tools.md)]

### Analyze metrics for Azure Managed Lustre

Metrics for Azure Managed Lustre are in the following namespace:

- Microsoft.StorageCache/amlFilesystems

For a complete list of the dimensions that Azure Storage supports, see [Metrics dimensions](monitor-blob-storage-reference.md#metrics-dimensions).

### [Azure portal](#tab/azure-portal)

You can analyze metrics for Azure Storage with metrics from other Azure services by using Metrics Explorer. Open Metrics Explorer by choosing **Metrics** from the **Azure Monitor** menu. For details on using this tool, see [Analyze metrics with Azure Monitor metrics explorer](/azure/azure-monitor/essentials/analyze-metrics).

This example shows how to view **Transactions** at the account level.

![Screenshot of accessing metrics in the Azure portal](./media/monitor-blob-storage/access-metrics-portal.png)

For metrics that support dimensions, you can filter the metric with the desired dimension value. This example shows how to view **Transactions** at the account level on a specific operation by selecting values for the **API Name** dimension.

![Screenshot of accessing metrics with dimension in the Azure portal](./media/monitor-blob-storage/access-metrics-portal-with-dimension.png)

### [PowerShell](#tab/azure-powershell)

#### List the metric definition

You can list the metric definition of your storage account or the Managed Lustre service. Use the [Get-AzMetricDefinition](/powershell/module/az.monitor/get-azmetricdefinition) cmdlet.

In this example, replace the `<resource-ID>` placeholder with the resource ID of the entire storage account or the resource ID of the Managed Lustre service. You can find these resource IDs on the **Endpoints** pages of your storage account in the Azure portal.

```powershell
   $resourceId = "<resource-ID>"
   Get-AzMetricDefinition -ResourceId $resourceId
```

#### Read metric values

You can read account-level metric values of your storage account or the Managed Lustre service. Use the [Get-AzMetric](/powershell/module/Az.Monitor/Get-AzMetric) cmdlet.

```powershell
   $resourceId = "<resource-ID>"
   Get-AzMetric -ResourceId $resourceId -MetricName "UsedCapacity" -TimeGrain 01:00:00
```

#### Read metric values with dimensions

When a metric supports dimensions, you can read metric values and filter them by using dimension values. Use the [Get-AzMetric](/powershell/module/Az.Monitor/Get-AzMetric) cmdlet.

```powershell
$resourceId = "<resource-ID>"
$dimFilter = [String](New-AzMetricFilter -Dimension ApiName -Operator eq -Value "GetBlob" 3> $null)
Get-AzMetric -ResourceId $resourceId -MetricName Transactions -TimeGrain 01:00:00 -MetricFilter $dimFilter -AggregationType "Total"
```

### [Azure CLI](#tab/azure-cli)

#### List the account-level metric definition

You can list the metric definition of your storage account or the Managed Lustre service. Use the [az monitor metrics list-definitions](/cli/azure/monitor/metrics#az-monitor-metrics-list-definitions) command.

In this example, replace the `<resource-ID>` placeholder with the resource ID of the entire storage account or the resource ID of the Managed Lustre service. You can find these resource IDs on the **Endpoints** pages of your storage account in the Azure portal.

```azurecli
   az monitor metrics list-definitions --resource <resource-ID>
```

#### Read account-level metric values

You can read the metric values of your storage account or the Managed Lustre service. Use the [az monitor metrics list](/cli/azure/monitor/metrics#az-monitor-metrics-list) command.

```azurecli
   az monitor metrics list --resource <resource-ID> --metric "UsedCapacity" --interval PT1H
```

#### Read metric values with dimensions

When a metric supports dimensions, you can read metric values and filter them by using dimension values. Use the [az monitor metrics list](/cli/azure/monitor/metrics#az-monitor-metrics-list) command.

```azurecli
az monitor metrics list --resource <resource-ID> --metric "Transactions" --interval PT1H --filter "ApiName eq 'GetBlob' " --aggregation "Total" 
```

---

### Analyze logs for Azure Managed Lustre

You can access resource logs either as a blob in a storage account, as event data, or through Log Analytics queries. For information about how to find those logs, see [Azure resource logs](/azure/azure-monitor/essentials/resource-logs).

To get the list of SMB and REST operations that are logged, see [Storage logged operations and status messages](/rest/api/storageservices/storage-analytics-logged-operations-and-status-messages).

Log entries are created only if there are requests made against the service endpoint. For example, if a storage account has activity in its file endpoint but not in its table or queue endpoints, only logs that pertain to the Azure Managed Lustre service are created. Azure Storage logs contain detailed information about successful and failed requests to a storage service. This information can be used to monitor individual requests and to diagnose issues with a storage service. Requests are logged on a best-effort basis.

When you view a storage account in the Azure portal, the operations called by the portal are also logged. For this reason, you may see operations logged in a storage account even though you haven't written any data to the account.

#### Log authenticated requests

 The following types of authenticated requests are logged:

- Successful requests
- Failed requests, including time-out, throttling, network, authorization, and other errors
- Requests that use a shared access signature (SAS) or OAuth, including failed and successful requests
- Requests to analytics data (classic log data in the **$logs** container and class metric data in the **$metric** tables)

Requests made by the Managed Lustre service itself, such as log creation or deletion, aren't logged. For a full list of the logged data, see [Storage logged operations and status messages](/rest/api/storageservices/storage-analytics-logged-operations-and-status-messages) and [Storage log format](monitor-blob-storage-reference.md).

> [!NOTE]
> Azure Monitor currently filters out logs that describe activity in the "insights-logs-" container.

#### Log anonymous requests

 The following types of anonymous requests are logged:

- Successful requests
- Server errors
- Time out errors for both client and server
- Failed GET requests with the error code 304 (Not Modified)

All other failed anonymous requests aren't logged. For a full list of the logged data, see [Storage logged operations and status messages](/rest/api/storageservices/storage-analytics-logged-operations-and-status-messages) and [Storage log format](monitor-blob-storage-reference.md).

[!INCLUDE [horz-monitor-kusto-queries](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-kusto-queries.md)]

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

[!INCLUDE [horz-monitor-alerts](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-alerts.md)]

### Azure Managed Lustre alert rules
The following table lists common and recommended alert rules for Azure Managed Lustre and the proper metric to use for the alert:

| Alert type | Condition | Description |
| --- | --- | --- |

[!INCLUDE [horz-monitor-advisor-recommendations](~/azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-advisor-recommendations.md)]

## Related content

Azure Monitor content:

- [Monitor Azure resources with Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource). General details on monitoring Azure resources.
- [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics). The basics of metrics and metric dimensions.
- [Azure Monitor Logs overview](/azure/azure-monitor/logs/data-platform-logs). The basics of logs and how to collect and analyze them.
- [Analyze metrics with Azure Monitor metrics explorer](/azure/azure-monitor/essentials/analyze-metrics). A tour of Metrics Explorer.
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview). A tour of Log Analytics.
