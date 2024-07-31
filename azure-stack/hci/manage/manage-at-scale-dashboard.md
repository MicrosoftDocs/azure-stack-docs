---
title: Monitor at scale using the Azure Stack HCI overview and All clusters page (preview)
description: Learn to monitor your Azure Stack HCI systems using dashboards in Azure portal. You can view the status of Azure Stack HCI systems as charts or lists (preview).
ms.topic: how-to
author: alkohli
ms.subservice: azure-stack-hci
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 03/26/2024
---

# Use the dashboard to manage Azure Stack HCI systems (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article details how to manage at-scale your Azure Stack HCI systems via the dashboard in the Azure portal. You can view the status of the systems as charts or lists.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## View the dashboard charts

The Azure Stack HCI dashboard displays overview and detailed information about your clusters in the form of charts.

To access the dashboard chart view, follow these steps in the Azure portal:

1. In Azure portal, go to **Azure Arc** > **Infrastructure** > **Azure Stack HCI** > **Overview (preview)**.

   You can filter the dashboard display by **Subscription**, **Resource group**, and **Region**.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-overview.png" alt-text="Screenshot of the Azure Stack HCI dashboard." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-overview.png":::

   To view top alerts, select **Top alerts** in the Alerts tile.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-alert-details.png" alt-text="Screenshot of the Azure Stack HCI dashboard alert details." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-alert-details.png":::

   To view VM workload details, select **Virtual machines**.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-workloads.png" alt-text="Screenshot of the Azure Stack HCI dashboard VM workloads." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-workloads.png":::

   You are taken to the list view of VMs running on your Azure Stack HCI systems.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-workload-details.png" alt-text="Screenshot of the Azure Stack HCI dashboard VM workload details." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-workload-details.png":::

## View the all clusters list

The Azure Stack HCI **All clusters** list view displays information about your clusters.

To view the dashboard list view, follow these steps in the Azure portal:

1. In Azure portal, go to **Azure Arc** > **Infrastructure** > **Azure Stack HCI** > **All clusters (preview)**. The **All clusters** page is enhanced to include an hierarchical view of all your workloads within a cluster.

   All columns can be sorted by selecting a column header. You can filter the dashboard display by subscription, resource group, and region. You can also group display results by using the grouping control at the top right.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-list-view.png" alt-text="Screenshot of the Azure Stack HCI dashboard list view." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-list-view.png":::

   Select a cluster name to view details about a cluster, or select a parameter to view details about cluster status.

## Troubleshooting

### Issue: No data available

Use the following information when no cluster data is displayed in the **All clusters (preview)** tab on the Azure portal dashboard. You might see **No data available** in the **Updates** column or in the **Connection status** column.

| Issue | Issue seen in | Resolution |
|-------|---------------|-------|
| *Microsoft.Edge* Resource Provider (RP) is not registered with your subscription. | Connection status | Use the following steps: <br> 1. Run PowerShell as administrator. <br> 2. Run the following cmdlet: <br> `Register-AzResourceProvider -ProviderNamespace "Microsoft.Edge"` |
| The *Microsoft.Edge* RP isn't able to process data for the cluster. | Connection status | No action is required on your part. Azure Stack HCI service will automatically detect this condition and raise a Support ticket.  |
| Your cluster isn't functioning. | Connection status | Your cluster is in **Needs attention** state. <br> Bring up the cluster. |
| You have an older version cluster running Azure Stack HCI, version 22H2. This version can't be updated to Azure Stack HCI, version 23H2. | Updates and Connection status | Make sure to use an Azure Stack HCI, version 23H2 cluster. |

## Next steps

- Learn about the various options available to monitor your Azure Stack HCI clusters in [What is Azure Stack HCI monitoring?](../concepts/monitoring-overview.md)
