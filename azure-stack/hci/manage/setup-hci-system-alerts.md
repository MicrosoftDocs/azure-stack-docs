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

>Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article describes how to set up alerts for Azure Stack HCI systems, using pre-existing sample log queries such as average node CPU, available memory, available volume capacity and more. To use the sample queries, you must first enable logs, and then associate a log analytics workspace with your Azure Stack HCI system. Additionally, you'll see how to configure Azure Insights for monitoring resources and setting up alerts.

## Set up alerts using sample Log queries

1. From the [Azure portal](https://portal.azure.com), navigate to **Azure Monitor > Logs**.
2. Select **`+ Add filter`** to add a filter for **Resource type** and choose **Azure Stack HCI**. Here you'll get a populated list of sample logs for Azure Stack HCI.

    :::image type="content" source="media/alerts-logs-insights/azure-monitor-logs.png" alt-text="Screenshot of the Azure Monitor Logs space and how to access the sample queries." lightbox="media/alerts-logs-insights/azure-monitor-logs.png":::

3. Select **Load to Editor** to open the query workspace.
4. Set the **scope** to **Log analytics workspace** for logs linked to the cluster resource.
5. On the cluster **Overview** page, select **JSON View**

    :::image type="content" source="media/alerts-logs-insights/json-view.png" alt-text="Screenshot of the JSON View link to find ClusteArmId." lightbox="media/alerts-logs-insights/json-view.png":::

6. Copy the information from the **Resource ID** box for the next step.

    :::image type="content" source="media/alerts-logs-insights/resource-id.png" alt-text="Screenshot of the Resource JSON page to copy ClusteArmId information." lightbox="media/alerts-logs-insights/resource-id.png":::

7. Paste your **ClusterArmId** detail in the **`where ClusterArmId =~`** section of the query to see results related to your cluster.

    :::image type="content" source="media/alerts-logs-insights/cluster-arm-id.png" alt-text="Screenshot of the log analytics workspace and Cluster Arm Id query." lightbox="media/alerts-logs-insights/cluster-arm-id.png":::

8. Select **Run**.

Once the information is populated, you can analyze the logs and set up alerts on the results.

## Set up alerts using Insights

Alerts can be set up in Azure portal, using Azure Insights workbooks, if the Insights function has been configured for your Azure Stack HCI system. If your resources aren't monitored, see [How to configure Azure portal to monitor Azure Stack HCI clusters - Azure Stack HCI | Microsoft Docs](../manage/monitor-hci-single.md) to enable Insights monitoring before setting up alerts.

> [!IMPORTANT]
> It could take 15 minutes to collect these logs and isn't a recommended method for high severity alerts.

1. From Azure portal, navigate to **Azure Monitor > Azure Stack HCI Insights (preview)**. Here you'll access the Insights.

    :::image type="content" source="media/alerts-logs-insights/hci-insights-preview.png" alt-text="Screenshot of Azure Stack HCI monitoring screen and the resources that are set up for alerts." lightbox="media/alerts-logs-insights/hci-insights-preview.png":::

2. Once the workbook is loaded, select one of the tabs to view the health of those resources. For example, select **Servers** to view the health of servers in your cluster.

    :::image type="content" source="media/alerts-logs-insights/health-faults.png" alt-text="Screenshot of the monitored resources and the resources health." lightbox="media/alerts-logs-insights/health-faults.png":::

3. Select the blue **Logs view** icon, highlighted above on the far right, to view and edit the query.
4. After the query loads, select the **+ New alert rule** option.

    :::image type="content" source="media/alerts-logs-insights/new-alert-rule.png" alt-text="Screenshot of the cluster New alert rule and how to create a new alert." lightbox="media/alerts-logs-insights/new-alert-rule.png":::

5. From the alerts interface you can set up alert rules and send notifications.

    :::image type="content" source="media/alerts-logs-insights/create-alert-rule.png" alt-text="Screenshot of items to define when a new alert is being created." lightbox="media/alerts-logs-insights/create-alert-rule.png":::

## Set up alerts for multiple clusters

To change an existing query to accommodate multiple ClusterArmId's in your log query add `| where ClusterArmId in~` to your query with the ClusterArmId's you want to include.

Here is an example:

| where ClusterArmId in~ ('clusterarmId1', 'clusterarmId2', 'clusterarmId3')

:::image type="content" source="media/alerts-logs-insights/multiple-clusters.png" alt-text="Screenshot of a query to show logs for multiple clusters." lightbox="media/alerts-logs-insights/multiple-clusters.png":::

## Log query results

Once you have added logs, run the query to confirm that you get the expected results. If you don't, correct the log query and rerun it.

If you want to set a new alert rule, click New alert rule and fill in the required details:

- **Measure**: This is the value you want to set up alert on. By default, it takes only numeric value, so please convert your values to integer. Select the value from Measure dropdown.
- Look at your logs query carefully to set up correct alerts. Eg if you are setting up alerts on multiple clusters, make sure that you give aggregation type as maximum and not an average or total. It will make sure that even if one cluster memory value meets the desired value, it should show up an alert.
- Split by dimensions: Select this value if you want to split the alert measure value based on other values. So, if you want to get alerts on cluster, select clusterarmID or if you want to set up alerts using node, select _resourceID. Please check the value names in your log query to set up alert correctly.
- Dimension name: Please use dimension name if you want to get alert measure split further like in this case, if you want to get alerts as per Node, then select Nodename as well.
- Sometimes, while setting up alerts, you might not be able to see all the values being populated in the dropdown, make sure to select the checkbox for "Include all future values". It will help in setting up the same alert on more nodes in the cluster.
- Threshold value: Give the value you want to be notified for. So, in the example below, when Memoryusageint maximum value reaches 15 minutes, customer will get an alert.
 
## Log collection frequency

By default logs are collected every hour, so alerts are generated every hour. To check the frequency of the log collection use the following PowerShell command:

```powershell
get-clusterresource "sddc management" | get-clusterparameter
```

To change the frequency of log generation on your local machine, change the log collection parameter `CacheDumpIntervalInSeconds`.

Here is an example of changing the log frequency to 15 minutes.

```powershell
get-clusterresource "sddc management" | set-clusterparameter -name "CacheDumpIntervalInSeconds" -value 900
```

> [!NOTE]
> For all logs to be collected don't lower the frequency below 15 minutes.

## Next steps

- [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule)
