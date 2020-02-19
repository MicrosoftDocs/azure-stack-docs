---
title: Generate certificate signing requests for Azure Stack Hub 
description: Learn how to generate certificate signing requests for Azure Stack Hub PKI certificates in Azure Stack Hub integrated systems.
author: IngridAtMicrosoft
ms.topic: article
ms.date: 09/10/2019
ms.author: inhenkel
ms.reviewer: ppacent
ms.lastreviewed: 09/10/2019
---

# Generate certificate signing requests for Azure Stack Hub

You can use the Azure Stack Hub Readiness Checker tool to create Certificate Signing Requests (CSRs) suitable for an Azure Stack Hub deployment. Certificates should be requested, generated, and validated with enough time to test before deployment. You can get the tool [from the PowerShell Gallery](https://aka.ms/AzsReadinessChecker).

You can use the Azure Stack Hub Readiness Checker tool (AzsReadinessChecker) to request the following certificates:

- **Standard Certificate Requests** according to [Generate certificate signing request](azure-stack-get-pki-certs.md#generate-certificate-signing-requests).
- **Platform-as-a-Service**: You can request platform-as-a-service (PaaS) names for certificates as specified in [Azure Stack Hub Public Key Infrastructure certificate requirements - Optional PaaS Certificates](azure-stack-pki-certs.md#optional-paas-certificates).

## Prerequisites

Your system should meet the following prerequisites before generating any CSRs for PKI certificates for an Azure Stack Hub deployment:

- Microsoft Azure Stack Hub Readiness Checker
- Certificate attributes:
  - Region name
  - External fully qualified domain name (FQDN)
  - Subject
- Windows 10 or Windows Server 2016 or later

  > [!NOTE]  
  > When you receive your certificates back from your certificate authority, the steps in [Prepare Azure Stack Hub PKI certificates](azure-stack-prepare-pki-certs.md) will need to be completed on the same system!

## Generate certificate signing requests

Use these steps to prepare and validate the Azure Stack Hub PKI certificates:

1. Install AzsReadinessChecker from a PowerShell prompt (5.1 or above), by running the following cmdlet:

    ```powershell  
        Install-Module Microsoft.AzureStack.ReadinessChecker
    ```

2. Declare the **subject**. For example:

    ```powershell  
    $subject = "C=US,ST=Washington,L=Redmond,O=Microsoft,OU=Azure Stack Hub"
    ```

    > [!NOTE]  
    > If a common name (CN) is supplied, it will be configured on every certificate request. If a CN is omitted, the first DNS name of the Azure Stack Hub service will be configured on the certificate request.

3. Declare an output directory that already exists. For example:

    ```powershell  
    $outputDirectory = "$ENV:USERPROFILE\Documents\AzureStackCSR"
    ```

4. Declare identity system.

    Azure Active Directory (Azure AD):

    ```powershell
    $IdentitySystem = "AAD"
    ```

    Active Directory Federation Services (AD FS):

    ```powershell
    $IdentitySystem = "ADFS"
    ```
    > [!NOTE]  
    > The parameter is required only for CertificateType Deployment.

5. Declare **region name** and an **external FQDN** intended for the Azure Stack Hub deployment.

    ```powershell
    $regionName = 'east'
    $externalFQDN = 'azurestack.contoso.com'
    ```

    > [!NOTE]  
    > `<regionName>.<externalFQDN>` forms the basis on which all external DNS names in Azure Stack Hub are created. In this example, the portal would be `portal.east.azurestack.contoso.com`.  

6. To generate certificate signing requests for deployment:

    ```powershell  
    New-AzsCertificateSigningRequest -certificateType Deployment -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
    ```

    To generate certificate requests for other Azure Stack Hub services, change the value for `-CertificateType`. For example:

    ```powershell  
    # App Services
    New-AzsCertificateSigningRequest -certificateType AppServices -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

    # DBAdapter
    New-AzsCertificateSigningRequest -certificateType DBAdapter -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

    # EventHubs
    New-AzsCertificateSigningRequest -certificateType EventHubs -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

    # IoTHub
    New-AzsCertificateSigningRequest -certificateType IoTHub -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory
    ```

7. Alternatively, for Dev/Test environments, to generate a single certificate request with multiple Subject Alternative Names add **-RequestType SingleCSR** parameter and value (**not** recommended for production environments):

    ```powershell  
    New-AzsCertificateSigningRequest -certificateType Deployment -RegionName $regionName -FQDN $externalFQDN -RequestType SingleCSR -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
    ```

8.  Review the output:

    ```powershell  
    New-AzsCertificateSigningRequest v1.1912.1082.37 started.
    Starting Certificate Request Process for Deployment
    CSR generating for following SAN(s): *.adminhosting.east.azurestack.contoso.com,*.adminvault.east.azurestack.contoso.com,*.blob.east.azurestack.contoso.com,*.hosting.east.azurestack.contoso.com,*.queue.east.azurestack.contoso.com,*.table.east.azurestack.contoso.com,*.vault.east.azurestack.contoso.com,adminmanagement.east.azurestack.contoso.com,adminportal.east.azurestack.contoso.com,management.east.azurestack.contoso.com,portal.east.azurestack.contoso.com
    Present this CSR to your Certificate Authority for Certificate Generation: C:\Users\checker\Documents\AzureStackCSR\wildcard_adminhosting_east_azurestack_contoso_com_CertRequest_20191219140359.req
    Certreq.exe output: CertReq: Request Created

    Log location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessChecker.log
    New-AzsCertificateSigningRequest Completed
    ```

9.  Submit the **.REQ** file generated to your CA (either internal or public). The output directory of **New-AzsCertificateSigningRequest** contains the CSR(s) necessary to submit to a Certificate Authority. The directory also contains, for your reference, a child directory containing the INF file(s) used during certificate request generation. Be sure that your CA generates certificates using your generated request that meet the [Azure Stack Hub PKI Requirements](azure-stack-pki-certs.md).

## Next steps

[Prepare Azure Stack Hub PKI certificates](azure-stack-prepare-pki-certs.md)
