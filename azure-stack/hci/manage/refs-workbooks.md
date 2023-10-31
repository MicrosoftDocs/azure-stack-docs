---
title: Monitor Azure Stack HCI features with Insights (preview)
description: Monitor Azure Stack HCI features with Insights (preview).
author: alkohli
ms.author: alkohli
ms.reviewer: saniyaislam
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/31/2023
---

# Monitor Azure Stack HCI features with Insights

> Applies to: Azure Stack HCI, version 23H2 (preview)

This article describes how to use Insights to monitor key Azure Stack HCI features, including Resilient File System (ReFS) deduplication and compression.

For information about monitoring a single Azure Stack HCI cluster and multiple clusters with Insights, see [Monitor a single Azure Stack HCI cluster with Insights](./monitor-hci-single.md) and [Monitor multiple Azure Stack HCI clusters with Insights](./monitor-hci-multi.md).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Sample workbooks for Azure Stack HCI features

Insights for Azure Stack HCI collects logs for different Azure Stack HCI features, which are processed using Kusto Query Language (KQL), and then visualized using the [Azure workbooks](/azure/azure-monitor/visualize/workbooks-overview).

By enabling Insights on your Azure Stack HCI system, you get access to a list of sample workbooks that you can use as-is or as a starting point to create custom workbooks. You can use these workbooks to visualize the collected data and gain insights into the key Azure Stack HCI features, including:

- **ReFS deduplication and compression.** The workbook for this feature helps you analyze data about ReFS deduplication and compression savings, performance impact, and jobs.

## Prerequisites

You must complete the following prerequisites before you can use Insights for monitoring Azure Stack HCI features:

- You must have access to an Azure Stack HCI, version 23H2 (preview) cluster deployed and registered with Azure.

- Your cluster must be Arc-enabled and have Azure Monitor extension installed. For instructions, see [Install an extension via the Azure portal](./arc-extension-management.md#install-an-extension).

- You must have Insights enabled on your Azure Stack HCI cluster. For instructions, see [Enable Insights](./monitor-hci-single.md#enable-insights).

- To monitor the ReFS deduplication and compression feature, you must have at least one volume that has this feature enabled. <!--add link to the ReFS dedup and compression doc.-->

## Work with workbooks

Make sure all the prerequisites are met before using Insights to monitor Azure Stack HCI features.

Once you enable Insights on your Azure Stack HCI cluster, follow these steps to access the sample workbooks:

1. In the Azure portal, browse to your Azure Stack HCI cluster resource page, and then select your cluster.

1. Select **Insights** from the left pane, and then select the **Overview (Preview)** tab.

    This tab provides a list of Azure Stack HCI features available for monitoring, along with descriptions of what is monitored, and the current monitoring status.

    :::image type="content" source="media/refs-workbooks/overview-tab.png" alt-text="Screenshot of the Overview tab." lightbox="media/refs-workbooks/overview-tab.png":::

    The following table describes the different monitoring statuses:

    | Monitoring status | Description |
    |--|--|
    | Enabled | Indicates that the workbook is enabled to retrieve log data from Windows events and performance counters. |
    | Not enabled | Indicates that the workbook is not enabled to collect data and surface insights. This is the default status. You must enable a workbook to use it. |
    | Needs update | Indicates that there are some configuration issues that prevent the workbook from collecting data. This may happen when the required events or data sources are not correctly configured within the workbook. You must update the workbook for it to successfully collect data. |

Based on the monitoring status, you can perform one of these actions:

- Enable a workbook

- Disable a workbook

- Enable or disable multiple workbooks

- Update a workbook

### Enable a workbook

By default, a workbook isn't enabled and the monitoring status is displayed as **Not enabled**.

Enabling a workbook automatically adds the necessary performance counters and Windows event logs to the associated data collection rule (DCR) within the cluster. Once the DCR is configured, you receive a success message, and the feature name changes from plain text to a clickable link on the **Overview (Preview)** tab.

Once you enable a workbook, it takes around 20-30 minutes to start collecting data and show insights.

Follow these steps to enable a workbook and start monitoring the feature:

1. On the **Overview (Preview)** tab, select the feature with the **Not enabled** monitoring status.

    :::image type="content" source="media/refs-workbooks/feature-not-enabled.png" alt-text="Screenshot that shows the status of ReFS deduplication and compression as not enabled." lightbox="media/refs-workbooks/feature-not-enabled.png":::

1. A context pane opens on the right that provides additional details, such as a sample image of the workbook. Select the **Enable** button.

    :::image type="content" source="media/refs-workbooks/enable-feature-monitoring.png" alt-text="Screenshot that shows the Enable button to enable monitoring of the ReFS deduplication and compression feature." lightbox="media/refs-workbooks/enable-feature-monitoring.png":::

1. After you enable a workbook for a feature, the monitoring status for that feature changes from **Not enabled** to **Enabled** and its name changes from plain text to a clickable link. You can select the feature name to open its workbook.

### Disable a workbook

By disabling a workbook, you stop collecting monitoring data associated with that feature. However, this action doesn't affect other event collection on this DCR or previously collected data.

Follow these steps to disable a workbook:

1. On the **Overview (Preview)** tab, select the feature with the **Enabled** monitoring status.

1. On the **Disable selected insights** pane on the right, select the **Disable** button.

    :::image type="content" source="media/refs-workbooks/disable-feature-monitoring.png" alt-text="Screenshot that shows the Disable button to disable monitoring of the ReFS deduplication and compression feature." lightbox="media/refs-workbooks/disable-feature-monitoring.png":::

### Enable or disable multiple workbooks

In addition to enabling or disabling individual workbooks, you can also enable or disable multiple workbooks simultaneously from the **Overview (Preview)** tab.

1. On the **Overview (Preview)** tab, select the checkboxes next to the desired features.

1. Select either **Enable selected** or **Disable selected**. The **Enable selected insights** or **Disable selected insights** pane appears on the right. It displays a list of features that you selected to enable monitoring or disable monitoring.

1. Select either the **Enable** or **Disable** button to enable or disable monitoring for all the selected features at once.

### Update a workbook

On the **Overview (Preview)** tab, if **Monitoring status** of a feature is displayed as **Needs update**, it indicates that there are some configuration issues preventing the workbook to collect data.

Follow these steps to update a workbook:

1. On the **Overview (Preview)** tab, select the **Needs update** link for the feature with the **Needs update** monitoring status.

1. On the right pane, select the **Needs update** button to install the required configuration updates for the workbook.

## Monitor the ReFS deduplication and compression feature

ReFS deduplication and compression is a storage capability that helps save storage space with minimal performance impact. It is a post-process solution and carries out block-level deduplication and compression at a fixed block size based on cluster size. You can enable this feature on hybrid or all flash systems. It targets cache and capacity tiers.

Follow these steps to start monitoring the ReFS deduplication and compression feature:

1. Make sure the [Prerequisites](#prerequisites) are met before you begin to use workbook.

1. Enable the workbook for the ReFS deduplication and compression feature. For instructions, see [Enable workbooks](#enable-a-workbook).

1. Select the feature name from the **Overview (Preview)** tab to open the workbook.

### What data is collected?

Once you enable the ReFS deduplication and compression feature for monitoring, Insights starts collecting the following data:

| Data source           | Data                                          |
|-----------------------|-----------------------------------------------|
| Windows event channel | Microsoft-Windows-ReFSDedupSVC <br> microsoft-windows-sddc-management/operational |
| Performance counters  | CSVFS(\*)/sec <br> CSVFS(\*)/sec <br> CSVFS(\*)Bytes/sec <br> CSVFS(\*)Bytes/sec <br> CSVFS(\*). sec/Read <br> CSVFS(*). sec/Write  |

The workbook for ReFS deduplication and compression comprises various tabs, each serving a specific functionality, as described in the following sections.

### Get started

This tab gives basic information about the workbook and the prerequisites to view the workbook. Review the prerequisites and then select **Got it** to go to the next tab.

:::image type="content" source="media/refs-workbooks/got-it-button.png" alt-text="Screenshot that shows the Get started tab with the Got it button." lightbox="media/refs-workbooks/got-it-button.png":::

### Savings

This tab provides volumes information within a cluster and shows the savings for each volume.

:::image type="content" source="media/refs-workbooks/savings-tab.png" alt-text="Screenshot that shows the Savings tab." lightbox="media/refs-workbooks/savings-tab.png":::

The following table describes the columns under the **Savings per volume** section:

| Column | Description | Example |
|--|--|--|
| Name | The name of the volumes in a cluster. | Volume A |
| Deduplication | Indicates if deduplication is enabled or not. | On/Off |
| Compression | Indicates if compression is enabled or not. | On/Off |
| Volume Size | The size of the volume as specified by the user. | 1 TB |
| Dataset Size | The original size of data on the disk prior to any deduplication and compression optimizations. | 1.92 GB |
| Saved | The number of bytes saved on each volume. | 1.60TB |
| Savings(%) | The saved space divided by the dataset size. | 77% |
| Size On Disk | The total amount of data stored on disk. | 321 GB |
| Usage (%) | The size on disk divided by the total volume size. | 32% |

### Performance

This tab provides details such as read and write input/output operations/second (IOPS) for all the cluster shared volumes (CSV) on a cluster.

:::image type="content" source="media/refs-workbooks/performance-tab.png" alt-text="Screenshot that shows the Performance tab." lightbox="media/refs-workbooks/performance-tab.png":::

| Column | Description | Example |
|--|--|--|
| Volume | Shows the different cluster shared volumes (CSV) in a cluster. | Volume A |
| Read IOPS (Avg) | Gives the average value of input output read operations on a volume. |  |
| Write IOPS (Avg) | Gives the average value of input output write operations on a volume. |  |
| Read Lat. (Avg) | Gives the average value of read latency on a volume. |  |
| Write Lat. (Avg) | Gives the average value of write latency on a volume. |  |
| P95 Read Lat. | Gives the 95th percentile of read latency on a volume. |  |
| P95 Write Lat. | Gives the 95th percentile of write latency on a volume. |

You can select various aggregates like Average, P1st, P5th, P50th, P90th, P95th, 99th, Min, and Max for the different metrics.

### Jobs

This tab shows the jobs performed overtime during the deduplication process and a summary of the job details.

:::image type="content" source="media/refs-workbooks/jobs-tab.png" alt-text="Screenshot that shows the Jobs tab." lightbox="media/refs-workbooks/jobs-tab.png":::

| Column | Description | Example |
|--|--|--|
| Volume | Displays the different CSV in a cluster. | Volume A |
| Status | Indicates the status of the ReFS deduplication. | Success/failed |
| Start time | Displays the time when ReFS deduplication started. | 4/26/2023, 5:10:45 AM |
| End time | Displays the time when ReFS deduplication completed. | 4/26/2023, 6:28:19 AM |
| Duration | Displays the total time taken for ReFS deduplication to finish. | 01 hours 17 mins 33 seconds |
| Scanned blocks | Displays the total scanned blocks. | 283.02 GiB |
| Scanned(%) | Displays the total scanned blocks divided by the total volume size. | 27.64% |

> [!NOTE]
> If you don't see any data, make sure that logs are collected for ReFS deduplication and compression. To do so, go to **Monitor** \> **Associated Data collection rules** Data sources and check that data is being captured from the `Microsoft-Windows-ReFSDedupSVC` log.

## Next steps

- [Monitor a single Azure Stack HCI cluster with Insights](./monitor-hci-single.md)
- [Monitor multiple Azure Stack HCI clusters with Insights](./monitor-hci-multi.md)