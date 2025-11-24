---
title: Overview of NAT Gateway on Multi-Rack Deployments of Azure Local (preview)
description: Learn about NAT gateway on multi-rack deployments of Azure Local (preview).
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 11/24/2025
ms.topic: conceptual
---

# About NAT gateway on multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides an overview of Network Address Translation (NAT) gateway on multi-rack deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## What is NAT gateway on Azure Local?

NAT gateway in mult-irack deployments of Azure Local is a fully managed service that provides outbound connectivity for resources within virtual networks. It's a critical component that enables resources in a virtual network to communicate with external networks, whether that's customer's enterprise network or the internet.

NAT gateway blocks unsolicited inbound connections from external networks, except for response packets to outbound requests or traffic that matches a configured inbound rule.

## Key characteristics of NAT gateway

- NAT gateway is the only way a resource in a virtual network can reach any external network.
- NAT gateway provides outbound connectivity at a subnet level. When you associate a virtual network subnet with a NAT gateway, all resources within that subnet automatically use the NAT gateway for outbound communication.
- After you attach NAT gateway to a subnet, it provides outbound connectivity right away, without any changes to the subnet's route table.
- Outbound NAT rules are automatically created. You don't need to provide any input.
- Azure Local supports NAT gateways only on virtual networks, not on logical networks. Resources on logical networks use the default gateway on the logical network instead.
- NAT pinholes remain open based on the state of the underlying TCP connection or UDP packets. Currently, TCP and UDP timeouts aren't configurable.

### NAT gateway connection timeouts

The following table summarizes how long NAT gateway keeps connections open based on protocol and activity:

| Connection Type | Description | Timeout |
|--|--|--|
| TCP connection finished | After a TCP connection finishes, the SNAT port is available for reuse after 120 seconds. | 120s |
| TCP connection established | A TCP connection that's active and running normally can stay open for up to 432,000 seconds (five days) if there’s no activity. | 432,000s (five days) |
| UDP single packet & reply | For UDP traffic that consists of a single request and a single reply, the system keeps track of it for 30 seconds before forgetting it. | 30s |
| UDP stream | If a UDP session involves multiple messages, it stays active for 120 seconds before timing out if no new packets are seen. | 120s |

## NAT gateway configurations

- Multiple subnets within the same virtual network can share a single NAT gateway or use different NAT gateways.
- You can attach only one NAT gateway to a virtual network and its subnets, but any number of subnets within that virtual network can share the same NAT gateway.
- A NAT gateway can’t span multiple virtual networks. In the preview version, a NAT gateway can use only one public IP address. Additionally, the virtual network's address space must not overlap with the logical network from which the public IP address is allocated.
- The NAT gateway must have at least one virtual network subnet configured for the entire lifetime of the load balancer.
- To delete a NAT gateway, first delete any load balancer configured on the same virtual network. Then, delete each virtual network subnet or update each subnet to remove its NAT gateway association.

> [!NOTE]
> You must set up a NAT gateway with a subnet in the same virtual network before you can configure a load balancer.