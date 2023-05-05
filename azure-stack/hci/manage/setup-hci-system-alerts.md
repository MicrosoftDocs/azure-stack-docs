---
title: Set up alerts for Azure Stack HCI systems
description: How to set up alerts for various Azure Stack HCI system resources using sample log queries or Azure Insights workbooks.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/28/2022
---

# Set up alerts for Azure Stack HCI systems

>[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)].

This article describes how to set up alerts for Azure Stack HCI systems, using pre-existing sample log queries such as average server CPU, available memory, available volume capacity and more. To use the sample queries, you must first enable logs, and then associate a log analytics workspace with your Azure Stack HCI system. We also share how to configure Azure Insights for monitoring resources and setting up alerts.

## Set up alerts using sample Log queries

Pre-existing log queries in the [Azure portal](https://portal.azure.com) are a helpful way to get started with checking the health of your Azure Stack HCI system and setting up alerts for it.

1. From the Azure portal, navigate to **Azure Monitor** and select **Logs**.
2. Select **+ Add filter** to add a filter for **Resource type**.
3. Choose **Azure Stack HCI** for a populated list of Azure Stack HCI system sample logs.

    :::image type="content" source="media/alerts-logs-insights/azure-monitor-logs.png" alt-text="Screenshot of the Azure Monitor Logs space and how to access the sample queries." lightbox="media/alerts-logs-insights/azure-monitor-logs.png":::

4. Select **Load to Editor** to open the query workspace.
5. Set the **scope** to **Log analytics workspace** for logs linked to the cluster resource.
6. On the cluster **Overview** page, select **JSON View**

    :::image type="content" source="media/alerts-logs-insights/json-view.png" alt-text="Screenshot of the JSON View link to find ClusteArmId." lightbox="media/alerts-logs-insights/json-view.png":::

7. Copy the ClusterArmId detail from the **Resource ID** box.

    :::image type="content" source="media/alerts-logs-insights/resource-id.png" alt-text="Screenshot of the Resource JSON page to copy ClusteArmId information." lightbox="media/alerts-logs-insights/resource-id.png":::

8. Paste your **ClusterArmId** detail in the **`where ClusterArmId =~`** section of the query to see results related to your cluster.

    :::image type="content" source="media/alerts-logs-insights/cluster-arm-id.png" alt-text="Screenshot of the log analytics workspace and Cluster Arm Id query." lightbox="media/alerts-logs-insights/cluster-arm-id.png":::

9. Select **Run**.

Once the information populates, you can analyze the logs and set up alerts on the results.

## Set up alerts using Insights

Alerts can be set up in the Azure portal to use Azure Insights workbooks if the Insights function is configured for your Azure Stack HCI system. If your resources aren't monitored, see [How to configure Azure portal to monitor Azure Stack HCI clusters - Azure Stack HCI | Microsoft Docs](../manage/monitor-hci-single.md) to enable Insights monitoring before setting up alerts.

> [!IMPORTANT]
> Using Insights isn't recommended for high severity alerts. It could take 15 minutes to collect logs.
s
1. From the Azure portal, navigate to Azure Monitor and select **Insights**.

    :::image type="content" source="media/alerts-logs-insights/hci-insights-preview.png" alt-text="Screenshot of Azure Stack HCI monitoring screen and the resources that are set up for alerts." lightbox="media/alerts-logs-insights/hci-insights-preview.png":::

2. Once the workbook loads, select one of the tabs to view the health of those resources. For example, select **Servers** to view the health of servers in your cluster.

    :::image type="content" source="media/alerts-logs-insights/health-faults.png" alt-text="Screenshot of the monitored resources and the resources health." lightbox="media/alerts-logs-insights/health-faults.png":::

3. Select the blue **Logs view** icon to view and edit the query.
4. After the query loads, select **+ New alert rule**.

    :::image type="content" source="media/alerts-logs-insights/new-alert-rule.png" alt-text="Screenshot of the cluster New alert rule and how to create a new alert." lightbox="media/alerts-logs-insights/new-alert-rule.png":::

5. From the alerts interface you can set up alert rules and send notifications.

    :::image type="content" source="media/alerts-logs-insights/create-alert-rule.png" alt-text="Screenshot of items to define when a new alert is being created." lightbox="media/alerts-logs-insights/create-alert-rule.png":::

For more information, see [Log query results](setup-hci-system-alerts.md#log-query-results).

## Set up alerts for multiple clusters

To set a new or change an existing query to accommodate multiple clusters ClusterArmId's, add the `| where ClusterArmId in~` clause to your query. Include the ClusterArmId's for each of the clusters you want to use in your query.

:::image type="content" source="media/alerts-logs-insights/multiple-clusters.png" alt-text="Screenshot of a query to show logs for multiple clusters." lightbox="media/alerts-logs-insights/multiple-clusters.png":::

## Log query results

Once you add logs, run your query against the workspace that stores your cluster logs to confirm that you get the expected results. If you don't receive the expected results, correct your log query, and rerun it.

If you want to set a new alert rule, select **New alert rule** and fill in the required conditional details:

- **Measure**: The value used to set up alerts. By default, it takes only numerical values. Convert your values to integer and select the correct one from the dropdown list.
- **Aggregation type**: Ensures that if even one cluster memory value meets the desired value, an alert shows. For alerts on multiple clusters, you need to put the aggregation type as a maximum and not an average or total.
- **Resource ID column**: The value used to split the alert measure value based on other values. To get alerts on a cluster, use the `clusterarmID` or to set up alerts for the server, use `_resourceID`. Check your value names in your log query for accuracy.
- **Dimension name**: The value used to split an alert measure further. For example, to get alerts per server, select the `Nodename`. When you set up alerts, you might not see all the values in the dropdown menu. Select the checkbox for **Include all future values** to ensure you set up the same alert on multiple servers in the cluster.
- **Threshold value**: Provides a notification based on the value you've set.

In this alert example, when the measure value Memoryusageint with an aggregation type of maximum value reaches the threshold of 15 minutes, you get an alert.

:::image type="content" source="media/alerts-logs-insights/measure-detail.png" alt-text="Screenshot of the log query detail to specify." lightbox="media/alerts-logs-insights/measure-detail.png":::

Once your details are set, you can preview your conditions for alert accuracy.

:::image type="content" source="media/alerts-logs-insights/alert-preview.png" alt-text="Screenshot of the alert condition preview." lightbox="media/alerts-logs-insights/alert-preview.png":::

## Alert actions and details

To determine how you're notified for your cluster alerts use the **Actions** tab as highlighted in the image. You can set an alert rule for existing action groups or create new action groups. You can choose notifications via email, Azure app, Event Hubs, and more.

:::image type="content" source="media/alerts-logs-insights/action-groups.png" alt-text="Screenshot of the action groups action options." lightbox="media/alerts-logs-insights/action-groups.png":::

Once you have set your actions, the **Details** tab allows you to set the alert severity, name, description, and region. Select the Review + Create for a final review of all your alert settings and to create your alert.

:::image type="content" source="media/alerts-logs-insights/alert-details.png" alt-text="Screenshot of the action groups action options." lightbox="media/alerts-logs-insights/alert-details.png":::

After your alerts are set up, you can monitor your alert rules, action groups, and more in the **Alerts** tab.

:::image type="content" source="media/alerts-logs-insights/alert-rules-monitoring.png" alt-text="Screenshot of the action groups action options." lightbox="media/alerts-logs-insights/alert-rules-monitoring.png":::

## Log collection frequency

By default, logs collect and generate every hour. To check the frequency of the log collection, use the following PowerShell command:

```powershell
get-clusterresource "sddc management" | get-clusterparameter
```

To change the frequency of log generation on your local machine, change the log collection parameter `CacheDumpIntervalInSeconds`.

Here's an example of changing the log frequency to 15 minutes.

```powershell
get-clusterresource "sddc management" | set-clusterparameter -name "CacheDumpIntervalInSeconds" -value 900
```

> [!NOTE]
> To collect all logs don't lower the frequency to less than 15 minutes.

## Next steps

- [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule)
