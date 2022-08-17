---
title: Prerequisites for deploying Azure Stack HCI version 22H2 (preview)
description: Learn the prerequisites and pre-deployment steps for deploying Azure Stack HCI version 22H2
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Prerequisites for deploying Azure Stack HCI version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article discusses the software, hardware, and networking prerequisites plus a pre-deployment checklist in order to deploy Azure Stack HCI, version 22H2.

## Software requirements

You must set up the Azure Stack HCI, version 22H2 operating system to boot from a VHDX image file using the instructions in this article.

## Hardware requirements

Before you begin, make sure that the physical hardware used to deploy the solution meets the following requirements:

|Component|Minimum|
|--|--|
|CPU|A 64-bit Intel Nehalem grade or AMD EPYC or later compatible processor with second-level address translation (SLAT).|
|Memory|A minimum of 32 GB RAM.|
|Host network adapters|At least two network adapters listed in the Windows Server Catalog. Or dedicated network adapeters per intent which does requires two separate adapters for storage intent.|
|BIOS|Intel VT or AMD-V must be turned on.|
|Boot drive|A minimum size of 200 GB size.|
|Data drives|At least 3 disks with a minimum capacity of 500 GB (SSD or HDD).|
|TPM|TPM 2.0 hardware must be present and turned on.|
|Secure boot|Secure boot must be present and turned on.|

## Network requirements

Before you begin, make sure that the physical network and the host network where the solution is deployed meet the requirements described in:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)

> [!NOTE]
> Advanced settings within the storage network configuration like iWarp or MTU changes are not supported in this release.

## Active Directory requirements

You will need the following information from your administrator:

- Active directory organizational unit (OU) name
- Active directory domain FQDN
- Active directory cluster name
- Active directory object prefix
- Active directory username and password

> [!NOTE]
> This preview release supports a single Azure Stack HCI deployment per Active Directory domain.

## Pre-deployment checklist

Use the following checking to gather this information ahead of the actual deployment of your Azure Stack HCI cluster.

> [!NOTE]
> This preview release does not support the use of a /26 network size (64-bit address range).

|Component|What is needed|
|--|--|
|Server names|a unique name for each server you wish to deploy.|
|Domain names|an internal domain name.|
|IPv4 subnet for management network intent|A subnet used for the management network. Each host must have an IPv4 address configured from this network.|
|Two IPv4 subnet for storage network intent|Two different subnets used for the storage network.||
|Management VLAN ID|a VLAN ID to be used for the management network, from your IT network administrator.|
|Storage VLAN ID|two unique VLAN IDs to be used for the storage networks, from your IT network administrator.|
|DNS forwarder|A DNS Server that allows DNS forwarding.|
|Time server|A time server used to synchronize the server time with that of Azure.|
|Azure subscription	ID|ID for the Azure subscription used to register the cluster. You must be an administrator on this subscription to manage access to Azure resources.|

## Next step

After reviewing and adhering to the prerequisites, you are ready to install the operating system on each server in your cluster:

- [Install Azure Stack HCI version 22H2](deployment-tool-install-os.md)
