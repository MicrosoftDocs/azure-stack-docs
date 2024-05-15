---
title: Use Kerberos authentication with Service Principal Name (SPN)
description: Learn how to use Kerberos authentication with SPN.
manager: grcusanz
ms.topic: article
ms.assetid: bc625de9-ee31-40a4-9ad2-7448bfbfb6e6
ms.author: anpaul
author: AnirbanPaul
ms.date: 05/15/2024
---

# Kerberos with Service Principal Name (SPN)

> Applies to: Azure Stack HCI, versions 23H2 and 22H2; Windows Server 2022, Windows Server 2019

This article describes how to use Kerberos authentication with Service Principal Name (SPN).

Network Controller supports multiple authentication methods for communication with management clients. You can use Kerberos based authentication, X509 certificate-based authentication. You also have the option to use no authentication for test deployments.

System Center Virtual Machine Manager uses Kerberos-based authentication. If you're using Kerberos-based  authentication, you must configure an SPN for Network Controller in Active Directory. The SPN is a unique identifier for the Network Controller service instance, which is used by Kerberos authentication to associate a service instance with a service login account. For more details, see [Service Principal Names](/windows/desktop/ad/service-principal-names).

## Configure Service Principal Names (SPN)

The Network Controller automatically configures the SPN. All you need to do is to provide permissions for the Network Controller machines to register and modify the SPN.

1. On the Domain Controller machine, start **Active Directory Users and Computers**.

1. Select **View > Advanced**.

1. Under **Computers**, locate one of the Network Controller machine accounts, and then right-click and select **Properties**.

1. Select the **Security** tab and click **Advanced**.

1. In the list, if all the Network Controller machine accounts or a security group having all the Network Controller machine accounts isn't listed, click **Add** to add it.

1. For each Network Controller machine account or a single security group containing the Network Controller machine accounts:

   1.  Select the account or group and click **Edit**.

   1.  Under Permissions select **Validate Write servicePrincipalName**.

   1.  Scroll down and under **Properties** select:

       -  **Read servicePrincipalName**

       -  **Write servicePrincipalName**

    1.  Click **OK** twice.

1.  Repeat steps 3 - 6 for each Network Controller machine.

1.  Close **Active Directory Users and Computers**.

## Failure to provide permissions for SPN registration or modification

On a new Windows Server 2019 deployment, if you chose Kerberos for REST client authentication and don't authorize Network Controller nodes to register or modify the SPN, REST operations on Network Controller will fail. This prevents you from effectively managing your SDN infrastructure.

For an upgrade from Windows Server 2016 to Windows Server 2019, and you chose Kerberos for REST client authentication, REST operations don't get blocked, ensuring transparency for existing production deployments.

If SPN isn't registered, REST client authentication uses NTLM, which is less secure. You also get a critical event in the Admin channel of **NetworkController-Framework** event channel asking you to provide permissions to the Network Controller nodes to register SPN. Once you provide permission, Network Controller registers the SPN automatically, and all client operations use Kerberos.

> [!TIP]
> Typically, you can configure Network Controller to use an IP address or DNS name for REST-based operations. However, when you configure Kerberos, you cannot use an IP address for REST queries to Network Controller. For example, you can use \<https://networkcontroller.consotso.com\>, but you cannot use \<https://192.34.21.3\>. Service Principal Names cannot function if IP addresses are used.
>
> If you were using IP address for REST operations along with Kerberos authentication in Windows Server 2016, the actual communication would have been over NTLM authentication. In such a deployment, once you upgrade to Windows Server 2019, you continue to use NTLM-based authentication. To move to Kerberos-based authentication, you must use Network Controller DNS name for REST operations and provide permission for Network Controller nodes to register SPN.

## Next steps

- [Secure the Network Controller](./nc-security.md)
