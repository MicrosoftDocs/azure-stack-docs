---
title: Checklist for deploying Azure Stack HCI version 22H2 (preview)
description: Follow the pre-deployment checklist for deploying Azure Stack HCI version 22H2
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Checklist for deploying Azure Stack HCI version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

Use the following checking to gather this information ahead of the actual deployment of your Azure Stack HCI cluster.

> [!NOTE]
> This release supports a single Azure Stack HCI deployment per Active Directory domain.

> [!NOTE]
> This release does not support the use of a /26 network size (64-bit address range).

|Component|What is needed|
|--|--|
|Server names|Unique name for each server you wish to deploy.|
|Active Directory cluster name|Name of your cluster in Active Directory.|
Active directory object prefix|Name of the object prefix for the Active Directory domain.|
Active directory OU|Name of the organizational unit (OU) for the Active Directory domain.|
|Active Directory FQDN|Fully-qualified domain name (FQDN) for the Active Directory domain.|
|Active Directory credentials|Username and password for the Active directory account.|
|IPv4 subnet for management network intent|A subnet used for the management network. Each host must have an IPv4 address configured from this network.|
|Two IPv4 subnet for storage network intent|Two different subnets used for the storage network.|
|Management VLAN ID|a VLAN ID to be used for the management network, from your IT network administrator.|
|Storage VLAN ID|two unique VLAN IDs to be used for the storage networks, from your IT network administrator.|
|DNS forwarder|A DNS Server that allows DNS forwarding.|
|Time server|IP address of the Network Protocol Time (NTP) time server used to synchronize the server time with that of Azure.|
|Azure subscription ID|ID for the Azure subscription used to register the cluster. You must be an administrator on this subscription to manage access to Azure resources.|

## Next step

After reviewing the pre-deployment checklist, you are ready to prepare your Active Directory environment:

Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
