---
title:  Get-AksEdgeEventLog for AKS Edge
author: rcheeran
description: The Get-AksEdgeEventLog PowerShell command collects event logs from the deployment.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Get-AksEdgeEventLog

Collects event logs from the deployment.

## Syntax

```powershell
Get-AksEdgeEventLog [[-OutputPath] <String>] [<CommonParameters>]
```

## Description
The Get-AksEdgeEventLog cmdlet gets the event log from the AksEdge deployment

## Examples

### Example 1
```powershell
Get-AksEdgeEventLog
```

### Example 2
```powershell
Get-AksEdgeEventLog -OutputPath ~/Desktop
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

[AksEdge PowerShell Reference](./index.md)
