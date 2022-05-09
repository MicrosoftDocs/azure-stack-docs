---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.topic: include
ms.date: 04/27/2022
ms.lastreviewed: 04/19/2022

---

|  URL | Port | Notes |
|  :---| :---| :---|
| https\://login.microsoftonline.com  (Azure Public)<br>https\://login.chinacloudapi.cn/ (Azure China)<br>https\://login.microsoftonline.us (Azure Gov)  | 443  | For Active Directory Authority and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory. |
|   https\://graph.windows.net/ (Azure Public, Azure Gov)<br>https\://graph.chinacloudapi.cn/  (Azure China)  | 443 | For Graph and used for authentication, token fetch, and validation. Service Tag:  AzureActiveDirectory. |
|   https\://management.azure.com/  (Azure Public)<br>https\://management.chinacloudapi.cn/ (Azure China)<br>https\://management.usgovcloudapi.net/ (Azure Gov) | 443 | For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Service Tag: AzureResourceManager. |
|   https\://azurestackhci.azurefd.net (Azure Public)<br>https\://dp.stackhci.azure.cn (Azure China)<br>https\://dp.azurestackchi.azure.us (Azure Gov) | 443 | For Dataplane that pushes up diagnostics data and used in the Portal pipeline and pushes billing data. |
