---
title: Networking for Arc VM management on Azure Stack HCI
description: Learn the networking concepts for Arc VM management on Azure Stack HCI.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/29/2022
---

# Networking for Arc VM management on Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes networking concepts and limitations for Arc virtual machine (VM) management on Azure Stack HCI. Networking for Arc VM management on Azure Stack HCI consists of the following:

- Arc VM management setup infrastructure.
- Arc VMs deployed from the Azure management plane.

See the following network diagram for details:

:::image type="content" source="./media/arc-vm-management/networking-diagram.png" alt-text="Diagram showing networking for Arc VM management." lightbox="./media/arc-vm-management/networking-diagram.png":::

## Arc VM management infrastructure networking

Setting up Arc VM management on an Azure Stack HCI cluster requires creating and configuring a clustered service (MOC) and an Arc Resource Bridge VM that orchestrates operations on the cluster.

### Clustered service (MOC)

One IP address is required for the clustered service when none of the clustered networks use DHCP allocation. This IP address must be in the same network as the physical hosts of the Azure Stack HCI cluster.

The clustered service also requires an AD object along with a DNS entry. For details, see [Azure Arc VM management FAQs](/manage/faqs-arc-enabled-vms#my-environment-doesnt-support-dns-or-active-directory-updates-how-can-i-successfully-deploy-arc-resource-bridge).

### Arc Resource Bridge

A set of three contiguous IP addresses are required for the Arc Resource Bridge VM network. These Resource Bridge VM network interfaces can be tagged to a specific vLAN. The three IP addresses are as follows, using the preceding network diagram for IP-1, IP-2, and IP-3:

- IP address for the Arc Resource Bridge VM management control plane (IP-1). This is the IP address for the Kubernetes application used for VM management that is running inside the Arc Resource Bridge VM. This IP must be reserved in the VM network.
- IP address for the Arc Resource Bridge VM (IP-2) – IP address assigned to the Arc Resource Bridge VM. Can be obtained using DHCP.
- IP address for Arc Resource Bridge VM updates (IP-3) – IP address assigned to the new Arc Resource Bridge VM when update are performed. Can be obtained using DHCP.

> [!NOTE]
> VM addresses IP-2 and IP-3 are alternated on each update of the Arc Resource Bridge.

## Arc VM networking

VMs created through Azure Arc get their network configuration from the virtual network created by the Azure Stack HCI administrator. This virtual network consists of the following:

- **VM switch** – The virtual switch that is available on every host of the Azure Stack HCI cluster. This is mandatory for creating virtual NICs for the Arc VMs on Azure Stack HCI clusters.
- **vLAN ID** – The vLAN ID on which the VM traffic is isolated. This is an optional parameter and can be used irrespective of the IP allocation method.
- **IP allocation method** – Specifies if the virtual network assigns IP addresses to Arc VMs from addresses allocated through a DHCP server or from a pool of static IPs. The possible options for this parameter are `DHCP` and `Static`.

If static IPs are used, the following additional parameters are important:

|Parameter|Description|Required?|Example|
|---|---|---|---|
|IP Pool Start|Start of range of IP addresses|Mandatory|192.16.0.120|
|IP Pool End|End of range of IP addresses|Mandatory|192.16.0.219|
|DNS Servers|List of DNS servers|Optional|192.16.0.10, 192.16.0.11|
|Gateway|IP address of gateway|Optional|192.16.0.1|
|Subnet Mask|Prefix length of the subnet mask|Optional|192.16.0.0/16|

## Current limitations

- Arc VMs are currently not supported with SDN. Arc Resource Bridge can be deployed on a physical network when the Azure Stack HCI cluster is configured with SDN.
- Only DHCP allocation is supported for Arc VMs.
- Only one virtual network can be created per VM switch.
- Using the Arc Resource Bridge or using Arc VMs behind a network proxy is not supported.

## Next steps

- [What is Azure Arc VM management?](/manage/azure-arc-vm-management-overview)