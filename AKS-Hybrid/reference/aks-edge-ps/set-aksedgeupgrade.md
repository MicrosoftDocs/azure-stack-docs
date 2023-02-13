---
title: Set-AksEdgeUpgrade for AKS Edge
author: rcheeran
description: The Set-AksEdgeUpgrade PowerShell command set whether AksEdge is allowed to upgrade the Kubernetes version on update.
ms.topic: reference
ms.date: 02/02/2023
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# Set-AksEdgeUpgrade

Sets whether AKS Edge Essentials is allowed to upgrade the Kubernetes version on update.

## Syntax

```powershell
Set-AksEdgeUpgrade [[-AcceptUpgrade] <Boolean>]
```

## Description

The Set-AksEdgeUpgrade cmdlet sets whether AKS Edge Essentials is allowed to upgrade the Kubernetes version on update.

## Examples

```powershell
 Set-AksEdgeUpgrade -acceptUpgrade $True
```

## Parameters

### -AcceptUpgrade

This parameter specifies whether AksEdge is allowed to upgrade the Kubernetes version on update.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
