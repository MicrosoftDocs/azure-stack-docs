---
title: Enable-AksHciOfflineDownload for AKS hybrid
description: The Enable-AksHciOfflineDownload PowerShell command enables offline downloading to get the AKS hybrid images.
ms.topic: reference
ms.date: 01/25/2023
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 01/25/2023
ms.reviewer: jeguan
---

# Enable-AksHciOfflineDownload

## Synopsis

Enables offline downloading to get the AKS hybrid images.

## Syntax

```powershell
Enable-AksHciOfflineDownload  -stagingShare -offsiteTransferCompleted
```

## Description

Enables offline downloading to get the AKS hybrid images.

## Examples

```PowerShell
Enable-AksHciOfflineDownload -stagingShare -offsiteTransferCompleted
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

### -offsiteTransferCompleted

Sets deployment to use artifacts downloaded offsite and transferred to the deployment server.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksHci PowerShell Reference](index.md)
