---
title: Checklist for deploying Azure Stack HCI version 22H2 (preview)
description: Follow the pre-deployment checklist for deploying Azure Stack HCI version 22H2
author: dansisson
ms.topic: how-to
ms.date: 08/29/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Checklist for deploying Azure Stack HCI version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

Use the following checking to gather this information ahead of the actual deployment of your Azure Stack HCI cluster.

> [!NOTE]
> This release supports one Azure Stack HCI deployment per Active Directory domain.

## Pre-deployment checklist

|Component|What is needed|
|--|--|
|Server names|Unique name for each server you wish to deploy.|
|Active Directory cluster name|Name of your cluster in Active Directory.|
Active directory object prefix|Name of the object prefix for the Active Directory domain.|
Active directory OU|Name of the organizational unit (OU) for the Active Directory domain.|
|Active Directory FQDN|Fully-qualified domain name (FQDN) for the Active Directory domain.|
|Active Directory credentials|Username and password for the deployment user pre-created in the Active directory account.|
|IPv4 network range subnet for management network intent|A subnet IPv4 range with a minimum of one IP Address for the cluster used for the management network. Each host must have an IPv4 address configured from this network.|
|Storage VLAN ID|two unique VLAN IDs to be used for the storage networks, from your IT network administrator.|
|DNS Server|A DNS Server that resolves Active Directory.|
|Time server|IP address of the Network Protocol Time (NTP) time server used to synchronize the server time with that of Azure.|
|Azure subscription ID|ID for the Azure subscription used to register the cluster. You must be an administrator on this subscription to manage access to Azure resources.|

## Next steps

After reviewing the pre-deployment checklist, you are ready to prepare your Active Directory environment:

Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
