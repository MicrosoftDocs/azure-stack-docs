---
title: Monitor at scale using the Azure Stack HCI overview page (preview)
description: Learn to monitor your Azure Stack HCI systems using dashboards in Azure portal. You can view the status of Azure Stack HCI systems as charts or lists.
ms.topic: conceptual
author: alkohli
ms.subservice: azure-stack-hci
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 02/15/2024
---

# Monitor Azure Stack HCI systems using the dashboard (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

This article details how to monitor your Azure Stack HCI systems using the dashboards in Azure portal. You can view the status of Azure Stack HCI systems as charts or lists.

## View the dashboard chart view

The Azure Stack HCI dashboard displays overview and detailed information about your clusters.

To view the dashboard chart view:

1. In Azure portal, go to **Azure Arc** > **Infrastructure** > **Azure Stack HCI** > **Overview (preview)**.

   You can filter the dashboard display by **Subscription**, **Resource group**, and **Region**.

   :::image type="content" source="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-overview.png" alt-text="Screenshot of the Azure Stack HCI dashboard." lightbox="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-overview.png":::

   To view top alerts, select **Top alerts** in the Alters tile.

   :::image type="content" source="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-alert-details.png" alt-text="Screenshot of the Azure Stack HCI dashboard alert details." lightbox="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-alert-details.png":::

   To view VM workload details, select **Virtual machines**.

   :::image type="content" source="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-workloads.png" alt-text="Screenshot of the Azure Stack HCI dashboard VM workloads." lightbox="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-workloads.png":::

   The dashboard will display a list view of workload details for your VM.

   :::image type="content" source="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-workload-details.png" alt-text="Screenshot of the Azure Stack HCI dashboard VM workload details." lightbox="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-workload-details.png":::

## View the dashboard list view

The Azure Stack HCI dashboard list view displays information about your clusters.

To view the dashboard list view:

1. In Azure portal, go to **Azure Arc** > **Infrastructure** > **Azure Stack HCI** > **All clusters (preview)**.

   All columns can be sorted by selecting a culmn header. You can filter the dashboard display by Subscription, Resource group, and Region. You can also group display results using the grouping control at top right.

   :::image type="content" source="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-list-view.png" alt-text="Screenshot of the Azure Stack HCI dashboard list view." lightbox="media/azure-stack-hci-dashboard/azure-stack-hci-dashboard-list-view.png":::

   Select a cluster name to view details about a cluster, or select a parameter to view details about cluster status.

## Next steps

- Learn about the various options available to monitor your Azure Stack HCI clusters in [What is Azure Stack HCI monitoring?](monitoring-overview.md).
- [Assess deployment readiness via the Environment Checker](../manage/use-environment-checker.md).
