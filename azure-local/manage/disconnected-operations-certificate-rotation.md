---
title: Manage secret rotation for Azure Local disconnected operations
description: Learn how to rotate external ingress certificates and identity provider trust certificates for Azure Local disconnected operations.
author: haraldfianbakken
ms.author: hafianba
ms.reviewer: robess
ms.date: 07/31/2026
ms.topic: concept-article
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Manage secret rotation for Azure Local disconnected operations

::: moniker range=">=azloc-2606"

This article explains how to rotate certificates and secrets for disconnected operations on Azure Local. Learn how to renew external ingress certificates and identity provider trust certificates to maintain secure access and uninterrupted authentication.

Azure Local disconnected operations rely on certificates and secrets to secure external endpoints and trust relationships with integrated identity services. Establish a regular rotation process to maintain security and meet compliance requirements.

As a best practice, track expiration dates and renew certificates during planned maintenance windows. Regularly validate ingress connectivity and identity integration to help ensure that certificate updates don't affect platform availability or user access.

Two primary certificate categories require rotation:

- External ingress certificates
- Identity provider trust certificates

## External ingress certificates

External ingress endpoints present these certificates to secure client connections to platform services. Monitor certificate expiration dates and replace certificates before they expire to avoid service disruption. After you install a new certificate, validate endpoint accessibility and certificate trust from client systems.

### Rotate external ingress certificates

```powershell
$applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force    
$password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
$managementIp = "169.254.53.25"
$context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress $managementIp 

# You can automate certificate creation with New-ApplianceExternalCertificatesFromCA. 

# Folder with all required certificates to secure the ingress endpoints
$newCertsFolder = 'C:\AzureLocalDisconnectedOperations\UpdatedCerts\'
$certPassword = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  

Set-ApplianceExternalEndpointCertificates -DisconnectedOperationsClientContext $context -CertificatesFolder $newCertsFolder -CertificatePassword $certPassword
```

## Identity provider trust certificates

These certificates secure communication and trust relationships between Azure Local and your identity provider, such as Active Directory, Active Directory Federation Services (AD FS), or other supported federation services. Rotating these certificates typically requires you to update both the identity provider and Azure Local configuration so authentication and authorization workflows continue uninterrupted. After rotation, verify user sign-in and service-to-service authentication.

### Rotate identity provider trust certificates

If a certificate expires or is revoked, run the OperationsModule and update the identity configuration with the new certificate chain.

```powershell
$applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force    
$password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
$managementIp = "169.254.53.25"
$context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress $managementIp 

# Populate these variables with the new cert chain
$oidcCerts = ''
$ldapsCerts = ''

$config = New-AppliancePartialExternalIdentityConfiguration `
    -OidcCertChainInfo $oidcCerts `
    -LdapsCertChainInfo $ldapsCerts

# Update the appliance identity configuration with the new cert chain
Update-ApplianceExternalIdentityConfiguration -Config $config
```

::: moniker-end

::: moniker range="<=azloc-2605"

This feature is available only in Azure Local 2606 or later.

::: moniker-end
