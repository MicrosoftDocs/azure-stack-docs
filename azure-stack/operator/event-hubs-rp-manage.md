---
title: How to manage Event Hubs on Azure Stack Hub
description: Learn how to manage the Event Hubs resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 12/09/2019
ms.reviewer: jfggdl
ms.lastreviewed: 12/09/2019
---

# How to manage Event Hubs on Azure Stack Hub

The Event Hubs management experience allows you to control the service and visualize its status and alerts. 

## Overview

Use the following steps to access the Event Hubs management page:

1. Sign in to the Azure Stack Hub administrator portal.
2. Select **All Services** from the pane on the left.
3. Search for "Event Hubs" and select the service. If you cannot find the Event Hubs service, the resource provider must first be [installed](event-hubs-rp-install.md).
4. The Event Hubs management overview page display. You'll find four sections in the left pane:
   - **Overview**: provides a general view and access to specific management areas.
   - **Alerts**: displays all critical and warning alerts for Event Hubs. See the [Alerts section](#alerts) section for details.
   - **Quotas**: allows you to create, update, and delete quotas. See the [Quotas section](#quotas) section for details.
   - **Event Hubs clusters**: displays a list of all clusters configured. See the [Event Hubs clusters](#event-hubs-clusters) section for details.

   [![Manage event hubs](media/event-hubs-rp-manage/1-manage-event-hubs.png)](media/event-hubs-rp-manage/1-manage-event-hubs.png#lightbox)

## Quotas

Selecting **Quotas** on the main page displays a list of alerts issue. The **Quotas** page lists the quotas in use, and the associated plans using the quotas. 
 
[![Manage event hubs - quotas](media/event-hubs-rp-manage/3-quotas.png)](media/event-hubs-rp-manage/3-quotas.png#lightbox)

For more information on quota types defined for Event Hubs, see [Quota Types](azure-stack-quota-types.md#event-hubs-quota-types)

## Alerts

The Event Hubs resource provider supports the following alerts:
   
| Category | Alert | Type | Condition |
|----------|-------|------|-----------|
| Performance | | | |
| | EventHub-CpuUsage | Warning | The average of % CPU usage of Event Hubs cluster in the last 6 hours is larger than 50%. |
| | EventHub-MemoryUsage | Warning | The average of % Data Disk(E:) usage of Event Hubs cluster in the last 6 hours is larger than 50%. |
| | EventHub-DiskUsage | Warning | The average of % free memory space of Event Hubs cluster in the last 6 hours is smaller than 50%. |
| Usage/Quota | | | |
| | EventHub-QuotaExceeded | Warning | A quota exceeded error occurred within the last six hours. |
| | EventHub-NamespaceCreditUsage | Warning | The sum of namespace credit usages in the last six hours is larger than 10000.0. |
| Service degraded | | | |
| | EventHub-InternalServerError | Warning | An internal server error occurred within the last six hours. |
| | EventHub-ServerBusy | Warning | A server busy error occurred in the last six hours. |
| Client | | | |
| | EventHub-ClientError | Warning | A client error occurred in the last six hours. |
| Resource | | | |
| | EventHub-PendingDeletingResources | Warning | The sum of pending deleting resources in the last six hours is larger than 100. |
| | EventHub-ProvisioningQueueLength | Warning | The average of provisioning queue length in the last six hours is larger than 30. |

Selecting **Alerts** on the main page displays the list of alerts issued. Selecting an alert from the list, displays the **Alert details** panel on the right.

[![Manage event hubs - alerts summary](media/event-hubs-rp-manage/2-alerts-summary.png)](media/event-hubs-rp-manage/2-alerts-summary.png#lightbox)

[![Manage event hubs - alerts detail](media/event-hubs-rp-manage/2-alerts-detail.png)](media/event-hubs-rp-manage/2-alerts-detail.png#lightbox)

For more information on Azure Stack Hub monitoring capability, including alerting, see [Monitor Health and Alerts](azure-stack-monitor-health.md). For details on collecting logs, see [Overview of Azure Stack diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md).

::: moniker test
::: moniker-stop

## Event Hubs clusters

Selecting **Event Hubs clusters** on the main page displays a list of available user clusters. The list includes the following for each cluster:

- high-level configuration information
- service health
- backup status

[![Manage event hubs - user resources](media/event-hubs-rp-manage/4-user-resources.png)](media/event-hubs-rp-manage/2-user-resources.png#lightbox)

Selecting a link under **Health** or **Backup** will display detailed information on the state of Event Hubs health and backup status, respectively.

Selecting a link under **Name** displays a list of service limits for the cluster, along with status information across the top. 

[![Manage event hubs - user clusters](media/event-hubs-rp-manage/4-user-clusters.png)](media/event-hubs-rp-manage/3-user-clusters.png#lightbox)

Service limits are configuration parameters that define the operational boundaries of Event Hubs. The service limits available are similar to the ones offered for Azure Event Hubs Dedicated. By selecting the link(s) under **Config value**, you can change the assigned value.

> [!IMPORTANT]
> You should spend time analyzing the full implications before changing service limits. Service limit changes may impact the behavior of your solution that consumes and produces events. Changes may also impact the resource consumption from your Azure Stack capacity.

## Next steps

For more information on:

- The quota types defined for Event Hubs, consult [Quota Types](azure-stack-quota-types.md#event-hubs-quota-types).
- Azure Stack Hub monitoring capabilities, including alerting, refer to [Monitor Health and Alerts](azure-stack-monitor-health.md). 
- Azure Stack Hub log collection, see [Overview of Azure Stack diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md).













