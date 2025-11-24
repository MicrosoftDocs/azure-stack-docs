---
title: About Load Balancers in Multi-Rack Deployments of Azure Local (Preview)
description: Learn about the types of load balancers you can use in multi-rack deployments of Azure Local (Preview).
ms.topic: conceptual
ms.date: 11/24/2025
author: alkohli
ms.author: alkohli
---

# About load balancers in multi-rack deployments of Azure Local (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes the different types of load balancers you can use in multi-rack deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About load balancers

A load balancer is a fully managed service that distributes incoming traffic across backend virtual machines (VMs). It operates at Layer 4 of the Open Systems Interconnection (OSI) model and distributes inbound flows that arrive at the load balancer’s frontend to backend pool instances according to configured load-balancing rules and health probes.

Multi-rack deployments of Azure Local support three types of load balancers:

- **Public load balancer on virtual networks.** Provides inbound connectivity from external networks (internet or enterprise WAN) to VMs (network interfaces). It distributes traffic flows directed to a public frontend IP across a backend pool of VMs in the virtual network.

- **Internal load balancer on virtual networks.** Balances traffic within a virtual network. Use an internal load balancer to provide inbound connectivity to your VMs in private network connectivity scenarios. The internal load balancer uses a private frontend IP.

- **Load balancer on logical networks.** Balances traffic across a backend pool of VMs on the logical network using a public frontend IP.

> [!NOTE]
> A public IP in multi-rack deployments of Azure Local refers to IP space routable within the customer’s network or, optionally, internet-facing. It differs from public IPs in Azure, which must always be internet routable.

## Key characteristics of a load balancer

- Available as a managed Software Defined Networking (SDN) service. You don't need to install or manage a separate load balancer appliance or design for its high availability.
- Supports TCP and HTTP health monitoring to check backend availability and ensure traffic is sent only to healthy instances.
- Supports only IPv4 traffic. IPv6 traffic isn't supported currently.
- Doesn't support Network Address Translation (NAT), both inbound and outbound. For Source Network Address Translation (SNAT) functionality and outbound connectivity, always use a NAT Gateway.

> [!NOTE]
> You can use either a load balancer or configure inbound rules on a NAT Gateway to enable inbound connectivity on Azure Local virtual networks. We recommend that you use a load balancer for inbound connectivity.

## Load balancer configurations

Load balancers in Azure Local are available on both virtual networks and logical networks.

### On virtual networks

Azure Local supports both public and internal load balancers on virtual networks. Multiple load balancers can reside in the same virtual network, but all load balancers of one kind (public or internal) must be assigned to its own delegated subnet. When setting up the first load balancer, use an empty subnet with no other user resources such as NICs or VMs.

- To create an internal load balancer, provide the delegated subnet information (an empty subnet if it's the first instance). A private IP address from this subnet is assigned to the load balancer.

- To create a public load balancer, provide the Azure Resource Manager (ARM) ID of a public IP resource in addition to the delegated subnet. The instance is assigned both the public IP and a private IP from the subnet for internal communication.

Backend pools must be in the same virtual network but can be across different subnets.

### On logical networks

On logical networks, only public load balancers are supported. To create a load balancer on a logical network, provide a public IP address resource from the same logical network. Backend pools must be in the same logical network.

The following table shows the configuration parameters for different types of load balancers:

| Parameter | Public load balancer on virtual network | Internal load balancer on virtual network | Load balancers on logical network |
|--|--|--|--|
| `frontend-ip-subnet-ids` | Required | Required | Omit |
| `frontend-ip-public-ip-ids` | Required<br><br>Must be from the same logical network as the NAT Gateway public IP. | Omit | Required<br><br>Must be from the same logical network. |
| `backend-pool-virtual-network-ids` | Required | Required | Omit |
| `backend-pool-logical-network-ids` | Omit | Omit | Required |