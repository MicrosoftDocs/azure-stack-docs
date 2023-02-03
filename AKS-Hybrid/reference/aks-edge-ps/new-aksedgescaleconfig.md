---
title: New-AksEdgeScaleConfig for AKS Edge
author: rcheeran
description: The New-AksEdgeScaleConfig PowerShell command creates the configs needed to scale the cluster.
ms.topic: reference
ms.date: 11/17/2022
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# New-AksEdgeScaleConfig

 Creates a new AksEdge configuration template for scaling the cluster.

## Syntax

```powershell
 New-AksEdgeScaleConfig [[-outFile] <string>] [[-NodeType] <string>] [[-ScaleType] <string>]  [[-LinuxNodeIp] <string>] [[-WindowsNodeIp] <string>] [-ControlPlane]
```

## Description
Creates a new AksEdge configuration template for scaling the cluster. This template can be customized and input to Add-AksEdgeNode when the scaling intent it add a node locally, or to New-AksEdgeDeployment when the scaling intent is to add a new machine with a Linux/Windows/LinuxAndWindows node(s) to the existing cluster. This commandlet cannot be used for CAPI managed clusters. Further, this commandlet cannot be used to add machines in the single machine cluster case where only adding a potentially missing Windows node is supported.

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
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NodeType

 This parameter indicates whether the 'Linux' node or the 'Windows' node, or both at the same time with 'LinuxAndWindows' are to be deployed. When adding a node, either 'Linux' or 'Windows' must be supplied while for adding a machine, also 'LinuxAndWindows' may be supplied

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

### -ScaleType

 This parameter indicates the intended cluster scale operation: 'AddNode' - To create a configuration for adding a node locally, or 'AddMachine' - to create a configuration for creating a new deployment that joins the existing cluster on a new machine.

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

### -LinuxNodeIp

  Applicable for scalable clusters, this allow specifying the desired Linux node IP. A networking parameter check will be executed to ensure the IP is supported.

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

### -WindowsNodeIp

 Applicable for scalable clusters, this allow specifying the desired Windows node IP. A networking parameter check will be executed to ensure the IP is supported.

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

### -ControlPlane

This parameter when specified with a NodeType of Linux or LinuxAndWindows for the AddMachine case, this indicates that the intent is to create a Linux control plane node on the new machine.

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
