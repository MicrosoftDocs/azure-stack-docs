---
title: Monitor updates in Azure Stack Hub using Powershell | Microsoft Docs
description: Learn to monitor updates in Azure Stack Hub using Powershell
author: mattbriggs

ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.lastreviewed: 08/23/2019
ms.reviewer: ppacent 

---

# Monitor updates in Azure Stack Hub using Powershell

You can use the Azure Stack Hub administrative endpoints to monitor and manage your updates. They're accessible with PowerShell. For instructions on getting set up with PowerShell on Azure Stack Hub, see [Install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).

You can use the following PowerShell cmdlet to manage your updates:

| Cmdlet | Description |
|------------------------------------------------------|-------------|
| [Get-AzsUpdate](https://docs.microsoft.com/powershell/module/azs.update.admin/Get-AzsUpdate?view=azurestackps-1.8.0) | Get the list of available updates. |
| [Get-AzsUpdateLocation](https://docs.microsoft.com/powershell/module/azs.update.admin/Get-AzsUpdateLocation?view=azurestackps-1.8.0)| Get the list of update locations. |
| [Get-AzsUpdateRun](https://docs.microsoft.com/powershell/module/azs.update.admin/Get-AzsUpdateRun?view=azurestackps-1.8.0) | Get the list of update runs.  |
| [Install-AzsUpdate](https://docs.microsoft.com/powershell/module/azs.update.admin/Install-AzsUpdate?view=azurestackps-1.8.0) | Apply a specific update at an update location. |
| [Resume-AzsUpdateRun](https://docs.microsoft.com/powershell/module/azs.update.admin/Resume-AzsUpdateRun?view=azurestackps-1.8.0) | Resumes a previously started update run that failed. |

## Get a list of update runs

To get the list of update runs command:

```powershell
Get-AzsUpdateRun -UpdateName Microsoft1.0.180302.1
```

## Resume a failed update operation

If the update fails, you can resume the update run where it left off by running the following command:

```powershell
Get-AzsUpdateRun -Name 5173e9f4-3040-494f-b7a7-738a6331d55c -UpdateName Microsoft1.0.180305.1 | Resume-AzsUpdateRun
```

## Next steps

-   [Managing updates in Azure Stack Hub](https://docs.microsoft.com/azure-stack/operator/azure-stack-updates)
