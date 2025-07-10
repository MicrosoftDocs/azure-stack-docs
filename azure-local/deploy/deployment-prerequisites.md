---
title: Prerequisites to deploy Azure Local, version 23H2
description: Learn about the prerequisites to deploy Azure Local, version 23H2.
author: alkohli
ms.topic: install-set-up-deploy
ms.date: 04/22/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Review deployment prerequisites for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article discusses the security, software, hardware, and networking prerequisites, and the deployment checklist in order to deploy Azure Local instance.

## Review requirements and complete prerequisites

| Requirements | Links |
|--|--|
| Security features | [Link](../concepts/security-features.md) |
| Environment readiness | [Link](../manage/use-environment-checker.md) |
| System requirements | [Link](../concepts/system-requirements-23h2.md) |
| Firewall requirements | [Link](../concepts//firewall-requirements.md) |
| Physical network requirements | [Link](../concepts//physical-network-requirements.md) |
| Host network requirements | [Link](../concepts/host-network-requirements.md) |

## Complete deployment checklist

Use the following checklist to gather the required information ahead of the actual deployment of your Azure Local instance.

|Component|What is needed|
|--|--|
|Machine names|Unique name for each machine you wish to deploy.|
|Active directory OU|A new organizational unit (OU) to store all the objects for the Azure Local deployment. The OU is created during the [Active Directory preparation](./deployment-prep-active-directory.md).<br>The OU must be specified as the distinguished name (DN). The OU path doesn't support the following special characters anywhere within the path: `&,",',<,>`. For more information, see the format of [Distinguished Names](/previous-versions/windows/desktop/ldap/distinguished-names).|
|Active Directory Domain|Fully-qualified domain name (FQDN) for the Active Directory Domain Services prepared for deployment.|
|Active Directory LCM User credential|A new username and password that is created with the appropriate  permissions for deployment. This account is the same as the user account used by the Azure Local deployment.<br>The password must conform to the Azure length and complexity requirements. Use a password that is at least 14 characters long. The password must contain the following: a lowercase character, an uppercase character, a numeral, and  a special character.<br> The name must be unique for each deployment and you can't use *admin* as the username.|
|IPv4 network range subnet for management network intent|A subnet used for management network intent. You need an address range for management network with  a minimum of 6 available, contiguous IPs in this subnet. These IPs are used for infrastructure services with the first IP assigned to fail over clustering.<br> For more information, see the **Specify network settings** page in [Deploy via Azure portal](./deploy-via-portal.md#specify-network-settings).|
|Storage VLAN ID|Two unique VLAN IDs to be used for the storage networks, from your IT network administrator.<br> We recommend using the default VLANS from Network ATC for storage subnets. If you plan to have two storage subnets, Network ATC will use VLANS from 712 and 711 subnets. <br> For more information, see the **Specify network settings** page in [Deploy via Azure portal](./deploy-via-portal.md#specify-network-settings).|
|DNS server|A DNS server that is used in your environment. The DNS server used must resolve the Active Directory Domain. <br> For more information, see the **Specify network settings** page in [Deploy via Azure portal](./deploy-via-portal.md#specify-network-settings).|
|Local administrator credentials|Username and password for the local administrator for all the machines in your system. The credentials are identical for all the machines in your system.<br>Make sure that the local administrator password follows Azure password length and complexity requirements. Use a password that is at least 14 characters long and contains a lowercase character, an uppercase character, a numeral, and a special character.<br> For more information, see the **Specify management settings** page in [Deploy via Azure portal](./deploy-via-portal.md#specify-management-settings).|
|Custom location|(Optional) A name for the custom location created for your system. This name is used for Azure Local VM management. <br> For more information, see the **Specify management settings** page in [Deploy via Azure portal](./deploy-via-portal.md#specify-management-settings).|
|Azure subscription ID|ID for the Azure subscription used to register the system. Make sure that you are a user access administrator and a contributor on this subscription. This will allow you to manage access to Azure resources, specifically to Arc-enable each machine of an Azure Local instance. For more information, see [Assign Azure permissions for deployment](./deployment-arc-register-server-permissions.md#assign-required-permissions-for-deployment)|
|Azure Storage account|For two-node systems, a witness is required. For a cloud witness, an [Azure Storage account](/azure/storage/common/storage-account-create) is needed. In this release, you cannot use the same storage account for multiple systems. For more information, see **Specify management settings** in [Deploy via Azure portal](./deploy-via-portal.md#specify-management-settings). <br> For naming conventions, see [Azure Storage account names](/azure/storage/common/storage-account-overview#storage-account-name).|
|Azure Key Vault|A key vault is required to securely store secrets for this system, such as cryptographic keys, local admin credentials, and BitLocker recovery keys. For requirements, see **Azure Key Vault** in [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements). For creating a key vault during deployment, see **Basics** in [Deploy via Azure portal](./deploy-via-portal.md#start-the-wizard-and-fill-out-the-basics). <br> For naming conventions, see [Azure Key Vault names](/azure/key-vault/general/about-keys-secrets-certificates#object-identifiers).|
|Outbound connectivity| Run the [Environment checker](../manage/use-environment-checker.md) to ensure that your environment meets the outbound network connectivity requirements for firewall rules.|

## Next steps

- Prepare your [Active Directory](./deployment-prep-active-directory.md) environment.
