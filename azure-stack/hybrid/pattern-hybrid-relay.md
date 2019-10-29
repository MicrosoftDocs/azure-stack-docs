---
title: Pattern for implementing a hybrid relay solution using Azure and Azure Stack Hub.
description: Learn how to use Azure and Azure Stack services, to connect to edge resources or devices protected by firewalls.
author: BryanLa
ms.service: azure-stack
ms.topic: article
ms.date: 11/05/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 10/31/2019
---

# Hybrid relay pattern

Learn how to connect to resources or devices at the edge, that are protected by firewalls using Azure Service Bus Relays.

## Context and problem

Edge devices are often behind a corporate firewall or NAT device, leaving them unable to communicate with the public cloud, or edge devices on other corporate networks. However, it may be necessary to expose certain ports and functionality to users in the public cloud in a secure manner. 

## Solution

The hybrid relay pattern uses Azure Service Bus Relays to establish a WebSockets-based tunnel between two endpoints that cannot directly communicate. Devices outside the on-premises environment that wish to connect to an on-premises endpoint will instead connect to an endpoint in  public cloud that redirects the traffic on predefined routes over a secure channel. An endpoint inside the on-premises environment receives the traffic and routes it to the correct destination. 

![hybrid relay solution architecture](media/pattern-hybrid-relay/solution-architecture.png)

Here's how the solution works: 

1. A device connects to the VM in Azure, on a predefined port.
2. Traffic is forwarded to the Service Bus relay.
3. The VM on Azure Stack, which has already established a long-lived connection to the Service Bus Relay receives the traffic and forwards it on to the destination.
4. The on-premises service or endpoint processes the request. 

## Components

This solution uses the following components:

| Layer | Component | Description |
|----------|-----------|-------------|
| Azure Stack Hub | [b]() | c. |
| | b | c |
| | b | c |
| | b | c.<br><br>|
| Azure |  |  |
|  | b | c |

## Issues and considerations

Consider the following points when deciding how to implement this solution:

### Scalability 

To enable this solution to scale across multiple cameras and locations, you'll need to make sure that all of the components can handle the increased load. You may need to take actions such as:


### Availability

Since this solution is tiered, it's important to think about how to deal with networking or power failures. Depending on business needs, it might be appropriate to 

### Manageability

### Security

## Next steps

To learn more about the topics introduced in this article:
- See 
- See 

When you're ready to test the solution example, continue with the [Hybrid relay deployment guide](), which provides step-by-step instructions for deploying and testing its components.