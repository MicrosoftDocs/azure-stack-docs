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
Remove-AksEdgeDeployment [-Force] [-Headless] [<CommonParameters>]
```

## Description

Removes all nodes running on the current machine. If the last control-plane node of a cluster is
removed, remaining worker nodes will be dangling.

## Parameters

### -Force
This parameter forcefully removes a node even if there are errors. A confirmation dialogue will be
displayed because proceeding with error condition can have adverse side effects on the state of the cluster.
In combination with the headless switch, a node can be forcefully removed without user interaction even if there are errors. 

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
