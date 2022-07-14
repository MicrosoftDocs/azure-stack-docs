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
| http\://\*.windowsupdate.microsoft.com<br>https\://\*.windowsupdate.microsoft.com<br>http\://\*.update.microsoft.com<br>https\://\*.update.microsoft.com<br>http\://\*.windowsupdate.com<br>http\://download.windowsupdate.com<br>https\://download.microsoft.com<br>http\://*.download.windowsupdate.com<br>http\://wustat.windows.com<br>http\://ntservicepack.microsoft.com<br>http\://go.microsoft.com<br>http\://dl.delivery.mp.microsoft.com<br>https\://dl.delivery.mp.microsoft.com | 443 | For Microsoft Update, which allows the OS to receive updates. |
| *.blob.core.windows.net OR [myblobstorage].blob.core.windows.net | 443 | For Cluster Cloud Witness. To use a cloud witness as the cluster witness. |
| *.powershellgallery.com OR install module at https\://www.powershellgallery.com/packages/Az.StackHCI | 443 | To obtain the Az.StackHCI PowerShell module, which is required for cluster registration. |