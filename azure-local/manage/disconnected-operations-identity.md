---
title: Plan your Identity for Disconnected Operations on Azure Local (preview)
description: Plan and integrate your identity for disconnected operations on Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 08/06/2025
ai-usage: ai-assisted
---

# Plan your identity for disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-2506"

This article explains how to plan and integrate your identity for disconnected operations on Azure Local. Learn how to set up your identity solution, and understand the actions and roles available to operators.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Understand and plan identity

For disconnected operations, you need to integrate with an existing identity and access management solution. Before you deploy disconnected operations, make sure that you understand the steps required to integrate and apply the identity solution.

Disconnected operations support these solutions:

- Active Directory: Groups and memberships  
- Active Directory Federation Services (AD FS): Authentication  

> [!NOTE]
> Only Universal groups are supported for Active Directory. Set your group scope to Universal when you set up group memberships.

## Understand how identity integration works

During deployment, set up disconnected operations to integrate with your Identity Provider (IDP) and Identity and Access Management (IAM). Specify a **Root operator**. This user owns a special operator subscription and adds other operators after deployment. The **Operator subscription** defines the scope for operator actions, and individual actions depend on the **Operator role**.

On a high level, the OpenID Connect (OIDC) endpoint authenticates users to disconnected operations, and the Lightweight Directory Access Protocol (LDAP) endpoint integrates groups and memberships from your organization. After integration, standard Azure role-based access control is assigned to the desired scopes.

:::image type="content" source="./media/disconnected-operations/identity/identity-layout.png" alt-text="Screenshot of how the Appliance and users or workloads communicate with the service." lightbox=" ./media/disconnected-operations/identity/identity-layout.png":::

> [!NOTE]
> Role assignments and policies aren't inherited from the operator subscription to individual subscriptions. Each subscription has its own scope. Only specific roles assigned to individual subscriptions can perform actions within that specific subscription.

### Understand the operator role and actions  

You can assign more operators to the operator subscription to let them perform day-to-day actions. The built-in **Owner** role on the operator subscription lets operators perform these actions on the scope: `/Subscriptions/\<GUID>/Microsoft.AzureLocalOperator/*`.  

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

- Operators can't delete an operator subscription.

- Owners assigned to a service principal name (SPN) can also delete that SPN.

In this preview release, only the following actions are available in the Azure portal.

> [!NOTE]
> Other built-in roles such as *Security operator*, *Subscription manager*, and *Support operator* might be considered and evaluated post preview if needed. To achieve more detailed operator roles, you can create custom role definitions based on the operator role and assign access to the operator subscription.

### Understand synchronization  

After you finish the initial setup, groups with group memberships are synchronized making them accessible for disconnected operations. To see which groups and memberships are synchronized, use an Operator Application Programming Interface (API), like `Get-ApplianceExternalIdentityObservability` listed in the [Appendix](#appendix). Synchronization runs periodically, every 6 hours.

## Identity checklist  

Use this checklist to plan your identity integration with disconnected operations.

- Identify IP addresses or a fully qualified domain name (FQDN) for the:  
  - LDAP endpoint (Active Directory)  
  - Login endpoint (AD FS/OIDC)  

- If you use an FQDN for the LDAP endpoint:  

  - Make sure the disconnected operations appliance is set and uses a domain name system (DNS) that resolves the provided endpoint.  
- Create an account with read-only access on the LDAP v3 server (Active Directory).  
- Identify the root group for membership synchronization.  
- Identify UPN. This should be a user that is assigned the role of **Initial operator**.

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

Example configuration parameter:

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

Consider these limitations when you plan your identity integration with disconnected operations:

- **Users/Group removal after synchronization**: If you remove users and groups with memberships after the last sync, disconnected operations don't clean them up. This can cause errors when you query group memberships.
- **No force synchronization capability**: Sync runs every 6 hours.  
- **No management groups or aggregate root level**: Not available for multiple subscriptions.  
- **Supported validations**: Only Active Directory/AD FS are validated for support.
  - [Install Active Directory Domain Services (Level 100)](/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
  - [Active Directory Federation Services Overview](/windows-server/identity/ad-fs/ad-fs-overview)

## Mitigate issues with identity integration  

As a host admin, use the disconnected operations PowerShell cmdlet to update settings and fix issues. Here are some scenarios where you might need to reconfigure your identity settings:

- **Synchronization failed / Didn’t start**:  
  - Check that LDAP credentials are valid.
  - Check that LDAP credentials have read access.
  - Check that disconnected operations can reach the LDAP server, resolve the FQDN (if not using an IP address), and that no firewalls block traffic.

- **Wrong set of groups synchronized**:  
  - Check that the `SyncGroupIdentifier` is set to the correct root. The one you're synchronizing from.  

- **Lost access to operator subscription**:
  - To restore access to the operator, change the `rootOperatorUserPrincipalName`.

## Cmdlets for identity integration  

As a host admin, use the disconnected operations module and installation certificates to run cmdlets that help you change settings and troubleshoot identity integration. Run `Get-Command ApplianceExternalIdentity` to list available cmdlets for identity integration.

### Test identity configuration

Use this command to quickly validate your identity configuration on the client side.

```powershell
$idpConfig = new-applianceIdentityConfiguration @identityParams

Test-ApplianceExternalIDentityConfiguration -config $idpConfig
```

### Test identity configuration (deep validation)

Use this command to validate your parameters and setup before you apply your configuration.

```powershell
$idpConfig = new-applianceIdentityConfiguration @identityParams

Test-ApplianceExternalIDentityConfigurationDeep -config $idpConfig
```

### Set or reset identity

Use this command to reset the operator subscription. Only use if you have issues with your identity integration.

```powershell
Set-ApplianceExternalIdentityConfiguration
```

### Identity management

Use this command to list all cmdlets that help you set up and troubleshoot identity configurations.

```powershell
Get-Command *Appliance*ExternalIdentity*
```

## Appendix

Use PowerShell on Windows Server 2022 or newer for these commands.

### Set up Active Directory/Active Directory Domain Services (ADDS) for demo purposes

```powershell
# Modify to fit your domain/installation
$GSMAAccount = 'Local-contoso\gmsa_adfs$'

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the ADDSDeployement module
Import-Module ADDSDeployment

# Install the AD FS role
Install-WindowsFeature ADFS-Federation -IncludeManagementTools

# Promote the server to a domain controller
Install-ADDSForest `
    -DomainName "local.contoso.com" `
    -DomainNetbiosName "local-contoso " ` #NETBIOS 15 char limit
    -SafeModeAdministratorPassword (ConvertTo-SecureString "" -AsPlainText -Force) `
    -InstallDns

# Test only
Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))
$cert = New-SelfSignedCertificate -DnsName "adfs.local.contoso.com" 

# Import the AD FS module and configure AD FS
Import-Module ADFS

# Install AD FS
Install-AdfsFarm `
    -CertificateThumbprint "$($cert.Thumbprint)" `
    -FederationServiceName "adfs.local.contoso.com" `
    -FederationServiceDisplayName "Local Contoso ADFS" `
    -GroupServiceAccountIdentifier $GSMAAccount
```

### Create AD FS client app, sample users, and groups

```powershell
# ClientID can be any unique id in your organization - hardcoded GUID here just as example
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

# Create AD FS sync group and add the operator to it
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

# Display the syncGroupIdentifier (ObjectGUID), which is required by the IDP script run from the host
$group
```

### Grant LDAP User read access on Users with inherit option

The following example grants read access to the LDAP user on the Users container using the `ActiveDirectorySecurityInheritance "All"` setting. Assigning an access rule with "All" makes the rule apply to the entire subtree of the target object.

```powershell
$domain = Get-ADDomain
$identity = [System.Security.Principal.NTAccount]"$($domain.Name)\ldap"
$accessRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($identity,  [System.DirectoryServices.ActiveDirectoryRights] "GenericRead",    [System.Security.AccessControl.AccessControlType] "Allow",    [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All")
$acl = Get-Acl -Path "AD:\CN=Users,$($domain.DistinguishedName)"
$acl.AddAccessRule($accessRule)
Set-ACL -Path "AD:\$($domain.DistinguishedName)" -AclObject $acl
Write-Verbose "Granted 'GenericRead' permissions to ldap account."
```

### Grant the GSMA account permission to read user properties

The following example shows how to let the GSMA account read user properties in Active Directory from the sync group.

```powershell
# GropuName and GSMAccount defined earlier

# Get group details
$Group = Get-ADGroup -Identity $GroupName
$GroupDN = $Group.DistinguishedName

# Build the access rule
$Identity = New-Object System.Security.Principal.NTAccount($GSMAAccount)
$ActiveDirectoryRights = [System.DirectoryServices.ActiveDirectoryRights]::ReadProperty
$AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
$InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::All

# Create the access rule and apply it to the group
$Rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $Identity, $ActiveDirectoryRights, $AccessControlType, $null, $InheritanceType
$GroupEntry = [ADSI]"LDAP://$GroupDN"
$Security = $GroupEntry.ObjectSecurity
$Security.AddAccessRule($Rule)
$GroupEntry.CommitChanges()
```

> [!NOTE]
> If the GSMA account for your ADFS farm can't read user properties, the sign in fails even if the credentials entered on the ADFS sign in page are correct.

### Verify and test ADFS functionality

To enable the IDPInitiated Signon test page follow these steps:

1. Enable the signon test page. Run this command:

   ```powershell 
    Set-AdfsProperties -EnableIdpInitiatedSignonPage $true
   ```
1. Go to [IdpInitiatedSignon](https://adfs.FDQN/adfs/ls/IdpInitiatedSignon.aspx). Replace FQDN with your actual domain name and sign in with your operator account to confirm that ADFS is working.

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
