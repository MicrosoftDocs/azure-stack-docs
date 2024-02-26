--- 
title: Prepare Active Directory for new Azure Stack HCI, version 23H2 deployment
description: Learn how to prepare Active Directory before you deploy Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 02/22/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Prepare Active Directory for Azure Stack HCI, version 23H2 deployment

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare your Active Directory environment before you deploy Azure Stack HCI, version 23H2.

Active Directory requirements for Azure Stack HCI 23H2 include:

- A dedicated Organization Unit (OU).
- Group policy inheritance must be blocked for the applicable Group Policy Object (GPO).
- A user account that has permission to join computers to Active Directory and create the cluster name object (CNO).

> [!NOTE]
> You can use your existing process to meet the above requirements. The script used in this article is optional and provided to simplify this task.

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](./deployment-prerequisites.md) for new deployments of Azure Stack HCI.
- Install the PowerShell module to prepare Active Directory. You can follow one of these options:
    - [Download AsHciADArtifactsPreCreationTool.psm1 from this location](https://github.com/Azure/AzureStack-Tools/tree/master/HCI). Run the following command:
    
        ```powershell
        Import-Module .\AsHciADArtifactsPreCreationTool.psm1
        ```
    - [Download the version 2311 module from the PowerShell Gallery](https://www.powershellgallery.com/packages/AsHciADArtifactsPreCreationTool/10.2311). Run the following command:

        ```powershell
        Install-Module AsHciADArtifactsPreCreationTool -Repository PSGallery -Force
        ```

<!--You can also copy the module from the *C:\CloudDeployment\Prepare* folder on your first (staging) server and then import the module. Run this command from the folder where the module is located:

```azurepowershell
Import-Module .\AsHciADArtifactsPreCreationTool.psm1
```
-->

- Obtain domain administrator access to the Active Directory domain server.

## Active Directory preparation module

The *AsHciADArtifactsPreCreationTool.ps1* module is used to prepare Active Directory. Here are the required parameters associated with the cmdlet:

|Parameter|Description|
|--|--|
|`-AzureStackLCMUserCredential`|A new user object that is created with the appropriate  permissions for deployment. This account is the same as the user account used by the Azure Stack HCI deployment.<br> Make sure that only the username is provided. The name should not include the domain name, for example, `contoso\username`.<br>The password must conform to the length and complexity requirements. Use a password that is at least 12 characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow). <br> The name must be unique for each deployment and you can't use *admin* as the username.|
|`-AsHciOUName`|A new Organizational Unit (OU) to store all the objects for the Azure Stack HCI deployment. Existing group policies and inheritance are blocked in this OU to ensure there's no conflict of settings. The OU must be specified as the distinguished name (DN). For more information, see the format of [Distinguished Names](/previous-versions/windows/desktop/ldap/distinguished-names).|
|`-AsHciPhysicalNodeList`|A list of computer names that are created for the physical cluster servers.|
|`-DomainFQDN`|Fully qualified domain name (FQDN) of the Active Directory domain.|
|`-AsHciClusterName`|The name for the new cluster AD object.|
|`-AsHciDeploymentPrefix`|The prefix used for all AD objects created for the Azure Stack HCI deployment. <br> The prefix must not exceed 8 characters.|
|`-Deploy`|Select this scenario for a brand new deployment instead of an upgrade of an existing system.|

## Prepare Active Directory

When you prepare Active Directory, you create a dedicated Organizational Unit (OU) to place all the Azure Stack HCI related objects such as computer accounts.

> [!NOTE]
> In this release, only the Active Directory prepared via the provided module is supported.

To prepare and configure Active Directory, follow these steps:

1. Sign in to a computer that is joined to your Active Directory domain as a domain administrator.
1. Run PowerShell as administrator.
1. Run the following command to create the dedicated OU.

    ```powershell
    New-HciAdObjectsPreCreation -AzureStackLCMUserCredential (Get-Credential) -AsHciOUName "<OU name or distinguished name including the domain components>"

1. When prompted, provide the username and password for the deployment. 
    1. Make sure that only the username is provided. The name should not include the domain name, for example, `contoso\username`. **Username must be between 1 to 64 characters and only contain letters, numbers, hyphens, and underscores and may not start with a hyphen or number.**
    1. Make sure that the password meets complexity and length requirements. **Use a password that is at least 12 characters long and contains: a lowercase character, an uppercase character, a numeral, and  a special character.** <!--For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow).-->


    Here is a sample output from a successful completion of the script:

    ```
    PS C:\work> ConvertTo-SecureString '<password>' -AsPlainText -Force
    PS C:\work> "ms309deployuser"
    PS C:\work> $credential = New-Object System.Management.Automation.PSCredential ($user, $password)
    PS C:\work> New-HciAdObjectsPreCreation -AzureStackLCMUserCredential $credential -AsHciOUName "OU=ms309,DC=PLab8,DC=nttest,DC=microsoft,DC=com"    
    
    PS C:\temp>
    ```

1. Verify that the OU is created.  If using a Windows Server client, go to **Server Manager > Tools > Active Directory Users and Computers**.

1. An OU with the specified name should be created and within that OU, you'll see the deployment user.

    :::image type="content" source="media/deployment-prep-active-directory/active-directory-1.png" alt-text="Screenshot of Active Directory Computers and Users window." lightbox="media/deployment-prep-active-directory/active-directory-1.png":::

    :::image type="content" source="media/deployment-prep-active-directory/active-directory-2.png" alt-text="Screenshot of Active Directory Cluster Name Object window." lightbox="media/deployment-prep-active-directory/active-directory-2.png":::

    :::image type="content" source="media/deployment-prep-active-directory/active-directory-3.png" alt-text="Screenshot of Active Directory Users Object window." lightbox="media/deployment-prep-active-directory/active-directory-3.png":::

> [!NOTE]
> If you are repairing a single server, do not delete the existing OU. If the server volumes are encrypted, deleting the OU removes the BitLocker recovery keys.

## Next steps

- [Install Azure Stack HCI, version 23H2 operating system](./deployment-install-os.md) on each server in your cluster.
