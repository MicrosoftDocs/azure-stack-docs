---
title: Test-AksEdgeNode for AKS Lite
author: rcheeran
description: The Test-AksEdgeNode PowerShell command checks whether the Linux VM was created
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Test-AksEdgeNode

## Synopsis

Checks whether the VM was created.

## Syntax

```powershell
Test-AksEdgeNode [[-WorkloadType] <String>] [<CommonParameters>]
```

## Description

The Test-AksEdgeNode cmdlet is an exposed function to verify whether the Linux VM was created.
It returns true if the virtual machine was created or false if not.

## Examples

```powershell
Test-AksEdgeNode -WorkloadType Windows
```

## Parameters

### -WorkloadType
{{ Fill WorkloadType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[Akslite PowerShell Reference](./index.md)

