--- 
title: Custom or advanced Active Directory configuration for Azure Stack HCI, version 23H2
description: Learn how to assign the required permissions and create the required DNS records for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 06/20/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurepowershell
---

# Custom Active Directory configuration for your Azure Stack HCI, version 23H2

Many of our customers deploy Azure Stack HCI in large Active Directories with established processes and tools for assigning permissions. The Active Directory preparation script provided for Azure Stack HCI is optional and all required permissions can be configured manually including the creation of the organizational unit and blocking inheritance of GPOs.

Furthermore, it is a customer choice what DNS server to use, for example,  Microsoft DNS servers that support integration with Active Directory to take advantage of secure dynamic update. If none Microsoft DNS servers are used, a set of DNS records must be created for HCI to enable deployment and update of the solution.

The purpose of this article is to detail the required permissions and DNS records required for Azure Stack HCI, including examples.

## Overview

Before diving into the details,  lets clarify some of the Active Directory requirements.

A dedicated organization unit referenced as OU in the article going forward is required to optimize query times for object discovery, which is critical for large Active Directories spanning multiple Sites. This dedicated OU is only required for the computer objects and the Windows failover cluster CNO.

The user referenced as deployment user can reside anywhere in the directory it just requires the necessary permissions over the dedicated OU.

Blocking group policy inheritance is required to prevent any conflicts of settings coming from group policy objects and the new engine introduced with HCI version 23H2 that manages security settings including drift protection. You can learn more about security features in [Security features for Azure Stack HCI, version 23H2](../concepts/security-features).

Computer account objects and cluster CNO can be [precreated](https://learn.microsoft.com/windows-server/failover-clustering/prestage-cluster-adds) using the deployment user as an alternative to have the deployment itself create them.

## Required permissions

The permissions required by the user object referenced as deployment user is scoped to be applicable to the dedicated OU only.

The permissions can be summarized as read, create, and delete computer objects with the ability to retrieve BitLocker recovery information.

1. Permissions the deployment user must have over the OU and all descendant objects:

   - List contents.
   - Read all properties.
   - Read permissions.
   - Create computer objects.
   - Delete computer objects.

1. Permissions the deployment user must have over the OU but applied only to Descendant *msFVE-Recoveryinformation* objects.

   - Full control.
   - List contents.
   - Read all properties.
   - Write all properties.
   - Delete.
   - Read permissions.
   - Modify permissions.
   - Modify owner.
   - All validated writes.

1. Permissions the cluster CNO must have over the OU applied to this object and all descendant objects.

   - Read all properties.
   - Create Computer objects.

## Example – assign permissions using PowerShell

The following example shows how you can assign the required permissions to a user called *deploymentuser* over the OU named *HCI001* which does reside in the Active Directory domain contoso.com.

> [!NOTE]
> The script requires the user object [New-ADUser](https://learn.microsoft.com/powershell/module/activedirectory/new-aduser?view=windowsserver2022-ps) and [OU](https://learn.microsoft.com/powershell/module/activedirectory/new-adorganizationalunit?view=windowsserver2022-ps) already created in your Active Directory. For more information on how to block group policy inheritance, see [Set-GPInheritance](https://learn.microsoft.com/powershell/module/grouppolicy/set-gpinheritance?view=windowsserver2022-ps).

Run the following PowerShell cmdlets to import the Active Directory module and assign required permissions:

```powershell
#Required Module to be imported
import-module ActiveDirectory

#Input parameters
$ouPath ="OU=HCI001,DC=contoso,DC=com"
$DeploymentUser="deploymentuser"

#Assign required permission
$userSecurityIdentifier = Get-ADuser -Identity $Deploymentuser
$userSID = [System.Security.Principal.SecurityIdentifier] $userSecurityIdentifier.SID
$acl = Get-Acl -Path $ouPath
$userIdentityReference = [System.Security.Principal.IdentityReference] $userSID
$adRight = [System.DirectoryServices.ActiveDirectoryRights]::CreateChild -bor [System.DirectoryServices.ActiveDirectoryRights]::DeleteChild
$genericAllRight = [System.DirectoryServices.ActiveDirectoryRights]::GenericAll
$readPropertyRight = [System.DirectoryServices.ActiveDirectoryRights]::ReadProperty
$type = [System.Security.AccessControl.AccessControlType]::Allow 
$inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::All 
$allObjectType = [System.Guid]::Empty
#Computers object guid, this is a well-known ID
$computersObjectType = [System.Guid]::New('bf967a86-0de6-11d0-a285-00aa003049e2')
#msFVE-RecoveryInformation guid,this is a well-known ID
$msfveRecoveryGuid = [System.Guid]::New('ea715d30-8f53-40d0-bd1e-6109186d782c')
$rule1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($userIdentityReference, $adRight, $type, $computersObjectType, $inheritanceType)
$rule2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($userIdentityReference, $readPropertyRight, $type, $allObjectType , $inheritanceType)
$rule3 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($userIdentityReference, $genericAllRight, $type, $inheritanceType, $msfveRecoveryGuid)
$acl.AddAccessRule($rule1)
$acl.AddAccessRule($rule2)
$acl.AddAccessRule($rule3)
Set-Acl -Path $ouPath -AclObject $acl
```

## DNS records

If your DNS server doesn't support secure dynamic updates, you must create required records prior to starting the deployment of Azure Stack HCI version 23H2.

Below is the list of required DNS records and types:

| Object        | Type   |
|---------------|--------|
| Machine name  | Host A |
| Cluster CNO   | Host A |
| Cluster VCO   | Host A |

> [!NOTE]
> Every machine that will become part of the cluster requires a DNS record.

## Example - verify if DNS record does exist

Nslookup “machine name”

## Cluster aware updating (CAU)

Cluster aware updating does apply a client access point (VCO) which does require a DNS record.

In environments where dynamic secure updates aren't possible it requires to manually create the VCO. For more information about how to create the VCO, see [Prestage cluster computer objects in Active Directory Domain Services](https://learn.microsoft.com/windows-server/failover-clustering/prestage-cluster-adds#more-information).

> [!NOTE]
> Dynamic DNS update must be disabled in the Windows DNS client. Unfortunately, the timing is very critical because the setting is protected by the drift control build into Network ATC.

## Example – Disable dynamic update

Run the following PowerShell cmdlet to disable dynamic updates.

```powershell
Get-NetAdapter “vManagement*”|Set-DnsClient -RegisterThisConnectionsAddress $false
```

## Next steps
