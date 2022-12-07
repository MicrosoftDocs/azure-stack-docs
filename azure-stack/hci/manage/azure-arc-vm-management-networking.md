---
title: Understanding Azure Arc VM management networking on Azure Stack HCI
description: Learn the networking concepts for Azure Arc VM management on Azure Stack HCI.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/07/2022
---

# Understanding Azure Arc VM management networking on Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes networking concepts for Azure Arc virtual machine (VM) management on Azure Stack HCI.

## Introduction to Azure Arc management networking

Networking for Azure Arc VM management on Azure Stack HCI consists of the following:

- Network for Azure Arc VM management
- Virtual network for Azure Arc VMs

See the following network diagram for details:

:::image type="content" source="./media/azure-arc-vm-management-networking/networking-diagram.png" alt-text="Diagram showing networking for Arc VM management." lightbox="./media/azure-arc-vm-management-networking/networking-diagram.png":::

## Azure Arc VM management network

To set up Azure Arc VM management infrastructure networking on an Azure Stack HCI cluster, you are required to create and configure the following:

- A cloud agent clustered service.
- An Azure Arc Resource Bridge VM that orchestrates operations on the cluster.

The networking requirements for each of the preceding components are discussed in the following sections.  

### Clustered service

The Arc Resource Bridge requires a cloud agent to run on the host. This cloud agent is installed as a Failover Cluster generic clustered service. For more information, see [Failover cluster networking basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005).

`Cloudagent IP`, also known as `cloudServiceIP`, is the IP address for this clustered service, which hosts the cloud agent. The IP address is required only for static IP configurations on the underlay network for the physical hosts. The IP address must be in the same network as the physical hosts of the Azure Stack HCI cluster.

The clustered service also requires an AD object along with a DNS entry. For details, see [Azure Arc VM management FAQs](/manage/faqs-arc-enabled-vms#my-environment-doesnt-support-dns-or-active-directory-updates-how-can-i-successfully-deploy-arc-resource-bridge).

### Azure Arc Resource Bridge

A set of three contiguous IP addresses are required for the Azure Arc Resource Bridge VM network. These network interfaces can be tagged to a specific vLAN. The three IP addresses are as follows, using the preceding network diagram example for IP-1, IP-2, and IP-3:

- IP address used for the load balancer in the Arc Resource Bridge (**IP-1**). Also known as `controlPlaneIP`, this IP address is specifically used by the Kubernetes management application that is running on the Arc Resource Bridge VM. This IP address needs to be in the same subnet as the DHCP scope for VMs and must be excluded from the DHCP scope to avoid IP address conflicts. If DHCP is used to assign the control plane IP, then the IP address must be reserved on the VM network.

- IP address for the Arc Resource Bridge VM (**IP-2**). This is the IP address assigned to the Arc Resource Bridge VM. You can obtain this IP address using DHCP.

- IP address for Arc Resource Bridge VM updates (**IP-3**). This is the IP address assigned to the new Arc Resource Bridge VM instance when an update is performed. You can obtain this IP address using DHCP.

> [!NOTE]
> As an in-place upgrade of the Arc Resource Bridge is not supported, a new VM instance is created for this purpose using address IP-3. In this way, the IP-2 and IP-3 addresses are alternated each time the Arc Resource Bridge VM is updated.

## Azure Arc VM virtuaL network

VMs deployed from the Azure Arc management plane get their network configuration from the virtual network created on the Azure Stack HCI cluster. This virtual network consists of the following:

- **VM switch** – The virtual switch that is available on every host of the Azure Stack HCI cluster. This switch is mandatory for creating virtual NICs for the Arc VMs on the Azure Stack HCI cluster. This switch must be of the type `External`.
- **vLAN ID** – The vLAN ID on which the VM traffic is isolated. This is an optional parameter and can be used irrespective of the IP allocation method used. ou can get the vLAN ID from your network administrator.
- **IP allocation method** – Specifies if the virtual network assigns IP addresses to Azure Arc VMs from addresses allocated through a DHCP server or from a pool of static IPs. The possible options for this parameter are `DHCP` and `Static`.

If static IPs are used, the following additional parameters are relevant:

|Parameter|Description|Required?|Example|
|---|---|---|---|
|IPPoolStart|Start of range of IP addresses|Yes|192.16.0.120|
|IPPoolEnd|End of range of IP addresses|Yes|192.16.0.219|
|DNSServers|List of DNS servers|No|192.16.0.10, 192.16.0.11|
|Gateway|IP address of gateway|No|192.16.0.1|
|SubnetMask|Prefix length of the subnet mask|No|192.16.0.0/16|

## Current limitations

- Azure Arc VMs are currently not supported with Software Defined Networking (SDN). The Azure Arc Resource Bridge can be deployed on a physical network when the Azure Stack HCI cluster is configured with SDN.
- Only DHCP IP allocation is supported for Azure Arc VMs.
- Only one virtual network can be created per VM switch.
- Using the Azure Arc Resource Bridge or using Azure Arc VMs behind a network proxy is not supported.

## Next steps

- [What is Azure Arc VM management?](/manage/azure-arc-vm-management-overview)