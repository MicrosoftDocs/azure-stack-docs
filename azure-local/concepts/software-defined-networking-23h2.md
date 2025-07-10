---
title: Software defined networking (SDN) in Azure Local, version 23H2
description: Software defined networking (SDN) provides a way to centrally configure and manage networks and network services such as switching, routing, and load balancing in Azure Local.
author: AnirbanPaul
ms.author: anpaul
ms.topic: article
ms.service: azure-local
ms.date: 06/03/2025
---

# Software Defined Networking (SDN) in Azure Local

> Applies to: Azure Local 2311.2 and later; Windows Server 2022, Windows Server 2019, Windows Server 2016

Software defined networking (SDN) provides a way to centrally configure and manage networks and network services such as switching, routing, and load balancing in your data center. You can use SDN to dynamically create, secure, and connect your network to meet the evolving needs of your apps. Operating global-scale datacenter networks for services like Microsoft Azure, which efficiently performs tens of thousands of network changes every day, is possible only because of SDN.

Virtual network elements such as [Hyper-V Virtual Switch](/windows-server/virtualization/hyper-v-virtual-switch/hyper-v-virtual-switch), [Hyper-V Network Virtualization](/windows-server/networking/sdn/technologies/hyper-v-network-virtualization/hyper-v-network-virtualization), [Software Load Balancing](/windows-server/networking/sdn/technologies/network-function-virtualization/software-load-balancing-for-sdn), and [RAS Gateway](/windows-server/networking/sdn/technologies/network-function-virtualization/ras-gateway-for-sdn) are designed to be integral elements of your SDN infrastructure. You can also use your existing SDN-compatible devices to achieve deeper integration between your workloads running in virtual networks and the physical network.

There are three major SDN components, and you can choose which you want to deploy: Network Controller, Software Load Balancer, and Gateway.

## Network Controller

The [Network Controller](/windows-server/networking/sdn/technologies/Software-Defined-Networking-Technologies#network-controller) provides a centralized, programmable point of automation to manage, configure, monitor, and troubleshoot virtual network infrastructure in your data center. The Network Controller must be deployed on its own dedicated VMs.

Deploying Network Controller enables the following functionalities:

- Create and manage virtual networks and subnets. Connect virtual machines (VMs) to virtual subnets.
- Configure and manage micro-segmentation for VMs connected to virtual networks or traditional VLAN-based networks.
- Attach virtual appliances to your virtual networks.
- Configure Quality of Service (QoS) policies for VMs attached to virtual networks or traditional VLAN-based networks.

You have the option to [deploy an SDN Network Controller using SDN Express](../manage/sdn-express.md) PowerShell scripts, or [deploy SDN Network Controller using Windows Admin Center](../deploy/sdn-wizard-23h2.md) after creating a system.

## Software Load Balancing

[Software Load Balancer](software-load-balancer.md) (SLB) can be used to evenly distribute customer network traffic among multiple VMs. It enables multiple machines to host the same workload, providing high availability and scalability. SLB uses [Border Gateway Protocol](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp) to advertise virtual IP addresses to the physical network.

## Gateway

Gateways are used for routing network traffic between a virtual network and another network, either local or remote. Gateways can be used to:

- Create secure site-to-site IPsec connections between SDN virtual networks and external customer networks over the internet.
- Create Generic Routing Encapsulation (GRE) connections between SDN virtual networks and external networks. The difference between site-to-site connections and GRE connections is that the latter is not an encrypted connection. For more information about GRE connectivity scenarios, see [GRE Tunneling in Windows Server](/windows-server/remote/remote-access/ras-gateway/gre-tunneling-windows-server).
- Create Layer 3 connections between SDN virtual networks and external networks. In this case, the SDN gateway simply acts as a router between your virtual network and the external network.

Gateways use [Border Gateway Protocol](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp) to advertise GRE endpoints and establish point-to-point connections. SDN deployment creates a default gateway pool that supports all connection types. Within this pool, you can specify how many gateways are reserved on standby in case an active gateway fails.

## Next steps

For related information, see also:

- [Plan a Software Defined Network infrastructure](./plan-software-defined-networking-infrastructure-23h2.md)
- [Deploy an SDN infrastructure using SDN Express](../deploy/sdn-express-23h2.md)
