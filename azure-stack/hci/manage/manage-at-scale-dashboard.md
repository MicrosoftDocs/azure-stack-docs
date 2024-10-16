---
title: Monitor at scale using the Azure Local overview and All systems page (preview)
description: Learn to monitor your Azure Local systems using dashboards in Azure portal. You can view the status of Azure Local systems as charts or lists (preview).
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 10/08/2024
---

# Use the dashboard to manage Azure Local systems (preview)

[!INCLUDE [hci-applies-to-23h2](../../hci/includes/hci-applies-to-23h2.md)]

This article details how to manage at-scale your Azure Local systems via the dashboard in the Azure portal. You can view the status of the systems as charts or lists.

[!INCLUDE [hci-preview](../../hci/includes/hci-preview.md)]

## View the dashboard charts

The Azure Local dashboard displays overview and detailed information about your systems in the form of charts.

To access the dashboard chart view, follow these steps in the Azure portal:

1. In Azure portal, go to **Azure Arc** > **Infrastructure** > **Azure Local** > **Overview (preview)**.

   You can filter the dashboard display by **Subscription**, **Resource group**, and **Region**.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-overview.png" alt-text="Screenshot of the Azure Local dashboard." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-overview.png":::

   To view top alerts, select **Top alerts** in the Alerts tile.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-alert-details.png" alt-text="Screenshot of the Azure Local dashboard alert details." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-alert-details.png":::

   To view VM workload details, select **Virtual machines**.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-workloads.png" alt-text="Screenshot of the Azure Local dashboard VM workloads." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-workloads.png":::

   You are taken to the list view of VMs running on your Azure Local systems.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-workload-details.png" alt-text="Screenshot of the Azure Local dashboard VM workload details." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-workload-details.png":::

## View the all systems list

The Azure Local **All systems** list view displays information about your systems.

To view the dashboard list view, follow these steps in the Azure portal:

1. In Azure portal, go to **Azure Arc** > **Infrastructure** > **Azure Local** > **All systems (preview)**. The **All systems** page is enhanced to include an hierarchical view of all your workloads within a system.

   All columns can be sorted by selecting a column header. You can filter the dashboard display by subscription, resource group, and region. You can also group display results by using the grouping control at the top right.

   :::image type="content" source="media/manage-at-scale-dashboard/manage-at-scale-dashboard-list-view.png" alt-text="Screenshot of the Azure Local dashboard list view." lightbox="media/manage-at-scale-dashboard/manage-at-scale-dashboard-list-view.png":::

   Select a system name to view details about a system, or select a parameter to view details about system status.

## Troubleshooting

### Issue: No data available

Use the following information when no system data is displayed in the **All systems (preview)** tab on the Azure portal dashboard. You might see **No data available** in the **Updates** column or in the **Connection status** column.

| Issue | Issue seen in | Resolution |
|-------|---------------|-------|
| *Microsoft.Edge* Resource Provider (RP) is not registered with your subscription. | Connection status | Use the following steps: <br> 1. Run PowerShell as administrator. <br> 2. Run the following cmdlet: <br> `Register-AzResourceProvider -ProviderNamespace "Microsoft.Edge"` |
| The *Microsoft.Edge* RP isn't able to process data for the system. | Connection status | No action is required on your part. Azure Local service will automatically detect this condition and raise a Support ticket.  |
| Your system isn't functioning. | Connection status | Your system is in **Needs attention** state. <br> Bring up the system. |
| You have an older version system running Azure Local, version 22H2. This version can't be updated to Azure Local, version 23H2. | Updates and Connection status | Make sure to use an Azure Local, version 23H2 system. |

## Next steps

- Learn about the various options available to monitor your Azure Local instance in [What is Azure Local monitoring?](../concepts/monitoring-overview.md)