---
title: Overview of Event Hubs on Azure Stack Hub
description: Learn about Event Hubs on Azure Stack Hub, see how to build hybrid solutions, and compare features of Azure Event Hubs and Event Hubs on Azure Stack Hub. 
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: how-to
ms.date: 04/10/2024

---

# Overview of Event Hubs on Azure Stack Hub

Event Hubs on Azure Stack Hub enables hybrid cloud scenarios. Streaming and event-based solutions are supported, for both on-premises and Azure cloud processing. Whether your scenario is hybrid (connected), or disconnected, your solution can support processing of events/streams at large scale. Your scenario is only bound by the Event Hubs cluster size, which you can provision based on your needs.

## Run event processing tasks and build event-driven applications on site

With Event Hubs on Azure Stack Hub, you can implement business scenarios such as:

- AI and machine learning workloads where Event Hubs is the event streaming engine.
- Implement event-driven architectures in your own sites outside the Azure data centers.
- Clickstream analytics for your web applications deployed on-premises.
- Device telemetry analysis.
- Stream processing with open-source frameworks that use Apache Kafka such as Apache Spark, Flink, Storm, and Samza.
- [Consume compute guest OS metrics and events](azure-stack-metrics-monitor.md).

## Build Hybrid solutions

You can build hybrid solutions that ingest and process edge data locally on your Azure Stack Hub. You can also send aggregated data to Azure for further processing, visualization, and storage. If appropriate, you can use serverless computing on Azure.

[![Hybrid solutions diagram](media/event-hubs-overview/hybrid-architecture-ehoash.png)](media/event-hubs-overview/hybrid-architecture-ehoash.png#lightbox)

## Features

The Event Hubs editions (on Azure Stack Hub and on Azure) offer a high degree of feature parity. This parity means SDKs, samples, PowerShell, Azure CLI, and portals offer a similar experience, with a few differences. The following table summarizes the high-level differences in feature availability that exists between editions:  

| Feature | Event Hubs on Azure Stack Hub | Azure Event Hubs |
|-|-|-|-|
| Operator administrator experience | ✔ | ✘ |
| Kafka support | ✔ | ✔ |
| Same set of SDKs | ✔ | ✔ |
| Authorize access to Event Hubs using Microsoft Entra ID | ✘ | ✔ |
| Capture feature | ✘ | ✔ |
| Azure Monitor | ✔ | ✔ |

You can also perform Azure Resource Management operations using Azure Resource Manager templates, [PowerShell](/powershell/module/Az.eventhub/), and [Azure CLI](/cli/azure/eventhubs/eventhub/). Currently, there's no support for operator administration operations in PowerShell and Azure CLI.

## Feature documentation

### User documentation

To get started quickly and create an event hub on an Azure Stack Hub cluster, see [Quickstart: Create an Event Hubs cluster using the Azure Stack Hub portal](event-hubs-quickstart-cluster-portal.md).

In addition, the following [Azure Event Hubs conceptual articles](/azure/event-hubs/) also apply to using Event Hubs on Azure Stack Hub:

- Details on [Event Hubs concepts](/azure/event-hubs/event-hubs-features)
- How to create an [event hub](/azure/event-hubs/event-hubs-create#create-an-event-hub)
- How to stream [using the Kafka protocol](/azure/event-hubs/event-hubs-quickstart-kafka-enabled-event-hubs)

### Operator documentation

For more information about the Event Hubs on Azure Stack Hub operator experience, see the [Event Hubs operator documentation](../operator/event-hubs-rp-overview.md). This documentation provides information on activities such as:

- Installing Event Hubs.
- Making Event Hubs available to users.
- Getting information on the health of the service.
- Collecting logs.

## Next steps

- If Event Hubs isn't available in your subscription, work with your administrator to [install the Event Hubs on Azure Stack Hub resource provider](../operator/event-hubs-rp-overview.md).
- If you have Event Hubs installed and you're ready to use it, consult the [Event Hubs documentation](/azure/event-hubs/event-hubs-about) for more details on the service.
