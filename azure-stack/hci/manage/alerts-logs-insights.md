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

## Set up alerts using sample Log queries

1. Navigate to **Azure Monitor > Logs**.
2. Select **`+ Add filter`** to add a filter for **Resource type** and choose **Azure Stack HCI**. Here you'll get a populated list of sample logs for Azure Stack HCI.
3. *Are there specific sample logs to mention in this document?*
4. Select **Load to Editor** to open the query workspace. *Is the step after choosing a specific sample log?*
5. Set the **scope** to **Log analytics workspace** for logs linked to the cluster.
6. Add your **Cluster Arm ID** in the **`where ClusterArmId =~`** section of the query to see results related to your cluster.

*Are there any specifics to mention that might be beneficial for customers after getting their results?*

## Set up alerts using Insights

Alerts can be set up using Azure Insights workbooks if the Insights function has been configured, via the Azure portal, for your clusters. If your clusters aren't monitored, see the following [How to configure Azure portal to monitor Azure Stack HCI clusters - Azure Stack HCI | Microsoft Docs](./alerts-insights-logs.md) to enable Insights monitoring for your cluster before setting up alerts.

> [!IMPORTANT]
> It could take 15 minutes to collect these logs and is not a recommended method for high severity alerts.

1. Navigate to **Azure Monitor > Azure Stack HCI Insights (preview)**. Here you'll access the Insights workbook.
2. Once the workbook is loaded, select the **Cluster Health** tab to see all the health faults for your clusters.
3. *Is there anything else important customers would need to know or do before going to the next step?*
4. Select the blue icon, *what is this called*, highlighted above to edit the query. *Why would customers need to do perform this step?*
5. After the query loads, select the **+ New alert rule** option. *Why would customers need to perform this step, what more should be known before performing this step or after?*

From the alerts interface you can set up alert rules and send notifications.

To learn more about setting up alerts, see [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule).
