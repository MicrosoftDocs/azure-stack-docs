---
title: Start-AksEdgeUpdate for AKS Edge
author: rcheeran
description: The Start-AksEdgeUpdate PowerShell command set whether AksEdge is allowed to upgrade the Kubernetes version on update.
ms.topic: reference
ms.date: 02/02/2023
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# Start-AksEdgeUpdate

Starts the update process for updating AKS Edge Essentials. Upgrades control plane nodes only.

## Syntax

```powershell
Start-AksEdgeUpdate
```

## Description

Microsoft Update sends all the binaries necessary to complete the AKS Edge Essentials Update. The `Start-AksEdgeUpdate` command locates these
binaries and starts the MSI update process. Running this command results in some downtime for the images inside of AKS Edge Essentials.
If you have any worker nodes in the cluster, you must run `Start-AksEdgeWorkerNodeUpdate` once all of the control plane nodes in the cluster are updated.


## Examples

### To update the first control node in the cluster

```powershell
 Start-AksEdgeUpdate 
```

### To update the secondary control node in the cluster

```powershell
 Start-AksEdgeUpdate -secondaryControlPlaneUpdate
```

## Parameters

### -secondaryControlPlaneUpdate

If this is not the first control plane node you've upgraded in the cluster, you must set this flag.

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

### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
