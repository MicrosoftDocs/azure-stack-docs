---
title: disable-akshcipreview
author: mamezgeb
description: The Disable-AksHciPreview PowerShell command enables the ability to revert from a preview channel back to the stable channel.
ms.topic: reference
ms.date: 09/08/2021
ms.author: mamezgeb
---

# Disable-AksHciPreview

## Synopsis
Reverts AKS on Azure Stack HCI from a preview channel back to the stable channel.

## Description
This cmdlet reverts AKS on Azure Stack HCI from a preview channel back to the stable channel. After running `Disable-AksHciPreview`, you need to run [Get-AksHciUpdates](get-akshciupdates.md) to list the available updates, and then run [Update-AksHci](update-akshci.md) to revert back to the stable channel. 

> [!NOTE]
> The preview channel is intended to be used only for development and testing purposes.

## Syntax

```powershell
Disable-AksHciPreview
```

## Example

```powershell
Disable-AksHciPreview
Get-AksHciUpdates
Update-AksHci
```

## Next steps

[AksHci PowerShell Reference](index.md)
