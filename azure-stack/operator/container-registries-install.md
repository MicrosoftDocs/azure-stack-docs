---
title: Install Azure Container Registry on Azure Stack Hub 
description: Learn how to install Azure Container Registry on Azure Stack Hub.
author: mattbriggs
ms.topic: how-to
ms.date: 08/20/2021
ms.author: mabrigg
ms.reviewer: chasat
ms.lastreviewed: 08/20/2021

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---

# Install Azure Container Registry on Azure Stack Hub

You can install the Azure Container Registry (ACR) on Azure Stack Hub and make it available to your users so that they can host containers in your environment. To install the ACR, you will need to generate and validate a certificate and install the ACR. You can install through the Azure Stack Hub administrative portal or the by using PowerShell.

## Prerequisites

* **Azure Stack Hub version**  
    You can only enable the Microsoft Azure Container in an Azure Stack Hub integrated system running the 2108 update, and later releases. You must install the Azure Stack Hub update before you complete the steps in this article. The Azure Container Registry (ACR) service is not supported on the Azure Stack Developer Kit (ASDK) deployments.
* **Certificate requirements**  
    The configuration of the ACR on your Azure Stack Hub system adds a new data path that requires a certificate. The certificate must meet the same requirements as the other certificates required to install and operate Azure Stack Hub. You can find more information in the article, "[Azure Stack Hub public key infrastructure (PKI) certificate requirements](/azure-stack-pki-certs.md)."

    The URI for this new certificate should have the following format:

    `*.azsacr.<region>.<fqdn>`

    For example:

    `*.azsacr.azurestack.contoso.com`
## Generate your certificate

You can use the following steps to generate ACR certificate using The Azure Stack Hub Readiness Checker tool. You must specific the version of the **Microsoft.AzureStack.ReadinessChecker** module for the steps to work.

1. Open PowerShell with an elevated prompt.

2. Run the following cmdlets:

    ```powershell  
    Install-Module -Name Microsoft.AzureStack.ReadinessChecker -RequiredVersion 1.2100.1448.484
    New-Item -ItemType Directory "$ENV:USERPROFILE\Documents\AzsCertRequests"
                $certificateRequestParams = @{
                    'regionName' = 'azurestack'
                    'externalFQDN' = 'contoso.com'
                    'subject' = "C=US,ST=Washington,L=Redmond,O=Microsoft,OU=Azure Stack"
                    'OutputRequestPath' = "$ENV:USERPROFILE\Documents\AzsCertRequests" }
    New-AzsHubAzureContainerRegistryCertificateSigningRequest @certificateRequestParams
    ```

3. When the **ReadinessChecker** module creates the **.req** file, sub the file to your Certificate Authority (CA) 
(either internal or public). The output directory of **New-AzsCertificateSigningRequest** 
contains the CSR(s) necessary to submit to a CA. For your reference, the directory also 
contains a child directory containing the INF file(s) used during certificate request generation.

## Validate the ACR certificate

Validate the ACR certificate adheres to Azure Stack Hub requirements.

1. Copy resulting certificate file (.cer) signed by the CA (supported extensions .cer, .cert, .srt, .pfx) to `\$ENV:USERPROFILE\Documents\AzureStack`.

2. Run the following PowerShell cmdlets from an elevated prompt:

    ```powershell
    Install-Module -Name Microsoft.AzureStack.ReadinessChecker -RequiredVersion 1.2100.1448.484
    $Path = "\$ENV:USERPROFILE\Documents\AzureStack"
    $pfxPassword = Read-Host -AsSecureString -Prompt "PFX Password"
    ConvertTo-AzsPFX -Path \$Path -pfxPassword \$pfxPassword -ExportPath \$Path
    ```
## Installation steps

You can use these steps to install the ACR service in Azure Stack Hub.

### [Portal](#tab/portal)

You can use the Azure Stack Hub administrative portal to import the certificate and install the service.

1.  Sign into the Azure Stack Hub administrative portal.
2. Navigate to **All Services** > **Container Registries**.
    ![Get the Azure Stack Hub container registry.](media/container-registries-install/azure-stack-hub-get-container-registries.png)
3. Enter the full path to the certificate.
    ![Azure Stack Hub container registry is installed.](media/container-registries-install/azure-stack-hub-container-registries.png)
4. Select **Install**. Installation of the ACR service may take up to one hour

### [PowerShell](#tab/ps)

You can use the following PowerShell cmdlets to import the certificate and install the service.
1. Install ContainerRegistry Admin cmdlet:

```powershell  
Install-Package Azs.ContainerRegistry.Admin
```
2. Connect to Az Account:

```powershell  
$ArmEndpoint = "<AdminResourceManagerEndpoint>"
Add-AzEnvironment -ARMEndpoint $ArmEndpoint -Name "AzureStackAdmin"
Connect-AzAccount -EnvironmentName "AzureStackAdmin" -TenantId $tenantID -Credential $credential
```
3. Define parameters for Container Registry Setup:

```powershell  
$password = ConvertTo-SecureString "<certificate password>" -AsPlainText -Force
$pfx_cert_path = "<certificate pfx path>"
Start Container Registry Service Setup:
Start-AzsContainerRegistrySetup -Password $password -SslCertInputFile $pfx_cert_path | ConvertTo-Json
```
4. Check Container Registry Setup Progress:

```powershell  
(Get-AzsContainerRegistrySetupStatus).ToJsonString()
``` 
---

Once the installation is complete, you can review or update your capacity in quota in the Azure Stack Hub administrative portal.

## Next steps

[Azure Container Registries on Azure Stack Hub overview](container-registries-overview.md)
