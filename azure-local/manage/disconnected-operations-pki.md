---
title: Understand Public Key Infrastructure (PKI) requirements for disconnected operations on Azure Local (preview)
description: Learn about the public key infrastructure (PKI) requirements for disconnected operations on Azure Local and how to create the necessary certificates to secure the endpoints provided by the disconnected operations appliance (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 04/22/2025
---

# Public Key Infrastructure (PKI) for disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-24112"

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This document describes your local public key infrastructure (PKI) requirements and shows you how to create the necessary certificates to secure the endpoints provided by the disconnected operations appliance.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About PKI

PKI for disconnected operations is essential for securing the endpoints provided by the disconnected operations appliance. You create and manage digital certificates to ensure secure communication and data transfer within your Azure Local environment.

## PKI requirements

Public certificate authorities (CA) or enterprise certificate authorities must issue certificates. Ensure that your certificates are part of the Microsoft Trusted Root Program. For more information, see [List of Participants - Microsoft Trusted Root Program](/security/trusted-root/participants-list).  

Mandatory certificates are grouped by area with the appropriate subject alternate names (SAN). Before you create the certificates, make sure you understand the following requirements:

- The use of self-signed certificates isn’t supported. We recommend you use certificates issued by an enterprise CA.
- Disconnected operations requires 26 external certificates for the endpoints it exposes.
- Individual certificates should be generated for each endpoint and copied into the corresponding directory/folder structure. These Certificates are mandatory for disconnected operations deployment.
- All certificates must have Subject and SAN defined, as required by most browsers.
- All certificates should share the same trust chain and should at least have a two-year expiration from the day of the deployment.
- All root certificates should be exported in Base64 encoded format. The resulting file typically has a .cer, .crt, or .pem extension.
- For fully disconnected deployments:
  - Use a private or internal Certificate Authority (CA).
  - Only internal network access to the Certificate Revocation List (CRL) endpoint is required.
  - Internet connectivity is not required.
  - Ensure your disconnected operations infrastructure can reach the CRL endpoint specified in the certificates’ CRL Distribution Point (CDP) extension.
  - Do not use a public or external CA. Deployments fail if certificates come from a public CA, because internet connectivity is required to access the CRL and Online Certificate Status Protocol (OCSP) services for HTTPS.  

### Ingress endpoints

This table lists the mandatory certificates required for disconnected operations on Azure Local.

| Service | Required certificate subject and subject alternative names (SAN) |
|-------------------|----------------------|  
| Azure Container Registry | *.edgeacr.fqdn |
| Appliances | dp.appliances.fqdn <br></br> adminmanagement.fqdn |
| Azure Data Policy | data.policy.fqdn |
| Arc configuration data plane | autonomous.dp.kubernetesconfiguration.fqdn |
| Arc for Server Agent data service | agentserviceapi.fqdn |
| Arc for server | his.fqdn |
| Arc guest notification service | guestnotificationservice.fqdn |
| Arc metrics | metricsingestiongateway.monitoring.fqdn |
| Arc monitor agent | amcs.monitoring.fqdn |
| Azure Arc resource bridge data plane | dp.appliances.fqdn |
| Azure Resource Manager | armmanagement.fqdn |
| Azure Arc-enabled Kubernetes | autonomous.dp.kubernetesconfiguration.fqdn |
| Azure queue storage | *.queue.fqdn |
| Azure Resource Manager Public | armmanagement.fqdn |
| Azure Table storage | *.table.fqdn |
| Azure Blob storage | *.blob.fqdn |
| Front end appliances | frontend.appliances.fqdn |
| Graph | graph.fqdn |
| Azure Key Vault | *.vault.<'fqdn'> (wildcard Secure Sockets Layer (SSL) certificate) |
| Kubernetes configuration | dp.kubernetesconfiguration.fqdn |
| Licensing | licensing.aszrp.fqdn <br></br> dp.aszrp.fqdn <br></br> lbc.fqdn |
| Managed Arc proxy services (MAPS) Azure Kubernetes Service (AKS) | *.k8sconnect.fqdn |
| Public extension host | *.hosting.fqdn (wildcard SSL certificate) |
| Public portal     | portal.fqdn <br></br> hosting.fqdn <br></br> portalcontroller.fqdn <br></br> catalogapi.fqdn |
| Secure token service | login.fqdn |
| Service bus | *.servicebus.fqdn |

### Management endpoints

The management endpoint requires two certificates and they must be put in the same folder, *ManagementEndpointCerts*. The certificates are:

| Management endpoint certificate  | Required certificate subject  |
|----------------------|------------------|
| Server  | Management endpoint IP address: $ManagementIngressIpAddress. <br></br> If the management endpoint IP is **192.168.100.25**, then the server certificate’s subject name must match exactly. For example, **Subject = 192.168.100.25**|
| Client  | Use a certificate subject that helps you distinguish it from others. Any string is acceptable. <br></br> For example, **Subject = ManagementEndpointClientAuth**.  |

## Create certificates to secure endpoints
### Ingress endpoints
On the host machine or Active Directory virtual machine (VM), follow the steps in this section to create certificates for the ingress traffic and external endpoints of the disconnected operations appliance. Make sure you modify for each of the 26 certificates.

You need these certificates when deploying the disconnected operations appliance. Additionally, you need the public key for your local infrastructure to provide a secure trust chain.

> [!NOTE]
> **IngressEndpointCerts** is the folder where all 26 certificate files should be stored. **IngressEndpointPassword** is a secure string with the certificate password.


1. Connect to the CA.
1. Create a folder named **IngressEndpointsCerts**. Use this folder to store all certificates.
1. Modify the variables and run the script below (this will create the ingress certificates and export them to the configured folder)

```PowerShell    
$fqdn = "autonomous.cloud.private" 
$caName = "<CA Computer Name>\<CA Name>" # Replace with your CA server and CA name (Run certutil -config - -ping to find the names)
$extCertFilePath = "<Your Preferred Path\IngressEndpointsCerts"
$certPassword = Read-Host -AsSecureString -Message 'CertPass' -Force  
# Alternative
# $certPassword = "REPLACEME"|ConvertTo-SecureString -AsPlainText -Force

$AzLCerts = @(
    "*.blob.$fqdn"
    "*.edgeacr.$fqdn"
    "*.hosting.$fqdn"
    "*.k8sconnect.$fqdn"
    "*.queue.$fqdn"
    "*.servicebus.$fqdn"
    "*.table.$fqdn"
    "*.vault.$fqdn"
    "agentserviceapi.$fqdn"
    "amcs.monitoring.$fqdn"
    "armmanagement.$fqdn"
    "autonomous.dp.kubernetesconfiguration.$fqdn"
    "data.policy.$fqdn"
    "dp.appliances.$fqdn"
    "dp.kubernetesconfiguration.$fqdn"
    "frontend.appliances.$fqdn"
    "graph.$fqdn"
    "guestnotificationservice.$fqdn"
    "his.$fqdn"
    "login.$fqdn"
    "metricsingestiongateway.monitoring.$fqdn"
    # Here's the multi-SAN certificates
    "portal.$fqdn,hosting.$fqdn,portalcontroller.$fqdn,catalogapi.$fqdn"
    "licensing.aszrp.$fqdn,dp.aszrp.$fqdn,lbc.$fqdn"
    "dp.appliances.$fqdn,adminmanagement.$fqdn"
)

$AzLCerts | ForEach-Object {
    # Check if there is a comma in the string
    if ($_.Contains(',')) {
        $certSubject = "CN=$($_.Split(',')[0])"
        $dns = $_.Replace(',', '&DNS=').Replace(' ', '')
        $filePrefix = $_.Split(',')[0].Replace('*.', '')
    }
    else {
        $certSubject = "CN=$_"
        $dns = $certSubject.Split('=')[1]
        $filePrefix = $dns.Replace('*.', '')
    }
    $certFilePath = "$extCertFilePath\INF"
    New-Item -ItemType Directory -Path $certFilePath -Force | Out-Null
    Remove-Item "$certFilePath\$filePrefix.*" -Force -ErrorAction SilentlyContinue
    $csrPath = Join-Path -Path $certFilePath -ChildPath "$filePrefix.csr"
    $infPath = Join-Path -Path $certFilePath -ChildPath "$filePrefix.inf"

    # Create the INF file for the CSR
    @"
[NewRequest]
Subject = "$certSubject"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
MachineKeySet = TRUE
SMIME = FALSE
PrivateKeyArchive = FALSE
UserProtected = FALSE
UseExistingKeySet = FALSE
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ProviderType = 12
RequestType = PKCS10
KeyUsage = 0xa0
HashAlgorithm = sha256

[Extensions]
2.5.29.17 = "{text}"
_continue_ = "DNS=$dns"
"@ | Out-File -FilePath $infPath

    # Generate the CSR
    certreq -new $infPath $csrPath

    # Define parameters to submit the CSR
    $certPath = Join-Path $certFilePath -ChildPath "$filePrefix.cer"

    # Submit the CSR to the CA
    certreq -submit -attrib "CertificateTemplate:WebServer" -config $caName $csrPath $certPath
    Write-Verbose "Certificate request submitted. Certificate saved to $certPath" -Verbose

    # Accept the certificate and install it.
    $certReqOutput = certreq.exe -accept $certPath

    # Parse the thumbprint and export the certificate
    $match = $certReqOutput -match 'Thumbprint:\s*([a-fA-F0-9]+)'
    if ($null -ne $match) {
        $thumbprint = (($match[0]).Split(':')[1]).Trim()
        Write-Verbose "Thumbprint: $thumbprint" -Verbose
    }
    else {
        Write-Verbose "Thumbprint not found" -Verbose
        #return;
    }

    # Export the certificate to a PFX file
    $cert = Get-Item -Path "Cert:\LocalMachine\My\$thumbprint"
    $cert | Export-PfxCertificate -FilePath "$extCertFilePath\$filePrefix.pfx" -Password $certPassword -Force
    Write-Verbose "Certificate for $certSubject and private key exported to $extCertFilePath" -Verbose
}
``` 

1. Copy the original certificates (26 .pfx files) obtained from your CA to the directory structure represented in IngressEndpointCerts.

### Management endpoint
Here is an an example on how to create certificates for securing the management endpoint :

```powershell
## Endpoint cert (SSL)

## Client cert

```
1. Copy the management certificates to the directory structure represented in ManagementEndpointCerts

## Obtain certificate thumbprints for identity integration (oidc / ldap)

Here's an example script to get the certificate chain your ADFS endpoint:

```powershell
# Resolve certificates from endpoint
# https://gist.github.com/keystroke/643bcbc449b3081544c7e6db7db0bba8

#This script uses endpoints that needs to be modified
$oidcCertChain = Get-CertificateChainFromEndpoint https://adfs.contoso.com 
$ldapCertchain =  Get-CertificateChainFromEndpoint https://adfs2.contoso.com 

# Save certificates to specified folder 
$targetDirectory = 'C:\WinfieldExternalIdentityCertificates1' #Please modify 
foreach ($certificate in $oidcCertChain) 
{ 
    $bytes = $certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert) 
    $bytes | Set-Content -Path "$targetDirectory\$($certificate.Thumbprint).cer" -Encoding Byte 
} 


# Read certificate information for external identity configuration 
$targetDirectory = 'C:\WinfieldExternalIdentityCertificates1' 
$oidcCertChainInfo = @() 
foreach ($file in (Get-ChildItem $targetDirectory)) 
{ 
    $certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($file.FullName) 
    $bytes = $certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert) 
    $b64 = [system.convert]::ToBase64String($bytes) 
    $oidcCertChainInfo += $b64 
} 

# Save certificates to specified folder 
$targetDirectory = 'C:\WinfieldExternalIdentityCertificates2' 
foreach ($certificate in $ldapCertchain) 
{ 
    $bytes = $certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert) 
    $bytes | Set-Content -Path "$targetDirectory\$($certificate.Thumbprint).cer" -Encoding Byte 
} 


# Read certificate information for external identity configuration 
$targetDirectory = 'C:\WinfieldExternalIdentityCertificates2' 
$ ldapCertchainInfo = @() 
foreach ($file in (Get-ChildItem $targetDirectory)) 
{ 
    $certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($file.FullName) 
    $bytes = $certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert) 
    $b64 = [system.convert]::ToBase64String($bytes) 
    $ldapCertchainInfo += $b64 
} 

Write-Host "LdapcertChainInfo"
$ldapCertChainInfo

Write-Host "oidcCertChainInfo"
$oidcCertChainInfo
```

## Related content

- [Plan hardware for Azure local with disconnected operations](disconnected-operations-overview.md#preview-participation-criteria).

- [Plan and understand identity](disconnected-operations-identity.md).

- [Plan and understand networking](disconnected-operations-network.md).

- [Set up disconnected operations](disconnected-operations-set-up.md).

::: moniker-end

::: moniker range="<=azloc-2506"

This feature is available only in Azure Local 2506

::: moniker-end
