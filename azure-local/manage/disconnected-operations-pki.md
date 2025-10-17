---
title: Understand Public Key Infrastructure (PKI) requirements for disconnected operations on Azure Local (preview)
description: Learn about public key infrastructure (PKI) requirements for disconnected operations on Azure Local. Discover how to create certificates to secure endpoints and ensure a trusted deployment (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 10/16/2025
ai-usage: ai-assisted
---

# Public key infrastructure (PKI) for disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-2506"

This article explains the public key infrastructure (PKI) requirements for disconnected operations on Azure Local. You'll learn how to create certificates to secure appliance endpoints and ensure secure communication in your environment.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## PKI overview for disconnected operations

PKI for disconnected operations is essential for securing the endpoints provided by the disconnected operations appliance. Create and manage digital certificates to ensure secure communication and data transfer within your Azure Local environment.

## PKI requirements

A public certificate authority (CA) or enterprise certificate authority must issue certificates. Make sure your certificates are part of the Microsoft Trusted Root Program. For more information, see [List of Participants - Microsoft Trusted Root Program](/security/trusted-root/participants-list).  

Mandatory certificates are grouped by area with the appropriate subject alternate names (SAN). Before you create the certificates, review these requirements:

- The use of self-signed certificates aren't supported. We recommend you use certificates issued by an enterprise CA.
- Disconnected operations require 24 external certificates for the endpoints it exposes.
- Generate individual certificates for each endpoint and copy them into the corresponding directory or folder structure. These certificates are required for disconnected operations deployment.
- All certificates must have the subject and SAN defined, as required by most browsers.
- All certificates should share the same trust chain and have at least a two-year expiration from the day of deployment.
- Export all root certificates in Base64 encoded format. The resulting file typically has a .cer, .crt, or .pem extension.
- For fully disconnected deployments:
  - Use a private or internal certificate authority (CA).
  - Only internal network access to the certificate revocation list (CRL) endpoint is required.
  - Internet connectivity isn't required.
  - Make sure your disconnected operations infrastructure can reach the CRL endpoint specified in the certificates' CRL distribution point (CDP) extension.
  - Don't use a public or external CA. Deployments fail if certificates come from a public CA, because internet connectivity is required to access the CRL and online certificate status protocol (OCSP) services for HTTPS.  

### Ingress endpoint certificate requirements

This table lists the mandatory certificates required for disconnected operations on Azure Local.

| Service | Required certificate subject and subject alternative names (SAN) |
|-------------------|----------------------|  
| Azure Container Registry | *.edgeacr.fqdn |
| Azure Key Vault | *.vault.fqdn  |
| Azure queue storage | *.queue.fqdn |
| Azure Table storage | *.table.fqdn |
| Azure Blob storage | *.blob.fqdn |
| Azure Service Bus | *.servicebus.fqdn |
| Azure Data Policy | data.policy.fqdn |
| Arc configuration data plane <br/br> Azure Arc-enabled Kubernetes | autonomous.dp.kubernetesconfiguration.fqdn |
| Arc for Server Agent data service | agentserviceapi.fqdn |
| Arc for server | his.fqdn |
| Arc guest notification service | guestnotificationservice.fqdn |
| Arc metrics | metricsingestiongateway.monitoring.fqdn |
| Arc monitor agent | amcs.monitoring.fqdn |
| Azure Arc resource bridge data plane | dp.appliances.fqdn |
| Azure Resource Manager | armmanagement.fqdn |
| Appliances | adminmanagement.fqdn |
| Front end appliances | frontend.appliances.fqdn |
| Graph | graph.fqdn |
| Licensing | dp.aszrp.fqdn <br></br> ibc.fqdn |
| Public portal     | portal.fqdn <br></br> hosting.fqdn <br></br> catalogapi.fqdn |
| Secure token service | login.fqdn |

### Management endpoints

The management endpoint requires two certificates, and you must put them in the same folder, *ManagementEndpointCerts*. The certificates are:

| Management endpoint certificate  | Required certificate subject  |
|----------------------|------------------|
| Server  | Management endpoint IP address: $ManagementIngressIpAddress. <br> If the management endpoint IP is **192.168.50.100**, then the server certificate's subject name must match exactly. For example, **Subject = 192.168.50.100**. You can also use an FQDN as an SN as long as it resolves to the management IP.| 
| Client  | Use a certificate subject that helps you distinguish it from others. Any string is acceptable. <br> For example, **Subject = ManagementEndpointClientAuth**.  |

## Create certificates to secure endpoints

### Ingress endpoints

On the host machine or Active Directory virtual machine (VM), follow the steps in this section to create certificates for the ingress traffic and external endpoints of the disconnected operations appliance. Make sure you modify for each of the 24 certificates.

You need these certificates to deploy the disconnected operations appliance. You also need the public key for your local infrastructure to provide a secure trust chain.

> [!NOTE]
> **IngressEndpointsCerts** is the folder where you store all 24 certificate files. **IngressEndpointPassword** is a secure string with the certificate password.

1. Connect to the CA.
1. Create a folder named **IngressEndpointsCerts**. Use this folder to store all certificates.
1. Create the 24 certs in the table above and export them into the IngressEndpointsCerts folder. 

Here's an example script you can modify and run. It creates ingress certificates and exports them to the configured folder by creating CSRs and issuing them to your CA.

> [!NOTE]
> Run this script on a domain-joined machine using an account with Domain Administrator access to issue certificates.

  ```PowerShell    
  $fqdn = "autonomous.cloud.private" 
  $caName = "<CA Computer Name>\<CA Name>" # Replace with your CA server and CA name (Run certutil -config - -ping to find the names)
  
  $extCertFilePath = "C:\AzureLocalDisconnectedOperations\Certs\IngressEndpointsCerts"
  # Making sure to create this directory if it does not exist
[void](New-Item -ItemType Directory -path $extCertFilePath -force)

  $certPassword = Read-Host -AsSecureString -Message 'CertPass' -Force  
  # Alternative
  # $certPassword = "REPLACEME"|ConvertTo-SecureString -AsPlainText -Force
$AzLCerts = @(    
    "*.edgeacr.$fqdn"      
    "*.vault.$fqdn"
    "*.queue.$fqdn"    
    "*.table.$fqdn"
    "*.blob.$fqdn" 
    "*.servicebus.$fqdn"   
    "data.policy.$fqdn"
    "autonomous.dp.kubernetesconfiguration.$fqdn"
    "agentserviceapi.$fqdn"
    "his.$fqdn"
    "guestnotificationservice.$fqdn"
    "metricsingestiongateway.monitoring.$fqdn"
    "amcs.monitoring.$fqdn"
    "dp.appliances.$fqdn"
    "armmanagement.$fqdn"
    "adminmanagement.$fqdn"
    "frontend.appliances.$fqdn"
    "graph.$fqdn"
    "dp.aszrp.$fqdn"
    "ibc.$fqdn"
    "portal.$fqdn"
    "hosting.$fqdn"    
    "catalogapi.$fqdn"    
    "login.$fqdn"    
    # Multi-San could be added with comma seperated list x.$fqdn,y.$fqdn    
)
  
  $AzLCerts | ForEach-Object {
      # Check if this is a multi SAN certificate
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

- Copy the original certificates (24 .pfx files / *.pfx) obtained from your CA to the directory structure represented in IngressEndpointsCerts.

### Management endpoint

Here's an example of how to create certificates for securing the management endpoint:

> [!NOTE]
> Run this script on a domain-joined machine using an account with Domain Administrator access to issue certificates.

```powershell
$caName = "<CA Computer Name>\<CA Name>" # Replace with your CA server and CA name 
# For more info on how to find your CA: https://learn.microsoft.com/en-us/troubleshoot/windows-server/certificates-and-public-key-infrastructure-pki/find-name-enterprise-root-ca-server 
$certPassword = Read-Host -AsSecureString -Message 'ManagementCertPass' -Force 
# Alternative
# $certPassword = "REPLACEME"|ConvertTo-SecureString -AsPlainText -Force

$managementendpointPath = "C:\AzureLocalDisconnectedOperations\Certs\ManagementEndpointCerts"
[void](New-Item -ItemType Directory -path $managementendpointPath -force)
$managementEndpointIPAddress = '192.168.100.25'
$fileNames = @('ManagementEndpointSsl', 'ManagementEndpointClientAuth')
$subjects = @($managementEndpointIPAddress,'ManagementEndpointClientAuth')  

$subjects|Foreach-Object {
    $subject=$_    
    $filename = $fileNames[$subjects.IndexOf($_)] 
    $infFilename = "$($managementendpointPath)\$($filename).inf"
    $csrPath = "$($managementendpointPath)\$($filename).csr"
    $certPath = "$($managementendpointPath)\$($filename).cer"
    $pfxPath = "$($managementendpointPath)\$($filename).pfx"
@"
[NewRequest]
Subject = "CN=$subject"
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
_continue_ = "DNS=$subject"
"@ | Out-File -FilePath $infFilename

    # Generate the CSR
    certreq -new $infFilename $csrPath
    
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
    $cert | Export-PfxCertificate -FilePath $pfxPath -Password $certPassword -Force
    Write-Verbose "Certificate for $subject and private key exported to $certPath" -Verbose
}


```

Copy the management certificates (*.pfx) to the directory structure represented in ManagementEndpointCerts.

## Export Root CA certificate 

You need the root certificate public key for deployment. The Root certificate needs to be exported with base64 encoding. 

The following example shows how to export your root certificate public key:

```powershell
$applianceRootcert = "C:\AzureLocalDisconnectedOperations\applianceRoot.cer"
$caName = 'corp/myca'

# Option 1) Get the Root CA certificate by its name:
$RootCACert = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "*$($caname)*" } | Select-Object -First 1

# # Option 2) Get the Root CA certificate by its thumbprint:
$RootCACert = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Thumbprint -eq "12345678ABCDEFGH607857694DF5E45B68851868" } | Select-Object -First 1

# Check you have the correct Root CA certificate:
$RootCACert

# If it matches, export in CER (DER) format
Export-Certificate -Cert $RootCACert -FilePath "C:\Temp\RootCA-DER.cer" -Type CERT

# Finally, convert from CER (DER) to Base-64 CER (and store it in $applianceRootcert)
certutil -encode "C:\Temp\RootCA-DER.cer" $applianceRootcert

## Alternative method (If CA is setup and responds)
# certutil -ca.cert $applianceRootCert
```

For more information, see [Active Directory Certificate Services](/troubleshoot/windows-server/certificates-and-public-key-infrastructure-pki/export-root-certification-authority-certificate).

## Obtain certificate information for identity integration

To secure your identity integration, we recommend that you pass these two parameters:

- LdapsCertChainInfo
- OidcCertChainInfo

These checks confirm that the certificates and chain for these endpoints haven’t been changed or tampered with.

You have a helper method in the **OperationsModule** that can help you populate these parameters.

Here's an example of how to populate the required parameters:

```powershell
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force


$oidcCertChain = Get-CertificateChainFromEndpoint -requestUri 'https://adfs.azurestack.local/adfs'
$ldapsCertChain = Get-CertificateChainFromEndpoint -requestUri 'https://dc01.azurestack.local'
```

Here's an example of the output from Get-CertificateChainFromEndpoint

```powershell
# Returns: System.Security.Cryptography.X509Certificates.X509Certificate2[]
>> Get-CertificateChainFromEndpoint
>>
Thumbprint                                Subject
----------                                -------
TESTING580E20618EA15357FC1028622518DDC4D  CN=www.website.com, O=Contoso Corporation, L=Redmond, S=WA, C=US
TESTINGDAA2345B48E507320B695D386080E5B25  CN=www.website.com, O=Contoso Corporation, L=Redmond, S=WA, C=US
TESTING9BFD666761B268073FE06D1CC8D4F82A4  CN=www.website.com, O=Contoso Corporation, L=Redmond, S=WA, C=US
```

## Related content

- [Plan hardware for Azure local with disconnected operations](disconnected-operations-overview.md#preview-participation-criteria)
- [Plan and understand identity](disconnected-operations-identity.md)
- [Plan and understand networking](disconnected-operations-network.md)
- [Set up disconnected operations](disconnected-operations-set-up.md)

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506

::: moniker-end
