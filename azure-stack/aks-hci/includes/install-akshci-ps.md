---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 05/02/2022
ms.reviewer: abha
ms.lastreviewed: 05/02/2022

---

### On all nodes in your Azure Stack HCI cluster or Windows Server cluster

**If you are using remote PowerShell, you must use CredSSP.** 

Close all open PowerShell windows, open a fresh PowerShell session as administrator, and run the following command on all nodes in your Azure Stack HCI or Windows Server cluster:

```powershell  
Install-PackageProvider -Name NuGet -Force 
Install-Module -Name PowershellGet -Force -Confirm:$false -SkipPublisherCheck
Exit
```

**You must close all existing PowerShell windows** again to ensure that loaded modules are refreshed. Please do not continue to the next step until you have closed all open PowerShell windows.

Install the AKS-HCI PowerShell module by running the following command on all nodes in your Azure Stack HCI or Windows Server cluster.

```powershell
Install-Module -Name AksHci -Repository PSGallery
Exit
```
**You must close all existing PowerShell windows** again to ensure that loaded modules are refreshed. Please do not continue to the next step until you have closed all open PowerShell windows.

You can use a [helper script to delete old AKS-HCI PowerShell modules](https://github.com/Azure/aks-hci/issues/130), to avoid any PowerShell version related issues in your AKS deployment.

### Validate your installation

```powershell
Get-Command -Module AksHci
```
To view the complete list of AksHci PowerShell commands, see [AksHci PowerShell](../reference/ps/index.md).
