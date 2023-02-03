---
title: New-AksEdgeConfig for AKS Edge
author: rcheeran
description: The New-AksEdgeConfig PowerShell command creates the configs needed for a new AKS Edge Essentials deployment 
ms.topic: reference
ms.date: 02/03/2023
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# New-AksEdgeConfig

Creates a JSON file with the configurations.

## Syntax

```powershell
New-AksEdgeConfig [[-outFile] <String>]
```

## Description
Creates a sample configuration file needed to create an AKS Edge Essentials deployment.


## Parameters

### -outFile
Provide the name of configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeploymentType

This parameter supports two deployment types: 
- `SingleMachineCluster`- The simple single machine cluster that requires minimal parameters but can't be scaled across multiple machines. 
- `ScalableCluster` - The scalable cluster that requires input of network parameters and which can be scaled by calling New-AksEdgeScaleConfig after deployment (this config can be transferred to another machine to join the cluster).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NodeType

This parameter indicates whether a 'Linux' node or a 'Windows' node or 'LinuxAndWindows' should be deployed.

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

## Next steps

[AksEdge PowerShell Reference](./index.md)
