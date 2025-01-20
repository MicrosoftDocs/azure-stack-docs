---
title: Understand and plan your identity for disconnected operations on Azure Local (preview)
description: Integrate your identity with disconnected operations on Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 01/17/2025

#customer intent: As a Senior Content Developer, I aim to provide customers with top-quality content to help them understand and plan their identity for Disconnected Operations on Azure Local.
---

# Plan your identity for disconnected operations on Azure Local (preview) 

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This guide helps you plan and integrate your identity with disconnected operations on Azure Local. It explains how to configure your identity solution to work with disconnected operations and understand the actions and roles available to operators.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Understand and plan identity

For disconnected operations, you need to integrate with an existing identity and access management solution. Before you deploy and configure disconnected operations, make sure you understand how the identity solution is integrated. Also, know the steps required for successful integration and how the identity solution is applied in disconnected operations.

Disconnected operations has been validated for the following solutions:

- **AD (LDAP v3)**: Groups and memberships  
- **ADFS (OIDC)**: Authentication  

> [!NOTE]
> While the system might work with other solutions, support during the preview is only available for these validated systems.

## How identity integration works

### Deployment  

During deployment, you configure disconnected operations to integrate with your IDP/IAM. Currently, you need to specify a **Root operator**. This user owns a special operator subscription and is responsible for adding other operators' post-deployment. The **Operator subscription** is the scope that defines operator actions, and individual actions are based on the **Operator role**.

On a high level, the OIDC endpoint authenticates users to disconnected operations, and the LDAP endpoint integrates groups and memberships from your enterprise. Once integrated, standard Azure role-based access control is assigned to the desired scopes.  

> [!NOTE]
> Role assignments and policies aren't inherited from the operator subscription to individual subscriptions. Each subscription has its own scope. Only specific roles assigned to individual subscriptions can perform actions within that specific subscription.

## Understanding the operator role and actions  

You can assign more operators to the operator subscription, which allows operator-related actions (day-to-day operations) to be performed. The built-in role (Owner) on the operator subscription allows the following actions on the scope: `/Subscriptions/\<GUID>/Microsoft.WinfieldOperator/*`.  

This is a comprehensive list of actions that should be available but note that it’s subject to change. Some areas are to be included in later releases.

### Identity and access management

| Action                                | Operator |  
|---------------------------------------|----------|  
| Assign more operators           | Y        |  
| View group memberships (synced)       | Y        |  
| View identity synchronization status  | Y        |  
| View Identity configuration           | Y        |  
| List SPNs                             | Y        |  
| Create SPN                            | Y        |  
| Delete SPN <sub>2</sub>               | Y        |  
| Update SPN <sub>2</sub>               | Y        |

### Subscription management

| Action                                | Operator |
|---------------------------------------|----------|
| List all subscriptions                | Y        |  
| Create subscriptions                  | Y        |  
| Rename subscription                   | Y        |  
| Suspend subscription <sub>3</sub>     | Y        |  
| Resume subscription                   | Y        |  
| Delete subscription <sub>1</sub>      | Y        |  
| Reassign subscription ownership      | Y        |  
| List alias                            | Y        |  
| Create Alias                          | Y        |  
| Delete Alias                          | Y        |  

### Update

| Action                                | Operator |
|---------------------------------------|----------|  
| Upload update <sub>3</sub>            | Y        |  
| Trigger update <sub>3</sub>           | Y        |  
| Get update status <sub>3</sub>        | Y        |  
| Schedule update <sub>3</sub>          | Y        |  
| View update history <sub>3</sub>      | Y        |

### Observability and diagnostics

| Action                                          | Operator |
|-------------------------------------------------|----------|  
| Configure syslog forwarding                     | Y        |  
| Collect logs                                    | Y        |  
| Download logs                                   | Y        |  
| Configure diagnostics and telemetry settings    | Y        |

### Usage / billing / registration

| Action                                          | Operator |
|-------------------------------------------------|----------|
| Get usage data <sub>3</sub>                     | Y        |  
| View instance license information <sub>3</sub>  | Y        |  
| Register disconnected operations <sub>3</sub>   | Y        |

### Secrets management

| Action                                          | Operator |
|-------------------------------------------------|----------|
| View external secrets expiration <sub>3</sub>   | Y        |  
| Rotate secrets (internal) <sub>3</sub>          | Y        |  
| Rotate secrets (external certificates) <sub>3</sub> | Y    |  

<sub>1. Operator subscription cannot be deleted</sub>
<sub>2. SPNs can also be deleted by the owners assigned to the SPN itself</sub>
<sub>3. Scoped for release in the future</sub>

The Portal UX isn't available for each of these actions, and some backend capabilities aren't ready for public preview. The list is for completeness of what should be available, with some areas coming post public preview.

> [!NOTE]
> Other built-in roles such as *Security operator*, *Subscription manager*, and *Support operator* might be considered and evaluated post preview if needed. To achieve more detailed operator roles, you can create custom role definitions based on the operator role and assign access to the operator subscription.

## Understanding synchronization  

After you complete the initial configuration, groups with group memberships are synchronized, making them accessible from disconnected operations. To see which groups and memberships are synchronized, you can view them using an Operator API, such as `Get-ApplianceExternalIdentityObservability` listed in the Appendix. In later releases, you can view them through the Portal. Synchronization runs periodically, every 6 hours.

## Identity checklist  

Here's a checklist to help you plan your identity integration with disconnected operations.

Identify IP addresses or a fully qualified domain name (FQDN) for the:  

- LDAP endpoint (LDAP v3)  
- Login endpoint (OIDC)  

If you use an FQDN for the LDAP endpoint:  

- Ensure the disconnected operations appliance is configured and uses a domain name system (DNS) that can resolve the endpoint provided.  
- Create an account with read-only access on the LDAP v3 server (AD).  
- Identify the root group for membership synchronization.  
- Identify UPN: The user to be assigned the role of **Initial operator**.  

The following parameters must be collected and available before deployment:  

| Parameter Name                    | Description                                                                 | Example                                           |  
|-----------------------------------|-----------------------------------------------------------------------------|---------------------------------------------------|  
| Authority                         | An accessible authority URI that gives information about OIDC endpoints, metadata, and more. | `https://adfs.contoso-winfield.com/adfs` |  
| ClientID                          | AppID created when setting up the adfsclient app.                            | `1e7655c5-1bc4-52af-7145-afdf6bbe2ec1`            |  
| LdapServer                        | LDAP v3 endpoint that can be reached from disconnected operations. This is used to synchronize groups and group memberships. | `Ldap.contoso.com`                                |  
| LdapCredential (Username + Password) | Credentials (read-only) for LDAP integration.                             | Username: `ldapreader` Password: `******`         |  
| RootOperatorUserPrincipalName     | UPN for the initial operator persona granted access to the Operator subscription | `Cloud-admin@contoso.com`        |  
| SyncGroupIdentifier               | GUID to AD group to start syncing from. Example: | `$group = Get-ADGroup -Identity “mygroup” \| Select-Object Name, ObjectGUID  81d71e5c5-abc4-11af-8132-afdf6bbe2ec1` |
| LdapsCertChainInfo                | Certificate chain information for Ldap. This is used to validate calls from the appliance to LDAP. Don't omit this in production it can cause certificate validation for identity integration to be skipped. However, this can be omitted for demo purposes. | MIIF ......  |
|OidcCertChainInfo                  | Certificate chain information used for Oidc to validate tokens from OpenId Connect compliant endpoint. Don't omit this in production it can cause certificate validation for identity integration to be skipped. However, this can be omitted for demo purposes. | MIID ......  |

<!--For more information on how to get LdapsCertChainInfo and OidcCertChainInfo, see [Understand and plan PKI](link).-->

Example Configuration Object:

```console  
$idpConfig = @{  
     authority = 'https://adfs.contoso-winfield.com/adfs'  
     clientId  = '9e7655c5-1bc4-45af-8345-cdf6bbf4ec1'  
     rootOperatorUserPrincipalName = 'operator@contoso.com'  
     ldapServer                    = 'ldap.contoso.com'  
     ldapUsername                  = 'ldapreader'  
     ldapPassword                  = $ldappass  
     syncGroupIdentifier           = '81d71e5c5-abc4-11af-8132-afdf6bbe2ec1'  
}
```  

> [!NOTE]
> Identity endpoints must be secured with certificates that share the same root of trust as those used for the disconnected operations appliance. Multiple roots of trust aren't supported.

## Current limitations

- **Users/Group removal after synchronization**: If users and groups with memberships are removed after the last sync, they aren't cleaned up in the disconnected operations graph. This can cause errors when querying group memberships.
- **No force synchronization capability**: Sync runs every 6 hours.  
- **No management groups or aggregate root level**: Not available for multiple subscriptions.  
- **Supported validations**: Only AD + ADFS are validated for support.
    - [Install Active Directory Domain Services (Level 100)](/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
    - [Active Directory Federation Services Overview](/windows-server/identity/ad-fs/ad-fs-overview)

## Mitigate issues with identity integration  

As a host administrator, you can use the disconnected operations PowerShell cmdlet to update and change a few settings to mitigate rainy-day scenarios that might occur. Here are some scenarios where you might need to reconfigure your identity settings to mitigate issues:  

- **Synchronization failed / Didn’t start**:  
  - Ensure LDAP credentials are valid.  
  - Ensure LDAP credentials have read access.  
  - Ensure disconnected operations has network line of sight to the LDAP server, can resolve the FQDN (if not using IP address), and there are no firewalls blocking traffic.  

- **Wrong set of groups synchronized**:  
  - Verify that the `SyncGroupIdentifier` is set to the correct root. The one you're synchronizing from.  

- **Lost access to operator subscription**:  
  - To re-establish access to the operator, change the `rootOperatorUserPrincipalName`.  

## Cmdlets for identity integration  

As a host administrator, with the disconnected operations module and certificates used during installation available, you have a range of cmdlets to change settings and help you to troubleshoot the identity integration. Use the Get-command `ApplianceExternalIdentity` for a list of cmdlets available for identity integration.

## Appendix

<details>
<summary>Set up AD/ADDS for demo purposes</summary>

Use PowerShell on Windows Server 2022 or newer:

```powershell
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the ADDSDeployement module
Import-Module ADDSDeployment


# Install the ADFS role
Install-WindowsFeature ADFS-Federation -IncludeManagementTools

#Promote the server to a domain controller
Install-ADDSForest `
    -DomainName "local.contoso.com" `
    -DomainNetbiosName "local-contoso " ` #NETBIOS 15 char limit
    -SafeModeAdministratorPassword (ConvertTo-SecureString "" -AsPlainText -Force) `
    -InstallDns

# Test only
Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))
$cert = New-SelfSignedCertificate -DnsName "adfs.local.contoso.com" 

# Import the ADFS module, configure ADFS
Import-Module ADFS

# Install ADFS
Install-AdfsFarm `
    -CertificateThumbprint "$($cert.Thumbprint)" `
    -FederationServiceName "adfs.local.contoso.com" `
    -FederationServiceDisplayName "Local Contoso ADFS" `
    -GroupServiceAccountIdentifier "Local.contoso\gmsa_adfs$"
```
</details>

<details>
<summary>Create ADFS client app, sample users, and groups</summary>

Use PowerShell on Windows Server 2022 or newer:

```powershell
Add-AdfsClient `
    -Name "Azure Local Disconnected operations Sign In Service" `
    -ClientId "7e7655c5-9bc4-45af-8345-afdf6bbe2ec1" `
    -RedirectUri "https://login.autonomous.cloud.private/signin-oidc"

# Import the Active Directory module
Import-Module ActiveDirectory

# Create new AD users
$users = @('operator', 'ldap', 'user1', 'user2', 'user3')
$users | % {Remove-ADUser $_ -Confirm:$false -ErrorAction SilentlyContinue }

$users | % {New-ADUser `
    -Name "AzureLocal User $_" `
    -GivenName "AzureLocal" `
    -Surname "User $_" `
    -SamAccountName $_ `
    -UserPrincipalName "$_@Local.contoso.com" `
    -Path "CN=Users,DC=local,DC=contoso,DC=com" `
    -AccountPassword (ConvertTo-SecureString "" -AsPlainText -Force) `
    -Enabled $true
 }

# Create a new AD group
New-ADGroup `
    -Name "AzureLocal Users" `
    -GroupScope Global `
    -Path "CN=Users,DC=local,DC=contoso,DC=com"

# Add the user to the group
Add-ADGroupMember `
    -Identity "AzureLocal Users" `
    -Members $users

# Create ADFS sync group and add operator to it
# Variables
$groupName = "ADFS_Sync_Group"
$ouPath = "CN=Users,DC=local,DC=contoso,DC=com"
$users = @("operator")

# Create the group
New-ADGroup -Name $groupName `
            -SamAccountName $groupName `
            -GroupScope Global `
            -GroupCategory Security `
            -Path $ouPath `
            -Description "Sync group for ADFS purposes"

# Add members to the group
foreach ($user in $users) {
    Add-ADGroupMember -Identity $groupName -Members $user
}

# Retrieve the group's ObjectGUID
$group = Get-ADGroup -Identity $groupName | Select-Object Name, ObjectGUID

# Display the syncGroupIdentifier (ObjectGUID), which will be required by the IDP script run from the host
$group
```

</details>
