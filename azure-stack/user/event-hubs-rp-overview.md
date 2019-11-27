---
title: Event Hubs on Azure Stack Hub overview
description: Learn about the Event Hubs resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 11/27/2019
ms.reviewer: jfggdl
ms.lastreviewed: 11/27/2019
---

# Event Hubs on Azure Stack Hub overview

Event Hubs on Azure Stack Hub allow you to realize hybrid cloud scenarios. Streaming and event-based solutions are supported, for both on-premises and Azure cloud processing. Whether your scenario is hybrid (connected), or disconnected, your solution can support processing of events/streams at large scale. Your scenario is only bound by the Event Hubs Cluster size, which you can provision according to your needs. 

## Features 

The different editions of Event Hubs (on Azure Stack Hub and on Azure) offer a high degree of feature parity between them. This parity means all SDKs, samples, PowerShell, CLI, and portals offer a similar experience, differing in only a few instances. The following table summarizes the high-level differences in feature availability that exists between editions.  

| Feature | Event Hubs on Azure Stack Hub | Event Hubs on Azure | Notes |
|-|-|-|-|
| Operator administrator experience | ✔ | ✘ | |
| Kafka support | ✔ | ✔ | |
| Same set of SDKs | ✔ | ✔ | |
| Capture feature | ✘ | ✔ | |
| Geo-disaster recovery | ✘ | ✔ | |
| Azure Monitor | ✘ | ✔ | |
| Auto-inflate feature | ✘ | ✔ | |

In addition, Azure Resource Management operations can be accomplished using Azure Resource Manager templates, [PowerShell](/powershell/module/azurerm.eventhub/), and [Azure CLI](/cli/azure/eventhubs/eventhub/). Currently, there's no support for Operator Administration operations in PowerShell and Azure CLI.

## Feature documentation

The [Azure Event Hubs documentation](/azure/event-hubs/) applies to both editions of Event Hubs: Event Hubs on Azure Stack Hub, and Azure Event Hubs. For example, where the documentation discusses differences based on Azure Event Hubs pricing tiers, refer to the Event Hubs Dedicated cluster documentation. Both the Event Hubs Dedicated offer and Event Hubs on Azure Stack Hub have nearly identical experiences (UI, PowerShell, Azure CLI). For example, the documentation for [creating an Azure Event Hubs Dedicated cluster (public cloud)](/azure/event-hubs/event-hubs-dedicated-cluster-create-portal) is applicable when creating a cluster on Azure Stack Hub.

In general, if you can't find an Event Hubs topic in the [Azure Stack Hub Operator](/azure-stack/operator) and [Azure Stack Hub User](/azure-stack/user) documentation, refer to the [Azure Event Hub](/azure/event-hubs/). In most cases, the Azure Event Hubs documentation should be used when working with the service on the Azure Stack Hub platform.


## Next steps

If it's not available in your subscription, work with your administrator to [install the Event Hubs on Azure Stack Hub resource provider](../operator/event-hubs-rp-overview.md).