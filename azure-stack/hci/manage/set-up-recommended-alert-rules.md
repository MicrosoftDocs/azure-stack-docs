---
title: Enable recommended alert rules for Azure Stack HCI
description: How to enable recommended alert rules  for Azure Stack HCI.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/05/2024
---

# Enable recommended alert rules for Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to enable recommended alert rules for Azure Stack HCI.

A metric alert rule monitors a resource by evaluating conditions on the resource metrics at regular intervals. If the conditions are met, an alert is fired. Recommended alerts are predefined metric-based alerts for your Azure Stack HCI cluster resource. These alerts provide you with initial monitoring for a common set of metrics including CPU percentage and available memory.

For information about how to set up log alerts and metric alerts, see [Set up log alerts for Azure Stack HCI](./setup-hci-system-alerts.md) and [Set up metric alerts for Azure Stack HCI](./setup-metric-alerts.md).

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- You have access to an Azure Stack HCI cluster that is deployed and registered.

- The `AzureEdgeTelemetryAndDiagnostics` extension must be installed to collect telemetry and diagnostics information from your Azure Stack HCI system. For more information about the extension, see [Azure Stack HCI telemetry and diagnostics extension overview](../concepts/telemetry-and-diagnostics-overview.md).

## When to enable recommended alerts

If you don't have alert rules defined for your cluster resource, you can enable recommended out-of-the-box alert rules in the Azure portal. The system compiles a list of recommended alert rules using Metrics data and provides threshold recommendations based on:

- The resource provider’s knowledge of important signals and thresholds for monitoring the resource.
- Data that tells us what customers commonly alert on for this resource.

For a list of predefined recommended alerts available for Azure Stack HCI, see [Recommended alert rules for Azure Stack HCI](#recommended-alert-rules-for-azure-stack-hci).

## Enable recommended alert rules

Follow these steps to enable recommended alert rules in the Azure portal:

1. Go to your Azure Stack HCI cluster resource page and select your cluster.

1. On the left pane, select **Alerts** from the **Monitoring** section, and then select **View + set up** to enable the recommended alerts. You can also select **Set up recommendations**.

    :::image type="content" source="media/set-up-recommended-alert-rules/set-up-recommended-alert-rules.png" alt-text="Screenshot showing the option to create view or set up a recommended alert rule." lightbox="media/set-up-recommended-alert-rules/set-up-recommended-alert-rules.png":::

1. In the **Set up recommended alert rules** pane, review the list of recommended alert rules for your cluster. In the **Select alert rules** section, all recommended alerts are populated with the default values for the rule condition, such as the percentage of CPU usage that you want to trigger an alert.

    :::image type="content" source="media/set-up-recommended-alert-rules/set-up-recommended-alert-rules-pane.png" alt-text="Screenshot of the Set up recommended alert rules pane with a list of recommended alert rules for your cluster." lightbox="media/set-up-recommended-alert-rules/set-up-recommended-alert-rules-pane.png":::

1. Expand each of the alert rules to see its details. By default, the severity for each is **Informational**. You can change it to another severity, such as **Error**. You can also change the recommended threshold if required.

1. In the **Notify me by** section, ensure that **Email** is enabled and provide an email address to be notified when any of the alerts fire.

1. Select **Use an existing action group**, and enter the details of the existing action group if you want to use an action group that already exists.

1. Turn on the toggle to create the alert rules, and select **Save**.

    :::image type="content" source="media/set-up-recommended-alert-rules/set-up-recommended-alert-rules-expanded.png" alt-text="Screenshot of an expanded recommended alert rule." lightbox="media/set-up-recommended-alert-rules/set-up-recommended-alert-rules-expanded.png":::

## View recommended alert rules

When the alert rule creation is complete, you'll see the alerts page for the Azure Stack HCI cluster.

Follow these steps to view recommended alert rules:

1. Go to your Azure Stack HCI cluster resource page and select your cluster. From the **Monitoring** section on the left menu, select **Alerts**.

1. On the **Alerts** page, select **Alert rules** to view the rules you created.

    :::image type="content" source="media/set-up-recommended-alert-rules/alerts-page.png" alt-text="Screenshot of the alerts page for your cluster." lightbox="media/set-up-recommended-alert-rules/alerts-page.png":::

1. On the **Alert rules** page, select the alert rule that you want to view or edit.

    :::image type="content" source="media/set-up-recommended-alert-rules/select-alert-rule.png" alt-text="Screenshot of the Alert rules page showing the alerts you have created." lightbox="media/set-up-recommended-alert-rules/select-alert-rule.png":::

1. Review the details of the selected alert rule. You can also select **Edit** to modify the default values of the selected alert rule, such as the default threshold value.

    :::image type="content" source="media/set-up-recommended-alert-rules/view-alert.png" alt-text="Screenshot of the selected alert rule." lightbox="media/set-up-recommended-alert-rules/view-alert.png":::

1. After making the necessary changes, select **Review + save**.

    :::image type="content" source="media/set-up-recommended-alert-rules/edit-alert-rule.png" alt-text="Screenshot of the Edit alert rule page." lightbox="media/set-up-recommended-alert-rules/edit-alert-rule.png":::

## Recommended alert rules for Azure Stack HCI

Here's a list of predefined recommended alert rules available for Azure Stack HCI:

| Alert name | Performance counters used | Unit | Suggested threshold value |
|--|--|--|--|
| Percentage CPU | Hyper-V Hypervisor Logical Processor\\\\% Total Run Time | Percentage | Greater than 80 |
| Available Memory Bytes | Memory\\\Available Bytes | GB | Less than 1 |
| Volume Latency Read | Cluster CSVFS\\\Avg. sec/Read | Milliseconds | Greater than 500 |
| Volume Latency Write | Cluster CSVFS\\\Avg. sec/Write | Milliseconds | Greater than 500 |
| Network In Per Second | Network Adapter\\\Bytes Received/sec | GigaBytesPerSecond | Greater than 500 |
| Network Out Per Second | Network Adapter\\\Bytes Sent/sec | GigaBytesPerSecond | Greater than 200 |

## Next steps

- Learn how to [Create Azure Monitor alert rules](/azure/azure-monitor/alerts/alerts-create-new-alert-rule).
- Learn how to [monitor Azure Stack HCI with Azure Monitor Metrics](./monitor-cluster-with-metrics.md).
