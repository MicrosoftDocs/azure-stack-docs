---
title: Test-AksEdgeNode for AKS Edge
author: rcheeran
description: The Test-AksEdgeNode PowerShell command checks whether the VM was created
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Test-AksEdgeNode

Checks whether the node of NodeType was created.

## Syntax

```powershell
Test-AksEdgeNode [[-NodeType] <String>] [<CommonParameters>]
```

## Description

The Test-AksEdgeNode commandlet is an exposed function to verify whether the Linux or Windows node was created. It returns true if the node was created or false if not.

## Examples

### Example

```powershell
Test-AksEdgeNode -NodeType Windows
```

## Parameters

### -NodeType

This parameter indicates whether the 'Linux' node or the 'Windows' node, or both at the same time with
'LinuxAndWindows', should be drained.
When not specified, the 'Linux' node is drained only.
When both nodes are drained, the Windows node is drained first, then the Linux node.

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

[AksEdge PowerShell Reference](./index.md)

