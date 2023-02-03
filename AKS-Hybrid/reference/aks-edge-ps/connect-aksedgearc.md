---
title: Connect-AksEdgeArc for AKS Edge
author: rcheeran
description: The Connect-AksEdgeArc PowerShell command adds the cluster to Azure Arc.
ms.topic: reference
ms.date: 02/01/2023
ms.author: rcheeran 
ms.lastreviewed: 02/01/2023
#ms.reviewer: jeguan

---

# Connect-AksEdgeArc

Connects the AKS Edge Essentials cluster running on this machine to Azure Arc for Kubernetes.

## Syntax

```powershell
Connect-AksEdgeArc [-JsonConfigFilePath <String>] [-JsonConfigString <String>] [<CommonParameters>]
```

## Description

Connects the AKS Edge Essentials cluster running to Azure Arc for Kubernetes. Running this command requires an up-to-date version of the Az.ConnectedKubernetes and Az.Accounts modules and an up-to-date helm version in the binary path.


## Examples

### Example 1

```powershell
Connect-AksEdgeArc -JsonConfigFilePath ./aksedge-config.json
```

### Example 2

```powershell
Connect-AksEdgeArc -JsonConfigString ($jsonObj | ConvertTo-Json)
```

## Parameters

### -JsonConfigFilePath

 Input parameters based on a JSON file.

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

### -JsonConfigString

Input parameters based on a JSON string.

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


### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
