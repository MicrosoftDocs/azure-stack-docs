---
title: Azure Stack Hub public key infrastructure certificate requirements 
description: Learn about the Azure Stack Hub PKI certificate deployment requirements for Azure Stack Hub integrated systems.
author: IngridAtMicrosoft
ms.topic: article
ms.date: 12/16/2019
ms.author: inhenkel
ms.reviewer: ppacent
ms.lastreviewed: 12/16/

# Intent: As an Azure Stack operator, I want to learn about the Azure Stack PKI certificate deployment requirements.
# Keyword: azure stack pki certificate requirements

---


# Azure Stack Hub public key infrastructure certificate requirements

Azure Stack Hub has a public infrastructure network using externally accessible public IP addresses assigned to a small set of Azure Stack Hub services and possibly tenant VMs. PKI certificates with the appropriate DNS names for these Azure Stack Hub public infrastructure endpoints are required during Azure Stack Hub deployment. This article provides information about:

- What certificates are required to deploy Azure Stack Hub.
- The process of obtaining certificates matching those specifications.
- How to prepare, validate, and use those certificates during deployment.

> [!NOTE]
> Azure Stack Hub by default also uses certificates issued from an internal Active Directory-integrated certificate authority (CA) for authentication between the nodes. To validate the certificate, all Azure Stack Hub infrastructure machines trust the root certificate of the internal CA by means of adding that certificate to their local certificate store. There's no pinning or whitelisting of certificates in Azure Stack Hub. The SAN of each server certificate is validated against the FQDN of the target. The entire chain of trust is also validated, along with the certificate expiration date (standard TLS server authentication without certificate pinning).

## Certificate requirements
The following list describes the certificate requirements that are needed to deploy Azure Stack Hub:

- Certificates must be issued from either an internal certificate authority or a public certificate authority. If a public certificate authority is used, it must be included in the base operating system image as part of the Microsoft Trusted Root Authority Program. For the full list, see [Microsoft Trusted Root Certificate Program: Participants](https://gallery.technet.microsoft.com/Trusted-Root-Certificate-123665ca).
- Your Azure Stack Hub infrastructure must have network access to the certificate authority's Certificate Revocation List (CRL) location published in the certificate. This CRL must be an http endpoint.
- When rotating certificates in pre-1903 builds, certificates must be either issued from the same internal certificate authority used to sign certificates provided at deployment or any public certificate authority from above. For 1903 and later, certificates can be issued by any enterprise or public certificate authority.
- The use of self-signed certificates aren't supported.
- For deployment and rotation, you can either use a single certificate covering all name spaces in the certificate's Subject Name and Subject Alternative Name (SAN) fields OR you can use individual certificates for each of the namespaces below that the Azure Stack Hub services you plan to utilize require. Both approaches require using wild cards for endpoints where they're required, such as **KeyVault** and **KeyVaultInternal**.
- The certificate's PFX Encryption should be 3DES.
- The certificate signature algorithm shouldn't be SHA1.
- The certificate format must be PFX, as both the public and private keys are required for Azure Stack Hub installation. The private key must have the local machine key attribute set.
- The PFX encryption must be 3DES (this encryption is default when exporting from a Windows 10 client or Windows Server 2016 certificate store).
- The certificate pfx files must have a value "Digital Signature" and "KeyEncipherment" in its "Key Usage" field.
- The certificate pfx files must have the values "Server Authentication (1.3.6.1.5.5.7.3.1)" and "Client Authentication (1.3.6.1.5.5.7.3.2)" in the "Enhanced Key Usage" field.
- The certificate's "Issued to:" field must not be the same as its "Issued by:" field.
- The passwords to all certificate pfx files must be the same at the time of deployment.
- Password to the certificate pfx has to be a complex password. Make note of this password because you'll use it as a deployment parameter. The password must meet the following password complexity requirements:
    - A minimum length of eight characters.
    - At least three of the following characters: uppercase letter, lowercase letter, numbers from 0-9, special characters, alphabetical character that's not uppercase or lowercase.
- Ensure that the subject names and subject alternative names in the subject alternative name extension (x509v3_config) match. The subject alternative name field lets you specify additional host names (websites, IP addresses, common names) to be protected by a single SSL certificate.

> [!NOTE]  
> Self-signed certificates aren't supported.  
> When deploying Azure Stack Hub in disconnected mode it is recommended to use certificates issued by an enterprise certificate authority. This is important because clients accessing Azure Stack Hub endpoints must be able to contact the certificate revocation list (CRL).

> [!NOTE]  
> The presence of Intermediary Certificate Authorities in a certificate's chain-of-trusts *is* supported.

## Mandatory certificates
The table in this section describes the Azure Stack Hub public endpoint PKI certificates that are required for both Azure AD and AD FS Azure Stack Hub deployments. Certificate requirements are grouped by area, as well as the namespaces used and the certificates that are required for each namespace. The table also describes the folder in which your solution provider copies the different certificates per public endpoint.

Certificates with the appropriate DNS names for each Azure Stack Hub public infrastructure endpoint are required. Each endpoint's DNS name is expressed in the format: *&lt;prefix>.&lt;region>.&lt;fqdn>*.

For your deployment, the [region] and [externalfqdn] values must match the region and external domain names that you chose for your Azure Stack Hub system. As an example, if the region name was *Redmond* and the external domain name was *contoso.com*, the DNS names would have the format *&lt;prefix>.redmond.contoso.com*. The *&lt;prefix>* values are predesignated by Microsoft to describe the endpoint secured by the certificate. In addition, the *&lt;prefix>* values of the external infrastructure endpoints depend on the Azure Stack Hub service that uses the specific endpoint.

For the production environments, we recommend individual certificates are generated for each endpoint and copied into the corresponding directory. For development environments, certificates can be provided as a single wild card certificate covering all namespaces in the Subject and Subject Alternative Name (SAN) fields copied into all directories. A single certificate covering all endpoints and services is an insecure posture and hence development-only. Remember, both options require you to use wildcard certificates for endpoints like **acs** and Key Vault where they're required.

> [!Note]  
> During deployment, you must copy certificates to the deployment folder that matches the identity provider you're deploying against (Azure AD or AD FS). If you use a single certificate for all endpoints, you must copy that certificate file into each deployment folder as outlined in the following tables. The folder structure is pre-built in the deployment virtual machine and can be found at: C:\CloudDeployment\Setup\Certificates.

| Deployment folder | Required certificate subject and subject alternative names (SAN) | Scope (per region) | Subdomain namespace |
|-------------------------------|------------------------------------------------------------------|----------------------------------|-----------------------------|
| Public Portal | portal.&lt;region>.&lt;fqdn> | Portals | &lt;region>.&lt;fqdn> |
| Admin Portal | adminportal.&lt;region>.&lt;fqdn> | Portals | &lt;region>.&lt;fqdn> |
| Azure Resource Manager Public | management.&lt;region>.&lt;fqdn> | Azure Resource Manager | &lt;region>.&lt;fqdn> |
| Azure Resource Manager Admin | adminmanagement.&lt;region>.&lt;fqdn> | Azure Resource Manager | &lt;region>.&lt;fqdn> |
| ACSBlob | *.blob.&lt;region>.&lt;fqdn><br>(Wildcard SSL Certificate) | Blob Storage | blob.&lt;region>.&lt;fqdn> |
| ACSTable | *.table.&lt;region>.&lt;fqdn><br>(Wildcard SSL Certificate) | Table Storage | table.&lt;region>.&lt;fqdn> |
| ACSQueue | *.queue.&lt;region>.&lt;fqdn><br>(Wildcard SSL Certificate) | Queue Storage | queue.&lt;region>.&lt;fqdn> |
| KeyVault | *.vault.&lt;region>.&lt;fqdn><br>(Wildcard SSL Certificate) | Key Vault | vault.&lt;region>.&lt;fqdn> |
| KeyVaultInternal | *.adminvault.&lt;region>.&lt;fqdn><br>(Wildcard SSL Certificate) |  Internal Keyvault |  adminvault.&lt;region>.&lt;fqdn> |
| Admin Extension Host | *.adminhosting.\<region>.\<fqdn> (Wildcard SSL Certificates) | Admin Extension Host | adminhosting.\<region>.\<fqdn> |
| Public Extension Host | *.hosting.\<region>.\<fqdn> (Wildcard SSL Certificates) | Public Extension Host | hosting.\<region>.\<fqdn> |

If you deploy Azure Stack Hub using the Azure AD deployment mode, you only need to request the certificates listed in previous table. But, if you deploy Azure Stack Hub using the AD FS deployment mode, you must also request the certificates described in the following table:

|Deployment folder|Required certificate subject and subject alternative names (SAN)|Scope (per region)|Subdomain namespace|
|-----|-----|-----|-----|
|ADFS|adfs.*&lt;region>.&lt;fqdn>*<br>(SSL Certificate)|ADFS|*&lt;region>.&lt;fqdn>*|
|Graph|graph.*&lt;region>.&lt;fqdn>*<br>(SSL Certificate)|Graph|*&lt;region>.&lt;fqdn>*|
|

> [!IMPORTANT]
> All the certificates listed in this section must have the same password.

## Optional PaaS certificates
If you're planning to deploy the additional Azure Stack Hub PaaS services (SQL, MySQL, and App Service) after Azure Stack Hub has been deployed and configured, you need to request additional certificates to cover the endpoints of the PaaS services.

> [!IMPORTANT]
> The certificates that you use for App Service, SQL, and MySQL resource providers need to have the same root authority as those used for the global Azure Stack Hub endpoints.

The following table describes the endpoints and certificates required for the SQL and MySQL adapters and for App Service. You don't need to copy these certificates to the Azure Stack Hub deployment folder. Instead, you provide these certificates when you install the additional resource providers.

|Scope (per region)|Certificate|Required certificate subject and Subject Alternative Names (SANs)|Subdomain namespace|
|-----|-----|-----|-----|
|SQL, MySQL|SQL and MySQL|&#42;.dbadapter.*&lt;region>.&lt;fqdn>*<br>(Wildcard SSL Certificate)|dbadapter.*&lt;region>.&lt;fqdn>*|
|App Service|Web Traffic Default SSL Cert|&#42;.appservice.*&lt;region>.&lt;fqdn>*<br>&#42;.scm.appservice.*&lt;region>.&lt;fqdn>*<br>&#42;.sso.appservice.*&lt;region>.&lt;fqdn>*<br>(Multi Domain Wildcard SSL Certificate<sup>1</sup>)|appservice.*&lt;region>.&lt;fqdn>*<br>scm.appservice.*&lt;region>.&lt;fqdn>*|
|App Service|API|api.appservice.*&lt;region>.&lt;fqdn>*<br>(SSL Certificate<sup>2</sup>)|appservice.*&lt;region>.&lt;fqdn>*<br>scm.appservice.*&lt;region>.&lt;fqdn>*|
|App Service|FTP|ftp.appservice.*&lt;region>.&lt;fqdn>*<br>(SSL Certificate<sup>2</sup>)|appservice.*&lt;region>.&lt;fqdn>*<br>scm.appservice.*&lt;region>.&lt;fqdn>*|
|App Service|SSO|sso.appservice.*&lt;region>.&lt;fqdn>*<br>(SSL Certificate<sup>2</sup>)|appservice.*&lt;region>.&lt;fqdn>*<br>scm.appservice.*&lt;region>.&lt;fqdn>*|

<sup>1</sup> Requires one certificate with multiple wildcard subject alternative names. Multiple wildcard SANs on a single certificate might not be supported by all public certificate authorities.

<sup>2</sup> A &#42;.appservice.*&lt;region>.&lt;fqdn>* wild card certificate can't be used in place of these three certificates (api.appservice.*&lt;region>.&lt;fqdn>*, ftp.appservice.*&lt;region>.&lt;fqdn>*, and sso.appservice.*&lt;region>.&lt;fqdn>*. Appservice explicitly requires the use of separate certificates for these endpoints.

## Learn more
Learn how to [generate PKI certificates for Azure Stack Hub deployment](azure-stack-get-pki-certs.md).

## Next steps
[Integrate AD FS identity with your Azure Stack Hub datacenter](azure-stack-integrate-identity.md).