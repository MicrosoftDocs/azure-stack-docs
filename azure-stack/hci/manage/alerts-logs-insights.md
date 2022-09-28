---
title: Set up alerts for Azure Stack HCI clusters
description: Setting up alerts using sample logs or Azure Monitor Insights workbooks.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/28/2022
---

# Azure Stack HCI cluster alerts

For Azure Stack HCI, customers can set up alerts using pre-existing sample Log queries. To utilize this function, customers will need to enable Logs and associate a Log analytics workspace with their Azure Stack HCI cluster prior to setting up alerts using Logs. Additionally, customers can configure Insights for monitoring their cluster and setting up alerts.

## Set up alerts using sample Logs

1. Navigate to **Azure Monitor > Logs**.
2. Add a filter for `Resource type` and select "**Azure Stack HCI**". All the sample log queries will be populated for Azure Stack HCI like the image below.
3. Select **Load to Editor** to open the query workspace.
4. Select the scope **Log analytics workspace** for logs linked to the cluster.
5. Add your **Cluster Arm ID** to see results related to your cluster.

## Set up alerts using Insights

Alerts can be set up using Azure Insights workbooks if the Insights function has been configured, via the Azure portal, for your clusters. If your clusters aren't monitored, see the following [How to configure Azure portal to monitor Azure Stack HCI clusters - Azure Stack HCI | Microsoft Docs](./alerts-insights-logs.md) to enable Insights monitoring for your cluster before setting up alerts.

> [!IMPORTANT]
> It could take 15 minutes to collect these logs and is not a recommended method for high severity alerts.

1. Navigate to **Azure Monitor > Azure Stack HCI Insights (preview)**. Here you'll access the Insights workbook.
2. Once the workbook is loaded, select the Cluster Health tab, and you should see all the health faults for your clusters.
3. Select, the blue icon highlighted above to edit the query.
4. After the query loads, select the **+ New alert rule** option.
5. At the alerts interface you can set up alerts and send notifications.

To learn more about setting up alerts, see [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule).
