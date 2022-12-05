---
title: Set-AksEdgeNodeToDrain for AKS Edge
author: rcheeran
description: The Set-AksEdgeNodeToDrain PowerShell command prepares to remove a  node  from an existing cluster.
ms.topic: reference
ms.date: 11/17/2022
ms.author: rcheeran 
ms.lastreviewed: 11/17/2022
#ms.reviewer: jeguan

---


# Set-AksEdgeNodeToDrain

## Synopsis

The Set-AksEdgeNodeToDrain PowerShell command prepares to remove a  node  from an existing cluster.

## Syntax

```powershell
Set-AksEdgeNodeToDrain [[-WorkloadType] <WorkloadType>] [[-TimeoutSeconds] <Int32>] [<CommonParameters>]
```

## PARAMETERS

### -WorkloadType
This parameter indicates whether the 'Linux' node or the 'Windows' node, or both at the same time with
'LinuxAndWindows', should be drained.
When not specified, the 'Linux' node is drained only.
When both nodes are drained, the Windows node is drained first, then the Linux node.

```yaml
Type: WorkloadType
Parameter Sets: (All)
Aliases:
Accepted values: Linux, Windows, LinuxAndWindows

Required: False
Position: 1
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutSeconds
{{ Fill TimeoutSeconds Description }}

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

[Aksedge PowerShell Reference](./index.md)
