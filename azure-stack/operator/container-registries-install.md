---
title: Install Azure Container Registry on Azure Stack Hub 
description: Learn how to install Azure Container Registry on Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 07/27/2024
ms.author: sethm

---

# Install Azure Container Registry on Azure Stack Hub

You can install Azure Container Registry on Azure Stack Hub and make it available to your users so that they can host containers in your environment. To install Azure Container Registry, you must generate and validate a certificate, then install Azure Container Registry. You can install through the Azure Stack Hub administrator portal.

> [!IMPORTANT]
> Once installed, Azure Container Registry on Azure Stack Hub is considered a foundational RP and cannot be uninstalled. Operators can still restrict user access to the Container Registry service through offers, plans, and quotas.

## Prerequisites

* **Azure Stack Hub version**  
    You can only enable the Microsoft Azure Container in an Azure Stack Hub integrated system running the 2108 update and later releases. Install the Azure Stack Hub update before you complete the steps in this article. The Azure Container Registry service is not supported on the Azure Stack Developer Kit (ASDK) deployments.
* **Certificate requirements**  
    The configuration of Azure Container Registry on your Azure Stack Hub system adds a new data path that requires a certificate. The certificate must meet the same requirements as the other certificates required to install and operate Azure Stack Hub.

    The URI for this new certificate should have the following format:

    `*.azsacr.<region>.<fqdn>`

    For example:

    `*.azsacr.azurestack.contoso.com`

* **Azure Stack Hub state**  
    You should only install Azure Container Registry after validating that your Azure Stack Hub is healthy. You can do so by following the steps listed in [Validate Azure Stack Hub system state](azure-stack-diagnostic-test.md).

## Generate your certificate

You can use the following steps to generate an Azure Container Registry certificate using the Azure Stack Hub Readiness Checker tool. You must specify the version of the **Microsoft.AzureStack.ReadinessChecker** module for the steps to work.

1. Open PowerShell with an elevated prompt.

1. Run the following cmdlets:

   ```powershell  
   Install-Module -Name Microsoft.AzureStack.ReadinessChecker 
   New-Item -ItemType Directory "$ENV:USERPROFILE\Documents\AzsCertRequests"
       $certificateRequestParams = @{
           'regionName' = 'azurestack'
           'externalFQDN' = 'contoso.com'
           'subject' = "C=US,ST=Washington,L=Redmond,O=Microsoft,OU=Azure Stack"
           'OutputRequestPath' = "$ENV:USERPROFILE\Documents\AzsCertRequests" }
   New-AzsHubAzureContainerRegistryCertificateSigningRequest @certificateRequestParams
   ```

1. When the **ReadinessChecker** module creates the **.req** file, sub the file to your Certificate Authority (CA) (either internal or public). The output directory of **New-AzsCertificateSigningRequest** contains the CSRs necessary to submit to a CA. For your reference, the directory also contains a child directory containing the INF files used during certificate request generation.

## Validate the Azure Container Registry certificate

Validate that the Azure Container Registry certificate adheres to Azure Stack Hub requirements.

1. Copy resulting certificate file (.cer) signed by the CA (supported extensions .cer, .cert, .srt, .pfx) to `$ENV:USERPROFILE\Documents\AzureStack`.
1. Run the following PowerShell cmdlets from an elevated prompt:

   ```powershell
   Install-Module -Name Microsoft.AzureStack.ReadinessChecker 
   $Path = "$ENV:USERPROFILE\Documents\AzureStack"
   $pfxPassword = Read-Host -AsSecureString -Prompt "PFX Password"
   ConvertTo-AzsPFX -Path $Path -pfxPassword $pfxPassword -ExportPath $Path
   ```

## Installation steps

You can use these steps to install the Azure Container Registry service on Azure Stack Hub.

### Portal

You can use the Azure Stack Hub administrator portal to import the certificate and install the service.

1. Sign into the Azure Stack Hub administrator portal.
1. Navigate to **All Services** > **Container Registries**.
    ![Get the Azure Stack Hub container registry.](media/container-registries-install/azure-stack-hub-container-registries-install.png)
1. Enter the full path to the SSL certificate.
1. Enter the password for the certificate.
1. Select **Deploy**.  
    Installation of the Azure Container Registry service can take up to one hour.

    ![Azure Stack Hub container registry is installed.](media/container-registries-install/azure-stack-hub-container-registries.png)

1. Once the install completes in the Azure Stack Hub administrator portal, close and reopen the **Container Registries** blade.

Once the installation is complete, you can review or update your quota capacity in the Azure Stack Hub administrator portal.

## Next steps

[Azure Container Registries on Azure Stack Hub overview](container-registries-overview.md)
