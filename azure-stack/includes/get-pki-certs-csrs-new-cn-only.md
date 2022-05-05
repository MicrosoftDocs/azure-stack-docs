---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 04/29/2022
ms.reviewer: bryanla
ms.lastreviewed: 04/29/2022
---
   
1. Generate CSRs by completing one the following:

   - For a **production deployment environment**, the first script will generate CSRs for deployment certificates, the second will generate CSRs for any optional PaaS services you've installed:

      ```powershell  
      AzsCertificateSigningRequest -certificateType Deployment -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```

      ```powershell  
      # App Services
      AzsCertificateSigningRequest -CertificateType AppServices -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory

      # DBAdapter (SQL/MySQL)
      AzsCertificateSigningRequest -CertificateType DbAdapter -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory

      # EventHubs
      AzsCertificateSigningRequest -CertificateType EventHubs -RegionName $regionName -FQDN $externalFQDN -OutputRequestPath $OutputDirectory
      ```

   - For a **development and test environment**, to generate a single CSR with multiple-subject alternative names, add the `-RequestType SingleCSR` parameter and value. 

      > [!IMPORTANT]
      > We do *not* recommend using this approach for production environments.

      ```powershell  
      AzsCertificateSigningRequest -certificateType Deployment -RegionName $regionName -FQDN $externalFQDN -RequestType SingleCSR -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```
