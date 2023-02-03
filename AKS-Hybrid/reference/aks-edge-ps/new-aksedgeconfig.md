---
title: New-AksEdgeConfig for AKS Edge
author: rcheeran
description: The New-AksEdgeConfig PowerShell command creates the configs needed for as new AksEdge deployment 
ms.topic: reference
ms.date: 11/17/2022
ms.author: rcheeran 
ms.lastreviewed: 02/102/2023
#ms.reviewer: jeguan

---

# New-AksEdgeConfig

Creates a JSON file with the configurations.

## Syntax

```powershell
New-AksEdgeConfig [[-outFile] <String>]
```

## Description
Creates a sample configuration file needed to create an AKS Edge deployment.


## Parameters

### -outFile
Provide the name of configuration file

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

This parameter allows to specify three deployment types: The simple single machine cluster that requires minimal parameters but cannot be scaled across multiple machines. The scalable cluster which requires input of network parameters and which can be scaled by calling New-AksEdgeScaleConfig after deployment (this config can be transferred to another machine to join the cluster).
The CAPI managed cluster type: Similar to the scalable cluster type, network parameters are required, but in addition a multitude of machines can be specified. This allows for automated deployment of the whole cluster spanning across multiple machines in one go. Note that the deployment if the CAPI managed cluster is not yet supported.

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
