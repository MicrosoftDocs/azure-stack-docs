---
title: Get-AksIotLogs for AKS Lite
author: rcheeran
description: The Get-AksIotLogs PowerShell command collects all the logs from the deployment.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Get-AksIotLogs

## Synopsis

Collects all the logs from the deployment.

## Syntax

```powershell
Get-AksIotLogs [[-OutputPath] <String>] [<CommonParameters>]
```

## Description

The Get-AksIotLogs cmdlet collects all the logs from the AksIot deployment and installation.
It compresses them and outputs the bundled logs in the form of a .zip folder, by default in the current
installation directory.

## Examples

### Example 1

```powershell
Get-AksIotLogs
```

### Example 2

```powershell
Get-AksIotLogs -OutputPath ~/Desktop
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

[Akslite PowerShell Reference](./index.md)
