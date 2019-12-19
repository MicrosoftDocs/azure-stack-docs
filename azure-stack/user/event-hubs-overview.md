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

| Feature | Event Hubs on Azure Stack Hub | Azure Event Hubs |
|-|-|-|-|
| Operator administrator experience | ✔ | ✘ |
| Kafka support | ✔ | ✔ |
| Same set of SDKs | ✔ | ✔ |
| Capture feature | ✘ | ✔ |
| Geo-disaster recovery | ✘ | ✔ |
| Azure Monitor | ✔ | ✔ |
| Auto-inflate feature | ✘ | ✔ |

In addition, Azure Resource Management operations can be accomplished using Azure Resource Manager templates, [PowerShell](/powershell/module/azurerm.eventhub/), and [Azure CLI](/cli/azure/eventhubs/eventhub/). Currently, there's no support for Operator Administration operations in PowerShell and Azure CLI.

## Feature documentation

The [Azure Event Hubs documentation](/azure/event-hubs/) applies to both editions of Event Hubs: Event Hubs on Azure Stack Hub, and Azure Event Hubs. This documentation contains topics on using Event Hubs and activities such as:

- Details on [Event Hubs concepts](/azure/event-hubs/event-hubs-features)
- How to [create an Event Hubs cluster and namespace](/azure/event-hubs/event-hubs-dedicated-cluster-create-portal)
- How to create an [event hub](/azure/event-hubs/event-hubs-create#create-an-event-hub)
- How to stream [using the Kafka protocol](/azure/event-hubs/event-hubs-quickstart-kafka-enabled-event-hubs)

### Operator documentation 
 
To learn more about the Event Hubs on Azure Stack Hub operator experience, refer to the [Event Hubs operator documentation](/azure-stack/operator/event-hubs-rp-overview). This documentation provides information on activities such as:

- Installing Event Hubs.
- Making Event Hubs available to users.
- Getting information on the health of the service.
- Collecting logs.


## Next steps

If it's not available in your subscription, work with your administrator to [install the Event Hubs on Azure Stack Hub resource provider](../operator/event-hubs-rp-overview.md).

If you have Event Hubs installed and you're ready to use it, consult the [Event Hubs documentation](/azure/event-hubs/event-hubs-about) for more details on the service.
