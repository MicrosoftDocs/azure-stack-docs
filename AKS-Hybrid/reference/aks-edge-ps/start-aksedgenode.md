---
title: Start-AksEdgeNode for AKS Edge
author: rcheeran
description: The Start-AksEdgeNode PowerShell command starts the node VM. 
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---


# Start-AksEdgeNode

Starts the node VM if it's currently stopped. This is an asynchronous call and does not wait for the Kubernetes endpoint to be available. This would mean that you will have a wait for a while before the Kubernetes endpoint is made available. 

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

This parameter indicates whether the 'Linux' node or the 'Windows' node, or both at the same time with
'LinuxAndWindows'.

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
