---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 11/2/2020
ms.reviewer: waltero
ms.lastreviewed: 11/2/2020

---

### Azure Kubernetes Service (AKS) or Azure Container Registry (ACR) resource providers fail in test-azurestack

- Applicable: This issue applies to 2102 and earlier
- Cause: When you run the `test-azurestack` update readiness command the test triggers the following two warnings:
     ```powershell  
    WARNING: Name resolution of containerservice.aks.azs failed
    WARNING: Name resolution of containerregistry.acr.azs failed
    ```
- Remediation: These warnings are to be expected since you don't have the Azure Kubernetes Service (AKS) or Azure Container Registry (ACR) resource provider installed.
- Occurrence: Common