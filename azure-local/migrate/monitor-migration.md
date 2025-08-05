---
title: Monitor Azure Local migrations using diagnostic settings in Azure Migrate
description: Learn how to monitor Azure Local migrations using diagnostic settings in Azure Migrate.
author: alkohli
ms.topic: how-to
ms.date: 08/05/2025
ms.author: alkohli
---

# Monitor Azure Local migrations using diagnostic settings in Azure Migrate

This article describes how to enable diagnostic settings in Azure Migrate via the Azure portal to help monitor Azure Local migrations. Diagnostic logs provide detailed and frequent data about resource operations, helping in monitoring, troubleshooting, and auditing. For more information, see [Diagnostic settings in Azure Monitor](/azure/azure-monitor/platform/diagnostic-settings).

To enable diagnostic settings in Azure Migrate via PowerShell or the Azure CLI, see [Collect and consume log data from your Azure resources](/azure/azure-monitor/essentials/platform-logs-overview).

## Prerequisites

To enable diagnostic settings to monitor Azure Local migrations using Azure Migrate, ensure the following prerequisites are met:

- You have an Azure subscription with an Azure Migrate project.
- You have a Data Replication Vault resource that exists in the same resource group as your Azure Migrate project. This resource is automatically created after you register the source appliance VM with the intent to migrate to Azure Local.
- You have selected a destination for your diagnostic log data. For supported destinations, see [diagnostic settings destinations](/azure/azure-monitor/platform/diagnostic-settings#destinations).

## Before you begin

- Azure Migrate supports only logs in Azure Monitor diagnostic settings. Metrics aren't currently supported.

- This article uses Log Analytics workspace and Azure Storage account as destination examples. You can create these resources in the same resource group as your Migrate project.

   - **Log Analytics workspace**: Enables querying and analyzing logs. For more information, see [Log Analytics workspace](/azure/azure-monitor/platform/resource-logs?tabs=log-analytics#send-to-log-analytics-workspace).
   - **Azure Storage account**: Stores logs for audit, backup, or static analysis. The storage account can be in a different subscription if the user has the required permissions. For more information, see [Azure Storage account](/azure/azure-monitor/platform/resource-logs?tabs=storage#send-to-log-analytics-workspace).

## Enable diagnostic log collection  

Follow these steps to enable diagnostic logging in the Azure portal.

1. In the Azure portal, go to the resource group where your Azure Migrate project was created. Select the **Data Replication Vault** resource.
1. Under **Monitoring**, select **Diagnostics settings**. This page contains all previously created diagnostic settings for this resource.
1. To use a previously created resource, select it. Otherwise, select **+ Add diagnostic setting**.

   :::image type="content" source="media/monitor-migration/add-diagnostic-setting.png" alt-text="Screenshot of the Diagnostics settings page showing the Add diagnostic setting button." border="false" lightbox="media/monitor-migration/add-diagnostic-setting.png":::

1. Enter a name for the setting.
1. From **Destination details**, select **Send to log Analytics** or **Archive to a storage account**.
1. When prompted to configure, select the storage account where you want to store the diagnostic logs.
1. Under **Category groups**, select **allLogs** to enable logging for all log categories, or select individual category under **Categories**. To learn more about individual log category supported by Azure Migrate service, see [Supported logs for Microsoft.DataReplication/replicationVaults](/azure/azure-monitor/reference/supported-logs/microsoft-datareplication-replicationvaults-logs).
1. Select **Save**.

      :::image type="content" source="media/monitor-migration/diagnostic-setting.png" alt-text="Screenshot of the Diagnostics settings page." border="false" lightbox="media/monitor-migration/diagnostic-setting.png":::

   You can now proceed with appliance registration, discovery, and replication.

## View logs in Log Analytics workspace

Follow these steps to explore log analytics data for your resource:

1. In the Azure portal, search for and select **Log Analytics workspaces** from the top search bar.
1. In the **Log Analytics workspaces** view, search by resource name and select the one you created when enabling diagnostics setting.
1. Locate and select **Logs**. From this page, you can run queries against your logs.

      :::image type="content" source="media/monitor-migration/logs.png" alt-text="Screenshot of the Logs page where you can run queries against your logs." border="false" lightbox="media/monitor-migration/logs.png":::

### Sample queries

Run the following Kusto query to view the protected items diagnostic logs from Azure Migrate from the last 30 days:

```kusto
ASRv2ProtectedItems
| where TimeGenerated > ago(30d)
```

## View logs in Azure Storage accounts

Azure Storage accounts provide an object storage solution that is optimized for storing large amounts of unstructured data.

Follow these steps to locate and download the Azure Migrate service resource logs stored in Azure Storage account:

1. In the Azure portal, go to the Storage account you selected when enabling diagnostic settings.
1. In the left-hand menu, under **Data storage**, select **Containers**. <!--can we add a screenshot here?-->
1. After replication or migration starts, look for logs with the prefix `insights-logs-<category>`, such as `insights-logs-protecteditems`. Logs might take up to 30 minutes to appear after they are emitted from service to reach the selected Storage account.
1. To download the logs, open the container and navigate through the folder structure to locate the .json log files.

To learn more about what you can do with diagnostic data in Azure Storage, see [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction).

## Next steps

- Read [Understand log searches in Azure Monitor logs](/azure/azure-monitor/logs/log-query-overview).