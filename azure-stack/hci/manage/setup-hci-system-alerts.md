---
title: Set up alerts for Azure Stack HCI systems
description: How to set up alerts for various Azure Stack HCI system resources using sample log queries or Azure Insights workbooks.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.reviewer: kimlam
ms.date: 05/15/2023
---

# Set up alerts for Azure Stack HCI systems

>[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)].

This article describes how to set up alerts for Azure Stack HCI systems, using pre-existing sample log queries such as average server CPU, available memory, available volume capacity and more. To use the sample queries, you must first enable logs and associate a log analytics workspace with your Azure Stack HCI system. Additionally, we provide guidance on how to use Azure Insights for monitoring resources and setting up alerts.

## Set up alerts using sample Log queries

You can start monitoring your Azure Stack HCI system and setting up alerts for it by using pre-existing log queries available in the [Azure portal](https://portal.azure.com). These queries can help you check and monitor the health of your system. Identify the clusters you want to monitor using the sample queries and follow these steps:

1. On your cluster **Overview** page, select **JSON View**.

    :::image type="content" source="media/alerts-logs-insights/json-view.png" alt-text="Screenshot of the JSON View link to find ClusteArmId." lightbox="media/alerts-logs-insights/json-view.png":::

2. Copy the ClusterArmId detail from the **Resource ID** box.

    :::image type="content" source="media/alerts-logs-insights/resource-id.png" alt-text="Screenshot of the Resource JSON page to copy ClusteArmId information." lightbox="media/alerts-logs-insights/resource-id.png":::

3. From the Azure portal, navigate to or search for **Monitor** and select **Logs**.

4. Select **+ Add filter** to add a filter for **Resource type**.

5. Choose **Azure Stack HCI** for a populated list of Azure Stack HCI system sample logs.

    :::image type="content" source="media/alerts-logs-insights/azure-monitor-logs.png" alt-text="Screenshot of the Azure Monitor Logs space and how to access the sample queries." lightbox="media/alerts-logs-insights/azure-monitor-logs.png":::

6. Select **Load to Editor** to open the query workspace.

7. Set the **scope** to **Log analytics workspace** for logs linked to the cluster resource.

8. Paste your **ClusterArmId** detail in the **`where ClusterArmId =~`** section of the query to see results related to your cluster.

    :::image type="content" source="media/alerts-logs-insights/cluster-arm-id.png" alt-text="Screenshot of the log analytics workspace and Cluster Arm Id query." lightbox="media/alerts-logs-insights/cluster-arm-id.png":::

9. Select **Run**.

After the information appears, you can examine the logs and create alerts based on the results. For more information, see [Log query results](setup-hci-system-alerts.md#log-query-results) and [Alert actions and details](setup-hci-system-alerts.md#alert-actions-and-details).

## Set up alerts for multiple clusters

To set a new or change an existing query to accommodate multiple clusters ClusterArmId's, add the `| where ClusterArmId in~` clause to your query. Include the ClusterArmId's for each of the clusters you want to use in your query.

:::image type="content" source="media/alerts-logs-insights/multiple-clusters.png" alt-text="Screenshot of a query to show logs for multiple clusters." lightbox="media/alerts-logs-insights/multiple-clusters.png":::

## Set up alerts using Insights

To set up alerts using Azure Insights workbooks in the Azure portal, you must first configure the Insights function for your Azure Stack HCI system. If your resources aren't monitored and you want to enable Insights, see [How to configure Azure portal to monitor Azure Stack HCI clusters - Azure Stack HCI | Microsoft Docs](../manage/monitor-hci-single.md).

> [!IMPORTANT]
> Using Insights isn't recommended for high severity alerts. It could take 15 minutes to collect logs.

1. From the Azure portal, navigate to or search for **Monitor**.

2. Select **Azure Stack HCI** and set your time range, subscriptions, and other parameters.

    :::image type="content" source="media/alerts-logs-insights/workbooks-insights.png" alt-text="Screenshot of the workbooks and parameters for alerts." lightbox="media/alerts-logs-insights/workbooks-insights.png":::

3. Select one of the tabs to view the health of your resources. For example, select **Servers** to view the health of servers in your cluster.

4. Customize the workbook and edit it until you see a blue **Logs view** icon. Select the icon to view and edit your query.

    :::image type="content" source="media/alerts-logs-insights/health-faults.png" alt-text="Screenshot of the monitored resources and the resources health." lightbox="media/alerts-logs-insights/health-faults.png":::

5. After the query loads, select **+ New alert rule**.

    :::image type="content" source="media/alerts-logs-insights/new-alert-rule.png" alt-text="Screenshot of the cluster New alert rule and how to create a new alert." lightbox="media/alerts-logs-insights/new-alert-rule.png":::

6. From the alerts interface you can set up your alert conditions, actions and more. For more information, see [Log query results](setup-hci-system-alerts.md#log-query-results) and [Alert actions and details](setup-hci-system-alerts.md#alert-actions-and-details).

    :::image type="content" source="media/alerts-logs-insights/create-alert-rule.png" alt-text="Screenshot of items to define when a new alert is being created." lightbox="media/alerts-logs-insights/create-alert-rule.png":::

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

:::image type="content" source="media/alerts-logs-insights/measure-detail.png" alt-text="Screenshot of the log query detail to specify." lightbox="media/alerts-logs-insights/measure-detail.png":::

Once your details are set, you can review your conditions for alert accuracy.

:::image type="content" source="media/alerts-logs-insights/alert-preview.png" alt-text="Screenshot of the alert conditions to set." lightbox="media/alerts-logs-insights/alert-preview.png":::

## Alert actions and details

To determine how you receive notifications for your cluster alerts, use the **Actions** tab as shown in the image. You can create new action groups or set an alert rule for existing ones. You can choose to receive notifications through email, Event Hubs, and more.

:::image type="content" source="media/alerts-logs-insights/action-groups.png" alt-text="Screenshot of the action groups action options." lightbox="media/alerts-logs-insights/action-groups.png":::

Once you have set your actions, the **Details** tab allows you to set the alert severity, name, description, and region. Select **Review + Create** for a final review of all your alert settings and to create your alert.

:::image type="content" source="media/alerts-logs-insights/alert-details.png" alt-text="Screenshot of the action details for alerts." lightbox="media/alerts-logs-insights/alert-details.png":::

After your alerts are set up, you can monitor your alert rules, action groups, and more in the **Alerts** tab.

:::image type="content" source="media/alerts-logs-insights/alert-rules-monitoring.png" alt-text="Screenshot of the monitoring alerts." lightbox="media/alerts-logs-insights/alert-rules-monitoring.png":::

## Log collection frequency

Logs are generated every hour by default. To check how often your logs are collected, use the following PowerShell command:

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
