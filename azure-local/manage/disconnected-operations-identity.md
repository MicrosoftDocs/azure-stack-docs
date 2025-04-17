---
title: Understand and plan your identity for disconnected operations on Azure Local (preview)
description: Integrate your identity with disconnected operations on Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 04/22/2025
---

# Plan your identity for disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-24112"

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This article helps you plan and integrate your existing identity with disconnected operations on Azure Local. The article describes how to configure your identity solution to work with disconnected operations and understand the various actions and roles available to the operators.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Understand and plan identity

For disconnected operations, you need to integrate with an existing identity and access management solution. Before you deploy the disconnected operations, make sure that you understand the steps required to integrate and apply the identity solution.

Disconnected operations are validated for the following solutions:

- Active Directory: Groups and memberships  
- Active Directory Federation Services (AD FS): Authentication  

> [!NOTE]
> Only Universal groups are supported for Active Directory. Ensure your group scope is set to Universal when you configure and set up group memberships.

## Understand how identity integration works

During deployment, you configure disconnected operations to integrate with your Identity Provider (IDP) and Identity and Access Management (IAM). Currently, you need to specify a **Root operator**. This user owns a special operator subscription and is responsible for adding other operators' post-deployment. The **Operator subscription** is the scope that defines operator actions, and individual actions are based on the **Operator role**.

On a high level, the OpenID Connect (OIDC) endpoint authenticates users to disconnected operations, and the Lightweight Directory Access Protocol (LDAP) endpoint integrates groups and memberships from your enterprise. Once integrated, standard Azure role-based access control is assigned to the desired scopes.

:::image type="content" source="./media/disconnected-operations/identity/identity-layout.png" alt-text="Screenshot showing how the Appliance and users or workloads communicate with the service." lightbox=" ./media/disconnected-operations/identity/identity-layout.png":::

> [!NOTE]
> Role assignments and policies aren't inherited from the operator subscription to individual subscriptions. Each subscription has its own scope. Only specific roles assigned to individual subscriptions can perform actions within that specific subscription.

### Understand the operator role and actions  

You can assign more operators to the operator subscription, which allows operator-related actions (day-to-day operations) to be performed. The built-in role (Owner) on the operator subscription allows the following actions on the scope: `/Subscriptions/\<GUID>/Microsoft.AzureLocalOperator/*`.  

In this preview release, the following actions are available:

#### Identity and access management

| Action                                | Operator |  
|---------------------------------------|----------|  
| Assign more operators                 | Yes      |  
| Create SPN                            | Yes      |  
| Delete SPN                            | Yes      |  
| List Service Principal Names (SPNs)   | Yes      |  
| Update SPN                            | Yes      |
| View group memberships (synced)       | Yes      |  
| View Identity configuration           | Yes      |  
| View identity synchronization status  | Yes      |  

#### Subscription management

| Action                                | Operator |
|---------------------------------------|----------|
| Create Alias                          | Yes      |  
| Create subscriptions                  | Yes      |  
| Delete Alias                          | Yes      |  
| Delete subscription                   | Yes      |  
| List alias                            | Yes      |  
| List all subscriptions                | Yes      |  
| Reassign subscription ownership       | Yes      |  
| Rename subscription                   | Yes      |  
| Resume subscription                   | Yes      |  

#### Observability and diagnostics

| Action                                          | Operator |
|-------------------------------------------------|----------|  
| Collect logs                                    | Yes      |  
| Configure diagnostics and telemetry settings    | Yes      |
| Configure syslog forwarding                     | Yes      |  
| Download logs                                   | Yes      |  

There are a couple of exceptions to the actions available to operators:

- An Operator subscription can't be deleted
- SPNs can also be deleted by the owners assigned to the SPN itself

In this preview release, only the following actions are available in the Azure portal.

> [!NOTE]
> Other built-in roles such as *Security operator*, *Subscription manager*, and *Support operator* might be considered and evaluated post preview if needed. To achieve more detailed operator roles, you can create custom role definitions based on the operator role and assign access to the operator subscription.

### Understand synchronization  

After you complete the initial configuration, groups with group memberships are synchronized, making them accessible from disconnected operations. To see which groups and memberships are synchronized, use an Operator Application Programming Interface (API), such as `Get-ApplianceExternalIdentityObservability` listed in the [Appendix](#appendix). Synchronization runs periodically, every 6 hours.

## Identity checklist  

Here's a checklist to help you plan your identity integration with disconnected operations.

- Identify IP addresses or a fully qualified domain name (FQDN) for the:  

  - LDAP endpoint (Active Directory)  
  - Login endpoint (AD FS/OIDC)  

- If you use an FQDN for the LDAP endpoint:  

  - Ensure the disconnected operations appliance is configured and uses a domain name system (DNS) that can resolve the provided endpoint.  
- Create an account with read-only access on the LDAP v3 server (Active Directory).  
- Identify the root group for membership synchronization.  
- Identify UPN: This should be a user that is assigned the role of **Initial operator**.

The following parameters must be collected and available before deployment:  

| Parameter Name        | Description            | Example                 |  
|-----------------------|------------------------|-------------------------|  
| Authority    | An accessible authority URI that gives information about OIDC endpoints, metadata, and more. | `hhttps://adfs.contoso-AzureLocal.com/adfs` |  
| ClientID     | AppID created when setting up the adfsclient app.    | `1e7655c5-1bc4-52af-7145-afdf6bbe2ec1`     |  
| LdapCredential (Username and Password) | Credentials (read-only) for LDAP integration.       | Username: `ldap` <br></br> Password: ******       |  
| LdapsCertChainInfo    | Certificate chain information for your LDAP endpoint. You can omit the certificate chain information for demo purposes. | [How to get the certificate chain](disconnected-operations-pki.md)  |
| OidcCertChainInfo     | Certificate chain information for your OIDC endpoint. You can omit the certificate chain information for demo purposes. | [How to get the certificate chain](disconnected-operations-pki.md)  |
| LdapServer       | LDAP endpoint that can be reached from disconnected operations. This is used to synchronize groups and group memberships. | `Ldap.local.contoso.com`    |  
| RootOperatorUserPrincipalName  |   UPN for the initial operator persona granted access to the Operator subscription | `Cloud-admin@local.contoso.com`   |
| SyncGroupIdentifier    | GUID to Active Directory group to start syncing from. <br></br> `$group = Get-ADGroup -Identity “mygroup” \| Select-Object Name, ObjectGUID` | `81d71e5c5-abc4-11af-8132-afdf6bbe2ec1` |

Example of a configuration parameter:

```console  
$ldapPass = 'retracted'|Convertto-securestring -asplaintext -force
$idpConfig = @{ 
     authority = 'https://adfs.contoso-AzureLocal.com/adfs'    
           clientId  = '9e7655c5-1bc4-45af-8345-cdf6bbf4ec1'    
           rootOperatorUserPrincipalName = 'operator@local.contoso.com'    
           ldapServer                    = 'ldap.local.contoso.com'    
           LdapCredential = New-Object PSCredential -ArgumentList @("ldap", $ldapPass)
      syncGroupIdentifier           = '81d71e5c5-abc4-11af-8132-afdf6bbe2ec1'
}
```

## Limitations

Here are some limitations to consider when planning your identity integration with disconnected operations:

- **Users/Group removal after synchronization**: If users and groups with memberships are removed after the last sync, they aren't cleaned up in the disconnected operations graph. This can cause errors when querying group memberships.
- **No force synchronization capability**: Sync runs every 6 hours.  
- **No management groups or aggregate root level**: Not available for multiple subscriptions.  
- **Supported validations**: Only Active Directory/AD FS are validated for support.
  - [Install Active Directory Domain Services (Level 100)](/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
  - [Active Directory Federation Services Overview](/windows-server/identity/ad-fs/ad-fs-overview)

## Mitigate issues with identity integration  

As a host administrator, you can use the disconnected operations PowerShell cmdlet to update and change settings to mitigate potential issues that may arise in unforeseen scenarios. Here are some scenarios where you might need to reconfigure your identity settings to mitigate issues:  

- **Synchronization failed / Didn’t start**:  
  - Ensure LDAP credentials are valid.  
  - Ensure LDAP credentials have read access.  
  - Ensure disconnected operations have network line of sight to the LDAP server, can resolve the FQDN (if not using IP address), and there are no firewalls blocking traffic.  

- **Wrong set of groups synchronized**:  
  - Verify that the `SyncGroupIdentifier` is set to the correct root. The one you're synchronizing from.  

- **Lost access to operator subscription**:  
  - To re-establish access to the operator, change the `rootOperatorUserPrincipalName`.  

## Cmdlets for identity integration  

As a host administrator, with the disconnected operations module and certificates used during installation available, you have a range of cmdlets to change settings and help you to troubleshoot the identity integration. Use the Get-command `ApplianceExternalIdentity` for a list of cmdlets available for identity integration.

### Test identity configuration

Use this command to perform easy client side validation of your identity configuration.

```powershell
$idpConfig = new-applianceIdentityConfiguration @identityParams

Test-ApplianceExternalIDentityConfiguration -config $idpConfig
```

### Test identity configuration (deep validation)

Use this command to validate your parameters and setup before you set your configuration.

```powershell
$idpConfig = new-applianceIdentityConfiguration @identityParams

Test-ApplianceExternalIDentityConfigurationDeep -config $idpConfig
```

### Set or reset identity

Use this command to reset the ownership of the operator subscription. Only do this if you have issues with your identity integration.

```powershell
Set-ApplianceExternalIdentityConfiguration
```

### Identity management

Use this command for a list of all cmdlets to help you set up and troubleshoot identity configurations.

```powershell
Get-Command *Appliance*ExternalIdentity*
```

## Appendix

Use PowerShell on Windows Server 2022 or newer for these commands. Expand each section for more information.

### Set up Active Directory/Active Directory Domain Services (ADDS) for demo purposes

```powershell
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the ADDSDeployement module
Import-Module ADDSDeployment

# Install the AD FS role
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

# Import the AD FS module, configure AD FS
Import-Module ADFS

# Install AD FS
Install-AdfsFarm `
    -CertificateThumbprint "$($cert.Thumbprint)" `
    -FederationServiceName "adfs.local.contoso.com" `
    -FederationServiceDisplayName "Local Contoso ADFS" `
    -GroupServiceAccountIdentifier "Local.contoso\gmsa_adfs$"
```

### Create AD FS client app, sample users, and groups

```powershell
Add-AdfsClient `
    -Name "Azure Local Disconnected operations Sign In Service" `
    -ClientId "7e7655c5-9bc4-45af-8345-afdf6bbe2ec1" `
    -RedirectUri "https://login.autonomous.cloud.private/signin-oidc"

# Import the Active Directory module
Import-Module ActiveDirectory

# Create new Active Directory users
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

# Create a new Active Directory group
New-ADGroup `
    -Name "AzureLocal Users" `
    -GroupScope Global `
    -Path "CN=Users,DC=local,DC=contoso,DC=com"

# Add the user to the group
Add-ADGroupMember `
    -Identity "AzureLocal Users" `
    -Members $users

# Create AD FS sync group and add operator to it
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

### Grant LDAP user read on Users with inherit

```powershell
$domain = Get-ADDomain
$identity = [System.Security.Principal.NTAccount]"$($domain.Name)\ldap"
$accessRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($identity,  [System.DirectoryServices.ActiveDirectoryRights] "GenericRead",    [System.Security.AccessControl.AccessControlType] "Allow",    [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All")
$acl = Get-Acl -Path "AD:\CN=Users,$($domain.DistinguishedName)"
$acl.AddAccessRule($accessRule)
Set-ACL -Path "AD:\$($domain.DistinguishedName)" -AclObject $acl
Write-Verbose "Granted 'GenericRead' permissions to ldap account"
```

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.2.

::: moniker-end
