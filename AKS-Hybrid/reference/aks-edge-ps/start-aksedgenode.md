---
title: Start-AksEdgeNode for AKS Edge
author: rcheeran
description: The Start-AksEdgeNode PowerShell command starts the Linux node VM 
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---


# Start-AksEdgeNode

## Synopsis

Starts the node VM if it's currently stopped.

## Syntax

```powershell
Start-AksEdgeNode [[-NodeType] <String>]
```

## Description

The Start-AksEdgeNode cmdlet starts the virtual machine.
No action is taken if the virtual machine is already started.

## Examples

### Example 1
```powershell
Start-AksEdgeNode -NodeType Linux
```

## PARAMETERS

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
