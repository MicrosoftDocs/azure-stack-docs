--- 
title: Prepare Active Directory for new Azure Stack HCI deployments (preview) 
description: Learn how to prepare Active Directory before you deploy Azure Stack HCI (preview).
author: alkohli
ms.topic: how-to
ms.date: 07/14/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Prepare Active Directory for new Azure Stack HCI deployment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes how to prepare your Active Directory (AD) environment before you deploy Azure Stack HCI. To enable the security model, each component agent on Azure Stack HCI uses a dedicated Group Managed Service Account (gMSA). For an overview of gMSA, see [Group Manager Service Accounts](/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md) for new deployments of Azure Stack HCI.
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Install the PowerShell module to prepare Active Directory. [Download the module from the PowerShell Gallery](https://www.powershellgallery.com/packages/AsHciADArtifactsPreCreationTool/1.0) and run the following command:

    ```azurepowershell
    Install-Module AsHciADArtifactsPreCreationTool -Repository PSGallery
    ```    

    You can also copy the module from the *C:\CloudDeployment\Prepare* folder on your first (staging) server and then import the module. Run this command from the folder where the module is located:

    ```azurepowershell
    Import-Module .\AsHciADArtifactsPreCreationTool.psm1
    ```
- Obtain domain administrator access to the Active Directory domain server.
- (Only if you deploy Azure Stack HCI via PowerShell) Create a Service Principal with the necessary permissions for Azure Stack HCI registration. For more information, see:
    - [Create a Microsoft Entra app and service principal in the portal](/azure/active-directory/develop/howto-create-service-principal-portal).
    - [Assign Azure permissions from the Azure portal](./register-with-azure.md#assign-azure-permissions-for-registration).
    
## Active Directory preparation module

The *AsHciADArtifactsPreCreationTool.ps1* module is used to prepare Active Directory. Here are the required parameters associated with the cmdlet:

|Parameter|Description|
|--|--|
|`-AzureStackLCMUserCredential`|A new user object that is created with the appropriate  permissions for deployment. This account is the same as the user account used by the Azure Stack HCI 22H2 deployment tool.<br> Make sure that only the username is provided. The name should not include the domain name, for example, `contoso\username`.<br>The password must conform to the length and complexity requirements. Use a password that is at least eight characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow). <br> The name must be unique for each deployment and you can't use *admin* as the username.|
|`-AsHciOUName`|A new Organizational Unit (OU) to store all the objects for the Azure Stack HCI deployment. Existing group policies and inheritance are blocked in this OU to ensure there's no conflict of settings. The OU must be specified as the distinguished name (DN). For more information, see the format of [Distinguished Names](/previous-versions/windows/desktop/ldap/distinguished-names).|
|`-AsHciPhysicalNodeList`|A list of computer names that are created for the physical cluster servers.|
|`-DomainFQDN`|Fully qualified domain name (FQDN) of the Active Directory domain.|
|`-AsHciClusterName`|The name for the new cluster AD object.|
|`-AsHciDeploymentPrefix`|The prefix used for all AD objects created for the Azure Stack HCI deployment. <br> The prefix must not exceed 8 characters.|
|`-Deploy`|Select this scenario for a brand new deployment instead of an upgrade of an existing system.|

## Prepare Active Directory

When you prepare Active Directory, you create a dedicated Organizational Unit (OU) to place all the Azure Stack HCI related objects such as computer accounts, gMSA accounts, and user groups.

> [!NOTE]
> In this release, only the Active Directory prepared via the provided module is supported.

To prepare and configure Active Directory, follow these steps:

1. Sign in to a computer that is joined to your Active Directory domain as a domain administrator.
1. Run PowerShell as administrator.
1. Create a [Microsoft Key Distribution Service root key](/windows-server/security/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key) on the domain controller to generate group [Managed Service Account](/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview) passwords. Run the following command.

    ```powershell
    Add-KdsRootKey -EffectiveTime ((Get-Date).addhours(-10))
    ```

    Here's the sample output from a successful run of the command:

    ```
    PS C:\Users\Administrator> Add-KdsRootKey -EffectiveTime ((Get-Date).addhours(-10))

    Guid
    ----
    706e1dd7-3601-4f01-f2de-bb04c7b9afc3

    ```

1. Run the following command to create the dedicated OU.

    ```powershell
    New-HciAdObjectsPreCreation -Deploy -AzureStackLCMUserCredential (Get-Credential) -AsHciOUName "<OU name or distinguished name including the domain components>" -AsHciPhysicalNodeList @("<Server name>") -DomainFQDN "<FQDN for the Active Directory domain>" -AsHciClusterName "<Cluster name for deployment>" -AsHciDeploymentPrefix "<Deployment prefix>"

1. When prompted, provide the username and password for the deployment. 
    1. Make sure that only the username is provided. The name should not include the domain name, for example, `contoso\username`.
    1. Make sure that the password meets complexity and length requirements. For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow).


    Here is a sample output from a successful completion of the script:

    ```    
    PS C:\temp> New-HciAdObjectsPreCreation -Deploy -AsHciDeploymentUserCredential (get-credential) -AsHciOUName "OU=oudocs,DC=ASZ1PLab,DC=nttest,DC=microsoft,DC=com" -AsHciPhysicalNodeList @("a6p15140005012", "a4p1074000603b") -DomainFQDN "ASZ1PLab.nttest.microsoft.com" -AsHciClusterName "docspro2cluster" -AsHciDeploymentPrefix "docspro2"
    
    cmdlet Get-Credential at command pipeline position 1
    Supply values for the following parameters:
    Credential
    
    ActiveDirectoryRights : ReadProperty
    InheritanceType       : All
    ObjectType            : 00000000-0000-0000-0000-000000000000
    InheritedObjectType   : 00000000-0000-0000-0000-000000000000
    ObjectFlags           : None
    AccessControlType     : Allow
    IdentityReference     : ASZ1PLAB\docspro2cluster$
    IsInherited           : False
    InheritanceFlags      : ContainerInherit
    PropagationFlags      : None
    
    ActiveDirectoryRights : CreateChild
    InheritanceType       : All
    ObjectType            : bf967a86-0de6-11d0-a285-00aa003049e2
    InheritedObjectType   : 00000000-0000-0000-0000-000000000000
    ObjectFlags           : ObjectAceTypePresent
    AccessControlType     : Allow
    IdentityReference     : ASZ1PLAB\docspro2cluster$
    IsInherited           : False
    InheritanceFlags      : ContainerInherit
    PropagationFlags      : None
    
    PS C:\temp>

    ```

1. Verify that the OU and the corresponding **Computers** and **Users** objects are created.  If using a Windows Server client, go to **Server Manager > Tools > Active Directory Users and Computers**.

1. An OU with the specified name should be created and within that OU, you'll see **Computers** and **Users** objects.

    :::image type="content" source="media/deployment-tool/active-directory/active-directory-1.png" alt-text="Screenshot of Active Directory Computers and Users window." lightbox="media/deployment-tool/active-directory/active-directory-1.png":::

1. The **Computers** object should contain one computer account for each server node and one account for the **Cluster Name Object**.

    :::image type="content" source="media/deployment-tool/active-directory/active-directory-2.png" alt-text="Screenshot of Active Directory Cluster Name Object window." lightbox="media/deployment-tool/active-directory/active-directory-2.png":::

1. The **Users** object should contain one user group corresponding to the user you specified during the creation and one security group - domain local  with this name format: *Active Directory object prefix-OpsAdmin*. For example: *docspro2-OpsAdmin*.

    :::image type="content" source="media/deployment-tool/active-directory/active-directory-3.png" alt-text="Screenshot of Active Directory Users Object window." lightbox="media/deployment-tool/active-directory/active-directory-3.png":::

> [!NOTE]
> - To perform a second deployment, run the prepare step  with a different prefix and a different OU name.
> - If you are repairing a single server, do not delete the existing OU. If the server volumes are encrypted, deleting the OU removes the BitLocker recovery keys.


## Next steps

- [Install Azure Stack HCI version 22H2 operating system](deployment-tool-install-os.md) on each server in your cluster.
