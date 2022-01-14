---
title: Enable-AksHciPreview
author: mattbriggs
description: The Enable-AksHciPreview PowerShell command enables the ability to update AKS on Azure Stack HCI to a preview channel.
ms.topic: reference
ms.date: 09/08/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: mamezgeb
---

# Enable-AksHciPreview

## Synopsis
Updates AKS on Azure Stack HCI to a preview channel.

## Description
This cmdlet updates AKS on Azure Stack HCI to a preview channel. After running `Enable-AksHciPreview`, you need to run [Get-AksHciUpdates](get-akshciupdates.md) to list the available updates, and then run [Update-AksHci](update-akshci.md) to update to the preview channel. 

> [!NOTE]
> The preview channel is intended to be used only for development and testing purposes.

## Syntax

```powershell
Enable-AksHciPreview
```

## Example

```powershell
Enable-AksHciPreview
Get-AksHciUpdates
Update-AksHci
```

## Next steps

[AksHci PowerShell Reference](index.md)
