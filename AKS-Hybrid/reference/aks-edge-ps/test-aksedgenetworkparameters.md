---
title: Test-AksEdgeNetworkParameters for AKS Edge
author: rcheeran
description: The Test-AksEdgeNetworkParameters PowerShell command validates AksIot network parameters,
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Test-AksEdgeNetworkParameters

## Synopsis

Validates AksEdge network parameters, useful as a pre-deployment step.

## Syntax

### fromJsonConfigFile (Default)

```powershell
Test-AksEdgeNetworkParameters [-JsonConfigFilePath <String>] [<CommonParameters>]
```

### fromJsonConfigString

```powershell
Test-AksEdgeNetworkParameters -JsonConfigString <String> [<CommonParameters>]
```

## Description

Validates AksEdge network parameters, useful as a pre-deployment step.
For a documentation of the
parameters, see the New-AksEdgeDeployment commandlet.

## Examples

### Example 1
```powershell
Test-AksEdgeNetworkParameters -WorkloadType Linux
```

## Parameters

### -JsonConfigString
{{ Fill JsonConfigString Description }}

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
{{ Fill JsonConfigFilePath Description }}

```yaml
Type: String
Parameter Sets: fromJsonConfigFile
Aliases:

Required: False
Position: Named
Default value: $(Get-DefaultJsonConfigFileLocation)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
