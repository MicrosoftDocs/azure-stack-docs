---
title: Understand Public Key Infrastructure (PKI) requirements for disconnected operations on Azure Local (preview)
description: Learn about the public key infrastructure (PKI) requirements for disconnected operations on Azure Local and how to create the necessary certificates to secure the endpoints provided by the disconnected operations appliance (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 01/17/2025
---

# Public Key Infrastructure (PKI) for disconnected operations on Azure Local (preview) 

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This document describes your local public key infrastructure (PKI) requirements and shows you how to create the necessary certificates to secure the endpoints provided by the disconnected operations appliance.  

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About PKI

PKI for disconnected operations is essential for securing the endpoints provided by the disconnected operations appliance. You create and manage digital certificates to ensure secure communication and data transfer within your Azure Local environment.

## PKI requirements  

You need a public certificate authority (CA) to issue your certificates or they can be self-signed. Your certificates must be part of the Microsoft Trusted Root Program. For more information, see [List of Participants - Microsoft Trusted Root Program](/security/trusted-root/participants-list).  

Mandatory certificates are grouped by area with the appropriate subject alternate names (SAN). Before you create the certificates, make sure you understand the following requirements:

- Store all 26 certificates in one folder.
- Use certificates issued by an enterprise CA. Self-signed certificates aren’t supported.
- Define **Subject name** and **SAN**, as required by most browsers.
- Ensure all certificates share the same trust chain.
- Certificates must expire two years from the day of deployment.

### Ingress endpoints

This table lists the mandatory certificates required for disconnected operations on Azure Local.

| Service | Required certificate subject and subject alternative names (SAN) |
|-------------------|----------------------|  
| ACSQueue | *.queue.fqdn |
| ACSTable | *.table.fqdn |
| Appliances | dp.appliances.fqdn <br></br> adminmanagement.fqdn |
| Arc configuration data plane | <'regionname'>.dp.kubernetesconfiguration.fqdn |
| Arc for server | his.fqdn |
| Arc for Server Agent data service | agentserviceapi.fqdn |
| Arc guest notification service | guestnotificationservice.fqdn |
| Arc metrics | metricsingestiongateway.monitoring.fqdn |
| Arc monitor agent | amcs.monitoring.fqdn |
| Arc Resource Bridge data plane | dp.appliances.fqdn |
| Azure Container Registry | *.edgeacr.fqdn |
| Azure Data Policy | data.policy.fqdn |
| Azure Resource Manager | armmanagement.fqdn |
| Blob certificate  | *.blob.fqdn  |
| Front end appliances | frontend.appliances.fqdn |
| Front end monitoring | pqsqueryfrontend.monitoring.fqdn |
| Graph | graph.fqdn |
| Azure Key Vault | *.vault.<'fqdn'> (wildcard Secure Sockets Layer (SSL) certificate) |
| Kubernetes configuration | dp.kubernetesconfiguration.fqdn |
| Licensing | Licensing.aszrp.fqdn <br></br> Dp.aszrp.fwdn <br></br> lbc.fqdn |
| Managed Arc proxy services (MAPS) Azure Kubernetes Service (AKS) | *.k8sconnect.fqdn |
| Public extension host | *.hosting.fqdn (wildcard SSL certificate) |
| Public portal     | portal.fqdn <br></br> hosting.fqdn <br></br> portalcontroller.fqdn <br></br> catalogapi.fqdn |
| Service |  Required certificate subject names and SAN |
| Service bus | *.servicebus.fqdn |
| STS | login.fqdn |

### Management endpoints

| Management endpoint certificate  | Required certificate subject  | Required certificate subject alternative names (SAN) |
|----------------------|------------------|-----------------------|
| Server  | Management endpoint IP address: $ManagementIngressIpAddress. <br></br> If the management endpoint IP is *192.168.100.25*, then the server certificate’s subject name must match exactly. For example, *Subject = 192.168.100.25*| Management endpoint IP address: $ManagementIngressIpAddress. <br></br> If the management endpoint IP is *192.168.100.25*, then the server certificate’s SAN must match exactly. For example, *SAN = 192.168.100.25* |
| Client  | Use a certificate subject that helps you distinguish it from others. Any string is acceptable. <br></br> For example, *Subject = ManagementEndpointClientAuth*.  | Use a certificate SAN that helps you distinguish it from others. Any string is acceptable. <br></br> For example, *SAN = ManagementEndpointClientAuth*. |

## Create certificates to secure endpoints

Follow these steps to create certificates for the ingress traffic and external endpoints of the disconnected operations appliance. Modify for each of the 26 certificates.

1. Connect to the CA via the host machine or Active Directory virtual machine (VM).
1. Create a folder named **IngressEndpointsCerts**. Use this folder to store all certificates.
1. Create a Certificate Signing Request (CSR).

    ```PowerShell
    $dns = $certSubject.Split('=')[1]
    $filePrefix = $dns.Replace('*.','')
    $certFilePath = Split-Path -Path $extCertFilePath
    
    mkdir $certFilePath -Force
    rm "$certFilePath\$filePrefix.*" -Force
    
    $csrPath = Join-Path -Path $certFilePath -ChildPath "$filePrefix.csr"
    $infPath = Join-Path -Path $certFilePath -ChildPath "$filePrefix.inf"
    ```

1. Create the .inf file.

    ```PowerShell
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
    ```

1. [Generate a Certificate Signing Request (CSR)](/azure-stack/operator/azure-stack-get-pki-certs?view=azs-2408&tabs=omit-cn&pivots=csr-type-new-deployment&preserve-view=true) for each certificate.

    ```powershell
    certreq -new $infPath $csrPath
    Write-Verbose "CSR created and saved to $csrPath" -Verbose
    ```

1. Submit the CSR to the Enterprise CA.

    ```powershell
    $certPath = Join-Path $certFilePath -ChildPath "$filePrefix.cer"
    $caName = "contoso-disconnected.com\contoso-disconnected.com"
    ```

1. Submit the CSR to the CA.

    ```powershell
    certreq -submit -attrib "CertificateTemplate:WebServer" -config $caName $csrPath $certPath
    Write-Verbose "Certificate request submitted. Certificate saved to $certPath" -Verbose
    ```
1. Accept the certificate and install it.

    ```powershell
    $certReqOutput = certreq.exe -accept $certPath
    ```

1. Parse the thumbprint and export the certificate.

    ```powershell
    $match = $certReqOutput -match 'Thumbprint:\s*([a-fA-F0-9]+)'

    if ($null -ne $match) {
        $thumbprint = (($match[0]).Split(':')[1]).Trim()
        Write-Verbose "Thumbprint: $thumbprint" -Verbose
    } else {
        Write-Verbose "Thumbprint not found" -Verbose
        #return;
    }
    ```

1. Save the .pfx file in the **IngressEndpointsCerts** folder.

    ```powershell
    $cert = Get-Item -Path "Cert:\LocalMachine\My\$thumbprint"
    $cert | Export-PfxCertificate -FilePath $extCertFilePath -Password (ConvertTo-SecureString -String "…" -Force -AsPlainText)
    Write-Verbose "Certificate for $certSubject and private key exported to $extCertFilePath" -Verbose
    ```

1. Repeat steps 3-11 for each certificate.

1. Call sys configuration endpoint to import your .pfx files.

    ```powershell
    Set-ApplianceExternalEndpointCertificates  -DisconnectedOperationsClientContext $managementNetworkConfiguration.ToDisconnectedOperationsClientContext() - IngressEndpointCerts $ExternalCertsConfig.ExternalCertificatesFolder - IngressEndpointPassword $ExternalCertsConfig.ExternalCertificatePassword
    ```

## Management traffic  

The management endpoint requires two certificates and they must be put in the same folder, *ManagementEndpointCerts*. The certificates are:
  
- **Transport Layer Security certificate** (endpoint).
- **Client certificate** (authorization).

## Next steps