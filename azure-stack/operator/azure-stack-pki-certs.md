---
title: Azure Stack Hub public key infrastructure certificate requirements 
description: Learn about the Azure Stack Hub PKI certificate requirements for Azure Stack Hub integrated systems.
author: sethmanheim
ms.topic: article
ms.date: 08/12/2025
ms.author: sethm
ms.lastreviewed: 06/07/2021

# Intent: As an Azure Stack Hub operator, I want to learn about the Azure Stack Hub PKI certificate requirements.
# Keyword: azure stack hub pki certificate requirements

---

# Azure Stack Hub public key infrastructure (PKI) certificate requirements

Azure Stack Hub has a public infrastructure network using externally accessible public IP addresses assigned to a small set of Azure Stack Hub services and possibly tenant VMs. PKI certificates with the appropriate DNS names for these Azure Stack Hub public infrastructure endpoints are required during Azure Stack Hub deployment. This article provides information about:

- Certificate requirements for Azure Stack Hub.
- Mandatory certificates required for Azure Stack Hub deployment.
- Optional certificates required when deploying value-add resource providers.

> [!NOTE]
> By default, Azure Stack Hub also uses certificates issued from an internal Active Directory-integrated certificate authority (CA) for authentication between the nodes. To validate the certificate, all Azure Stack Hub infrastructure machines trust the root certificate of the internal CA by adding that certificate to their local certificate store. There's no pinning or filtering of certificates in Azure Stack Hub. The SAN of each server certificate is validated against the FQDN of the target. The entire chain of trust is also validated, along with the certificate expiration date (standard TLS server authentication without certificate pinning).

## Certificate requirements

The following list describes the general certificate issuance, security, and formatting requirements:

- Certificates must be issued from either an internal certificate authority or a public certificate authority. If a public certificate authority is used, it must be included in the base operating system image as part of the Microsoft Trusted Root Authority Program. For the full list, see [List of Participants - Microsoft Trusted Root Program](/security/trusted-root/participants-list).
- Your Azure Stack Hub infrastructure must have network access to the certificate authority's Certificate Revocation List (CRL) location published in the certificate. This CRL must be an http endpoint. For disconnected deployments, if the CRL endpoint is not accessible, certificates issued by a public certificate authority (CA) are not supported. For more information, see [Features that are impaired or unavailable in disconnected deployments](azure-stack-disconnected-deployment.md#features-that-are-impaired-or-unavailable-in-disconnected-deployments).

::: moniker range="< azs-1903"
- When rotating certificates in pre-1903 builds, certificates must be either issued from the same internal certificate authority used to sign certificates provided at deployment or any public certificate authority from above.
::: moniker-end

::: moniker range=">= azs-1903"
- When rotating certificates for builds 1903 and later, certificates can be issued by any enterprise or public certificate authority.
::: moniker-end
- Self-signed certificates aren't supported.
- For deployment and rotation, you can either use a single certificate covering all name spaces in the certificate's Subject Name and Subject Alternative Name (SAN). Alternatively, you can use individual certificates for each of the namespaces below that the Azure Stack Hub services you plan to utilize require. Both approaches require using wild cards for endpoints where they're required, such as **KeyVault** and **KeyVaultInternal**.
- The certificate signature algorithm shouldn't be SHA1.
- The certificate format must be PFX, as both the public and private keys are required for Azure Stack Hub installation. The private key must have the local machine key attribute set.
- The PFX encryption must be 3DES (this encryption is default when exporting from a Windows 10 client or Windows Server 2016 certificate store).
- The certificate pfx files must have a value "Digital Signature" and "KeyEncipherment" in its "Key Usage" field.
- The certificate pfx files must have the values "Server Authentication (1.3.6.1.5.5.7.3.1)" in the "Enhanced Key Usage" field.
- The certificate's "Issued to:" field must not be the same as its "Issued by:" field.
- The passwords to all certificate pfx files must be the same at the time of deployment.
- The password to the certificate pfx must be a complex password. Make a note of this password, because you use it as a deployment parameter. The password must meet the following password complexity requirements:
  - A minimum length of eight characters.
  - At least three of the following characters: uppercase letter, lowercase letter, numbers from 0-9, special characters, alphabetical character that's not uppercase or lowercase.
- Ensure that the subject names and subject alternative names in the subject alternative name extension (x509v3_config) match. The subject alternative name field lets you specify additional host names (websites, IP addresses, common names) to be protected by a single SSL certificate.

> [!NOTE]  
> Self-signed certificates aren't supported.  
> When deploying Azure Stack Hub in disconnected mode it's recommended that you use certificates issued by an enterprise certificate authority. This is important because clients accessing Azure Stack Hub endpoints must be able to contact the certificate revocation list (CRL).

> [!NOTE]  
> The presence of Intermediary Certificate Authorities in a certificate's chain-of-trusts is supported.

## Mandatory certificates

The table in this section describes the Azure Stack Hub public endpoint PKI certificates that are required for both Microsoft Entra ID and AD FS Azure Stack Hub deployments. Certificate requirements are grouped by area, and the namespaces used and the certificates that are required for each namespace. The table also describes the folder in which your solution provider copies the different certificates per public endpoint.

Certificates with the appropriate DNS names for each Azure Stack Hub public infrastructure endpoint are required. Each endpoint's DNS name is expressed in the format `<prefix>.<region>.<fqdn>`.

For your deployment, the `<region>` and `<fqdn>` values must match the region and external domain names that you chose for your Azure Stack Hub system. As an example, if the region is **Redmond** and the external domain name is **contoso.com**, the DNS names have the format `<prefix>.redmond.contoso.com`. The `<prefix>` values are reserved by Microsoft to describe the endpoint secured by the certificate. In addition, the `<prefix>` values of the external infrastructure endpoints depend on the Azure Stack Hub service that uses the specific endpoint.

For production environments, we recommend that individual certificates are generated for each endpoint and copied into the corresponding directory. For development environments, certificates can be provided as a single wildcard certificate covering all namespaces in the Subject and Subject Alternative Name (SAN) fields copied into all directories. A single certificate covering all endpoints and services is an insecure posture, and therefore intended only for development. Remember, both options require you to use wildcard certificates for endpoints such as **acs** and Key Vault where they're required.

> [!NOTE]  
> During deployment, you must copy certificates to the deployment folder that matches the identity provider you're deploying against (Microsoft Entra ID or AD FS). If you use a single certificate for all endpoints, you must copy that certificate file into each deployment folder as outlined in the following tables. The folder structure is pre-built in the [deployment virtual machine](deployment-networking.md#the-deployment-vm) and can be found at **C:\CloudDeployment\Setup\Certificates**.

| Deployment folder | Required certificate subject and subject alternative names (SAN) | Scope (per region) | Subdomain namespace |
|-------------------------------|------------------------------------------------------------------|----------------------------------|-----------------------------|
| Public portal | `portal.<region>.<fqdn>` | Portals | `<region>.<fqdn>` |
| Admin portal | `adminportal.<region>.<fqdn>` | Portals | `<region>.<fqdn>` |
| Azure Resource Manager Public | `management.<region>.<fqdn>` | Azure Resource Manager | `<region>.<fqdn>` |
| Azure Resource Manager Admin | `adminmanagement.<region>.<fqdn>` | Azure Resource Manager | `<region>.<fqdn>` |
| ACSBlob | `*.blob.<region>.<fqdn>`<br>(Wildcard SSL certificate) | Blob storage | `blob.<region>.<fqdn>` |
| ACSTable | `*.table.<region>.<fqdn>`<br>(Wildcard SSL certificate) | Table storage | `table.<region>.<fqdn>` |
| ACSQueue | `*.queue.<region>.<fqdn>`<br>(Wildcard SSL certificate) | Queue storage | `queue.<region>.<fqdn>` |
| KeyVault | `*.vault.<region>.<fqdn>`<br>(Wildcard SSL certificate) | Key Vault | `vault.<region>.<fqdn>` |
| KeyVaultInternal | `*.adminvault.<region>.<fqdn>`<br>(Wildcard SSL certificate) |  Internal Keyvault |  `adminvault.<region>.<fqdn>` |
| Admin Extension Host | `*.adminhosting.<region>.<fqdn>` (Wildcard SSL certificates) | Admin extension host | `adminhosting.<region>.<fqdn>` |
| Public Extension Host | `*.hosting.<region>.<fqdn>` (Wildcard SSL certificates) | Public extension host | `hosting.<region>.<fqdn>` |

If you deploy Azure Stack Hub using the Microsoft Entra deployment mode, you only need to request the certificates listed in the previous table. If you deploy Azure Stack Hub using the AD FS deployment mode, you must also request the certificates described in the following table:

|Deployment folder|Required certificate subject and subject alternative names (SAN)|Scope (per region)|Subdomain namespace|
|-----|-----|-----|-----|
|ADFS|`adfs.<region>.<fqdn>`<br>(SSL certificate)|AD FS|`<region>.<fqdn>`|
|Graph|`graph.<region>.<fqdn>`<br>(SSL certificate)|Graph|`<region>.<fqdn>`|

> [!IMPORTANT]
> All the certificates listed in this section must have the same password.

## Optional PaaS certificates

If you plan to deploy Azure Stack Hub PaaS services (such as SQL, MySQL, App Service, or Event Hubs) after Azure Stack Hub is deployed and configured, you must request additional certificates to cover the endpoints of the PaaS services.

> [!IMPORTANT]
> The certificates that you use for resource providers must have the same root authority as those used for the global Azure Stack Hub endpoints.

The following table describes the endpoints and certificates required for resource providers. You don't need to copy these certificates to the Azure Stack Hub deployment folder. Instead, you provide these certificates during resource provider installation:

|Scope (per region)|Certificate|Required certificate subject and Subject Alternative Names (SANs)|Subdomain namespace|
|-----|-----|-----|-----|
|App Service|Web Traffic Default SSL Cert|`*.appservice.<region>.<fqdn>`<br>`*.scm.appservice.<region>.<fqdn>`<br>`*.sso.appservice.<region>.<fqdn>`<br>(Multi Domain Wildcard SSL Certificate<sup>1</sup>)|`appservice.<region>.<fqdn>`<br>`scm.appservice.<region>.<fqdn>`|
|App Service|API|`api.appservice.<region>.<fqdn>`<br>(SSL Certificate<sup>2</sup>)|`appservice.<region>.<fqdn>`<br>`scm.appservice.<region>.<fqdn>`|
|App Service|FTP|`ftp.appservice.<region>.<fqdn>`<br>(SSL Certificate<sup>2</sup>)|`appservice.<region>.<fqdn>`<br>`scm.appservice.<region>.<fqdn>`|
|App Service|SSO|`sso.appservice.<region>.<fqdn>`<br>(SSL Certificate<sup>2</sup>)|`appservice.<region>.<fqdn>`<br>`scm.appservice.<region>.<fqdn>`|
|Event Hubs|SSL|`*.eventhub.<region>.<fqdn>`<br>(Wildcard SSL Certificate)|`eventhub.<region>.<fqdn>`|
|SQL, MySQL|SQL and MySQL|`*.dbadapter.<region>.<fqdn>`<br>(Wildcard SSL Certificate)|`dbadapter.<region>.<fqdn>`|

<sup>1</sup> Requires one certificate with multiple wildcard subject alternative names. Multiple wildcard SANs on a single certificate might not be supported by all public certificate authorities.

<sup>2</sup> A `*.appservice.<region>.<fqdn>` wildcard certificate can't be used in place of these three certificates (`api.appservice.<region>.<fqdn>`, `ftp.appservice.<region>.<fqdn>`, and `sso.appservice.<region>.<fqdn>`). Appservice explicitly requires the use of separate certificates for these endpoints.

## Next steps

Learn how to [generate PKI certificates for Azure Stack Hub deployment](azure-stack-get-pki-certs.md).
