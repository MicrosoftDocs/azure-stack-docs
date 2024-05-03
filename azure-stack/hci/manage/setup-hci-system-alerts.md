---
title: Set up log alerts for Azure Stack HCI
description: How to set up log alerts for various Azure Stack HCI system resources using Insights for Azure Stack HCI and sample log queries.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.reviewer: kimlam
ms.date: 04/22/2024
---

# Set up log alerts for Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to set up log alerts for Azure Stack HCI systems: using Insights for Azure Stack HCI and using pre-existing sample log queries, such as average server CPU, available memory, available volume capacity, and more.

For information about how to set up metric alerts, see [Set up metric alerts for Azure Stack HCI](./setup-metric-alerts.md).

Take a few moments to watch the video walkthrough on collecting new logs, customizing the Insights workbooks, and creating alerts using logs:

> [!VIDEO https://www.youtube.com/embed/IBNQE7iNtSs]

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- You have access to an Azure Stack HCI cluster that is deployed and registered.
- You must have [Insights enabled on the cluster](./monitor-hci-single-23h2.md#enable-insights). Enabling Insights configures the cluster to collect required logs in a Log Analytics workspace.

## Set up log alerts using Insights

> [!IMPORTANT]
> Using Insights isn't recommended for high severity alerts. It could take 15 minutes to collect logs.

Follow these steps to set up log alerts using Insights. Ensure that you have reviewed and completed the [prerequisites](#prerequisites).

1. From the Azure portal, navigate to or search for **Monitor** and select **Azure Stack HCI**.

1. Select one of the tabs to view the health of your resources. For example, select **Servers** to view the health of servers in your cluster.

1. Customize the workbook and edit it until you see a blue **Logs view** icon. Select the icon to view and edit your query.

    :::image type="content" source="media/setup-hci-system-alerts/health-faults.png" alt-text="Screenshot of the monitored resources and the resources health." lightbox="media/setup-hci-system-alerts/health-faults.png":::

1. After the query loads, select **+ New alert rule**.

    :::image type="content" source="media/setup-hci-system-alerts/new-alert-rule.png" alt-text="Screenshot of the cluster New alert rule and how to create a new alert." lightbox="media/setup-hci-system-alerts/new-alert-rule.png":::

1. From the alerts interface you can set up your alert conditions, actions, and more. For more information, see [Log query results](setup-hci-system-alerts.md#log-query-results) and [Alert actions and details](setup-hci-system-alerts.md#alert-actions-and-details).

    :::image type="content" source="media/setup-hci-system-alerts/create-alert-rule.png" alt-text="Screenshot of items to define when a new alert is being created." lightbox="media/setup-hci-system-alerts/create-alert-rule.png":::

## Set up alerts using sample log queries

You can start monitoring your Azure Stack HCI system and setting up alerts for it by using pre-existing log queries available in the [Azure portal](https://portal.azure.com). These queries can help you check and monitor the health of your system.

Follow these steps to set up log alerts using sample log queries. Ensure that you have reviewed and completed the [prerequisites](#prerequisites).

1. In the Azure portal, browse to your Azure Stack HCI cluster resource page, then select the cluster you want to monitor using sample log queries.

1. On your cluster **Overview** page, select **JSON View**.

    :::image type="content" source="media/setup-hci-system-alerts/json-view.png" alt-text="Screenshot of the JSON View link to find ClusteArmId." lightbox="media/setup-hci-system-alerts/json-view.png":::

1. Copy the ClusterArmId detail from the **Resource ID** box.

    :::image type="content" source="media/setup-hci-system-alerts/resource-id.png" alt-text="Screenshot of the Resource JSON page to copy ClusteArmId information." lightbox="media/setup-hci-system-alerts/resource-id.png":::

1. From the Azure portal, navigate to or search for **Monitor** and select **Logs**.

1. Select **+ Add filter** to add a filter for **Resource type**.

1. Choose **Azure Stack HCI** for a populated list of Azure Stack HCI system sample logs.

    :::image type="content" source="media/setup-hci-system-alerts/azure-monitor-logs.png" alt-text="Screenshot of the Azure Monitor Logs space and how to access the sample queries." lightbox="media/setup-hci-system-alerts/azure-monitor-logs.png":::

1. Select **Load to Editor** to open the query workspace.

1. Set the **scope** to **Log analytics workspace** for logs linked to the cluster resource.

1. Paste your **ClusterArmId** detail in the **`where ClusterArmId =~`** section of the query to see results related to your cluster.

    :::image type="content" source="media/setup-hci-system-alerts/cluster-arm-id.png" alt-text="Screenshot of the log analytics workspace and Cluster Arm ID query." lightbox="media/setup-hci-system-alerts/cluster-arm-id.png":::

1. Select **Run**.

After the information appears, you can examine the logs and create alerts based on the results. For more information, see [Log query results](setup-hci-system-alerts.md#log-query-results) and [Alert actions and details](setup-hci-system-alerts.md#alert-actions-and-details).

### Set up alerts for multiple clusters

To set a new or change an existing query to accommodate multiple clusters ClusterArmId's, add the `| where ClusterArmId in~` clause to your query. Include the ClusterArmId's for each of the clusters you want to use in your query. For example, `| where ClusterArmId in~ ('ClusterArmId1', 'ClusterArmId2', 'ClusterArmId3')`

:::image type="content" source="media/setup-hci-system-alerts/multiple-clusters.png" alt-text="Screenshot of a query to show logs for multiple clusters." lightbox="media/setup-hci-system-alerts/multiple-clusters.png":::

## Log query results

After adding logs, you should confirm that you get the expected results by running your query against the workspace that stores your cluster logs. If you don't get the expected results, correct your log query and rerun it.

When creating a new alert rule, you must set conditional details to summarize your query results. These details are based on three categories: measurement, split by dimensions, and alert logic. In your alert details, fill in the following components:

- **Measure**: The value used to set up alerts. By default, it takes only numerical values. Convert your values to integer and select the correct one from the dropdown list.
- **Aggregation type**: Ensures you receive an alert, even if only one cluster memory value meets what you have specified. For alerts on multiple clusters, you need to put the aggregation type as a maximum and not an average or total.
- **Resource ID column**: Splits the alert measure value based on other values. To get alerts on a cluster, use the `clusterarmID` or to set up alerts for the server, use `_resourceID`. Check your value names in your log query for accuracy.
- **Dimension name**: Splits an alert measure further. For example, to get alerts per server, select the `Nodename`.
  - When you set up alerts, you might not see all the values in the dropdown menu. Select the checkbox for **Include all future values** to ensure you set up the same alert on multiple servers in the cluster.
- **Threshold value**: Provides a notification based on the value you've set.

In this example, when the measure value Memoryusageint with an aggregation type of maximum reaches the threshold of 15 minutes, you get an alert.

:::image type="content" source="media/setup-hci-system-alerts/measure-detail.png" alt-text="Screenshot of the log query detail to specify." lightbox="media/setup-hci-system-alerts/measure-detail.png":::

Once your details are set, you can review your conditions for alert accuracy.

:::image type="content" source="media/setup-hci-system-alerts/alert-preview.png" alt-text="Screenshot of the alert conditions to set." lightbox="media/setup-hci-system-alerts/alert-preview.png":::

## Alert actions and details

To determine how you receive notifications for your cluster alerts, use the **Actions** tab as shown in the image. You can create new action groups or set an alert rule for existing ones. You can choose to receive notifications through email, Event Hubs, and more.

:::image type="content" source="media/setup-hci-system-alerts/action-groups.png" alt-text="Screenshot of the action groups action options." lightbox="media/setup-hci-system-alerts/action-groups.png":::

Once you have set your actions, the **Details** tab allows you to set the alert severity, name, description, and region. Select **Review + Create** for a final review of all your alert settings and to create your alert.

:::image type="content" source="media/setup-hci-system-alerts/alert-details.png" alt-text="Screenshot of the action details for alerts." lightbox="media/setup-hci-system-alerts/alert-details.png":::

After your alerts are set up, you can monitor your alert rules, action groups, and more in the **Alerts** tab.

:::image type="content" source="media/setup-hci-system-alerts/alert-rules-monitoring.png" alt-text="Screenshot of the monitoring alerts." lightbox="media/setup-hci-system-alerts/alert-rules-monitoring.png":::

## Log collection frequency

By default, logs are generated every hour. To check how often your logs are collected, use the following PowerShell command:

```powershell
get-clusterresource "sddc management" | get-clusterparameter
```

To change the frequency of log generation on your local machine, change the `CacheDumpIntervalInSeconds` log collection parameter.

Here's an example of the log frequency set for every 15 minutes.

```powershell
get-clusterresource "sddc management" | set-clusterparameter -name "CacheDumpIntervalInSeconds" -value 900
```

> [!NOTE]
> To collect all logs don't lower the frequency to less than 15 minutes.

## Next steps

Learn how to [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule).