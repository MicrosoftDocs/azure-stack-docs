---
title: Stop-AksEdgeNode for AKS Edge
author: rcheeran
description: The Stop-AksEdgeLinuxNode PowerShell command stops the node VM
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Stop-AksEdgeNode

Stops the node VM if it's currently started. This cmdlet is an asynchronous call and doesn't wait for the Kubernetes endpoint to be available. You'll have to wait for a while before the Kubernetes endpoint is made available.

## Syntax

```powershell
Stop-AksEdgeNode [[-NodeType] <String>]
```

## Description
Stops the virtual machine. No action is taken if the virtual machine is already stopped. 

## Examples

```powershell
Stop-AksEdgeNode
```

## Parameters

### -NodeType

Indicates whether the 'Linux' node or the 'Windows' node, or both at the same time with 'LinuxAndWindows'. 

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

### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).


## Next steps

[AksEdge PowerShell Reference](./index.md)
