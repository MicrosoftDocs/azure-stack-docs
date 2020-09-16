---
title: Software defined networking (SDN) in Azure Stack HCI
description: An overview of SDN topics that apply to features in Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/18/2020
---

# SDN in Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019

Software defined networking (SDN) provides a way to centrally configure and manage networks and network services such as switching, routing, and load balancing in your data center. You can use SDN to dynamically create, secure, and connect your network to meet the evolving needs of your apps. Operating global-scale datacenter networks for services like Microsoft Azure, which efficiently performs tens of thousands of network changes every day, is possible only because of SDN.

Virtual network elements such as [Hyper-V Virtual Switch](/windows-server/virtualization/hyper-v-virtual-switch/hyper-v-virtual-switch), [Hyper-V Network Virtualization](/windows-server/networking/sdn/technologies/hyper-v-network-virtualization/hyper-v-network-virtualization), [Software Load Balancing](/windows-server/networking/sdn/technologies/network-function-virtualization/software-load-balancing-for-sdn), and [RAS Gateway](/windows-server/networking/sdn/technologies/network-function-virtualization/ras-gateway-for-sdn) are designed to be integral elements of your SDN infrastructure. You can also use your existing SDN-compatible devices to achieve deeper integration between your workloads running in virtual networks and the physical network.

There are three major SDN components on Azure Stack HCI, and you can choose which you want to deploy: Network Controller, Software Load Balancer, and Gateway.

## Network Controller

The [Network Controller](/windows-server/networking/sdn/technologies/Software-Defined-Networking-Technologies#network-controller) provides a centralized, programmable point of automation to manage, configure, monitor, and troubleshoot virtual network infrastructure in your data center. It’s a highly scalable server role that uses Service Fabric to provide high availability. The Network Controller must be deployed on its own dedicated VMs.

Deploying Network Controller enables the following functionalities:

- Create and manage virtual networks and subnets. Connect virtual machines (VMs) to virtual subnets.
- Configure and manage micro-segmentation for VMs connected to virtual networks or traditional VLAN-based networks.
- Attach virtual appliances to your virtual networks.
- Configure Quality of Service (QoS) policies for VMs attached to virtual networks or traditional VLAN-based networks.

We recommend [deploying the Network Controller using PowerShell](../deploy/network-controller-powershell.md) after creating an Azure Stack HCI cluster.

## Software Load Balancing

[Software Load Balancing](/windows-server/networking/sdn/technologies/network-function-virtualization/software-load-balancing-for-sdn) (SLB) can be used to evenly distribute customer network traffic among multiple VMs. It enables multiple servers to host the same workload, providing high availability and scalability. SLB uses [Border Gateway Protocol](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp) to advertise virtual IP addresses to the physical network.

## Gateway

Gateways are used for routing network traffic between a virtual network and another network, either local or remote. Gateways can be used to:

- Create secure site-to-site IPsec connections between SDN virtual networks and external customer networks over the internet.
- Create Generic Routing Encapsulation (GRE) connections between SDN virtual networks and external networks. The difference between site-to-site connections and GRE connections is that the latter is not an encrypted connection. For more information about GRE connectivity scenarios, see [GRE Tunneling in Windows Server](/windows-server/remote/remote-access/ras-gateway/gre-tunneling-windows-server).
- Create Layer 3 connections between SDN virtual networks and external networks. In this case, the SDN gateway simply acts as a router between your virtual network and the external network.

Gateways use [Border Gateway Protocol](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp) to advertise GRE endpoints and establish point-to-point connections. SDN deployment creates a default gateway pool that supports all connection types. Within this pool, you can specify how many gateways are reserved on standby in case an active gateway fails.

## Next steps

For related information, see also:

- [SDN in Windows Server overview](/windows-server/networking/sdn/software-defined-networking)
- [Deploy a Software Defined Network infrastructure using scripts](/windows-server/networking/sdn/deploy/deploy-a-software-defined-network-infrastructure-using-scripts)
