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

Creates a new AksEdge deployment on this machine.

## Syntax

### JsonConfigFilePath (Default)

```powershell
New-AksEdgeDeployment [-JsonConfigFilePath <String>] [<CommonParameters>]
```

### JsonConfigString

```powershell
New-AksEdgeDeployment -JsonConfigString <String> [<CommonParameters>]
```

### Force

```powershell
New-AksEdgeDeployment [-JsonConfigFilePath <String>] -Force [<CommonParameters>]
```

## Description

Creates a new AKS Edge Essentials deployment with a Linux node, and optionally a Windows node, on this machine. When the `-JoinCluster` switch is specified, the new deployment joins an existing remote cluster. Otherwise, a new cluster is deployed.

The new cluster can either be a single machine cluster, or a scalable cluster. By default, a scalable cluster is created, but by specifying the `SingleMachine` switch, a single machine cluster hooked to an internal switch is created. For a scalable deployment, the node IPs, IP prefix length, gateway IP address and DNS servers have to be specified. For a single machine deployment, none of these parameters can be specified.

## Examples

### Example 1

```powershell
New-AksEdgeDeployment -JsonConfigString $jsonString
```

### Example 2

```powershell
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

This parameter enables you to create a deployment without the need to confirm the TPM pass-through capability. Note that enabling TPM passthrough to the virtual machine might increase security risks.
If `-Force` is specified, you are not asked for confirmation unless `-Confirm` is also specified.
Otherwise, user will be asked for confirmation to enable TPM pass-through capability. 

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
