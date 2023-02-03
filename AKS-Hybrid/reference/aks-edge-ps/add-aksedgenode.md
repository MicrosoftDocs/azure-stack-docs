---
title: Add-AksEdgeNode for AKS Edge
author: rcheeran
description: The Add-AksEdgeNode PowerShell command Adds a new AksEdge node to the cluster.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# Add-AksEdgeNode

Creates a new AksEdge node on the machine and adds it to the cluster.

## Syntax

```powershell
Add-AksEdgeNode [-JsonConfigFilePath <String>] [-JsonConfigString <String>] [<CommonParameters>]
```

## Description

Adds a new AksEdge node to the cluster. The new node created on this machine joins the cluster to
which the existing deployment on this machine belongs. In a single machine deployment, this command can be used to add a Windows node to the single machine cluster.
In a scalable deployment, the existing Linux or Windows node can be complemented with the other node type.


## Examples

### Using a configuration file

```powershell
Add-AksEdgeNode -JsonConfigFilePath ./aksedge-config.json
```

### Passing configurations as a JSON string

```powershell
Add-AksEdgeNode -JsonConfigString ($jsonObj | ConvertTo-Json)
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


### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
