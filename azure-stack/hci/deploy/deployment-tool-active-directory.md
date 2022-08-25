---
title: Prepare Active Directory for Azure Stack HCI version 22H2 (preview) deployment
description: Learn to prepare Active Directory for Azure Stack HCI version 22H2 (preview)
author: dansisson
ms.topic: how-to
ms.date: 08/29/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Prepare Active Directory for Azure Stack HCI version 22H2 deployment (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

These articles describe how to prepare your Active Directory (AD) environment  before you deploy Azure Stack HCI 22H2 version 22H2. To enable the new security model, each component agent on Azure Stack HCI uses a dedicated Group Managed Service Account (gMSA). For more information, see [Group Manager Service Accounts](/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview) overview.

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md)  for Azure Stack HCI version 22H2.
- Complete the [deployment checklist](deployment-tool-checklist.md).

> [!NOTE]
> In this preview release, only one Azure Stack HCI deployment per Active Directory domain is supported.

## Required script parameters

The *AsHciADArtifactsPreCreationTool.ps1* script is used to prepare Active Directory, and which requires the following parameters:

|Parameter|Description|
|--|--|
|`-AsHciDeploymentUserCredential`|A new user object that is created with the appropriate  permissions for deployment. This account is the same user account used by the Azure Stack HCI 22H2 deployment tool.<br>The password must conform to the length and complexity requirements. Use a password that is at least eight characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow).|
|`-AsHciOUName`|A new OU to store all the objects for the Azure Stack HCI deployment. Existing group policies are blocked to ensure there's no conflict of settings.|
|`-AsHciPhysicalNodeList`|A list of computer names that are created for the physical cluster servers.|
|`-DomainFQDN`|Fully qualified domain name (FQDN) of the Active Directory domain.|
|`-AsHciClusterName`|The name for the new cluster AD object.|
|`-AsHciDeploymentPrefix`|The prefix used for all AD objects created for the Azure Stack HCI deployment.|

## Prepare Active Directory

When preparing Active Directory, you need local administrative access to the Active Directory domain server.

Also, a dedicated Organizational Unit (OU) should be created to place all the Azure Stack HCI related objects such as computer accounts, gMSA accounts, and user groups.

To prepare and configure Active Directory, follow these steps:

1. Sign in to a computer that is joined to your Active Directory domain as a local administrator.
1. Download the *Adprep* command from [PowerShell Gallery](https://microsoft.sharepoint.com/sites/knowledgecenter/_layouts/15/TopicPagePreview.aspx?topicId=AL_GQSuzYWffyPyTBvhVtw0Ow&topicName=PowerShell%20Gallery&lang=en&ls=Ans_Bing) or copy it from the *C:\CloudDeployment\Prepare* folder on your first (staging) server.
1. Create a [Microsoft Key Distribution Service root key](/windows-server/security/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key) on the domain controller to generate group [Managed Service Account](/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview) passwords.

1. Run the following PowerShell command as administrator:

    ```powershell
    Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))
    ```

    Here's the sample output from a successful run of the command:

    ```powershell
    Windows PowerShell
    Copyright (C) Microsoft Corporation. All rights reserved.

    PS C:\Users\Administrator.SVCCLIENT02VM3> whoami
    HCIlab\administrator
    PS C:\Users\Administrator.SVCCLIENT02VM3> Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))

    Guid
    ----
    706e1dd7-3601-4f01-f2de-bb04c7b9afc3

    PS C:\Users\Administrator.SVCCLIENT02VM3>
    ```

1. Run the following command from the folder where the *AsHciADArtifactsPreCreationTool.ps1* script is located:

    ```powershell
    .\AsHciADArtifactsPreCreationTool.ps1 -AsHciDeploymentUserCredential (get-credential) -AsHciOUName "OU=Hci001,DC=contoso,DC=com" -AsHciPhysicalNodeList @("server1") -DomainFQDN "contoso.com" -AsHciClusterName "cluster_name" -AsHciDeploymentPrefix "Hci001"
    ```

1. When prompted, provide the username and password for the deployment. Make sure that the password meets complexity and length requirements. For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow).

    Here is a sample output from a successful completion of the script:

    ```powershell
    PS C:\Users\Administrator.SVCCLIENT02VM3> cd C:\temp
    PS C:\temp> dir

    Directory: C:\temp

    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a----         8/1/2022   7:22 PM          54908 AsHciADArtifactsPreCreationTool.ps1
    -a----         8/2/2022   1:36 PM          18299 Contoso.AsHci.Security.AdArtifactsTool.1.2206.12.nupkg
    -a----         8/2/2022   1:36 PM          18299 Contoso.AsHci.Security.AdArtifactsTool.1.2206.12.zip

    PS C:\temp> .\AsHciADArtifactsPreCreationTool.ps1 `
        -AsHciDeploymentUserCredential (get-credential) `
        -AsHciOUName "OU=HCI001,DC=contoso,DC=com"`
        -AsHciPhysicalNodeList @("a6p15140005012", "a4p1074000603b") `
        -DomainFQDN "HCI001.contoso.com" `
        -AsHciClusterName "docspro2cluster" `
        -AsHciDeploymentPrefix "docspro2"

    cmdlet Get-Credential at command pipeline position 1
    Supply values for the following parameters:
    Credential

    ActiveDirectoryRights : ReadProperty
    InheritanceType       : All
    ObjectType            : 00000000-0000-0000-0000-000000000000
    InheritedObjectType   : 00000000-0000-0000-0000-000000000000
    ObjectFlags           : None
    AccessControlType     : Allow
    IdentityReference     : HCI001\docspro2cluster$
    IsInherited           : False
    InheritanceFlags      : ContainerInherit
    PropagationFlags      : None

    ActiveDirectoryRights : CreateChild
    InheritanceType       : All
    ObjectType            : bf967a86-0de6-11d0-a285-00aa003049e2
    InheritedObjectType   : 00000000-0000-0000-0000-000000000000
    ObjectFlags           : ObjectAceTypePresent
    AccessControlType     : Allow
    IdentityReference     : HCI001\docspro2cluster$
    IsInherited           : False
    InheritanceFlags      : ContainerInherit
    PropagationFlags      : None

    PS C:\temp>
    ```

1. Verify that the OU and the corresponding **Computers** and **Users** objects are created.  If using a Windows Server client, go to **Server Manager > Tools > Active Directory Users and Computers**.

1. An OU with the specified name should be created and within that OU, you’ll see **Computers** and **Users** objects.

    :::image type="content" source="media/deployment-tool/active-directory-1.png" alt-text="Screenshot of Active Directory Computers and Users window." lightbox="media/deployment-tool/active-directory-1.png":::

1. The **Computers** object should contain one computer account for each server node and one account for the **Cluster Name Object**.

    :::image type="content" source="media/deployment-tool/active-directory-2.png" alt-text="Screenshot of Active Directory Cluster Name Object window." lightbox="media/deployment-tool/active-directory-2.png":::

1. The **Users** object should contain one user group corresponding to the user you specified during the creation and one local domain security group with this name format: *Active Directory object prefix-OpsAdmin*. For example: *docspro2-OpsAdmin*.

    :::image type="content" source="media/deployment-tool/active-directory-3.png" alt-text="Screenshot of Active Directory Users Object window." lightbox="media/deployment-tool/active-directory-3.png":::

## Next steps

[Install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server in your cluster.
