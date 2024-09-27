--- 
title: Custom or advanced Active Directory configuration for Azure Stack HCI, version 23H2
description: Learn how to assign the required permissions and create the required DNS records for use by Active Directory for your Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 06/26/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurepowershell
---

# Custom Active Directory configuration for your Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the permissions and the DNS records required for the Azure Stack HCI, version 23H2 deployment. The article also uses examples with detailed steps on how to manually assign permissions and create DNS records for your Active Directory environment.

The Azure Stack HCI solution is deployed in large Active Directories with established processes and tools for assigning permissions. Microsoft provides an [Active Directory preparation script](../deploy/deployment-prep-active-directory.md) that can be optionally used for the Azure Stack HCI deployment. The required permissions for Active Directory, the creation of the organizational unit, and blocking inheritance of GPOs - can all be also configured manually.

You also have the choice of the DNS server to use, for example, you can use Microsoft DNS servers that support the integration with Active Directory to take advantage of secure dynamic updates. If Microsoft DNS servers aren't used, you must create a set of DNS records for the deployment and update of the Azure Stack HCI solution.


## About Active Directory requirements

Here are some of the Active Directory requirements for the Azure Stack HCI deployment.

- A dedicated organization unit (OU) is required to optimize query times for the object discovery. This optimization is critical for large Active Directories spanning multiple sites. This dedicated OU is only required for the computer objects and the Windows failover cluster CNO.

- The user (also known as deployment user) requires the necessary permissions over the dedicated OU. The user can reside anywhere in the directory.

- Blocking group policy inheritance is required to prevent any conflicts of settings coming from group policy objects. The new engine introduced with Azure Stack HCI, version 23H2 manages security defaults including the drift protection. For more information, see [Security features for Azure Stack HCI, version 23H2](../concepts/security-features.md).

- Computer account objects and cluster CNO can be [precreated](/windows-server/failover-clustering/prestage-cluster-adds) using the deployment user as an alternative to the deployment itself creating them.

## Required permissions

The permissions required by the user object referenced as deployment user is scoped to be applicable to the dedicated OU only. The permissions can be summarized as read, create, and delete computer objects with the ability to retrieve BitLocker recovery information.

Here's a table that contains the permissions required for the deployment user and the cluster CNO over the OU and all descendant objects.


|Role  |Description of assigned permissions |
|---------|---------|
|Deployment user over OU and all descendant objects    | List contents.<br> Read all properties.<br> Read permissions. <br> Create computer objects. <br> Delete computer objects.        | 
|Deployment user over OU but applied only to descendant *msFVE-Recoveryinformation* objects  |Full control.<br> List contents.<br> Read all properties.<br> Write all properties.<br> Delete.<br> Read permissions.<br> Modify permissions.<br> Modify owner.<br> All validated writes.        |
|Cluster CNO over the OU applied to this object and all descendant objects     |Read all properties.<br> Create Computer objects.         |


### Assign permissions using PowerShell

You can use PowerShell cmdlets to assign appropriate permissions to deployment user over OU. The following example shows how you can assign the required permissions to a *deploymentuser* over the OU *HCI001* that resides in the Active Directory domain *contoso.com*.

> [!NOTE]
> The script requires you to precreate user object [New-ADUser](/powershell/module/activedirectory/new-aduser?view=windowsserver2022-ps&preserve-view=true) and [OU](/powershell/module/activedirectory/new-adorganizationalunit?view=windowsserver2022-ps&preserve-view=true) in your Active Directory. For more information on how to block group policy inheritance, see [Set-GPInheritance](/powershell/module/grouppolicy/set-gpinheritance?view=windowsserver2022-ps&preserve-view=true).

Run the following PowerShell cmdlets to import the Active Directory module and assign required permissions:

```powershell
#Import required module
import-module ActiveDirectory

#Input parameters
$ouPath ="OU=HCI001,DC=contoso,DC=com"
$DeploymentUser="deploymentuser"

#Assign required permissions
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

#Set computers object GUID, this is a well-known ID
$computersObjectType = [System.Guid]::New('bf967a86-0de6-11d0-a285-00aa003049e2')

#Set msFVE-RecoveryInformation GUID,this is a well-known ID
$msfveRecoveryGuid = [System.Guid]::New('ea715d30-8f53-40d0-bd1e-6109186d782c')
$rule1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($userIdentityReference, $adRight, $type, $computersObjectType, $inheritanceType)
$rule2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($userIdentityReference, $readPropertyRight, $type, $allObjectType , $inheritanceType)
$rule3 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($userIdentityReference, $genericAllRight, $type, $inheritanceType, $msfveRecoveryGuid)
$acl.AddAccessRule($rule1)
$acl.AddAccessRule($rule2)
$acl.AddAccessRule($rule3)
Set-Acl -Path $ouPath -AclObject $acl
```

## Required DNS records

If your DNS server doesn't support secure dynamic updates, you must create required DNS records before you deploy your Azure Stack HCI system.

The following table contains the required DNS records and types:

| Object        | Type   |
|---------------|--------|
| Machine name  | Host A |
| Cluster CNO   | Host A |
| Cluster VCO   | Host A |

> [!NOTE]
> Every machine that becomes a part of the Azure Stack HCI cluster requires a DNS record.

### Example - verify that DNS record exists

To verify that the DNS record exists, run the following command:

```powershell
nslookup "machine name"
```

## Disjoint namespace

A disjoint namespace occurs when the primary DNS suffix of one or more domain member computers doesn't match the DNS name of their Active Directory domain. For example, if a computer has a DNS name of corp.contoso.com but is part of an Active Directory domain called na.corp.contoso.com, it's using a disjoint namespace.

Before deploying Azure Stack HCI version 23H2, you must:

- Append the DNS suffix to the management adapter of every node.
- Verify you can resolve the hostname to the FQDN of the Active Directory.

### Example - append the DNS suffix

To append the DNS suffix, run the following command:

```powershell
Set-DnsClient -InterfaceIndex 12 -ConnectionSpecificSuffix "na.corp.contoso.com"
```

### Example - resolve the hostname to the FQDN

To resolve the hostname to the FQDN, run the following command:

```powershell
nslookup node1.na.corp.contoso.com
```

> [!NOTE]
> You cannot use group policies to configure the DNS suffix list with Azure Stack HCI, version 23H2.

## Cluster aware updating (CAU)

Cluster aware updating applies a client access point (Virtual Computer Object) that requires a DNS record.

In environments where dynamic secure updates aren't possible, you're required to manually create the Virtual Computer Object (VCO). For more information on how to create the VCO, see [Prestage cluster computer objects in Active Directory Domain Services](/windows-server/failover-clustering/prestage-cluster-adds#more-information).

> [!NOTE]
> Make sure to disable Dynamic DNS update in the Windows DNS client. This setting is protected by the drift control and is built into the Network ATC. Create the VCO immediately after disabling dynamic updates to avoid the drift rollback.
> For more information on how to change this protected setting, see [Modify security defaults](../manage/manage-secure-baseline.md#modify-security-defaults). <!--Unfortunately, the timing is very critical because the setting is protected by the drift control build into Network ATC.-->

### Example – disable dynamic update

To disable dynamic update, run the following command:

```powershell
Get-NetAdapter "vManagement*"|Set-DnsClient -RegisterThisConnectionsAddress $false
```

## Next steps

Proceed to:
- [Download the Azure Stack HCI OS software](../deploy/download-azure-stack-hci-23h2-software.md).
- [Install the Azure Stack HCI OS software](../deploy/deployment-install-os.md).