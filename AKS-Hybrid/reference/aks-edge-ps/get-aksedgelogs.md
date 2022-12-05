---
title: Get-AksEdgeLogs for AKS Edge
author: rcheeran
description: The Get-AksEdgeLogs PowerShell command collects all the logs from the deployment.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Get-AksEdgeLogs

## Synopsis

Collects all the logs from the deployment.

## Syntax

```powershell
Get-AksEdgeLogs [[-OutputPath] <String>] [<CommonParameters>]
```

## Description

The Get-AksEdgeLogs cmdlet collects all the logs from the AksEdge deployment and installation.
It compresses them and outputs the bundled logs in the form of a .zip folder, by default in the current
installation directory.

## Examples

### Example 1

```powershell
Get-AksEdgeLogs
```

### Example 2

```powershell
Get-AksEdgeLogs -OutputPath ~/Desktop
```

## Parameters

### -OutputPath

Optional parameter allowing to change the path to which the zipped log folder will be stored

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[Aksedge PowerShell Reference](./index.md)
