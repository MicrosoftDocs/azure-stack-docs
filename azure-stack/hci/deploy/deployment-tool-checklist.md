---
title: Deployment checklist for Azure Stack HCI version 22H2 via the supplemental package (preview) 
description: Follow the pre-deployment checklist for deploying Azure Stack HCI version 22H2 (preview).
author: dansisson
ms.topic: article
ms.date: 10/24/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Get the checklist for deploying Azure Stack HCI version 22H2 using the supplemental package (preview)

> Applies to: Azure Stack HCI, version 22H2

Use the following checklist to gather this information ahead of the actual deployment of your Azure Stack HCI cluster.


## Pre-deployment checklist

|Component|What is needed|
|--|--|
|Server names|Unique name for each server you wish to deploy.|
|Active Directory Cluster name|Name of your cluster in Active Directory.|
Active Directory Object prefix|Name of the object prefix for the Active Directory domain.|
Active directory OU|Name of the organizational unit (OU) for the Active Directory domain.|
|Active Directory FQDN|Fully-qualified domain name (FQDN) for the Active Directory domain.|
|Active Directory credentials|Username and password for the deployment user pre-created in the Active directory account.|
|IPv4 network range subnet for management network intent|A subnet IPv4 range with a minimum of 6 available IPs used for the management network intent. These IPs are used for infrastructure services such as clustering.|
|Storage VLAN ID|Two unique VLAN IDs to be used for the storage networks, from your IT network administrator.|
|DNS Server|A DNS Server that resolves Active Directory.|
|Azure subscription ID|ID for the Azure subscription used to register the cluster. You must be an owner on this subscription to manage access to Azure resources.|

## Next steps

After reviewing the pre-deployment checklist, you are ready to prepare your Active Directory environment:

Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
