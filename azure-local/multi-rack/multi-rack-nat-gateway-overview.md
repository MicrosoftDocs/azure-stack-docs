---
title: Overview of NAT Gateway on Multi-Rack Deployments of Azure Local (preview)
description: Learn about NAT gateway on multi-rack deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.date: 11/25/2025
ms.topic: overview
ms.subservice: multi-rack
---

# About NAT gateway on multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides an overview of Network Address Translation (NAT) gateway on multi-rack deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## What is NAT gateway on Azure Local?

NAT gateway in multi-rack deployments of Azure Local is a managed egress service that provides outbound connectivity for resources within virtual networks. It's a critical component that enables resources in a virtual network to communicate with external networks, whether that's customer's enterprise network or the internet.

When a subnet is associated with a NAT gateway, Source Network Address Translation (SNAT) is applied to outbound internet traffic from resources in that subnet, translating their source IP addresses to the NAT gateway’s public IP address. The NAT gateway blocks unsolicited inbound connections; only responses to established outbound flows are allowed. To allow specific inbound traffic, you can create Inbound Rule resources as children of the NAT Gateway.

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

- Multiple subnets within the same virtual network can share a single NAT gateway
- You can attach only one NAT gateway to a virtual network and its subnets, but any number of subnets within that virtual network can share the same NAT gateway.
- A NAT gateway can’t span multiple virtual networks. A NAT gateway requires exactly one public IP address. The virtual network's address space must not overlap with the logical network from which the public IP address is allocated.
- The NAT gateway must have at least one virtual network subnet configured for the entire lifetime of the NAT gateway.
- After the NAT gateway is created, its public IP address can't be changed.
- To delete a NAT gateway, delete each virtual network subnet or update each subnet to remove its NAT gateway association.

> [!NOTE]
> NAT gateway and load balancer are independent resources. You can deploy and delete them in any order without dependency on each other.
