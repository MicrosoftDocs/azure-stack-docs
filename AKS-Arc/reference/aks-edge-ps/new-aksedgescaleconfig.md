---
title: New-AksEdgeScaleConfig for AKS Edge
author: rcheeran
description: The New-AksEdgeScaleConfig PowerShell command creates the configs needed to scale the cluster.
ms.topic: reference
ms.date: 02/03/2023
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# New-AksEdgeScaleConfig

Creates a new AKS Edge Essentials configuration template for scaling the cluster.

## Syntax

```powershell
 New-AksEdgeScaleConfig [[-outFile] <string>] [[-ScaleType] <string>] [[-NodeType] <string>] [[-LinuxNodeIp] <string>] [[-WindowsNodeIp] <string>] [-ControlPlane]
```

## Description

Creates a new AKS Edge Essentials configuration template for scaling the cluster. This template can be customized and provided as an input to Add-AksEdgeNode (to add a new node) or  New-AksEdgeDeployment (to add a new machine). Further, this commandlet isn't needed when adding a Windows node on a single machine cluster. 

## Examples

### Creating the configurations to add a new machine to the cluster with both Linux and Windows nodes and make the Linux node as a Control node.

```powershell
New-AksEdgeScaleConfig -outFile ./aksedge-config -NodeType LinuxAndWindows -ScaleType AddMachine -LinuxNodeIp 192.168.1.2 -WindowsNodeIp 192.168.1.3 -ControlPlane
```

## Parameters

### -outFile
Provide the name of configuration file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScaleType

This parameter indicates the intended cluster scale operation: 'AddNode' - To create a configuration for adding a node locally, or 'AddMachine' - to create a configuration for creating a new deployment that joins the existing cluster on a new machine.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: AddMachine
Accept pipeline input: False
Accept wildcard characters: False
```

### -NodeType

This parameter indicates whether the 'Linux' node or the 'Windows' node, or both at the same time with 'LinuxAndWindows' are to be deployed. 

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```


### -LinuxNodeIp

Applicable for scalable clusters and specifies the desired Linux node IP. A networking parameter check will be executed to ensure the IP is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsNodeIp

Applicable for scalable clusters and specifies the desired Windows node IP. A networking parameter check will be executed to ensure the IP is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ControlPlane

This parameter when specified with a NodeType of Linux or LinuxAndWindows for the AddMachine case, indicates that the intent is to create a Linux control plane node on the new machine.

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
## Next steps

[AksEdge PowerShell Reference](./index.md)
