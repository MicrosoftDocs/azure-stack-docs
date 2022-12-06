---
title: New-AksEdgeScaleConfig for AKS Edge
author: rcheeran
description: The New-AksEdgeScaleConfig PowerShell command creates the configs needed for as new AksEdge deployment 
ms.topic: reference
ms.date: 11/17/2022
ms.author: rcheeran 
ms.lastreviewed: 11/17/2022
#ms.reviewer: jeguan

---

# New-AksEdgeScaleConfig

## Synopsis

Creates a JSON file with the configurations.

## Syntax

```powershell
 New-AksEdgeScaleConfig [[-outFile] <string>] [[-NodeType] <string>] [[-LinuxIp] <string>] [[-WindowsIp] <string>] [-ControlPlane]
```

## Description
Creates a sample configuration file needed to scale to additional nodes on an AKS Edge deployment.


## Parameters

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
## Next steps

[AksEdge PowerShell Reference](./index.md)
