---
title: Stop-AksEdgeNode for AKS Edge
author: rcheeran
description: The Stop-AksEdgeLinuxNode PowerShell command stops the Linux node VM
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Stop-AksEdgeNode

Stops the node VM if it's currently started.

## Syntax

```powershell
Stop-AksEdgeNode [[-NodeType] <String>]
```

## Description
The Stop-AksEdgeNode cmdlet stops the virtual machine.
No action is taken if the virtual machine is already stopped

## Examples

### Example 1
```powershell
Stop-AksEdgeNode
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

## Next steps

[AksEdge PowerShell Reference](./index.md)
