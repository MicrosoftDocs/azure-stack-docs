---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 04/27/2022
ms.reviewer: waltero
ms.lastreviewed: 04/27/2022

---

## Expired certificates for the front-proxy

- **Applicable**: This issue applies to all releases.
- **Cause**: When your certificate expires, your cluster will fail.
- **Remediation**: You'll need to renew your certificate. You can find the steps at [Rotate Kubernetes certificates on Azure Stack Hub](../user/kubernetes-aks-engine-rotate-certs.md)
- **Occurrence**: Common

This is by-design and will affect 