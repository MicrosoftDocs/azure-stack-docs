--- 
title: Prepare Active Directory for Azure Local, version 23H2 deployment
description: Learn how to prepare Active Directory before you deploy Azure Local, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 03/04/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---
test
# Prepare Active Directory for Azure Local deployment

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to prepare your Active Directory environment before you deploy Azure Local.

Active Directory requirements for Azure Local include:

- A dedicated Organization Unit (OU).
- Group policy inheritance that is blocked for the applicable Group Policy Object (GPO).
- A user account that has all rights to the OU in the Active Directory.
- Machines must not be joined to Active Directory before deployment.

> [!NOTE]
> - You can use your existing process to meet the above requirements. The script used in this article is optional and is provided to simplify the preparation.
> - When group policy inheritance is blocked at the OU level, GPOs with enforced option enabled aren't blocked. If applicable, ensure that these GPOs are blocked using other methods, for example using a [Windows Management Instrumentation (WMI) Filter](https://techcommunity.microsoft.com/t5/ask-the-directory-services-team/fun-with-wmi-filters-in-group-policy/ba-p/395648). Apply the WMI filter to any enforced GPOs, to exclude machine computer accounts for your Azure Local instances from applying the GPOs. Once the filter is applied, enforced GPOs won't apply, based on the logic defined in the WMI filter.

To manually assign the required permissions for Active Directory, create an OU, and block GPO inheritance, see
[Custom Active Directory configuration for your Azure Local](../plan/configure-custom-settings-active-directory.md).

## Prerequisites

- Complete the [prerequisites](./deployment-prerequisites.md) for new deployments of Azure Local.
- Install version 2402 of the ['AsHciADArtifactsPreCreationTool'](https://www.powershellgallery.com/packages/AsHciADArtifactsPreCreationTool/10.2402) module. Run the following command to install the module from PowerShell Gallery:

    ```powershell
    Install-Module AsHciADArtifactsPreCreationTool -Repository PSGallery -Force
    ```

    > [!NOTE]
    > Make sure to uninstall any previous versions of the module before installing the new version.

- You require permissions to create an OU. If you don't have permissions, contact your Active Directory administrator.

- If you have a firewall between your Azure Local system and Active Directory, ensure that the proper firewall rules are configured. For specific guidance, see [Firewall requirements for Active Directory Web Services and Active Directory Gateway Management Service](../concepts/firewall-requirements.md). See also [How to configure a firewall for Active Directory domains and trusts](/troubleshoot/windows-server/active-directory/config-firewall-for-ad-domains-and-trusts#windows-server-2008-and-later-versions).

## Active Directory preparation module

The `New-HciAdObjectsPreCreation` cmdlet of the AsHciADArtifactsPreCreationTool PowerShell module is used to prepare Active Directory for Azure Local deployments. Here are the required parameters associated with the cmdlet:

|Parameter|Description|
|--|--|
|`-AzureStackLCMUserCredential`|A new user object that is created with the appropriate permissions for deployment. This account is the same as the user account used by the Azure Local deployment.<br> Make sure that only the username is provided. The name shouldn't include the domain name, for example, `contoso\username`.<br>The password must conform to the length and complexity requirements. Use a password that is at least 14 characters long. The password must also contain three out of the four requirements: a lowercase character, an uppercase character, a numeral, and  a special character.<br>For more information, see [password complexity requirements](/azure/active-directory-b2c/password-complexity?pivots=b2c-user-flow).<br> The name can't be exactly the same as the local admin user. <br> The name can use *admin* as the username.|
|`-AsHciOUName`|A new Organizational Unit (OU) to store all the objects for the Azure Local deployment. Existing group policies and inheritance are blocked in this OU to ensure there's no conflict of settings. The OU must be specified as the distinguished name (DN). For more information, see the format of [Distinguished Names](/previous-versions/windows/desktop/ldap/distinguished-names).|

> [!NOTE]
> - The `-AsHciOUName` path doesn't support the following special characters anywhere within the path: `&,",',<,>`.
> - After the deployment is complete, moving the computer objects to a different OU isn't supported.

## Prepare Active Directory

When you prepare Active Directory, you create a dedicated Organizational Unit (OU) to place the Azure Local related objects such as deployment user.

To create a dedicated OU, follow these steps:

1. Sign in to a computer that is joined to your Active Directory domain.
1. Run PowerShell as administrator.
1. Run the following command to create the dedicated OU.

    ```powershell
    New-HciAdObjectsPreCreation -AzureStackLCMUserCredential (Get-Credential) -AsHciOUName "<OU name or distinguished name including the domain components>"

1. When prompted, provide the username and password for the deployment.

    1. Make sure that only the username is provided. The name shouldn't include the domain name, for example, `contoso\username`. **Username must be between 1 to 64 characters and only contain letters, numbers, hyphens, and underscores and may not start with a hyphen or number.**
    1. Make sure that the password meets complexity and length requirements. **Use a password that is at least 14 characters long and contains: a lowercase character, an uppercase character, a numeral, and  a special character.**

    Here's a sample output from a successful completion of the script:

    ```powershell
    PS C:\work> $password = ConvertTo-SecureString '<password>' -AsPlainText -Force
    PS C:\work> $user = "ms309deployuser"
    PS C:\work> $credential = New-Object System.Management.Automation.PSCredential ($user, $password)
    PS C:\work> New-HciAdObjectsPreCreation -AzureStackLCMUserCredential $credential -AsHciOUName "OU=ms309,DC=PLab8,DC=nttest,DC=microsoft,DC=com"    
    PS C:\work>
    ```

1. Verify that the OU is created. If using a Windows Server client, go to **Server Manager > Tools > Active Directory Users and Computers**.

1. An OU with the specified name is created. This OU contains the new Lifecycle Manager (LCM) deployment user account.

    :::image type="content" source="media/deployment-prep-active-directory/active-directory-11.png" alt-text="Screenshot of Active Directory Computers and Users window." lightbox="media/deployment-prep-active-directory/active-directory-11.png":::

> [!NOTE]
> If you're repairing a single machine, don't delete the existing OU. If the machine volumes are encrypted, deleting the OU removes the BitLocker recovery keys.

## Considerations for large scale deployments

The LCM user account is used during servicing operations, such as applying updates via PowerShell. This account is also used when performing domain join actions against your AD, such as [repairing a node](../manage/repair-server.md) or [adding a node](../manage/add-server.md). This requires the LCM user identity having delegated permissions to add computer accounts to the target OU in the on-premises domain.

During the cloud deployment of Azure Local, the LCM user account is added to the local administrators group of the physical nodes. To mitigate the risk of a compromised LCM user account, **we recommend having a dedicated LCM user account with a unique password for each Azure Local instance.** This recommendation limits the scope and impact of a compromised LCM account to a single instance.

We recommend that you follow these best practices for OU creation. These recommendations are automated when you use the `New-HciAdObjectsPreCreation` cmdlet to [Prepare Active Directory](#active-directory-preparation-module).

- For each Azure Local instance, create an individual OU within Active Directory. This approach helps manage the LCM user account, the computer accounts of the physical machines, and the cluster name object (CNO) within the scope of a single OU for each instance.
- When deploying multiple instances at-scale, for easier management:
  - Create an OU under a single parent OU for each instance.
  - Enable the **Block Inheritance** option at both the parent OU and sub OU levels.
  - To apply a GPO to all Azure Local instances, such as for nesting a domain group in the local administrators group, link the GPO to the parent OU and enable the **Enforced** option. By doing this, you apply the configuration to all sub OUs, even with **Block Inheritance** enabled.

If your organization's processes and procedures require deviations from these recommendations, they are allowed. However, it's important to consider the security and manageability implications of your design taking these factors into consideration.

## Next steps

- [Download operating system for Azure Local deployment](./download-23h2-software.md) on each machine in your system.
