---
title: Remove-AksEdgeNode for AKS Edge
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
Remove-AksEdgeNode [-NodeType] <String> [-Force] [-Headless] [<CommonParameters>]
```

## Description

Removes a local node from an existing cluster. This is supported only when Linux and Windows nodes are deployed
in the same machine.
To remove the single node deployed, use Remove-AksEdgeDeployment.

## Examples

```powershell
Remove-AksEdgeNode -WorkloadType Linux
```

## Parameters

### -NodeType

This parameter indicates whether the 'Linux' node or the 'Windows' node.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

This parameter forcefully removes a node despite errors. A confirmation dialogue will be displayed because proceeding in error cases can have adverse side effects on the state of the cluster. In combination with the headless switch, a node can be force removed without user interaction even if there are errors.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
