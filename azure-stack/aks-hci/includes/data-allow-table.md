---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 12/9/2020
ms.reviewer: abha
ms.lastreviewed: 12/9/2020

---

| URL        | Port | Notes |
| ---------- | ---- | ---- |
| msk8s.api.cdp.microsoft.com | 443 | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running `Set-AksHciConfig` and at any time you download from SFS. |
| msk8s.b.tlu.dl.delivery.mp.microsoft.com | 80 | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running `Set-AksHciConfig` and at any time you download from SFS. |
| msk8s.f.tlu.dl.delivery.mp.microsoft.com | 80 | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running `Set-AksHciConfig` and at any time you download from SFS. |
| login.microsoftonline.com | 443 | Used for logging into Azure when running `Set-AksHciRegistration`. |
| login.windows.net  | 443 | Used for logging into Azure when running `Set-AksHciRegistration`. |
| management.azure.com | 443 | Used for logging into Azure when running `Set-AksHciRegistration`. |
| www.microsoft.com  | 443 | Used for logging into Azure when running `Set-AksHciRegistration`. |
| msft.sts.microsoft.com | 443 | Used for logging into Azure when running `Set-AksHciRegistration`. |
| graph.windows.net | 443 | Used for logging into Azure when running `Set-AksHciRegistration`. |
| ecpacr.azurecr.io | 443 | Required to pull container images when running `Install-AksHci`. |
| *.blob.core.windows.net <br> US endpoint: wus2replica&ast;.blob.core.windows.net | 443 | Required to pull container images when running `Install-AksHci`. |
| mcr.microsoft.com, *.mcr.microsoft.com | 443 | Required to pull container images when running `Install-AksHci`. |
| akshci.azurefd.net | 443 | Required for AKS on Azure Stack HCI billing when running `Install-AksHci`. |
| api.github.com | 443 | Required for installing AKS on Azure Stack HCI management cluster (AKS host). |
| objects.githubusercontent.com  | 443 |  Required for installing AKS on Azure Stack HCI management cluster (AKS host). |
| arck8onboarding.azurecr.io | 443 | Required to pull container images when running `Install-AksHci`. |
| v20.events.data.microsoft.com | 443 | Used periodically to send Microsoft required diagnostic data from the Azure Stack HCI or Windows Server host. |
| adhs.events.data.microsoft.com | 443 | Used periodically to send Microsoft required diagnostic data from control plane nodes. |