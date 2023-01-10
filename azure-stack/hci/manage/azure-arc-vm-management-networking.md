---
title: Understanding Azure Arc VM management networking on Azure Stack HCI
description: Learn the networking concepts for Azure Arc VM management on Azure Stack HCI.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/19/2022
---

# Understanding Azure Arc VM management networking on Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes networking concepts for Azure Arc virtual machine (VM) management on Azure Stack HCI.

## Introduction to Azure Arc management networking

Networking for Azure Arc VM management on Azure Stack HCI consists of the following:

- Network for Azure VM management infrastructure.
- Network for VMs deployed using Azure Arc VM management.

See the following network diagram for details:

:::image type="content" source="./media/azure-arc-vm-management-networking/networking-diagram.png" alt-text="Diagram showing networking for Arc VM management." lightbox="./media/azure-arc-vm-management-networking/networking-diagram.png":::

## Network for Arc VM management infrastructure

To set up Azure Arc VM management infrastructure on an Azure Stack HCI cluster, you are required to create and configure the following:

- A cloud agent clustered service.
- An Arc Resource Bridge VM that orchestrates operations on the cluster.

|Component|Network|IP addresses|
|--|--|--|
|Clustered service|Physical network|One IP - *CloudserviceIP*|
|Arc Resource Bridge VM|VM network| Three IPs - *ControlPlaneIP*, *VMIP_1*, *VMIP_2*|

The networking requirements for each of the preceding components are discussed in the following sections.  

### Clustered service

Setting up Arc VM management requires an agent to run on every host of the Azure Stack HCI cluster. This agent is installed as a Failover Cluster generic clustered service. For more information, see [Failover cluster networking basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005).

The IP address for this clustered service is assigned using `CloudServiceIP`. The IP address is required if the underlay network of the physical hosts does not provide DHCP. This IP address should be in the same network as the physical hosts of the Azure Stack HCI cluster.

The clustered service also requires an AD object along with a DNS entry. For details, see [Azure Arc VM management FAQs](faqs-arc-enabled-vms.md#my-environment-doesnt-support-dns-or-active-directory-updates-how-can-i-successfully-deploy-arc-resource-bridge).

### Arc Resource Bridge

A set of three contiguous IP addresses are required for the Azure Arc Resource Bridge VM network. These network interfaces can be tagged to a specific vLAN:

- IP address used for the Arc Resource Bridge load balancer  (*ControlPlaneIP*). This is the IP address of the Kubernetes API server hosting the VM management application that is running inside the Resource Bridge VM. The IP address needs to be in the VM network of the Azure Stack HCI cluster. The IP address must be excluded from the DHCP scope and should be reserved.

- IP address for the Arc Resource Bridge VM (*VMIP_1* and *VMIP_2*). These IP addresses are used to assign to the Arc Resource Bridge VM. The IP addresses may be allocated using static or DHCP configuration and must be in the VM network of the Azure Stack HCI cluster.

> [!NOTE]
> When an Arc Resource Bridge VM is deployed, it uses one of these IP addresses. During an update of Arc Resource Bridge, a new VM is created and assigned the unused IP address. After the update is complete, the original IP address will be released and used in a subsequent update.

## Arc VM virtual network

VMs deployed using Azure Arc VM management get their network configuration from the virtual network created on the Azure Stack HCI cluster. This virtual network is created by the administrator of the cluster and consists of the following:

- **VM switch** – The virtual switch that is available on every host of the Azure Stack HCI cluster. This switch is mandatory for creating virtual NICs for the Arc VMs on the Azure Stack HCI cluster. This switch must be of the type `External`.
- **vLAN ID** – The vLAN ID on which the VM traffic is isolated. This is an optional parameter and can be used irrespective of the IP allocation method used.
- **IP allocation method** – Specifies if the virtual network assigns IP addresses to Azure Arc VMs from addresses allocated through a DHCP server or from a pool of static IPs. The possible options for this parameter are `DHCP` and `Static`.

If the IP allocation method is `static`, the following additional parameters are relevant:

|Parameter|Description|Required?|Example|
|---|---|---|---|
|IPPoolStart|Start of range of IP addresses|Yes|192.16.0.120|
|IPPoolEnd|End of range of IP addresses|Yes|192.16.0.219|
|DNSServers|List of DNS servers|No|192.16.0.10, 192.16.0.11|
|Gateway|IP address of gateway|No|192.16.0.1|
|SubnetMask|Prefix length of the subnet mask|No|192.16.0.0/16|

At the time of creating a network interface, you assign either a dynamic or a static IP address. In a dynamic configuration, the IP address to the network interface is allocated from the VM network. In a static configuration, you choose the virtual network and provide details such as IP address, DNS server, gateway, and subnet mask. The provided information must match the underlying virtual network.

## Current limitations

- Azure Arc VMs are currently not supported with Software Defined Networking (SDN). The Azure Arc Resource Bridge can be deployed on a physical network when the Azure Stack HCI cluster is configured with SDN.
- Only DHCP IP allocation is supported for the virtual network.
- Only one virtual network can be created per VM switch.
- Using Azure Arc VMs behind a network proxy server is not supported; however, using an Arc Resource Bridge behind a network proxy is supported.

## Next steps

- [What is Azure Arc VM management?](azure-arc-vm-management-overview.md)
