---
title: Networking requirements for Azure Stack HCI
description: How to choose and configure networking for Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/15/2020
---

# Networking requirements for Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2

An Azure Stack HCI cluster requires a reliable high-bandwidth, low-latency network connection between each server node. 

## Considerations and recommendations

You should verify the following:

- Verify at least one network adapter is available and dedicated for cluster management.
- Verify that physical switches in your network are configured to allow traffic on any VLANs you will use.

There are multiple types of communication going on between server nodes:

- Cluster communication (node joins, cluster updates, registry updates)
- Cluster Heartbeats
- Cluster Shared Volume (CSV) redirected traffic
- Live migration traffic for virtual machines

With Storage Spaces Direct, there is additional network traffic to consider:

- Storage Bus Layer (SBL) – extents, or data, spread out between the nodes
- Health – monitoring and managing objects (nodes, drives, network cards, Cluster Service)

For stretched clusters, there is also additional Storage Replica traffic flowing between the sites. Storage Bus Layer (SBL) and Cluster Shared Volume (CSV) traffic does not go between sites, only between the server nodes within each site.

For host networking planning considerations and requirements, see [Plan host networking for Azure Stack HCI](../concepts/plan-host-networking.md).

## Software Defined Networking requirements

When you create an Azure Stack HCI cluster using Windows Admin Center, you have the option to deploy Network Controller to enable Software Defined Networking (SDN). If you intend to use SDN on Azure Stack HCI:

- Make sure the host servers have at least 50-100 GB of free space to create the Network Controller virtual machines.

- You must copy a virtual hard disk (VHD) of the Azure Stack HCI operating system to the first node in the cluster in order to create the Network Controller VMs. You can prepare the VHD using [Sysprep](/windows-hardware/manufacture/desktop/sysprep-process-overview) or by running the [Convert-WindowsImage](https://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f) script to convert an .iso file into a VHD.

For more information about preparing for using SDN in Azure Stack HCI, see [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md) and [Plan to deploy Network Controller](../concepts/network-controller.md).

## Domain requirements

There are no special domain functional level requirements for Azure Stack HCI - just an operating system version for your domain controller that's still supported. We do recommend turning on the Active Directory Recycle Bin feature as a general best practice, if you haven't already. to learn more, see [Active Directory Domain Services Overview](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview).

## Next steps

For related information, see also:

- [Server requirements for Azure Stack HCI](server-requirements.md)
- [Storage requirements for Azure Stack HCI](storage-requirements.md)