---
title: Add-AksEdgeNode for AKS Edge
author: rcheeran
description: The Add-AksEdgeNode PowerShell command Adds a new AksEdge node to the cluster..
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Add-AksEdgeNode

Adds a new AksEdge node to the cluster.

## Syntax

```powershell
Add-AksEdgeNode [-NodeType] <String> [[-CpuCount] <Int32>] [[-MemoryInMB] <Int32>] [[-DataSizeInGB] <Int32>]
 [[-Ip4Address] <String>] [[-MacAddress] <String>] [-ControlPlane] [<CommonParameters>]
```

## Description

Adds a new AksEdge node to the cluster.
The new node created on this machine joins the cluster to
which the existing deployment on this machine belongs.
In case of a single machine deployment, this commandlet can be used to add a Windows node to the
single machine cluster.
In a scalable deployment, the existing Linux or Windows node can be
complemented with the other node type.

## Examples

### Example 1

```powershell
Add-AksEdgeNode -NodeType Windows -CpuCount 2 -MemoryInMB 4096
```

### Example 2

```powershell
Add-AksEdgeNode -NodeType Windows -CpuCount 2 -MemoryInMB 4096 `
```

-Ip4Address 192.168.1.3

## Parameters

### -NodeType

This parameter indicates whether a 'Linux' node or a 'Windows' node should be added.

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

### -CpuCount

This parameter specifies the number of vCPUs assigned to the new node

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemoryInMB

This parameter specifies the memory in MB to be assigned to the new node

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 2048
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSizeInGB

This parameter specifies the size of the data partition for the Linux node.
When application workloads with high disk requirements are to be deployed,
the size of the data partition can be extended accordingly.
This is ignored for Windows node.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ip4Address

This parameter specifies the static IP address to assign to the new node

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

### -MacAddress

This parameter specifies the MAC address to assign to the new node

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ControlPlane

This switch parameter specifies if the controlplane role needs to be enabled.
Applicable only for Linux Node.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
