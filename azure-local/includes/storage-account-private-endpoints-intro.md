---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 09/29/2026
---

Azure Local two-node deployments use a storage account for the cloud witness, and Azure Site Recovery uses a storage account for its cache. You can use private endpoints for these storage accounts. Keep public access to the cloud witness storage account until the initial Azure Local deployment is complete so that the Azure portal and Azure Local resource provider can configure the witness. After deployment, you can restrict the account to private networks.
