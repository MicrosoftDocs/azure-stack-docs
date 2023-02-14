---
title: Test-AksEdgeNetworkParameters for AKS Edge
author: rcheeran
description: The Test-AksEdgeNetworkParameters PowerShell command validates AKS Edge network parameters,
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Test-AksEdgeNetworkParameters

Validates AksEdge network parameters, useful as a pre-deployment step. This command is useful as a pre-deployment check before scaling your cluster across multiple machines. 

## Syntax

### fromJsonConfigFile (Default)

```powershell
Test-AksEdgeNetworkParameters [-JsonConfigFilePath <String>] [<CommonParameters>]
```

### fromJsonConfigString

```powershell
Test-AksEdgeNetworkParameters [-JsonConfigString <String>] [<CommonParameters>]
```

## Description

Validates AksEdge network parameters, useful as a pre-deployment step.
For a documentation of the
parameters, see the New-AksEdgeDeployment commandlet.

## Examples


```powershell
Test-AksEdgeNetworkParameters -JsonConfigFilePath ./aksedge-config.json
```

## Parameters

### -JsonConfigString

Input parameters based on a JSON string.

```yaml
Type: String
Parameter Sets: fromJsonConfigString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JsonConfigFilePath

Input parameters based on a JSON file.

```yaml
Type: String
Parameter Sets: fromJsonConfigFile
Aliases:

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
