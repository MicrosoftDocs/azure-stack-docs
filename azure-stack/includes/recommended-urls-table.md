---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.topic: include
ms.date: 04/27/2022
ms.lastreviewed: 04/19/2022

---

|   Service |  URL | Port | Notes |
|   :---|  :---| :---| :---|
| Microsoft Update | windowsupdate.microsoft.com   | 80   | For Microsoft Update, which allows the OS to receive updates. |
| Microsoft Update | download.windowsupdate.com    | 80   | For Microsoft Update, which allows the OS to receive updates. |
| Microsoft Update | download.microsoft.com   | 443  | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | wustat.windows.com    | 80   | For Microsoft Update, which allows the OS to receive updates. |
| Microsoft Update | ntservicepack.microsoft.com    | 80   | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | go.microsoft.com   | 80   | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | dl.delivery.mp.microsoft.com    | 443  | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | *.windowsupdate.microsoft.com   | 80   | For Microsoft Update, which allows the OS to receive updates. |
| Microsoft Update | *.windowsupdate.microsoft.com   | 80   | For Microsoft Update, which allows the OS to receive updates.   |
| Microsoft Update | *.update.microsoft.com    | 443  | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | *.update.microsoft.com   | 80   | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | *.windowsupdate.com   | 80   | For Microsoft Update, which allows the OS to receive updates.|
| Microsoft Update | *.download.windowsupdate.com    | 80   | For Microsoft Update, which allows the OS to receive updates.|
| Cluster Cloud Witness  | *.blob.core.windows.net   | 443  | For firewall access to the Azure blob container, if choosing to use a cloud witness as the cluster witness   |
| Azure Stack HCI  | *.powershellgallery.com   | 443  | To obtain the Az.StackHCI PowerShell module, which is required for cluster registration. |
| Azure Kubernetes Service | msk8s.api.cdp.microsoft.com    | 443  | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running Set-AksHciConfig and at any time you download from SFS. |
| Azure Kubernetes Service | msk8s.b.tlu.dl.delivery.mp.microsoft.com  | 80   | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running Set-AksHciConfig and at any time you download from SFS. |
| Azure Kubernetes Service | msk8s.f.tlu.dl.delivery.mp.microsoft.com  | 80   | Used when downloading the AKS on Azure Stack HCI product catalog, product bits, and OS images from SFS. Occurs when running Set-AksHciConfig and at any time you download from SFS. |
| Azure Kubernetes Service | login.microsoftonline.com  | 443  | Used for logging into Azure when running Set-AksHciRegistration. |
| Azure Kubernetes Service | login.windows.net   | 443  | Used for logging into Azure when running Set-AksHciRegistration. |
| Azure Kubernetes Service | management.azure.com | 443  | Used for logging into Azure when running Set-AksHciRegistration. |
| Azure Kubernetes Service | www\.microsoft.com   | 443  | Used for logging into Azure when running Set-AksHciRegistration.   |
| Azure Kubernetes Service | msft.sts.microsoft.com  | 443  | Used for logging into Azure when running Set-AksHciRegistration. |
| Azure Kubernetes Service | graph.windows.net    | 443  | Used for logging into Azure when running Set-AksHciRegistration.  |
| Azure Kubernetes Service | ecpacr.azurecr.io   | 443  | Required to pull container images when running Install-AksHci.   |
| Azure Kubernetes Service | mcr.microsoft.com   | 443  | Required to pull container images when running Install-AksHci.  |
| Azure Kubernetes Service | akshci.azurefd.net   | 443  | Required for AKS on Azure Stack HCI billing when running Install-AksHci. |
| Azure Kubernetes Service | v20.events.data.microsoft.com   | 443  | Used periodically to send Microsoft required diagnostic data from the Azure Stack HCI or Windows Server host. |
| Azure Kubernetes Service | adhs.events.data.microsoft.com  | 443  | Used periodically to send Microsoft required diagnostic data from control plane nodes. |
| Azure Kubernetes Service | *.blob.core.windows.net    | 443  | Required to pull container images when running Install-AksHci.   |
| Azure Kubernetes Service | wus2replica*.blob.core.windows.net  | 80   | Required to pull container images when running Install-AksHci.|
| Azure Kubernetes Service | *.mcr.microsoft.com | 80 | Required to pull container images when running Install-AksHci. |
| Remote Support | login.microsoftonline.com  | 443  | For Azure Active Directory  |
| Remote Support | edgesupprdwestuufrontend.westus2.cloudapp.azure.com  | 443  | Remote Support westus2 |
| Remote Support | edgesupprdwesteufrontend.westeurope.cloudapp.azure.com | 443  | Remote Support westeurope  |
| Remote Support | edgesupprdeastusfrontend.eastus.cloudapp.azure.com  | 443  | Remote Support eastus |
| Remote Support | edgesupprdwestcufrontend.westcentralus.cloudapp.azure.com | 443  | Remote Support westcentralus |
| Remote Support | edgesupprdasiasefrontend.southeastasia.cloudapp.azure.com | 443  | Remote Support southeastasia |
| Remote Support | edgesupprd.trafficmanager.net  | 443  | Remote Support traffic manager  |
| Remote Support | *.servicebus.windows.net   | 443  | Remote Support |
| Remote Support | *.core.windows.net | 443  | Remote Support |