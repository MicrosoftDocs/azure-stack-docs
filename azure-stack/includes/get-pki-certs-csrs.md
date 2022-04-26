---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 04/26/2022
ms.reviewer: bryanla
ms.lastreviewed: 04/26/2022
---

1. Generate CSRs for your **production deployment environment**:

   - Generate CSRs for deployment certificates:

      ```powershell  
      New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
      ```

   - Optionally, generate CSRs for any PaaS services you've installed:

      ```powershell  
      # App Services
      New-AzsHubAppServicesCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

      # DBAdapter (SQL/MySQL)
      New-AzsHubDbAdapterCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

      # EventHubs
      New-AzsHubEventHubsCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory
      ```

1. Alternatively, for **low-privilege environments**, to generate a clear-text certificate template file with the necessary attributes declared, add the `-LowPrivilege` parameter:

    ```powershell  
    New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem -LowPrivilege
    ```

1. Alternatively, for **development and test environments**, to generate a single CSR with multiple-subject alternative names, add the `-RequestType SingleCSR` parameter and value. 

    > [!IMPORTANT]
    > We do *not* recommend using this approach for production environments.

    ```powershell  
    New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -RequestType SingleCSR -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
    ```