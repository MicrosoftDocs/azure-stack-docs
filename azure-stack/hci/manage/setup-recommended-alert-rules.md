---
title: Enable recommended alert rules for Azure Stack HCI
description: How to enable recommended alert rules  for Azure Stack HCI.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/20/2024
---

# Enable recommended alert rules for Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to enable recommended alert rules for Azure Stack HCI.

A metric alert rule monitors a resource by evaluating conditions on the resource metrics at regular intervals. If the conditions are met, an alert is fired. Recommended alerts are predefined metric-based alerts for your Azure Stack HCI cluster resource. These alerts provide you with initial monitoring for a common set of metrics including CPU percentage and available memory.

For information about how to set up other alerts, see [Set up log alerts for Azure Stack HCI](./setup-hci-system-alerts.md) and [Set up metric alerts for Azure Stack HCI](./setup-metric-alerts.md).

## Prerequisites

Since the recommended alerts are metric-based alerts, they have the same prerequsites as metric alerts. For information, see [prerequisites]().

## Recommended alert rules for Azure Stack HCI

The following table lists the predefined recommended alert rules available for Azure Stack HCI:

| Alert name | Performance counters used | Unit | Suggested threshold value |
|--|--|--|--|
| Percentage CPU | Hyper-V Hypervisor Logical Processor\\\\% Total Run Time | Percentage | Greater than 80 |
| Available Memory Bytes | Memory\\\Available Bytes | Bytes | Less than 1000000000 |
| Volume Latency Read | Cluster CSVFS\\\Avg. sec/Read | Seconds | Greater than 0.500 |
| Volume Latency Write | Cluster CSVFS\\\Avg. sec/Write | Seconds | Greater than 0.500 |
| Network In Per Second | Network Adapter\\\Bytes Received/sec | BytesPerSecond | Greater than 500000000000 |
| Network Out Per Second | Network Adapter\\\Bytes Sent/sec | BytesPerSecond | Greater than 200000000000 |

## Enable recommended alert rules

Follow these steps to enable recommended alert rules in the Azure portal:

1. Go to your Azure Stack HCI cluster resource page and select your cluster.

1. On the left pane, select **Alerts** from the **Monitoring** section, and then select **View + set up** to enable the recommended alerts.

    :::image type="content" source="media/setup-recommended-alert-rules/set-up-recommended-alert-rules.png" alt-text="Screenshot showing the option to create view or set up a recommended alert rule." lightbox="media/setup-recommended-alert-rules/set-up-recommended-alert-rules.png":::

1. Select the signal name and then select **Apply**.

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
