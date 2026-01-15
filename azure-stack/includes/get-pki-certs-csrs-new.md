---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 08/12/2025
ms.reviewer: sethm
ms.lastreviewed: 08/12/2025
---

2. Generate CSRs by completing one of the following:

   - For a production deployment environment, the first script generates CSRs for deployment certificates:

     ```powershell  
     New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
     ```

   - The second script, if desired, uses the `-IncludeContainerRegistry` and generates a CSR for Azure Container Registry at the same time as CSRs for deployment certificates:

     ```powershell
     New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem -IncludeContainerRegistry
     ```

   - The third script generates CSRs for any optional PaaS services you installed:

     ```powershell  
     # App Services
     New-AzsHubAppServicesCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

     # DBAdapter (SQL/MySQL)
     New-AzsHubDbAdapterCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory

     # EventHubs
     New-AzsHubEventHubsCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory
      
     # Azure Container Registry
     New-AzsHubAzureContainerRegistryCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory 
     ```

   - For a low-privilege environment, to generate a clear-text certificate template file with the necessary attributes declared, add the `-LowPrivilege` parameter:

     ```powershell  
     New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem -LowPrivilege
     ```

   - For a development and test environment, to generate a single CSR with multiple-subject alternative names, add the `-RequestType SingleCSR` parameter and value:

     > [!IMPORTANT]
     > This approach is not recommended for production environments.

     ```powershell  
     New-AzsHubDeploymentCertificateSigningRequest -RegionName $regionName -FQDN $externalFQDN -RequestType SingleCSR -subject $subject -OutputRequestPath $OutputDirectory -IdentitySystem $IdentitySystem
     ```
