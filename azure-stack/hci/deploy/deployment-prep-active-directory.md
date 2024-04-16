--- 
title: Prepare Active Directory for new Azure Stack HCI, version 23H2 deployment
description: Learn how to prepare Active Directory before you deploy Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 03/11/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Prepare Active Directory for Azure Stack HCI, version 23H2 deployment

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare your Active Directory environment before you deploy Azure Stack HCI, version 23H2.

Active Directory requirements for Azure Stack HCI include:

- A dedicated Organization Unit (OU).
- Group policy inheritance that is blocked for the applicable Group Policy Object (GPO).
- A user account that has all rights to the OU in the Active Directory.

> [!NOTE]
> - You can use your existing process to meet the above requirements. The script used in this article is optional and is provided to simplify the preparation.
> - When group policy inheritance is blocked at the OU level, enforced GPO's aren't blocked. Ensure that any applicable GPO, which are enforced, are also blocked using other methods, for example, using [WMI Filters](https://techcommunity.microsoft.com/t5/ask-the-directory-services-team/fun-with-wmi-filters-in-group-policy/ba-p/395648) or [security groups](/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012).

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](./deployment-prerequisites.md) for new deployments of Azure Stack HCI.
- [Download and install the version 2402 module from the PowerShell Gallery](https://www.powershellgallery.com/packages/AsHciADArtifactsPreCreationTool/10.2402). Run the following command from the folder where the module is located:

    ```powershell
    Install-Module AsHciADArtifactsPreCreationTool -Repository PSGallery -Force
    ```

    > [!NOTE]
    > Make sure to uninstall any previous versions of the module before installing the new version.

- You have obtained permissions to create an OU. If you don't have permissions, contact your Active Directory administrator.

## Active Directory preparation module

The *AsHciADArtifactsPreCreationTool.ps1* module is used to prepare Active Directory. Here are the required parameters associated with the cmdlet:

|Parameter|Description|
|--|--|
|`-AzureStackLCMUserCredential`|A new user object that is created with the appropriate permissions for deployment. This account is the same as the user account used by the Azure Stack HCI deployment.<br> Make sure that only the username is provided. The name should not include the domain name, for example, `contoso\username`.<br>The password must conform to the length and complexity requirements. Use a password that is at least 12 characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow). <br> The name must be unique for each deployment and you can't use *admin* as the username.|
|`-AsHciOUName`|A new Organizational Unit (OU) to store all the objects for the Azure Stack HCI deployment. Existing group policies and inheritance are blocked in this OU to ensure there's no conflict of settings. The OU must be specified as the distinguished name (DN). For more information, see the format of [Distinguished Names](/previous-versions/windows/desktop/ldap/distinguished-names).|

<!--|`-AsHciPhysicalNodeList`|A list of computer names that are created for the physical cluster servers.|
|`-DomainFQDN`|Fully qualified domain name (FQDN) of the Active Directory domain.|
|`-AsHciClusterName`|The name for the new cluster AD object.|
|`-AsHciDeploymentPrefix`|The prefix used for all AD objects created for the Azure Stack HCI deployment. <br> The prefix must not exceed 8 characters.|
|`-Deploy`|Select this scenario for a brand new deployment instead of an upgrade of an existing system.|-->

> [!NOTE]
> The `-AsHciOUName` path does not support the following special characters **anywhere** within the OUPath.
> 
> **& < > \ '**
> 
> Additionally, it is not supported to move the computer objects to a different OU once the deployment is complete.

## Prepare Active Directory

When you prepare Active Directory, you create a dedicated Organizational Unit (OU) to place the Azure Stack HCI related objects such as deployment user.


To create a dedicated OU, follow these steps:

1. Sign in to a computer that is joined to your Active Directory domain.
1. Run PowerShell as administrator.
1. Run the following command to create the dedicated OU.

    ```powershell
    New-HciAdObjectsPreCreation -AzureStackLCMUserCredential (Get-Credential) -AsHciOUName "<OU name or distinguished name including the domain components>"

1. When prompted, provide the username and password for the deployment.
    
    1. Make sure that only the username is provided. The name should not include the domain name, for example, `contoso\username`. **Username must be between 1 to 64 characters and only contain letters, numbers, hyphens, and underscores and may not start with a hyphen or number.**
    1. Make sure that the password meets complexity and length requirements. **Use a password that is at least 12 characters long and contains: a lowercase character, an uppercase character, a numeral, and  a special character.** 


    Here is a sample output from a successful completion of the script:

    ```
    PS C:\work> $password = ConvertTo-SecureString '<password>' -AsPlainText -Force
    PS C:\work> $user = "ms309deployuser"
    PS C:\work> $credential = New-Object System.Management.Automation.PSCredential ($user, $password)
    PS C:\work> New-HciAdObjectsPreCreation -AzureStackLCMUserCredential $credential -AsHciOUName "OU=ms309,DC=PLab8,DC=nttest,DC=microsoft,DC=com"    
    PS C:\work>
    ```

1. Verify that the OU is created.  If using a Windows Server client, go to **Server Manager > Tools > Active Directory Users and Computers**.

1. An OU with the specified name should be created and within that OU, you'll see the deployment user.

    :::image type="content" source="media/deployment-prep-active-directory/active-directory-11.png" alt-text="Screenshot of Active Directory Computers and Users window." lightbox="media/deployment-prep-active-directory/active-directory-11.png":::


> [!NOTE]
> If you are repairing a single server, do not delete the existing OU. If the server volumes are encrypted, deleting the OU removes the BitLocker recovery keys.

## Next steps

- [Download Azure Stack HCI, version 23H2 software](./download-azure-stack-hci-23h2-software.md) on each server in your cluster.
