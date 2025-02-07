---
title: Understand and plan your identity for disconnected operations on Azure Local (preview)
description: Integrate your identity with disconnected operations on Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 02/06/2025
---

# Plan your identity for disconnected operations on Azure Local (preview)

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This article helps you plan and integrate your existing identity with disconnected operations on Azure Local. The article describes how to configure your identity solution to work with disconnected operations and understand the various actions and roles available to the operators.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Understand and plan identity

For disconnected operations, you need to integrate with an existing identity and access management solution. Before you deploy the disconnected operations, make sure that you understand the steps required to integrate and apply the identity solution.

Disconnected operations is validated for the following solutions:

- Active Directory: Groups and memberships  
- Active Directory Federation Services (AD FS): Authentication  

> [!NOTE]
> Only Universal groups are supported for Active Directory. Ensure your group scope is set to Universal when you configure and set up group memberships.

## How identity integration works

### Deployment  

During deployment, you configure disconnected operations to integrate with your Identity Provider (IDP) and Identity and Access Management (IAM). Currently, you need to specify a **Root operator**. This user owns a special operator subscription and is responsible for adding other operators' post-deployment. The **Operator subscription** is the scope that defines operator actions, and individual actions are based on the **Operator role**.

On a high level, the OpenID Connect (OIDC) endpoint authenticates users to disconnected operations, and the Lightweight Directory Access Protocol (LDAP) endpoint integrates groups and memberships from your enterprise. Once integrated, standard Azure role-based access control is assigned to the desired scopes.

:::image type="content" source="./media/disconnected-operations/identity/identity-overview.png" alt-text="Screenshot showing how the Appliance and users or workloads communicate with the service." lightbox=" ./media/disconnected-operations/identity/identity-overview.png":::

> [!NOTE]
> Role assignments and policies aren't inherited from the operator subscription to individual subscriptions. Each subscription has its own scope. Only specific roles assigned to individual subscriptions can perform actions within that specific subscription.

## Understanding the operator role and actions  

You can assign more operators to the operator subscription, which allows operator-related actions (day-to-day operations) to be performed. The built-in role (Owner) on the operator subscription allows the following actions on the scope: `/Subscriptions/\<GUID>/Microsoft.AzureLocalOperator/*`.  

In this preview release, the following actions are available:

### Identity and access management

| Action                                | Operator |  
|---------------------------------------|----------|  
| Assign more operators                 | Yes      |  
| View group memberships (synced)       | Yes      |  
| View identity synchronization status  | Yes      |  
| View Identity configuration           | Yes      |  
| List Service Principal Names (SPNs)   | Yes      |  
| Create SPN                            | Yes      |  
| Delete SPN <sub>2</sub>               | Yes      |  
| Update SPN <sub>2</sub>               | Yes      |

### Subscription management

| Action                                | Operator |
|---------------------------------------|----------|
| List all subscriptions                | Yes      |  
| Create subscriptions                  | Yes      |  
| Rename subscription                   | Yes      |  
| Suspend subscription <sub>3</sub>     | Yes      |  
| Resume subscription                   | Yes      |  
| Delete subscription <sub>1</sub>      | Yes      |  
| Reassign subscription ownership       | Yes      |  
| List alias                            | Yes      |  
| Create Alias                          | Yes      |  
| Delete Alias                          | Yes      |  

### Update

| Action                                | Operator |
|---------------------------------------|----------|  
| Upload update <sub>3</sub>            | Yes      |  
| Trigger update <sub>3</sub>           | Yes      |  
| Get update status <sub>3</sub>        | Yes      |  
| Schedule update <sub>3</sub>          | Yes      |  
| View update history <sub>3</sub>      | Yes      |

### Observability and diagnostics

| Action                                          | Operator |
|-------------------------------------------------|----------|  
| Configure syslog forwarding                     | Yes      |  
| Collect logs                                    | Yes      |  
| Download logs                                   | Yes      |  
| Configure diagnostics and telemetry settings    | Yes      |

### Usage / billing / registration

| Action                                          | Operator |
|-------------------------------------------------|----------|
| Get usage data <sub>3</sub>                     | Yes      |  
| View instance license information <sub>3</sub>  | Yes      |  
| Register disconnected operations <sub>3</sub>   | Yes      |

### Secrets management

| Action                                          | Operator |
|-------------------------------------------------|----------|
| View external secrets expiration <sub>3</sub>   | Yes      |  
| Rotate secrets (internal) <sub>3</sub>          | Yes      |  
| Rotate secrets (external certificates) <sub>3</sub> | Yes  |  

<sub>1. Operator subscription cannot be deleted</sub>
<sub>2. SPNs can also be deleted by the owners assigned to the SPN itself</sub>
<sub>3. Scoped for release in the future</sub>

In this release, some of the actions in the preceding list are not available in the Azure portal.

> [!NOTE]
> Other built-in roles such as *Security operator*, *Subscription manager*, and *Support operator* might be considered and evaluated post preview if needed. To achieve more detailed operator roles, you can create custom role definitions based on the operator role and assign access to the operator subscription.

## Understanding synchronization  

After you complete the initial configuration, groups with group memberships are synchronized, making them accessible from disconnected operations. To see which groups and memberships are synchronized, you can view them using an Operator Application Programming Interface (API), such as `Get-ApplianceExternalIdentityObservability` listed in the Appendix. In later releases, you can view them through the Portal. Synchronization runs periodically, every 6 hours.

## Identity checklist  

Here's a checklist to help you plan your identity integration with disconnected operations.

Identify IP addresses or a fully qualified domain name (FQDN) for the:  

- LDAP endpoint (Active Directory)  
- Login endpoint (AD FS/OIDC)  

If you use an FQDN for the LDAP endpoint:  

- Ensure the disconnected operations appliance is configured and uses a domain name system (DNS) that can resolve the provided endpoint.  
- Create an account with read-only access on the LDAP v3 server (Active Directory).  
- Identify the root group for membership synchronization.  
- Identify UPN: This should be a user that is assigned the role of **Initial operator**.

The following parameters must be collected and available before deployment:  

| Parameter Name                    | Description                                                                 | Example                                           |  
|-----------------------------------|-----------------------------------------------------------------------------|---------------------------------------------------|  
| Authority                         | An accessible authority URI that gives information about OIDC endpoints, metadata, and more. | `hhttps://adfs.contoso-AzureLocal.com/adfs` |  
| ClientID                          | AppID created when setting up the adfsclient app.                            | `1e7655c5-1bc4-52af-7145-afdf6bbe2ec1`            |  
| LdapServer                        | LDAP v3 endpoint that can be reached from disconnected operations. This is used to synchronize groups and group memberships. | `Ldap.contoso.com`                                |  
| LdapCredential (Username and Password) | Credentials (read-only) for LDAP integration.                             | Username: `ldapreader` Password:         |  
| RootOperatorUserPrincipalName     | UPN for the initial operator persona granted access to the Operator subscription | `Cloud-admin@contoso.com`        |  
| SyncGroupIdentifier               | GUID to Active Directory group to start syncing from. Example: | `$group = Get-ADGroup -Identity “mygroup” \| Select-Object Name, ObjectGUID  81d71e5c5-abc4-11af-8132-afdf6bbe2ec1` |
| LdapsCertChainInfo                | Certificate chain information for LDAP. This is used to validate calls from the appliance to LDAP. You can omit the certificate chain information for demo purposes. | MIIF ......  |
|OidcCertChainInfo                  | Certificate chain information used for OIDC to validate tokens from OpenId Connect compliant endpoint. You can omit the certificate chain information for demo purposes. | MIID ......  |

Example of a configuration object:

```console  
$idpConfig = @{  
     authority = 'https://adfs.contoso-AzureLocal.com/adfs'  
     clientId  = '9e7655c5-1bc4-45af-8345-cdf6bbf4ec1'  
     rootOperatorUserPrincipalName = 'operator@contoso.com'  
     ldapServer                    = 'ldap.contoso.com'  
     ldapUsername                  = 'ldapreader'  
     ldapPassword                  = $ldappass  
     syncGroupIdentifier           = '81d71e5c5-abc4-11af-8132-afdf6bbe2ec1'  
}
```  

> [!NOTE]
> Make sure to secure identity endpoints with certificates that share the same root of trust as those used for the disconnected operations appliance. Multiple roots of trust aren't supported.

## Current limitations

Here are some limitations to consider when planning your identity integration with disconnected operations:

- **Users/Group removal after synchronization**: If users and groups with memberships are removed after the last sync, they aren't cleaned up in the disconnected operations graph. This can cause errors when querying group memberships.
- **No force synchronization capability**: Sync runs every 6 hours.  
- **No management groups or aggregate root level**: Not available for multiple subscriptions.  
- **Supported validations**: Only Active Directory/AD FS are validated for support.
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

As a host administrator, with the disconnected operations module and certificates used during installation available, you have a range of cmdlets to change settings and help you to troubleshoot the identity integration. Use the Get-command `ApplianceExternalIdentity` for a list of cmdlets available for identity integration. Expand each section for more information.

<details>

<summary>Test identity configuration</summary>

Use this command to peform easy client side validation of your identity configuration.

```powershell
$idpConfig = new-applianceIdentityConfiguration @identityParams

Test-ApplianceExternalIDentityConfiguration -config $idpConfig
```

</details>

<details>

<summary>Test identity configuration (deep validation)</summary>

Use this command to valiate your parameters and setup before you set your configuration.

```powershell
$idpConfig = new-applianceIdentityConfiguration @identityParams

Test-ApplianceExternalIDentityConfigurationDeep -config $idpConfig
```

</details>

<details>

<summary>Set or reset identity</summary>

Use this command to reset the ownership of the operator subscription. Only do this if you have issues with your identity integration.

```powershell
Set-ApplianceExternalIdentityConfiguration
```

</details>

<details>

<summary>Identity management</summary>

Use this command for a list of all cmlets to help you setup and troubleshoot identity configurations.

```powershell
Get-Command *Appliance*ExternalIdentity*
```

</details>

## Appendix

Use PowerShell on Windows Server 2022 or newer. Expand each section for more information.

<details>

<summary>Set up Active Directory/Active Directory Domain Services (ADDS) for demo purposes</summary>

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

</details>

<details>

<summary>Create AD FS client app, sample users, and groups</summary>

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

</details>

## Next steps

<!--- [Deploy disconnected operations on Azure Local](./disconnected-operations-deploy.md)-->