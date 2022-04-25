---
title: Generate certificate signing requests for Azure Stack Hub 
description: Learn how to generate certificate signing requests for Azure Stack Hub PKI certificates in Azure Stack Hub integrated systems.
author: BryanLa
ms.topic: article
ms.date: 11/15/2021
ms.author: bryanla
ms.reviewer: ppacent
ms.lastreviewed: 11/15/2021

# Intent: As an Azure Stack operator, I want to generate CSRs before deploying Azure Stack so my identity system is ready.
# Keyword: azure stack certificate signing request 

---


# Generate certificate signing requests for Azure Stack Hub

You can use the Azure Stack Hub Readiness Checker tool to create certificate signing requests (CSRs) that are suitable for an Azure Stack Hub deployment. It's important to request, generate, and validate certificates with enough time to test them before they're deployed. 

To get the Readiness Checker tool, go to the [PowerShell Gallery](https://aka.ms/AzsReadinessChecker).

You can use the tool to request the following certificates:

- **Standard certificates**: [Generate certificate signing requests for new deployments](azure-stack-get-pki-certs.md#generate-certificate-signing-requests-for-new-deployments).
- **Renewal certificates**: [Generate certificate signing request for certificate renewal](azure-stack-get-pki-certs.md#generate-certificate-signing-requests-for-certificate-renewal).
- **Platform-as-a-service (PaaS) certificates**: [Azure Stack Hub public key infrastructure (PKI) certificate requirements - optional PaaS certificates](azure-stack-pki-certs.md#optional-paas-certificates).

## Prerequisites

Before you generate any CSRs for PKI certificates for an Azure Stack Hub deployment, your system should meet the following prerequisites:

- Microsoft Azure Stack Hub Readiness Checker, installed
- Certificate attributes:
  - Region name
  - External fully qualified domain name (FQDN)
  - Subject
- Windows 10 or later, or Windows Server 2016 or later

  > [!NOTE]  
  > When you receive your certificates from your certificate authority, follow the steps in [Prepare Azure Stack Hub PKI certificates](azure-stack-prepare-pki-certs.md) on the same system.
  >
  > Elevation is required to generate certificate signing requests. In restricted environments where elevation is not possible, you can use this tool to generate clear-text template files, which contain all the information that's required for Azure Stack Hub external certificates.  You then need to use these template files on an elevated session to finish the public/private key pair generation.  

## Generate certificate signing requests for new deployments

To prepare certificate signing requests for new Azure Stack Hub PKI certificates, do the following:

# [Omit CN](#tab/omit-cn)

Content for Subject with no CN

# [Add CN](#tab/add-cn)

Content for Subject with a CN

# [Only CN](#tab/only-cn)

Content for Subject with only a CN

---

1. Install AzsReadinessChecker from a PowerShell prompt (5.1 or later) by running the following cmdlet:

    ```powershell  
        Install-Module Microsoft.AzureStack.ReadinessChecker
    ```

1. Declare the *subject*. For example, run:

    ```powershell  
    $subject = "C=US,ST=Washington,L=Redmond,O=Microsoft,OU=Azure Stack Hub"
    ```

    > [!NOTE]  
    > If you require truncated subject with only a common name attribute, you must use New-AzsCertificateSigningRequest with the -CertificateType parameter.
    >
    > If you supply a common name (CN), it will be configured on every certificate request. If you omit the CN, the first DNS name of the Azure Stack Hub service will be configured on the certificate request.

1. Declare an output directory that already exists. For example, run:

    ```powershell  
    $outputDirectory = "$ENV:USERPROFILE\Documents\AzureStackCSR"
    ```

1. Declare the identity system.

    For Azure Active Directory (Azure AD):

    ```powershell
    $IdentitySystem = "AAD"
    ```

    For Active Directory Federation Services (AD FS):

    ```powershell
    $IdentitySystem = "ADFS"
    ```
    > [!NOTE]  
    > The parameter is required only for CertificateType deployment.

1. Declare the *region name* and an *external FQDN* that's intended for the Azure Stack Hub deployment.

    ```powershell
    $regionName = 'east'
    $externalFQDN = 'azurestack.contoso.com'
    ```

    > [!NOTE]  
    > `<regionName>.<externalFQDN>` forms the basis on which all external DNS names in Azure Stack Hub are created. In this example, the portal would be `portal.east.azurestack.contoso.com`.  

1. To generate CSRs for deployment, run:

    ```powershell  
    New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
    ```

    To generate CSRs for other Azure Stack Hub services, change the cmdlet name. For example:

    ```powershell  
    # App Services
    New-AzsHubAppServicesCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

    # DBAdapter
    New-AzsHubDbAdapterCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

    # EventHubs
    New-AzsHubEventHubsCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory
    ```

1. Alternatively, for low-privilege environments, to generate a clear-text certificate template file with the necessary attributes declared, add the `-LowPrivilege` parameter:

    ```powershell  
    New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem -LowPrivilege
    ```

1. Alternatively, for development and test environments, to generate a single CSR with multiple-subject alternative names, add the `-RequestType SingleCSR` parameter and value. (We do *not* recommend using this approach for production environments.)

    ```powershell  
    New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -RequestType SingleCSR -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
    ```

1. Review the output:

    ```powershell  
    Starting Certificate Request Process for Deployment
    CSR generating for following SAN(s): *.adminhosting.east.azurestack.contoso.com,*.adminvault.east.azurestack.contoso.com,*.blob.east.azurestack.contoso.com,*.hosting.east.azurestack.contoso.com,*.queue.east.azurestack.contoso.com,*.table.east.azurestack.contoso.com,*.vault.east.azurestack.contoso.com,adminmanagement.east.azurestack.contoso.com,adminportal.east.azurestack.contoso.com,management.east.azurestack.contoso.com,portal.east.azurestack.contoso.com
    Present this CSR to your Certificate Authority for Certificate Generation:  C:\Users\username\Documents\AzureStackCSR\Deployment_east_azurestack_contoso_com_SingleCSR_CertRequest_20200710165538.req
    Certreq.exe output: CertReq: Request Created
    ```

1. Submit the generated *.req* file to your certificate authority (CA) (either internal or public). Output directory *New-AzsCertificateSigningRequest* contains the CSRs that must be submitted to a CA. The directory also contains, for your reference, a child directory containing the *.inf* files that are used during certificate request generation. Be sure that your CA generates certificates by using a generated request that meets the [Azure Stack Hub PKI requirements](azure-stack-pki-certs.md).

1. If the `-LowPrivilege` parameter was used, copy the resulting *.inf* file. For example:  

    `C:\Users\username\Documents\AzureStackCSR\Deployment_east_azurestack_contoso_com_SingleCSR_CertRequest_20200710165538_ClearTextTemplate.inf` 

    Copy the file to a system where elevation is allowed, and then sign each request with *certreq* by using the following syntax: *certreq -new <example.inf> <example.req>*. You then need to complete the rest of the process on that elevated system, because it requires matching the new certificate that's signed by the CA with its private key, which is generated on the elevated system.

## Generate certificate signing requests for certificate renewal  

To prepare CSRs for renewal of existing Azure Stack Hub PKI certificates, do the following:

1. Install AzsReadinessChecker from a PowerShell prompt (5.1 or later), by running the following cmdlet:

    ```powershell  
        Install-Module Microsoft.AzureStack.ReadinessChecker -Force -AllowPrerelease
    ```

1. Declare `stampEndpoint` in the form of *regionname.domain.com* of the Azure Stack Hub system. For example, if the Azure Stack Hub tenant portal address is *<code>https://</code><code>portal.east.azurestack.contoso.com</code>*, run the following:

    ```powershell  
    $stampEndpoint = 'east.azurestack.contoso.com'
    ```

    > [!NOTE]  
    > You need HTTPS connectivity for the previously discussed Azure Stack Hub system.
    >
    > The Readiness Checker uses `stampEndpoint` (region and domain) to build a pointer to existing certificates that the certificate type requires. For example, for deployment certificates, "portal" is prepended by the tool. So *portal.east.azurestack.contoso.com* is used in certificate cloning, and *sso.appservices.east.azurestack.contoso.com* is used for app services.
    >
    > The certificate that's bound to the computed endpoint will be used to clone such attributes as subject, key length, and signature algorithm.  To change any of these attributes, follow the instructions in [Generate certificate signing request for new deployments](azure-stack-get-pki-certs.md#generate-certificate-signing-requests-for-new-deployments).
    > 
    > **Known Issue**: Certificates subjects containing only a common name cannot be processed by this commandlet, if a truncated subject attribute is required for successful renewal follow the instructions in [Generate certificate signing request for new deployments](azure-stack-get-pki-certs.md#generate-certificate-signing-requests-for-new-deployments).

1. Declare an output directory that already exists. For example, run:

    ```powershell  
    $outputDirectory = "$ENV:USERPROFILE\Documents\AzureStackCSR"
    ```

1. To generate certificate signing requests for deployment, run:

    ```powershell  
    New-AzsHubDeploymentCertificateSigningRequest -StampEndpoint $stampEndpoint -OutputRequestPath $OutputDirectory
    ```

    To generate certificate requests for other Azure Stack Hub services, run:

    ```powershell  
    # App Services
    New-AzsHubAppServicesCertificateSigningRequest -StampEndpoint $stampEndpoint -OutputRequestPath $OutputDirectory

    # DBAdapter
    New-AzsHubDBAdapterCertificateSigningRequest -StampEndpoint $stampEndpoint -OutputRequestPath $OutputDirectory

    # EventHubs
    New-AzsHubEventHubsCertificateSigningRequest -StampEndpoint $stampEndpoint -OutputRequestPath $OutputDirectory
    ```

1. Alternatively, for development and test environments, to generate a single certificate request with multiple-subject alternative names, add the `-RequestType SingleCSR` parameter and value. (We do *not* recommend using this approach for production environments.)

    ```powershell  
    New-AzsHubDeploymentCertificateSigningRequest -StampEndpoint $stampendpoint -OutputRequestPath $OutputDirectory -RequestType SingleCSR
    ```

1. Review the output:

    ```powershell  
    Querying StampEndpoint portal.east.azurestack.contoso.com for existing certificate
    Starting Certificate Request Process for Deployment
    CSR generating for following SAN(s): *.adminhosting.east.azurestack.contoso.com,*.adminvault.east.azurestack.contoso.com,*.blob.east.azurestack.contoso.com,*.hosting.east.azurestack.contoso.com,*.queue.east.azurestack.contoso.com,*.table.east.azurestack.contoso.com,*.vault.east.azurestack.contoso.com,adminmanagement.east.azurestack.contoso.com,adminportal.east.azurestack.contoso.com,management.east.azurestack.contoso.com,portal.east.azurestack.contoso.com
    Present this CSR to your certificate authority for certificate generation: C:\Users\username\Documents\AzureStackCSR\Deployment_east_azurestack_contoso_com_SingleCSR_CertRequest_20200710122723.req
    Certreq.exe output: CertReq: Request Created
    ```

1. Submit the generated *.req* file to your CA (either internal or public). Output directory *New-AzsCertificateSigningRequest* contains the CSRs that you must submit to a certificate authority. The directory also contains, for your reference, a child directory that contains the *.inf* files to be used during certificate request generation. Be sure that your CA generates certificates by using a generated request that meets the [Azure Stack Hub PKI requirements](azure-stack-pki-certs.md).

## Next steps

[Prepare Azure Stack Hub PKI certificates](azure-stack-prepare-pki-certs.md)
