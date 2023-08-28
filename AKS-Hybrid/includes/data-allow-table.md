---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 08/28/2022
ms.reviewer: abha
ms.lastreviewed: 08/15/2022

# Created from build at the repo: edge modules

---

|  URL | Port | Notes |
|  :---| :---| :---|
|  msk8s.api.cdp.microsoft.com | 443  | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running `Set-AksHciConfig` and any time you download from SFS. |
|  msk8s.b.tlu.dl.delivery.mp.microsoft.com </br> msk8s.f.tlu.dl.delivery.mp.microsoft.com | 80 | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running `Set-AksHciConfig` and any time you download from SFS. |
|  login.microsoftonline.com </br> login.windows.net </br> management.azure.com </br> msft.sts.microsoft.com </br> graph.windows.net | 443 | Used for logging into Azure when running `Set-AksHciRegistration`. |
|  ecpacr.azurecr.io </br> mcr.microsoft.com </br> \*.mcr.microsoft.com </br> \*.data.mcr.microsoft.com </br> \*.blob.core.windows.net </br> US endpoint: wus2replica\*.blob.core.windows.net | 443 | Required to pull container images when running `Install-AksHci`. |
|  \<region>.dp.kubernetesconfiguration.azure.com | 443  | Required to onboard AKS hybrid clusters to Azure Arc. |
| gbl.his.arc.azure.com | 443 | Required to get the regional endpoint for pulling system-assigned Managed Identity certificates. |
| \*.his.arc.azure.com | 443 | Required to pull system-assigned Managed Identity certificates. |
| k8connecthelm.azureedge.net	| 443 | Arc-enabled Kubernetes uses Helm 3 to deploy Azure Arc agents on the AKS-HCI management cluster. This endpoint is needed for the Helm client download to facilitate deployment of the agent helm chart.
| \*.arc.azure.net| 443 | Required to manage AKS hybrid clusters in Azure portal. |
| dl.k8s.io | 443 | Required to download and update Kubernetes binaries for Azure Arc. |
|  akshci.azurefd.net | 443 | Required for AKS on Azure Stack HCI billing when running `Install-AksHci`. |
|  v20.events.data.microsoft.com </br> gcs.prod.monitoring.core.windows.net | 443 | Used periodically to send Microsoft required diagnostic data from the Azure Stack HCI or Windows Server host. |
