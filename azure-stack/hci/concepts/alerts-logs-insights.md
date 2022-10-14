---
title: Set up alerts for Azure Stack HCI clusters
description: Setting up alerts using sample logs or Azure Monitor Insights workbooks.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/10/2022
---

# Azure Stack HCI cluster alerts

This article describes how customers can set up alerts for Azure Stack HCI, customers can set up alerts using pre-existing sample Log queries. To utilize this function, customers will need to enable Logs and associate a Log analytics workspace with their Azure Stack HCI cluster prior to setting up alerts using Logs. Additionally, customers can configure Insights for monitoring their cluster and setting up alerts.

## Set up alerts using sample Log queries

1. From **Azure Portal** navigate to **Azure Monitor > Logs**.
2. Select **`+ Add filter`** to add a filter for **Resource type** and choose **Azure Stack HCI**. Here you'll get a populated list of sample logs for Azure Stack HCI.
3. Select **Load to Editor** to open the query workspace. 
4. Set the **scope** to **Log analytics workspace** for logs linked to the cluster.
5. Add your **Cluster Arm ID** in the **`where ClusterArmId =~`** section of the query to see results related to your cluster.

Once the information is populated you can analyze the logs and set up alerts on the results.

## Set up alerts using Insights

Alerts can be set up using Azure Insights workbooks if the Insights function has been configured, via the Azure portal, for your clusters. If your clusters aren't monitored, see the following [How to configure Azure portal to monitor Azure Stack HCI clusters - Azure Stack HCI | Microsoft Docs](../manage/monitor-hci-single) to enable Insights monitoring for your cluster before setting up alerts.

> [!IMPORTANT]
> It could take 15 minutes to collect these logs and is not a recommended method for high severity alerts.

1. From Azure Portal navigate to **Azure Monitor > Azure Stack HCI Insights (preview)**. Here you'll access the Insights workbook.

    :::image type="content" source="media/alerts-logs-insights/hci-insights-preview.png" alt-text="Monitor Azure Stack HCI preview screen" lightbox="media/alerts-logs-insights/hci-insights-preview.png":::

2. Once the workbook is loaded, select one of the tabs to view the health of those resources. For example select **Servers** to view the health of servers within your cluster.
3. Select the blue **Logs view** icon, highlighted above, to view and edit the query.
4. After the query loads, select the **+ New alert rule** option. From the alerts interface you can set up alert rules and send notifications.

    :::image type="content" source="media/alerts-logs-insights/create-alert-rule.png" alt-text="cluster Create an alert rule screen" lightbox="media/alerts-logs-insights/create-alert-rule.png":::

To learn more about setting up alerts, see [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule).
