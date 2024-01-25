---
title: Set up metric alerts for Azure Stack HCI
description: How to set up metric alerts for Azure Stack HCI.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 01/24/2024
---

# Set up metric alerts for Azure Stack HCI systems

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to use Azure Insights for setting up metric alerts. For information about how to set up log alerts, see [](./setup-hci-system-alerts.md).

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- You must have access to an Azure Stack HCI cluster that is deployed and registered.
- You must have [Insights enabled on the cluster](./monitor-hci-single.md#enable-insights).

## Set up metric alerts using Insights

> [!IMPORTANT]
> Using Insights isn't recommended for high severity alerts. It could take 15 minutes to collect logs.

Follow these steps to set up metric alerts:

1. From the Azure portal, navigate to or search for **Monitor** and select **Azure Stack HCI**.

2. Select one of the tabs to view the health of your resources. For example, select **Servers** to view the health of servers in your cluster.

3. Customize the workbook and edit it until you see a blue **Logs view** icon. Select the icon to view and edit your query.

    :::image type="content" source="media/alerts-logs-insights/health-faults.png" alt-text="Screenshot of the monitored resources and the resources health." lightbox="media/alerts-logs-insights/health-faults.png":::

4. After the query loads, select **+ New alert rule**.

    :::image type="content" source="media/alerts-logs-insights/new-alert-rule.png" alt-text="Screenshot of the cluster New alert rule and how to create a new alert." lightbox="media/alerts-logs-insights/new-alert-rule.png":::

5. From the alerts interface you can set up your alert conditions, actions and more. For more information, see [Log query results](setup-hci-system-alerts.md#log-query-results) and [Alert actions and details](setup-hci-system-alerts.md#alert-actions-and-details).

    :::image type="content" source="media/alerts-logs-insights/create-alert-rule.png" alt-text="Screenshot of items to define when a new alert is being created." lightbox="media/alerts-logs-insights/create-alert-rule.png":::

## Next steps

Learn how to [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule).
