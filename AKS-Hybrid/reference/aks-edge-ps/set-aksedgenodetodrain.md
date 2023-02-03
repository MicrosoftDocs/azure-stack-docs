---
title: Set-AksEdgeNodeToDrain for AKS Edge
author: rcheeran
description: The Set-AksEdgeNodeToDrain PowerShell command prepares to remove a node from an existing cluster.
ms.topic: reference
ms.date: 11/17/2022
ms.author: rcheeran 
ms.lastreviewed: 11/17/2022
#ms.reviewer: jeguan

---


# Set-AksEdgeNodeToDrain

Drains a local node.

## Syntax

```powershell
Set-AksEdgeNodeToDrain [[-NodeType] <String>] [[-TimeoutSeconds] <Int32>] [<CommonParameters>]
```

## Description

Drains a local node.
This is useful for gracefully terminating the pods running on the node, for instance, for servicing or removing the node.

## Parameters

### -NodeType

This parameter indicates whether the 'Linux' node or the 'Windows' node, or both at the same time with
'LinuxAndWindows', should be drained. When not specified, the 'Linux' node is drained only.
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

### -TimeoutSeconds
This parameter is to provide the time out value in seconds. 

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).


## Next steps

[AksEdge PowerShell Reference](./index.md)
