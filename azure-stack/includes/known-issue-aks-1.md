---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 12/8/2021
ms.reviewer: waltero
ms.lastreviewed: 12/8/2021
---

### Applications deployed to AKS clusters fail to access persistent volumes

- Applicable: This issue applies to release 2108.
- Cause: When you deploy an AKS cluster using:
    - Kubernetes 1.19, or  
    - Kubernetes 1.20 with Kubenet as the network plug-in  
    And and deploy an application that uses persistent volumes, you will note an issue with the application's pod when it tries to deploy a persistent volume. If you look into the pod's log, you may find an error regarding permissions denied. The problem resides in Azure Stack Hub's Azure Disk CSI driver. 
- Remediation: When deploying an AKS cluster, you should select only Kubernetes version 1.20 and Azure CNI for the Network plugin.
- Occurrence: Common