---
title: New-AksEdgeDeployment for AKS Edge
author: rcheeran
description: The New-AksEdgeDeployment PowerShell command creates a new AksEdge deployment 
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# New-AksEdgeDeployment

## Synopsis

Creates a new AksEdge deployment on this machine.

## Syntax

### fromJsonConfigFile (Default)

```powershell
New-AksEdgeDeployment [-JsonConfigFilePath <String>] [<CommonParameters>]
```

### fromJsonConfigString

```
New-AksEdgeDeployment -JsonConfigString <String> [<CommonParameters>]
```

## Description

Creates a new AksEdge deployment with a Linux node, and optionally a Windows node, on this machine.
When the JoinCluster switch is specified, the new deployment will join an existing remote cluster.
Otherwise, a new cluster will be deployed.
The new cluster can either be a single machine cluster,
or a scalable cluster.
By default, a scalable cluster is created whereas by specifying the SingleMachine
switch, a single machine cluster hooked to an internal switch is created.
For a scalable deployment, the node IPs, IP prefix length, gateway IP address and DNS servers
have to be specified.
For a single machine deployment, none of these parameters may be specified.

## Examples

### Example 1

```
New-AksEdgeDeployment -JsonConfigString $herestring
```

### Example 2

```
New-AksEdgeDeployment -JsonConfigFilePath $jsonFile
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
Default value: $(Get-DefaultJsonConfigFileLocation)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
