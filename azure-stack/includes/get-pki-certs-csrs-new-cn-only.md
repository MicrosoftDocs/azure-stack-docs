---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 04/29/2022
ms.reviewer: bryanla
ms.lastreviewed: 04/29/2022
---
2. Generate CSRs by completing one the following:

   - For a **production deployment environment**, the first script will generate CSRs for deployment certificates, the second will generate CSRs for any optional PaaS services you've installed:

      ```powershell  
      New-AzsHubCertificateSigningRequest -certificateType Deployment -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```

      ```powershell  
      # App Services
      New-AzsHubCertificateSigningRequest -CertificateType AppServices -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

      # DBAdapter (SQL/MySQL)
      New-AzsHubCertificateSigningRequest -CertificateType DbAdapter -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

      # EventHubs
      New-AzsHubCertificateSigningRequest -CertificateType EventHubs -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory
      ```

   - For a **development and test environment**, to generate a single CSR with multiple-subject alternative names, add the `-RequestType SingleCSR` parameter and value. 

      > [!IMPORTANT]
      > We do *not* recommend using this approach for production environments.

      ```powershell  
      New-AzsHubCertificateSigningRequest -certificateType Deployment -RegionName $regionName -FQDN $externalFQDN -RequestType SingleCSR -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```
