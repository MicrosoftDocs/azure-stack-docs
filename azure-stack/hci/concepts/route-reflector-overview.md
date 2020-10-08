---
title: Overview of BGP Route Reflector in Azure Stack HCI
description: Use this topic to learn about BGP Route Reflector for Software Defined Networking in Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/8/2020
---

# What is Route Reflector?

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

Border Gateway Protocol (BGP) Route Reflector is included with [Remote Access Service (RAS) Gateway](gateway-overview.md) and provides an alternative to BGP full mesh topology that is required for route synchronization between routers. A Route Reflector in a Software Defined Networking deployment is a logical entity that sits on the control plane between the RAS Gateways and the [Network Controller](network-controller-overview). It does not, however, participate in data plane routing.

## How Route Reflector works

With full mesh synchronization, all BGP routers must connect with all other routers in the routing topology. When you use Route Reflector, however, the Route Reflector is the only router that connects with all of the other routers, called BGP Route Reflector clients, thereby simplifying route synchronization and reducing network traffic. The Route Reflector learns all routes, calculates best routes, and redistributes the best routes to its BGP clients.

You can configure an individual tenant's remote access tunnels to terminate on more than one RAS Gateway virtual machine (VM). This provides increased flexibility for Cloud Service Providers (CSPs) in situations where one RAS Gateway VM cannot meet all of the bandwidth requirements of the tenant connections.

This capability, however, introduces the additional complexity of route management and effective synchronization of routes between the tenant remote sites and their virtual resources in the cloud datacenter. Providing tenants with connections to multiple RAS Gateways also introduces additional complexity in configuration at the enterprise end, where each tenant site will have separate routing neighbors.

A BGP Route Reflector in the control plane addresses these problems and makes the CSP internal fabric deployment transparent to the enterprise tenants.

- When you add a new tenant to your datacenter, Network Controller automatically configures the first tenant RAS Gateway as a Route Reflector.

- Each tenant has a corresponding Route Reflector, and it resides on one of the RAS Gateway VMs that are associated with that tenant.

- A tenant Route Reflector acts as the Route Reflector for all of the RAS Gateway VMs that are associated with the tenant. Tenant gateways other than the RAS Gateway Route Reflector are the Route Reflector Clients. The Route Reflector performs route synchronization between all Route Reflector Clients so that the actual data path routing can occur.

- A Route Reflector does not provide services for the RAS Gateway upon which it is configured.

- A Route Reflector updates Network Controller with the enterprise routes that correspond to the tenant's enterprise sites. This allows Network Controller to configure the required Hyper-V Network Virtualization policies on the tenant virtual network for End-to-End Data Path access.

- If your Enterprise customers use BGP Routing in the Customer Address space, the RAS Gateway Route Reflector is the only external BGP (eBGP) neighbor for all of the sites of the corresponding tenant. This is true regardless of the Enterprise tenant's tunnel termination points. In other words, no matter which RAS Gateway VM in the CSP datacenter terminates the site-to-site VPN tunnel for a tenant site, the eBGP Peer for all the tenant sites is the Route Reflector.

## Next steps

For related information, see also:

- [RAS Gateway overview](gateway-overview.md)
- [RAS Gateway Deployment Architecture](/windows-server/networking/sdn/technologies/network-function-virtualization/ras-gateway-deployment-architecture)
- [Internet Engineering Task Force (IETF) Request for Comments topic RFC 4456 BGP Route Reflection: An Alternative to Full Mesh Internal BGP](https://tools.ietf.org/html/rfc4456)