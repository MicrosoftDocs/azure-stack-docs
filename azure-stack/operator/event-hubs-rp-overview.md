---
title: Event Hubs on Azure Stack Hub overview
description: Learn about the Event Hubs resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 12/09/2019
ms.reviewer: jfggdl
ms.lastreviewed: 12/09/2019
---

# Event Hubs on Azure Stack Hub overview

Event Hubs on Azure Stack Hub allows you to realize hybrid cloud scenarios. Streaming and event-based solutions are supported, for both on-premises and Azure cloud processing. Whether your scenario is hybrid (connected), or disconnected, your solution can support processing of events/streams at large scale. Your scenario is only bound by the Event Hubs Cluster size, which you can provision according to your needs. 

## Features

See the [Azure Stack Hub User](/azure-stack/user/event-hubs-overview) documentation for a feature comparison, between Event Hubs on Azure Stack vs. Azure.

## Feature documentation

The [Azure Event Hubs documentation](/azure/event-hubs/) applies to both editions of Event Hubs: Event Hubs on Azure Stack Hub, and Azure Event Hubs. For example, where the documentation discusses differences based on Azure Event Hubs pricing tiers, refer to the Event Hubs Dedicated cluster documentation. Both the Event Hubs Dedicated offer and Event Hubs on Azure Stack Hub have nearly identical experiences (UI, PowerShell, Azure CLI). For example, the documentation for [creating an Azure Event Hubs Dedicated cluster (public cloud)](/azure/event-hubs/event-hubs-dedicated-cluster-create-portal) is applicable when creating a cluster on Azure Stack Hub.

If you can't find an Event Hubs topic in the [Azure Stack Hub Operator](/azure-stack/operator/event-hubs-rp-overview.md) and [Azure Stack Hub User](/azure-stack/user/event-hubs-overview.md) documentation, refer to the [Azure Event Hub](/azure/event-hubs/) documentation. In most cases, the Azure Event Hubs documentation should be used when working with the service on the Azure Stack Hub platform.


## Next steps

Review [Capacity planning for Event Hubs on Azure Stack Hub](event-hubs-rp-capacity-planning.md), before beginning the installation process. Understanding capacity planning will help you ensure your users have the capacity they require.