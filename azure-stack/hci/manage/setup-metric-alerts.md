---
title: Set up metric alerts for Azure Stack HCI
description: How to set up metric alerts for Azure Stack HCI.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 01/31/2024
---

# Set up metric alerts for Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to set up metric alerts for Azure Stack HCI.

For information about how to set up log alerts, see [Set up log alerts for Azure Stack HCI systems](./setup-hci-system-alerts.md).

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- You have access to an Azure Stack HCI cluster that is deployed and registered.

- The `AzureEdgeTelemetryAndDiagnostics` extension must be installed to collect telemetry and diagnostics information from your Azure Stack HCI system. For more information about the extension, see [Azure Stack HCI telemetry and diagnostics extension overview](../concepts/telemetry-and-diagnostics-overview.md).

## Create metrics alerts

A metric alert rule monitors a resource by evaluating conditions on the resource metrics at regular intervals. If the conditions are met, an alert is fired. A metric time-series is a series of metric values captured over a period of time. You can use these metrics to create alert rules.

To learn more about metric alerts and how to create alert rules, see [Metric alerts](/azure/azure-monitor/alerts/alerts-types#metric-alerts) and [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule?tabs=metric).

To learn about the metrics on which alerts can be set up, see [What metrics are collected?](./monitor-cluster-with-metrics.md#what-metrics-are-collected).

You can create metric alerts for your Azure Stack HCI cluster through metrics explorer in the Azure portal or command-Line Interface (CLI).

### Create metric alerts through metrics explorer

Follow these steps to create alerts through metrics explorer:

1. In the Azure portal, select **Metrics** under the **Monitoring** section.

1. Select **Scope** and then select **Metric Namespace** as **Azure Stack HCI**.

1. Select the **Metric** on which you want to set up alerts.

1. Select **New alert rule**.

    :::image type="content" source="media/setup-metric-alerts/new-alert-rule.png" alt-text="Screenshot showing the option to create a new alert rule." lightbox="media/setup-metric-alerts/new-alert-rule.png":::

1. Select the signal name and then select **Apply**.

    :::image type="content" source="media/setup-metric-alerts/select-a-signal.png" alt-text="Screenshot of the Select a signal pane on the right." lightbox="media/setup-metric-alerts/select-a-signal.png":::

1. Preview the results of the selected metric signal in the **Preview** section. Select values for the **Time range** and **Time series**.

1. In the **Alert logic** section, add details like threshold, operator, aggregation type, threshold values, unit, threshold sensitivity, aggregation granularity, and frequency of evaluation and then select **Next: Actions \>**.

    :::image type="content" source="media/setup-metric-alerts/create-alert-rule-alerts-logic-section.png" alt-text="Screenshot of the Alerts logic section on the Create an alert rule page." lightbox="media/setup-metric-alerts/create-alert-rule-alerts-logic-section.png":::

1. On the **Actions** tab of the **Create and alert rule** page, specify the action group to indicate your preferred method of notification, and then select **Next: Details \>**.

    :::image type="content" source="media/setup-metric-alerts/create-alert-rule-action-tab.png" alt-text="Screenshot of the Select action groups context pane on the Create an alert rule page." lightbox="media/setup-metric-alerts/create-alert-rule-action-tab.png":::

1. On the **Details** tab of the **Create and alert rule** page, select severity and alert rule description. Select **Review+Create** and then select **Create**.

    :::image type="content" source="media/setup-metric-alerts/create-alert-rule-details-tab.png" alt-text="Screenshot of the Details tab on the Create an alert rule page." lightbox="media/setup-metric-alerts/create-alert-rule-details-tab.png":::

### Create metric alerts through Azure CLI

Use the [`az monitor metrics alert create`](/cli/azure/monitor/metrics/alert#az-monitor-metrics-alert-create) command to create metrics alert rules through Azure CLI.

Here's an example of the command usage:

To create a metric alert rule that monitors if the average CPU usage of a VM is greater than 90, run the following command:

```azure CLI
az monitor metrics alert create -n {nameofthealert} -g {ResourceGroup} --scopes {VirtualMachineResourceID} --condition "avg Percentage CPU > 90" --description {descriptionofthealert}
```

## Next steps

- Learn how to [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule).
- Learn how to [monitor Azure Stack HCI with Azure Monitor Metrics](./monitor-cluster-with-metrics.md).
