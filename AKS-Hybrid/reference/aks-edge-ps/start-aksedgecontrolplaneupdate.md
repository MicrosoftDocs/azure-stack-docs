---
title: Start-AksEdgeControlPlaneUpdate for AKS Edge
author: rcheeran
description: The Start-AksEdgeControlPlaneUpdate PowerShell command updates any control plane nodes on this machine as part of the update process.
ms.topic: reference
ms.date: 06/15/2023
ms.author: rcheeran 
ms.lastreviewed: 02/03/2023
#ms.reviewer: jeguan

---

# Start-AksEdgeControlPlaneUpdate

Updates the control plane nodes on this machine as part of the update process. You must have already run `Start-AksEdgeUpdate` on every deployment in the cluster before running this command on the control plane node. Refresh the PowerShell instance and reimport the AKS Edge Essentials module before running this command.

## Syntax

```powershell
Start-AksEdgeControlPlaneUpdate -firstControlPlane  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## Description

After starting the upgrade process with `Start-AksEdgeUpdate`, and running `Start-AksEdgeUpdate` on every machine in the cluster, run this command on every machine to upgrade the worker nodes. Refresh the PowerShell instance and reimport the AKS Edge Essentials module before running this command.

## Examples

### Update the primary control plane node

```powershell
Start-AksEdgeControlPlaneUpdate -firstControlPlane true -Force
```

### Update the secondary control plane nodes

```powershell
Start-AksEdgeControlPlaneUpdate -firstControlPlane false -Force
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
