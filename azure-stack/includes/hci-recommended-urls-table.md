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
| Azure Stack HCI  | *.powershellgallery.com   | 443  | To obtain the Az.StackHCI PowerShell module, which is required for cluster registration. Alternatively, you can download and install the Az.StackHCI PowerShell module manually from [PowerShell Gallery](https://www.powershellgallery.com/packages/Az.StackHCI/1.1.1). |
| Cluster Cloud Witness  | *.blob.core.windows.net   | 443  | For firewall access to the Azure blob container, if choosing to use a cloud witness as the cluster witness, which is optional. |
| Microsoft Update | windowsupdate.microsoft.com   | 80   | For Microsoft Update, which allows the OS to receive updates. |
| Microsoft Update | download.windowsupdate.com    | 80   | For Microsoft Update, which allows the OS to receive updates. |
| Microsoft Update | download.microsoft.com   | 443  | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | wustat.windows.com    | 80   | For Microsoft Update, which allows the OS to receive updates. |
| Microsoft Update | ntservicepack.microsoft.com    | 80   | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | go.microsoft.com   | 80   | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | *.delivery.mp.microsoft.com    | 443  | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | *.windowsupdate.microsoft.com   | 80, 443   | For Microsoft Update, which allows the OS to receive updates. |
| Microsoft Update | *.update.microsoft.com   | 80, 443   | For Microsoft Update, which allows the OS to receive updates.  |
| Microsoft Update | *.windowsupdate.com | 80 | For Microsoft Update, which allows the OS to receive updates.|
| Microsoft Update | *.download.windowsupdate.com    | 80   | For Microsoft Update, which allows the OS to receive updates.|
