---
title: Remove-AksEdgeNode for AKS Lite
author: rcheeran
description: The Remove-AksEdgeNode PowerShell command removes a local node from an existing cluster.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---


# Remove-AksEdgeNode

## Synopsis

Removes a local node from an existing cluster.

## Syntax

```powershell
Remove-AksEdgeNode [[-WorkloadType] <WorkloadType>] [-Headless] [<CommonParameters>]
```

## Description

Removes a local node from an existing cluster.
In case the last control-plane node of a cluster is
removed, remaining worker nodes will be dangling.

## Examples

```powershell
Remove-AksEdgeNode -WorkloadType Linux
```

## Parameters

### -WorkloadType

This parameter indicates whether the 'Linux' node or the 'Windows' node, or both at the same time with
'LinuxAndWindows', should be removed.
When not specified, the 'Linux' node is removed only.

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

### -Headless

This parameter is useful for automation without user interaction.
The default user input will be applied.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[Akslite PowerShell Reference](./index.md)
