---
title: Deployment checklist for Azure Stack HCI version 22H2 via the supplemental package (preview) 
description: Follow the pre-deployment checklist for deploying Azure Stack HCI version 22H2 (preview).
author: dansisson
ms.topic: article
ms.date: 10/27/2022
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
|Active Directory Cluster name|The name for the new cluster AD object. This name is also used for the name of the cluster during deployment.|
Active Directory Object prefix|The prefix used for all AD objects created for the Azure Stack HCI deployment. <br> The prefix must not exceed 8 characters.|
Active directory OU|A new organizational unit (OU) to store all the objects for the Azure Stack HCI deployment.|
|Active Directory FQDN|Fully-qualified domain name (FQDN) for the Active Directory domain.|
|Active Directory deployment user credential|A new username and password that is created with the appropriate  permissions for deployment. This account is the same as the user account used by the Azure Stack HCI 22H2 deployment tool.<br>The password must conform to the length and complexity requirements. Use a password that is at least eight characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow). <br> The name must be unique for each deployment and you can't use *admin* as the username.|
|IPv4 network range subnet for management network intent|A subnet used for management network intent. You need a minimum of 6 available, contiguous IPs in this subnet. These IPs are used for infrastructure services such as clustering.|
|Storage VLAN ID|Two unique VLAN IDs to be used for the storage networks, from your IT network administrator.<br> We recommend that you use the default 712 and 711 subnets for VLAN IDs.|
|DNS Server|A DNS Server that resolves Active Directory.|
|Azure subscription ID|ID for the Azure subscription used to register the cluster. You must be an owner on this subscription to manage access to Azure resources.|
|Outbound connectivity| Run the [Environment checker](../manage/use-environment-checker.md) to ensure that your environment meets the outbound network connectivity requirements for firewall rules.|

## Next steps

After reviewing the pre-deployment checklist, you are ready to prepare your Active Directory environment:

Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
