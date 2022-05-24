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
| https\://login.microsoftonline.com (Azure Public)<br>https\://login.chinacloudapi.cn/ (Azure China)<br>https\://login.microsoftonline.us (Azure Gov)  | 443  | For Active Directory Authority and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory. |
| https\://graph.windows.net/ (Azure Public, Azure Gov)<br>https\://graph.chinacloudapi.cn/ (Azure China) | 443 | For Graph, and used for authentication, token fetch, and validation. Service Tag:  AzureActiveDirectory. |
|  https\://management.azure.com/  (Azure Public)<br>https\://management.chinacloudapi.cn/ (Azure China)<br>https\://management.usgovcloudapi.net/ (Azure Gov) | 443 | For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Service Tag: AzureResourceManager. |
| https\://dp.stackhci.azure.com (Azure Public)<br>https\://dp.stackhci.azure.cn (Azure China)<br>https\://dp.azurestackchi.azure.us (Azure Gov) | 443 | For Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data. |
| http\://\*.windowsupdate.microsoft.com<br>https\://\*.windowsupdate.microsoft.com<br>http\://\*.update.microsoft.com<br>https\://\*.update.microsoft.com<br>http\://\*.windowsupdate.com<br>http\://download.windowsupdate.com<br>https\://download.microsoft.com<br>http\://*.download.windowsupdate.com<br>http\://wustat.windows.com<br>http\://ntservicepack.microsoft.com<br>http\://go.microsoft.com<br>http\://dl.delivery.mp.microsoft.com<br>https\://dl.delivery.mp.microsoft.com | 443 | For Microsoft Update, which allows the OS to receive updates. |
| *.blob.core.windows.net OR [myblobstorage].blob.core.windows.net | 443 | For Cluster Cloud Witness. To use a cloud witness as the cluster witness. |
| \*.servicebus.windows.net<br>\*.core.windows.net<br>login.microsoftonline.com<br>https\://edgesupprdwestuufrontend.westus2.cloudapp.azure.com<br>https\://edgesupprdwesteufrontend.westeurope.cloudapp.azure.com<br>https\://edgesupprdeastusfrontend.eastus.cloudapp.azure.com<br>https\://edgesupprdwestcufrontend.westcentralus.cloudapp.azure.com<br>https\://edgesupprdasiasefrontend.southeastasia.cloudapp.azure.com<br>https\://edgesupprd.trafficmanager.net | 443 | For Remote Support. To allow remote access to Microsoft support for troubleshooting. |
| *.powershellgallery.com OR install module at https\://www.powershellgallery.com/packages/Az.StackHCI | 443 | To obtain the Az.StackHCI PowerShell module, which is required for cluster registration. |