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

Removes a local node from an existing cluster.

## Syntax

```powershell
Remove-AksEdgeNode [-NodeType] <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## Description

Removes a local node from an existing cluster. This is supported only when Linux and Windows nodes are deployed in the same machine. To remove the single node deployed, use Remove-AksEdgeDeployment.

## Examples

Prompt confirmation for both general removal, and force removal if needed

```powershell
Remove-AksEdgeNode -NodeType Linux
```

Skip both confirmation

```powershell
Remove-AksEdgeNode -Force -NodeType Linux
```

Prompt confirmation for both general removal, and force removal if needed

```powershell
Remove-AksEdgeNode -Force -Confirm -NodeType Linux
```

Skip confirmation for general removal, but will prompt confirmation if force removal is required

```powershell
Remove-AksEdgeNode -Confirm:$false -NodeType Linux
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

This parameter enables user to remove node without user interaction.
In combination with the Confirm switch, a node can be force removed with or without user interaction even in case of errors.
If Force is specified, user will not be asked for confirmation unless Confirm is also specified.
Otherwise, user will be asked for confirmation for node removal unless Confirm is set to false, and asked again if force removal is required.

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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
