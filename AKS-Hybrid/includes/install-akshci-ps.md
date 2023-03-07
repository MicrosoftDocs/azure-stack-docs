---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 01/19/2023
ms.reviewer: abha
ms.lastreviewed: 05/02/2022

---

Follow these steps on all nodes in your Azure Stack HCI cluster or Windows Server cluster:

> [!NOTE]
> If you are using remote PowerShell, you must use CredSSP.

1. Close all open PowerShell windows, open a new PowerShell session as administrator, and run the following command on all nodes in your Azure Stack HCI or Windows Server cluster:

   ```powershell  
   Install-PackageProvider -Name NuGet -Force 
   Install-Module -Name PowershellGet -Force -Confirm:$false -SkipPublisherCheck
   ```

   You must close all existing PowerShell windows again to ensure that loaded modules are refreshed. Do not continue to the next step until you have closed all open PowerShell windows.

1. Install the AKS-HCI PowerShell module by running the following command on all nodes in your Azure Stack HCI or Windows Server cluster:

   ```powershell
   Install-Module -Name AksHci -Repository PSGallery -Force -AcceptLicense
   ```

   You must close all existing PowerShell windows again to ensure that loaded modules are refreshed. Do not continue to the next step until you have closed all open PowerShell windows.

You can use a [helper script to delete old AKS-HCI PowerShell modules](https://github.com/Azure/aks-hci/issues/130), to avoid any PowerShell version-related issues in your AKS deployment.

### Validate your installation

```powershell
Get-Command -Module AksHci
```

To view the complete list of AksHci PowerShell commands, see [AksHci PowerShell](../reference/ps/index.md).
