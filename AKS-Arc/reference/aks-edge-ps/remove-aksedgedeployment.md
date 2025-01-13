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

Removes all nodes running on the current machine. Remove all worker nodes before removing the last control plane node.

## Parameters

### -Force

This parameter enables user to remove node without interaction.
In combination with the Confirm switch, a node can be force removed with or without user interaction even if there are errors.
If Force is specified, user isn't asked for confirmation for node removal.
Specifying `-Confirm` explicitly, prompts user for confirmation.

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
The cmdlet isn't run.

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

Prompts you for confirmation before running the cmdlet. Overrides `-Force` parameter for user confirmations.

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
