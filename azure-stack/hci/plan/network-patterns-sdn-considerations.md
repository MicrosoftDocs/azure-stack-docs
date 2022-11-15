---
title: Review SDN considerations for network reference patterns
description: Learn about SDN considerations for network reference patterns for Azure Stack HCI.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/10/2022
---

# Review SDN considerations for network reference patterns

[!INCLUDE [includes](../../includes/hci-applies-to-22h2-21h2.md)]

In this article, you'll review considerations when deploying Software Defined Networking (SDN) in your Azure Stack HCI cluster.

## SDN hardware requirements

When using SDN, you must ensure that the physical switches used in your Azure Stack HCI cluster support a set of capabilities that are documented at [Plan a Software Defined Network infrastructure](/concepts/plan-software-defined-networking-infrastructure.md).

If you are using SDN Software Load Balancers (SLB) or Gateway Generic Routing Encapsulation (GRE) gateways, you must also configure Border Gateway Protocol (BGP) peering with the top of rack (ToR) switches so that the SLB and GRE Virtual IP addresses (VIPs) can be advertised. For more information, see [Switches and routers](/concepts/plan-software-defined-networking-infrastructure.md#switches-and-routers).

## SDN Network Controller

SDN Network Controller is the centralized control plane to provision and manage networking services for your Azure Stack HCI workloads. It provides virtual network management, microsegmentation through Network Security Groups (NSGs), management of Quality of Service (QoS) policies, virtual appliance chaining to allow you to bring in third-party appliances, and is also responsible for managing SLB and GRE. SLBs leverage virtual first-party appliances to provide high availability to applications, while and Gateways are used to provide external network connectivity to workloads.

For more information about Network Controller, see [What is Network Controller](/concepts/network-controller-overview).

## SDN configuration options

Based on your requirements, you may need to deploy a subset of the SDN infrastructure. For example, if you want to only host customer workloads in your datacenter, and external communication is not required, you can deploy Network Controller and skip deploying SLB/MUX and gateway VMs. The following describes networking feature infrastructure requirements for a phased deployment of the SDN infrastructure.

|Feature|Deployment requirements|Network requirements|
|--|--|--|
|Logical Network management<br>NSGs for VLAN-based network<br>QoS for VLAN-based networks|Network Controller|None|
|Virtual Networking<br>User Defined Routing<br>ACLs for virtual network<br>Encrypted subnets<br>QoS for virtual networks<br>Virtual network peering|Network Controller|HNV PA VLAN, subnet, router|
|Inbound/Outbound NAT<br>Load Balancing|Network Controller<br>SLB/MUX|BGP on HNV PA network<br>Private and public VIP subnets|
GRE gateway connections|Network Controller<br>SLB/MUX<br>Gateway|BGP on HNV PA network<br>Private and public VIP subnets<br>GRE VIP subnet|
|IPSec gateway connections|Network Controller<br>SLB/MUX<br>Gateway|BGP on HNV PA network<br>Private and public VIP subnets|
|L3 gateway connections|Network Controller<br>SLB/MUX<br>Gateway|BGP on HNV PA network<br>Private and public VIP subnets<br>Tenant VLAN, subnet, router<br>BGP on tenant VLAN optional|

## Next steps

- [Choose a network pattern ](choose-network-pattern.md) to review.