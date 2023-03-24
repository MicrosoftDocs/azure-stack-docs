---
title: RAS Gateway for Software Defined Networking
description: Learn about Remote Access Service (RAS) Gateway for Software Defined Networking in Azure Stack HCI and Windows Server.
author: AnirbanPaul
ms.author: anpaul
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/24/2022
ms.custom: kr2b-contr-experiment
---
# What is Remote Access Service (RAS) Gateway for Software Defined Networking?

> Applies to: Azure Stack HCI, versions 22H2, 21H2, and 20H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

RAS Gateway is a software-based Border Gateway Protocol (BGP) capable router designed for cloud service providers (CSPs) and enterprises that host multitenant virtual networks using Hyper-V Network Virtualization (HNV). You can use RAS Gateway to route network traffic between a virtual network and another network, either local or remote.

RAS Gateway requires [Network Controller](network-controller-overview.md), which performs the deployment of gateway pools, configures tenant connections on each gateway, and switches network traffic flows to a standby gateway if a gateway fails.

  > [!NOTE]
  > Multitenancy is the ability of a cloud infrastructure to support the virtual machine (VM) workloads of multiple tenants, yet isolate them from each other, while all of the workloads run on the same infrastructure. The multiple workloads of an individual tenant can interconnect and be managed remotely, but these systems do not interconnect with the workloads of other tenants, nor can other tenants remotely manage them.

## Features

RAS Gateway offers many features for virtual private network (VPN), tunneling, forwarding, and dynamic routing.

### Site-to-Site IPsec VPN

This RAS Gateway feature allows you to connect two networks at different physical locations across the Internet by using a Site-to-Site (S2S) virtual private network (VPN) connection. This is an encrypted connection, using IKEv2 VPN protocol.

For CSPs that host many tenants in their datacenter, RAS Gateway provides a multitenant gateway solution that allows tenants to access and manage their resources over site-to-site VPN connections from remote sites. RAS Gateway allows network traffic flow between virtual resources in your datacenter and their physical network.

### Site-to-Site GRE tunnels

Generic Routing Encapsulation (GRE)-based tunnels enable connectivity between tenant virtual networks and external networks. Because the GRE protocol is lightweight and support for GRE is available on most network devices, it's an ideal choice for tunneling where encryption of data isn't required.

GRE support in S2S tunnels solves the problem of forwarding between tenant virtual networks and tenant external networks using a multitenant gateway.

### Layer 3 forwarding

Layer 3 (L3) forwarding enables connectivity between the physical infrastructure in the datacenter and the virtualized infrastructure in the Hyper-V network virtualization cloud. By using L3 forwarding connection, tenant network VMs can connect to a physical network through the Software Defined Networking (SDN) gateway, which is already configured in the SDN environment. In this case, the SDN gateway acts as a router between the virtualized network and the physical network.

Here's an example of the L3 forwarding setup:

This example assumes that you have an Azure Stack HCI cluster, which is already configured with SDN. Your cluster has two virtual networks: Virtual Network1 with address prefix 10.0.0.0/16 and Virtual Network2 with address prefix 16.0.0.0/16. Each virtual network has an L3 connection to the physical network. Because the L3 connections are for different virtual networks, the SDN gateway has a separate compartment for each connection to provide isolation guarantees. Each SDN gateway compartment has one interface in the virtual network space and one interface in the physical network space. Each L3 connection must map to a unique VLAN on the physical network. This VLAN must be different from the HNV PA VLAN, which is used as the underlying data forwarding physical network for virtualized network traffic.

  :::image type="content" source="./media/ras-gateway/layer3-forwarding.png" alt-text="Windows Admin Center showing a feature update ready to install." lightbox="./media/ras-gateway/layer3-forwarding.png":::
Here are the details of each connection used in this example:

| Network element          | Connection 1 | Connection 2 |
|--------------------------|--------------|--------------|
| Gateway subnet prefix    | 10.0.1.0/24  | 16.0.1.0/24  |
| L3 IP address            | 15.0.0.5/24  | 20.0.0.5/24  |
| L3 peer IP address       | 15.0.0.1     | 20.0.0.1     |
| Routes on the connection | 18.0.0.0/24  | 22.0.0.0/24  |

This example uses static routes. For static routing, you must configure a route on the physical network to reach the virtual network. For example, a route with address prefix 10.0.0.0/16 with the next hop as the L3 IP Address of the connection (15.0.0.5/24).

For dynamic routing with BGP, you must still configure a static /32 route because the BGP connection is between the gateway compartment internal interface and the L3 peer IP. For Connection 1, the peering would be between 10.0.1.6 and 15.0.0.1. Hence, for this connection, you need a static route on the physical switch with destination prefix of 10.0.1.6/32 with the next hop as 15.0.0.5.

If you plan to deploy L3 Gateway connections with BGP routing, ensure that you’ve configured the Top of Rack (ToR) switch BGP settings with the following:

- update-source: This specifies the source address for BGP updates, that is L3 VLAN. For example, VLAN 250.
- ebgp multihop: This specifies more hops are required since the BGP neighbor is more than one hop away.

### Dynamic routing with BGP

BGP reduces the need for manual route configuration on routers because it is a dynamic routing protocol, and automatically learns routes between sites that are connected by using site-to-site VPN connections. If your organization has multiple sites that are connected using BGP-enabled routers, such as RAS Gateway, BGP allows the routers to automatically calculate and use valid routes to each other in the event of network disruption or failure.

The BGP Route Reflector included with RAS Gateway provides an alternative to BGP full mesh topology that is required for route synchronization between routers. For more information, see [What Is Route Reflector?](route-reflector-overview.md)

## How RAS Gateway works

RAS Gateway routes network traffic between the physical network and VM network resources, regardless of the location. You can route the network traffic at the same physical location or many different locations.

You can deploy RAS Gateway in high availability pools that use multiple features at once. Gateway pools contain multiple instances of RAS Gateway for high availability and failover.

You can easily scale a gateway pool up or down by adding or removing gateway VMs in the pool. Removal or addition of gateways doesn't disrupt the services that are provided by a pool. You can also add and remove entire pools of gateways. For more information, see [RAS Gateway High Availability](/windows-server/networking/sdn/technologies/network-function-virtualization/ras-gateway-high-availability).

Every gateway pool provides M+N redundancy. This means that 'M' number of active gateway VMs are backed up by 'N' number of standby gateway VMs. M+N redundancy provides you with more flexibility in determining the level of reliability that you require when you deploy RAS Gateway.

You can assign a single public IP address to all pools or to a subset of pools. Doing so greatly reduces the number of public IP addresses that you must use, because it's possible to have all tenants connect to the cloud on a single IP address.

## Next steps

For related information, see also:

- [RAS Gateway Deployment Architecture](/windows-server/networking/sdn/technologies/network-function-virtualization/ras-gateway-deployment-architecture)
- [Network Controller overview](network-controller-overview.md)
- [Plan to deploy Network Controller](network-controller.md)
- [SDN in Azure Stack HCI and Windows Server](software-defined-networking.md)