---
title: Deployment checklist for Azure Stack HCI (preview) 
description: Complete the deployment checklist prior to deploying Azure Stack HCI (preview).
author: alkohli
ms.topic: article
ms.date: 04/04/2023
ms.author: alkohli
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
|Active Directory lifecycle manager (LCM) credential|A new username and password that is created with the appropriate  permissions for deployment. This account is the same as the user account used by the Azure Stack HCI 22H2 deployment tool.<br>The password must conform to the length and complexity requirements. Use a password that is at least eight characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow). <br> The name must be unique for each deployment and you can't use *admin* as the username.|
|IPv4 network range subnet for management network intent|A subnet used for management network intent. You need an address range for management network with  a minimum of 6 available, contiguous IPs in this subnet. These IPs are used for infrastructure services with the first IP assigned to fail over clustering.<br> For more information, see the **Provide management network details** page in [Deploy interactively using a config file](./deployment-tool-new-file.md).|
|Storage VLAN ID|Two unique VLAN IDs to be used for the storage networks, from your IT network administrator.<br> We recommend using the default VLANS from Network ATC for storage subnets. If you plan to have two storage subnets, Network ATC will use VLANS from 712 and 711 subnets. <br> For more information, see the **Provide storage network details** page in [Deploy interactively using a config file](./deployment-tool-new-file.md).|
|DNS Server|A DNS Server that is used in your environment. The DNS server used must resolve the Active Directory Domain. <br> For more information, see the **Provide management network details** page in [Deploy interactively using a config file](./deployment-tool-new-file.md).|
|Azure subscription ID|ID for the Azure subscription used to register the cluster. Make sure that you are a user access administrator and a contributor on this subscription. This will allow you to manage access to Azure resources, specifically to Arc-enable each server of an Azure Stack HCI cluster. For more information, see [Assign Azure permissions for deployment](./deployment-tool-set-up-first-server.md#assign-azure-permissions-for-deployment)|
|Azure Storage account|For two-node clusters, a witness is required. For a cloud witness, an [Azure Storage account](/azure/storage/common/storage-account-create) is needed. For more information, see **Step 3: Cluster** in [Deploy interactively using a config file](./deployment-tool-new-file.md#step-3-cluster).|
|Access key for Azure Storage account|To setup a cloud witness, the [Access key](/azure/storage/common/storage-account-get-info#get-a-connection-string-for-the-storage-account) for the Azure Storage account is needed. For more information, see **Step 3: Cluster** in [Deploy interactively using a config file](./deployment-tool-new-file.md#step-3-cluster).|
|Azure blob service domain|The domain name for the Azure blob service is needed if you choose to use a custom domain when setting up a cloud witness. For more information, see **Step 3: Cluster** in [Deploy interactively using a config file](./deployment-tool-new-file.md#step-3-cluster).|
|File share path|For two-node clusters, a witness is required. For a file share witness, the file share path for the witness is needed. For more information, see **Step 3: Cluster** in [Deploy interactively using a config file](./deployment-tool-new-file.md#step-3-cluster).|
|Outbound connectivity| Run the [Environment checker](../manage/use-environment-checker.md) to ensure that your environment meets the outbound network connectivity requirements for firewall rules.|

## Next steps

- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
