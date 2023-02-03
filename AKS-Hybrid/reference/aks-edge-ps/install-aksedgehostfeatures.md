---
title: Install-AksEdgeHostFeatures for AKS Edge
author: rcheeran
description: The Install-AksEdgeHostFeatures PowerShell command Installs missing required OS features.
ms.topic: reference
ms.date: 02/02/2023
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# Install-AksEdgeHostFeatures

Installs missing required OS features.

## Syntax

```powershell
Install-AksEdgeHostFeatures
```

## Description

This function tests for OS features and capabilities that are not installed, and installs them. This function can be run before deployment to ensure all dependencies are met.


## Examples

### Install required features

```powershell
Install-AksEdgeHostFeatures
```

### Forcefully install required features

```powershell
Install-AksEdgeHostFeatures -Force
```

## Parameters

### -Force

This parameter forcefully installs required features and capabilities despite errors.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```


### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
