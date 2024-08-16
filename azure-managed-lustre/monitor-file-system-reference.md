---
title: Monitoring data reference for Azure Managed Lustre
description: This article contains important reference material you need when you monitor Azure Managed Lustre.
ms.date: 08/16/2024
ms.custom: horz-monitor
ms.topic: reference
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-managed-lustre
---

# Azure Managed Lustre monitoring data reference

[!INCLUDE [horz-monitor-ref-intro](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-intro.md)]

See [Monitor Azure Managed Lustre](monitor-file-system.md) for details on the data you can collect for Azure Managed Lustre and how to use it.

[!INCLUDE [horz-monitor-ref-metrics-intro](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-intro.md)]

### Supported metrics for Microsoft.StorageCache/amlFilesystems

The following table lists the metrics available for the Microsoft.StorageCache/amlFilesystems resource type.

[!INCLUDE [horz-monitor-ref-metrics-tableheader](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-tableheader.md)]

[!INCLUDE [Microsoft.StorageCache/amlFilesystems](~/../azure-reference-other-repo/azure-monitor-ref/supported-metrics/includes/microsoft-storagecache-amlfilesystems-metrics-include.md)]

> [!NOTE]
> The metric `OSTBytesUsed` represents the total capacity consumed on the file system, including all metadata and overhead associated with the files. The value for `OSTBytesUsed` might be greater than the result of running `lfs df` on the file system, as `df` output for **Used** only attempts to capture the data that the end user has placed on the file system.

[!INCLUDE [horz-monitor-ref-metrics-dimensions-intro](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-dimensions-intro.md)]

[!INCLUDE [horz-monitor-ref-metrics-dimensions](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-dimensions.md)]

### Dimensions specific to Azure Managed Lustre

| Dimension name | Description |
| --- | --- |
| `ostnum` | Object Storage Target (OST) index number |
| `mdtnum` | Metadata Target (MDT) index number |
| `operation` | Type of operation performed |

### Supported resource logs for Microsoft.StorageCache/amlFilesystems

[!INCLUDE [Microsoft.StorageCache/amlFilesystems](~/../azure-reference-other-repo/azure-monitor-ref/supported-logs/includes/microsoft-storagecache-amlfilesystems-logs-include.md)]

### Azure Monitor Logs tables

This section lists the Azure Monitor Logs tables relevant to this service, which are available for query by Log Analytics using Kusto queries.

- [AFSAuditLogs](/azure/azure-monitor/reference/tables/AFSAuditLogs)
- [AzureActivity](/azure/azure-monitor/reference/tables/azureactivity)
- [AzureMetrics](/azure/azure-monitor/reference/tables/azuremetrics)

[!INCLUDE [horz-monitor-ref-activity-log](~/../azure-stack/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-activity-log.md)]

- [Microsoft.StorageCache permissions](/azure/role-based-access-control/permissions/storage#microsoftstoragecache)

## Related content

- See [Monitor Azure Managed Lustre](monitor-file-system.md) for a description of monitoring Azure Managed Lustre.
- See [Monitor Azure resources with Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource) for details on monitoring Azure resources.
