---
title: Overview of RAS Gateway in Azure Stack HCI and Windows Server
description: Use this topic to learn about RAS Gateway for Software Defined Networking in Azure Stack HCI and Windows Server.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/02/2021
---
# What is RAS Gateway for Software Defined Networking?

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019; Windows Server 2016

Remote Access Service (RAS) Gateway is a software-based Border Gateway Protocol (BGP) capable router designed for cloud service providers (CSPs) and enterprises that host multitenant virtual networks using Hyper-V Network Virtualization (HNV). You can use RAS Gateway to route network traffic between a virtual network and another network, either local or remote.

RAS Gateway requires [Network Controller](network-controller-overview.md), which performs the deployment of gateway pools, configures tenant connections on each gateway, and switches network traffic flows to a standby gateway in the event of a gateway failure.

  > [!NOTE]
  > Multitenancy is the ability of a cloud infrastructure to support the virtual machine (VM) workloads of multiple tenants, yet isolate them from each other, while all of the workloads run on the same infrastructure. The multiple workloads of an individual tenant can interconnect and be managed remotely, but these systems do not interconnect with the workloads of other tenants, nor can other tenants remotely manage them.

## RAS Gateway features

RAS Gateway offers a number of features for virtual private network (VPN), tunneling, forwarding, and dynamic routing.

### Site-to-Site IPsec VPN

This RAS Gateway feature allows you to connect two networks at different physical locations across the Internet by using a Site-to-Site (S2S) virtual private network (VPN) connection. This is an encrypted connection, using IKEv2 VPN protocol.

For CSPs that host many tenants in their datacenter, RAS Gateway provides a multitenant gateway solution that allows tenants to access and manage their resources over site-to-site VPN connections from remote sites. RAS Gateway allows network traffic flow between virtual resources in your datacenter and their physical network.

### Site-to-Site GRE tunnels

Generic Routing Encapsulation (GRE)-based tunnels enable connectivity between tenant virtual networks and external networks. Because the GRE protocol is lightweight and support for GRE is available on most network devices, it is an ideal choice for tunneling where encryption of data is not required.

GRE support in S2S tunnels solves the problem of forwarding between tenant virtual networks and tenant external networks using a multitenant gateway.

### Layer 3 forwarding

Layer 3 (L3) forwarding enables connectivity between the physical infrastructure in the datacenter and the virtualized infrastructure in the Hyper-V network virtualization cloud. Using L3 forwarding connection, tenant network VMs can connect to a physical network through the SDN gateway, which is already configured in a software defined networking (SDN) environment. In this case, the SDN gateway acts as a router between the virtualized network and the physical network.

### Dynamic routing with BGP

BGP reduces the need for manual route configuration on routers because it is a dynamic routing protocol, and automatically learns routes between sites that are connected by using site-to-site VPN connections. If your organization has multiple sites that are connected using BGP-enabled routers such as RAS Gateway, BGP allows the routers to automatically calculate and use valid routes to each other in the event of network disruption or failure.

The BGP Route Reflector included with RAS Gateway provides an alternative to BGP full mesh topology that is required for route synchronization between routers. For more information, see [What Is Route Reflector?](route-reflector-overview.md)

## How RAS Gateway works

RAS Gateway routes network traffic between the physical network and VM network resources, regardless of the location. You can route the network traffic at the same physical location or many different locations.

You can deploy RAS Gateway in high availability pools that use multiple features at once. Gateway pools contain multiple instances of RAS Gateway for high availability and failover.

You can easily scale a gateway pool up or down by adding or removing gateway VMs in the pool. Removal or addition of gateways does not disrupt the services that are provided by a pool. You can also add and remove entire pools of gateways. For more information, see [RAS Gateway High Availability](/windows-server/networking/sdn/technologies/network-function-virtualization/ras-gateway-high-availability).

Every gateway pool provides M+N redundancy. This means that 'M' number of active gateway VMs are backed up by 'N' number of standby gateway VMs. M+N redundancy provides you with more flexibility in determining the level of reliability that you require when you deploy RAS Gateway.

You can assign a single public IP address to all pools or to a subset of pools. Doing so greatly reduces the number of public IP addresses that you must use, because it is possible to have all tenants connect to the cloud on a single IP address.

## Next steps

For related information, see also:

- [RAS Gateway Deployment Architecture](/windows-server/networking/sdn/technologies/network-function-virtualization/ras-gateway-deployment-architecture)
- [Network Controller overview](network-controller-overview.md)
- [Plan to deploy Network Controller](network-controller.md)
- [SDN in Azure Stack HCI and Windows Server](software-defined-networking.md)