---
title: Disconnect-AksEdgeArc for AKS Edge
author: rcheeran
description: The Disconnect-AksEdgeArc PowerShell command removes the cluster from Azure Arc.
ms.topic: reference
ms.date: 02/01/2023
ms.author: rcheeran 
ms.lastreviewed: 02/01/2023
#ms.reviewer: jeguan

---

# Disconnect-AksEdgeArc

Disconnects the AKS Edge Essentials cluster running on this machine from Azure Arc for Kubernetes.

## Syntax

```powershell
Disconnect-AksEdgeArc [-JsonConfigFilePath <String>] [-JsonConfigString <String>] [<CommonParameters>]
```

## Description

Disconnects the AKS Edge Essentials cluster running on this machine to Azure Arc for Kubernetes. 


## Examples

### Example 1

```powershell
Disconnect-AksEdgeArc -JsonConfigFilePath ./aksedge-config.json
```

### Example 2

```powershell
Disconnect-AksEdgeArc -JsonConfigString ($jsonObj | ConvertTo-Json -Depth 4)
```

## Parameters

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


### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
