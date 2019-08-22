---
title: Monitor updates in Azure Stack using Powershell | Microsoft Docs
description: Learn to monitor updates in Azure Stack using Powershell
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/15/2019
ms.author: mabrigg
ms.lastreviewed: 08/15/2019
ms.reviewer: ppacent 

---

# Monitor updates in Azure Stack using Powershell

*Applies to: Azure Stack integrated systems*

You can use the Azure Stack administrative endpoints through a set of update PowerShell cmdlets to monitor and manage your updates. For instructions on getting set up with PowerShell on Azure Stack, see "Install PowerShell for Azure Stack".

You can use the following PowerShell cmdlets to manage your updates:

| Cmdlet | Description |
|------------------------------------------------------|-------------|
| Get-AzsUpdate | Get the list of available updates. |
| Get-AzsUpdateLocation | Get the list of update locations. |
| Get-AzsUpdateRun | Get the list of update runs.  |
| Install-AzsUpdate | Apply a specific update at an update location. |
| Resume-AzsUpdateRun | Resumes a previously started update run that failed. |

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

-   [Managing updates in Azure Stack](https://docs.microsoft.com/azure-stack/operator/azure-stack-updates)