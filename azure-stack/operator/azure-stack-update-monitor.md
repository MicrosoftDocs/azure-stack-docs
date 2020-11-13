---
title: Monitor updates with PowerShell in Azure Stack Hub
description: Learn how to monitor updates with PowerShell in Azure Stack Hub.
author: IngridAtMicrosoft
ms.topic: how-to
ms.date: 03/04/2020
ms.author: inhenkel
ms.lastreviewed: 08/23/2019
ms.reviewer: ppacent

# Intent: As an Azure Stack Hub operator, I want to monitor updates with PowerShell so I can monitor and manage all my updates.
# Keyword: monitor updates powershell azure stack hub

---

# Monitor updates with PowerShell in Azure Stack Hub

You can use the Azure Stack Hub administrative endpoints to monitor and manage your updates. They're accessible with PowerShell. For instructions on getting set up with PowerShell on Azure Stack Hub, see [Install PowerShell for Azure Stack Hub](powershell-install-az-module.md).

You can use the following PowerShell cmdlets to manage your updates:

| Cmdlet | Description |
|------------------------------------------------------|-------------|
| [Get-AzsUpdate](/powershell/module/azs.update.admin/get-azsupdate?view=azurestackps-1.8.0) | Get the list of available updates. |
| [Get-AzsUpdateLocation](/powershell/module/azs.update.admin/get-azsupdatelocation?view=azurestackps-1.8.0)| Get the list of update locations. |
| [Get-AzsUpdateRun](/powershell/module/azs.update.admin/get-azsupdaterun?view=azurestackps-1.8.0) | Get the list of update runs.  |
| [Install-AzsUpdate](/powershell/module/azs.update.admin/install-azsupdate?view=azurestackps-1.8.0) | Apply a specific update at an update location. |
| [Resume-AzsUpdateRun](/powershell/module/azs.update.admin/resume-azsupdaterun?view=azurestackps-1.8.0) | Resumes a previously started update run that failed. |

## Get a list of update runs

To get the list of update runs, run the following command:

```powershell
Get-AzsUpdateRun -UpdateName Microsoft1.0.180302.1
```

## Resume a failed update operation

If the update fails, you can resume the update run where it left off by running the following command:

```powershell
Get-AzsUpdateRun -Name 5173e9f4-3040-494f-b7a7-738a6331d55c -UpdateName Microsoft1.0.180305.1 | Resume-AzsUpdateRun
```

## Troubleshoot

For more information on troubleshooting updates, see [Azure Stack Troubleshooting](azure-stack-troubleshooting.md).

## Next steps

- [Managing updates in Azure Stack Hub](./azure-stack-updates.md)
