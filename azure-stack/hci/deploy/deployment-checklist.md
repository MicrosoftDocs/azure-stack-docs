---
title: Deployment checklist for Azure Stack HCI, version 23H2 (preview) 
description: Complete the deployment checklist prior to deploying Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.topic: article
ms.date: 10/26/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Get the deployment checklist for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

Use the following checklist to gather the required information ahead of the actual deployment of your Azure Stack HCI, version 23H2 cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Deployment checklist

|Component|What is needed|
|--|--|
|Server names|Unique name for each server you wish to deploy.|
|Active Directory cluster name|The name for the new cluster AD object during the [Active Directory preparation](./deployment-prep-active-directory.md). This name is also used for the name of the cluster during deployment.|
Active Directory prefix|The prefix used for all AD objects created for the Azure Stack HCI deployment. The prefix is used during the [Active Directory preparation](./deployment-prep-active-directory.md). <br> The prefix must not exceed 8 characters.|
Active directory OU|A new organizational unit (OU) to store all the objects for the Azure Stack HCI deployment. The OU is created during the [Active Directory preparation](./deployment-prep-active-directory.md).|
|Active Directory Domain|Fully-qualified domain name (FQDN) for the Active Directory Domain Services prepared for deployment.|
|Active Directory Lifecycle Manager (LCM) credential|A new username and password that is created with the appropriate  permissions for deployment. This account is the same as the user account used by the Azure Stack HCI 23H2 deployment.<br>The password must conform to the length and complexity requirements. Use a password that is at least 12 characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow). <br> The name must be unique for each deployment and you can't use *admin* as the username.|
|IPv4 network range subnet for management network intent|A subnet used for management network intent. You need an address range for management network with  a minimum of 6 available, contiguous IPs in this subnet. These IPs are used for infrastructure services with the first IP assigned to fail over clustering.<br> For more information, see the **Specify network settings** page in [Deploy via Azure portal](./deploy-via-portal.md).|
|Storage VLAN ID|Two unique VLAN IDs to be used for the storage networks, from your IT network administrator.<br> We recommend using the default VLANS from Network ATC for storage subnets. If you plan to have two storage subnets, Network ATC will use VLANS from 712 and 711 subnets. <br> For more information, see the **Specify network settings** page in [Deploy via Azure portal](./deploy-via-portal.md).|
|DNS Server|A DNS Server that is used in your environment. The DNS server used must resolve the Active Directory Domain. <br> For more information, see the **Specify network settings** page in [Deploy via Azure portal](./deploy-via-portal.md).|
|Local administrator credentials|Username and password for the local administrator for all the servers in your cluster. The credentials are identical for all the servers in your system.<br> For more information, see the **Specify management settings** page in [Deploy via Azure portal](./deploy-via-portal.md).|
|Custom location|(Optional) A name for the custom location created for your cluster. This name is used for Azure Arc VM management. If a name is not specified, the system name is used for custom location. <br> For more information, see the **Specify management settings** page in [Deploy via Azure portal](./deploy-via-portal.md).|
|Azure subscription ID|ID for the Azure subscription used to register the cluster. Make sure that you are a user access administrator and a contributor on this subscription. This will allow you to manage access to Azure resources, specifically to Arc-enable each server of an Azure Stack HCI cluster. For more information, see [Assign Azure permissions for deployment](./deployment-arc-register-server-permissions.md#assign-required-permissions-for-deployment)|
|Azure Storage account|For two-node clusters, a witness is required. For a cloud witness, an [Azure Storage account](/azure/storage/common/storage-account-create) is needed. You can use the same storage account for multiple clusters. For more information, see **Specify management settings** in [Deploy via Azure portal](./deploy-via-portal.md).|
|Access key for Azure Storage account|To set up a cloud witness, the [Access key](/azure/storage/common/storage-account-get-info#get-a-connection-string-for-the-storage-account) for the Azure Storage account is needed. For more information, see **Specify management settings** in [Deploy via Azure portal](./deploy-via-portal.md).|
|Azure blob service domain|The domain name for the Azure blob service is needed if you choose to use a custom domain when setting up a cloud witness. For more information, see **Specify management settings** in [Deploy via Azure portal](./deploy-via-portal.md).|
|File share path|For two-node clusters, a witness is required. For a file share witness, the file share path for the witness is needed. For more information, see **Specify management settings** in [Deploy via Azure portal](./deploy-via-portal.md).|
|Outbound connectivity| Run the [Environment checker](../manage/use-environment-checker.md) to ensure that your environment meets the outbound network connectivity requirements for firewall rules.|

## Next steps

- Prepare your [Active Directory](./deployment-prep-active-directory.md) environment.
