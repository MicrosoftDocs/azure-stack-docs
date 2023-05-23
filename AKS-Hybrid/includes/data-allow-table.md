---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 08/15/2022
ms.reviewer: abha
ms.lastreviewed: 08/15/2022

# Created from build at the repo: edge modules

---

|  URL | Port | Notes |
|  :---| :---| :---|
|  msk8s.api.cdp.microsoft.com | 443  | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS.Occurs when running `Set-AksHciConfig` and at any time you download from SFS. |
|  msk8s.b.tlu.dl.delivery.mp.microsoft.com <break> msk8s.f.tlu.dl.delivery.mp.microsoft.com | 80 | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running `Set-AksHciConfig` and at any time you download from SFS. |
|  login.microsoftonline.com <break> login.windows.net <break> management.azure.com <break> msft.sts.microsoft.com <break> graph.windows.net | 443 | Used for logging into Azure when running `Set-AksHciRegistration`. |
|  ecpacr.azurecr.io <break> mcr.microsoft.com <break> \*.mcr.microsoft.com <break> \*.data.mcr.microsoft.com <break> \*.blob.core.windows.net <break> US endpoint: wus2replica\*.blob.core.windows.net | 443 | Required to pull container images when running `Install-AksHci`. |
|  \<region>.dp.kubernetesconfiguration.azure.com | 443  | Required to onboard AKS hybrid clusters to Azure Arc |
| gbl.his.arc.azure.com |  Required to get the regional endpoint for pulling system-assigned Managed Identity certificates. |
| \*.his.arc.azure.com |  Required to pull system-assigned Managed Identity certificates. |
| \*.arc.azure.net| Required to manage AKS hybrid clusters in Azure portal. |
|  akshci.azurefd.net | 443 | Required for AKS on Azure Stack HCI billing when running `Install-AksHci`. |
|  v20.events.data.microsoft.com <break> gcs.prod.monitoring.core.windows.net | 443 | Used periodically to send Microsoft required diagnostic data from the Azure Stack HCI or Windows Server host. |
