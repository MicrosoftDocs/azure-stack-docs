---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 10/26/2022
ms.reviewer: sethm
ms.lastreviewed: 10/26/2022
---

1. Generate CSRs by completing one of the following:

   - For a **production deployment environment**, the first script will generate CSRs for deployment certificates:

      ```powershell
      New-AzsCertificateSigningRequest -CertificateType Deployment -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```

   - The second script, if desired, uses the `-IncludeContainerRegistry` and will generate a CSR for Azure Container Registry at the same time as CSRs for deployment certificates:

      ```powershell
      New-AzsCertificateSigningRequest -CertificateType Deployment -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory -IncludeContainerRegistry
      ```

   - The third script will generate CSRs for any optional PaaS services you've installed:

      ```powershell
      # App Services
      New-AzsCertificateSigningRequest -CertificateType AppServices -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory

      # DBAdapter (SQL/MySQL)
      New-AzsCertificateSigningRequest -CertificateType DbAdapter -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory

      # EventHubs
      New-AzsCertificateSigningRequest -CertificateType EventHubs -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory

      # Azure Container Registry
      New-AzsHubAzureContainerRegistryCertificateSigningRequest -CertificateType AzureContainerRegistry -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory 
      ```

   - For a **development and test environment**, to generate a single CSR with multiple-subject alternative names, add the `-RequestType SingleCSR` parameter and value.

      > [!IMPORTANT]
      > We do *not* recommend using this approach for production environments.

      ```powershell
      New-AzsCertificateSigningRequest -CertificateType Deployment -RegionName $regionName -FQDN $externalFQDN -RequestType SingleCSR -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```
