---
title: Enable-AksHciOfflineDownload for AKS hybrid
description: The Enable-AksHciOfflineDownload PowerShell command enables offline downloading to get the AKS hybrid images.
ms.topic: reference
ms.date: 10/03/2022
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 10/03/2022
ms.reviewer: jeguan
---

# Enable-AksHciOfflineDownload

## Synopsis

Enables offline downloading to get the AKS hybrid images.

## Syntax

```powershell
Enable-AksHciOfflineDownload  -stagingShare
```

## Description

Enables offline downloading to get the AKS hybrid images.

## Examples

```PowerShell
Enable-AksHciOfflineDownload -stagingShare
```

## Parameters

### -stagingShare

The path to where you want the images to be downloaded.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksHci PowerShell Reference](index.md)
