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
5. Add your **Cluster Arm ID** in the **`where ClusterArmId =~`** section of the query to see results related to your cluster.

    :::image type="content" source="media/alerts-logs-insights/cluster-arm-id.png" alt-text="Screenshot of the log analytics workspace and Cluster Arm Id query." lightbox="media/alerts-logs-insights/cluster-arm-id.png":::

6. Select **Run**.

Once the information is populated, you can analyze the logs and set up alerts on the results.

## Set up alerts using Insights

Alerts can be set up in Azure portal, using Azure Insights workbooks, if the Insights function has been configured for your Azure Stack HCI system. If your resources aren't monitored, see [How to configure Azure portal to monitor Azure Stack HCI clusters - Azure Stack HCI | Microsoft Docs](../manage/monitor-hci-single.md) to enable Insights monitoring before setting up alerts.

> [!IMPORTANT]
> It could take 15 minutes to collect these logs and isn't a recommended method for high severity alerts.

1. From Azure portal, navigate to **Azure Monitor > Azure Stack HCI Insights (preview)**. Here you'll access the Insights.

    :::image type="content" source="media/alerts-logs-insights/hci-insights-preview.png" alt-text="Screenshot of Azure Stack HCI monitoring screen and resources setup for alerts." lightbox="media/alerts-logs-insights/hci-insights-preview.png":::

2. Once the workbook is loaded, select one of the tabs to view the health of those resources. For example, select **Servers** to view the health of servers in your cluster.

    :::image type="content" source="media/alerts-logs-insights/health-faults.png" alt-text="Screenshot of the the monitored resource and their health." lightbox="media/alerts-logs-insights/health-faults.png":::

3. Select the blue **Logs view** icon, highlighted above on the far right, to view and edit the query.
4. After the query loads, select the **+ New alert rule** option.

    :::image type="content" source="media/alerts-logs-insights/new-alert-rule.png" alt-text="Screenshot of the cluster New alert rule and how to create a new alert." lightbox="media/alerts-logs-insights/new-alert-rule.png":::

5. From the alerts interface you can set up alert rules and send notifications.

    :::image type="content" source="media/alerts-logs-insights/create-alert-rule.png" alt-text="Screenshot of items to define when a new alert is being created." lightbox="media/alerts-logs-insights/create-alert-rule.png":::

## Next steps

- [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule)
