---
title: Start-AksEdgeWorkerNodeUpdate for AKS Edge
author: rcheeran
description: The Start-AksEdgeWorkerNodeUpdate PowerShell command updates any worker nodes on this machine as part of the update process.
ms.topic: reference
ms.date: 02/02/2023
ms.author: rcheeran 
ms.lastreviewed: 02/03/2023
#ms.reviewer: jeguan

---

# Start-AksEdgeWorkerNodeUpdate

Updates any worker nodes on this machine as part of the update process. You must have already run `Start-AksEdgeUpdate` on every deployment in the cluster before running this command on every machine with a worker node. Please refresh the PowerShell instance and re-import the AKS Edge Essentials module before running this command.

## Syntax

```powershell
Start-AksEdgeWorkerNodeUpdate [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## Description

After starting the upgrade process with `Start-AksEdgeUpdate`, and running `Start-AksEdgeUpdate` on every machine in the cluster, run this command on every machine to upgrade the worker nodes. Refresh the PowerShell instance and re-import the AKS Edge Essentials module before running this command.


## Examples

```powershell
Start-AksEdgeWorkerNodeUpdate -Force
```

## Parameters

### -Force

This parameter force-installs required features and capabilities despite errors.

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
