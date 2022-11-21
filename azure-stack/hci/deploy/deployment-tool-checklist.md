---
title: Deployment checklist for Azure Stack HCI (preview) 
description: Complete the deployment checklist prior to deploying Azure Stack HCI (preview).
author: dansisson
ms.topic: article
ms.date: 11/18/2022
ms.author: v-dansisson
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Get the deployment checklist for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

Use the following checklist to gather the required information ahead of the actual deployment of your Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Deployment checklist

|Component|What is needed|
|--|--|
|Server names|Unique name for each server you wish to deploy.|
|Active Directory Cluster name|The name for the new cluster AD object during the [Active Directory preparation](./deployment-tool-active-directory.md). This name is also used for the name of the cluster during deployment.|
Active Directory Object prefix|The prefix used for all AD objects created for the Azure Stack HCI deployment. The prefix is used during the [Active Directory preparation](./deployment-tool-active-directory.md). <br> The prefix must not exceed 8 characters.|
Active directory OU|A new organizational unit (OU) to store all the objects for the Azure Stack HCI deployment. The OU is created during the [Active Directory preparation](./deployment-tool-active-directory.md).|
|Active Directory FQDN|Fully-qualified domain name (FQDN) for the Active Directory domain.|
|Active Directory deployment user credential|A new username and password that is created with the appropriate  permissions for deployment. This account is the same as the user account used by the Azure Stack HCI 22H2 deployment tool.<br>The password must conform to the length and complexity requirements. Use a password that is at least eight characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow). <br> The name must be unique for each deployment and you can't use *admin* as the username.|
|IPv4 network range subnet for management network intent|A subnet used for management network intent. You need an address range for management network with  a minimum of 6 available, contiguous IPs in this subnet. These IPs are used for infrastructure services with the first IP assigned to failover clustering.<br> For more information, see the **Provide management network details** page in [Deploy interactively using a config file](./deployment-tool-new-file.md).|
|Storage VLAN ID|Two unique VLAN IDs to be used for the storage networks, from your IT network administrator.<br> We recommend to use the default VLANS from Network ATC for storage subnets. If you plan to have two storage subnets, Network ATC will use VLANS from 712 and 711 subnets. <br> For more information, see the **Provide storage network details** page in [Deploy interactively using a config file](./deployment-tool-new-file.md).|
|DNS Server|A DNS Server that is used in your environment. The DNS server used must resolve the Active Directory Domain. <br> For more information, see the **Provide management network details** page in [Deploy interactively using a config file](./deployment-tool-new-file.md).|
|Azure subscription ID|ID for the Azure subscription used to register the cluster. Make sure that you are a user access administrator on this subscription. This will allow you to manage access to Azure resources, specifically to Arc-enable each server of an Azure Stack HCI cluster.|
|Outbound connectivity| Run the [Environment checker](../manage/use-environment-checker.md) to ensure that your environment meets the outbound network connectivity requirements for firewall rules.|

## Next steps

- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
