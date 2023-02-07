---
title: Remove-AksEdgeDeployment for AKS Edge
author: rcheeran
description: The Remove-AksEdgeDeployment PowerShell command removes the deployment from an existing cluster.
ms.topic: reference
ms.date: 11/17/2022
ms.author: rcheeran 
ms.lastreviewed: 11/17/2022
#ms.reviewer: jeguan

---


# Remove-AksEdgeDeployment

Removes all nodes on the current machine.

## Syntax

```powershell
Remove-AksEdgeDeployment [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## Description

Removes all nodes running on the current machine. If the last control-plane node of a cluster is removed, remaining worker nodes will be dangling.

## Parameters

### -Force
This parameter enables to remove node without user interaction.
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
