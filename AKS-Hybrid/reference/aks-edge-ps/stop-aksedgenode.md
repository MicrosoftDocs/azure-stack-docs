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

## Synopsis
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
{{ Fill NodeType Description }}

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
