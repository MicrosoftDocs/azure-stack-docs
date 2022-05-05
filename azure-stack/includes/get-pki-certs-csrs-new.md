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
      New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```

      ```powershell  
      # App Services
      New-AzsHubAppServicesCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

      # DBAdapter (SQL/MySQL)
      New-AzsHubDbAdapterCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

      # EventHubs
      New-AzsHubEventHubsCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory
      ```

   - For a **low-privilege environment**, to generate a clear-text certificate template file with the necessary attributes declared, add the `-LowPrivilege` parameter:

      ```powershell  
      New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem -LowPrivilege
      ```

   - For a **development and test environment**, to generate a single CSR with multiple-subject alternative names, add the `-RequestType SingleCSR` parameter and value. 

      > [!IMPORTANT]
      > We do *not* recommend using this approach for production environments.

      ```powershell  
      New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -RequestType SingleCSR -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```