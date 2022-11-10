---
title: Add-AksIotNode for AKS Lite
author: rcheeran
description: The Add-AksIotNode PowerShell command Adds a new AksIot node to the cluster..
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Add-AksIotNode

## Synopsis

Adds a new AksIot node to the cluster.

## Syntax

### fromJsonConfigFile (Default)

```powershell
Add-AksIotNode [-JsonConfigFilePath <String>] [<CommonParameters>]
```

### fromParameters

```powershell
Add-AksIotNode [-WorkloadType <WorkloadType>] [-LinuxVmCpuCount <Int32>] [-LinuxVmMemoryInMB <Int32>]
 [-LinuxVmDataSizeInGB <Int32>] [-WindowsVmCpuCount <Int32>] [-WindowsVmMemoryInMB <Int32>]
 [-LinuxVmIp4Address <String>] [-WindowsVmIp4Address <String>] [-ClusterJoinToken <String>]
 [-DiscoveryTokenHash <String>] [-ControlPlane] [-Headless] [-TimeoutSeconds <Int32>] [<CommonParameters>]
```

### fromJsonConfigString

```powershell
Add-AksIotNode -JsonConfigString <String> [<CommonParameters>]
```

## Description

Adds a new AksIot node to the cluster.
The new node created on this machine joins the cluster to
which the existing deployment on this machine belongs.
In case of a single machine deployment, this commandlet can be used to add a Windows node to the
single machine cluster.
In a scalable deployment, the existing Linux or Windows node can be
complemented with the other node type.

## Examples

### Example 1

```powershell
Add-AksIotNode -WorkloadType Windows -WindowsVmCpuCount 2 -WindowsVmMemoryInMB 4096
```

### Example 2

```powershell
Add-AksIotNode -WorkloadType Windows -WindowsVmCpuCount 2 -WindowsVmMemoryInMB 4096 -WindowsVmIp4Address 192.168.1.3 -clusterjointoken \<token\> -discoverytokenhash \<hash\>
```

## Parameters

### -WorkloadType

This parameter indicates whether a 'Linux' node or a 'Windows' node should be added.

```yaml
Type: WorkloadType
Parameter Sets: fromParameters
Aliases:
Accepted values: Linux, Windows, LinuxAndWindows

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinuxVmCpuCount

This parameter specifies the number of vCPUs assigned to the Linux node

```yaml
Type: Int32
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinuxVmMemoryInMB

This parameter specifies the memory in MB to be assigned to the Linux node

```yaml
Type: Int32
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinuxVmDataSizeInGB

This parameter specifies the size of the data partition for the Linux node.
When application workloads with high disk requirements are to be deployed,
the size of the data partition can be extended accordingly.

```yaml
Type: Int32
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsVmCpuCount

This parameter specifies the number of vCPUs assigned to the Windows node

```yaml
Type: Int32
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsVmMemoryInMB

This parameter specifies the memory in MB to be assigned to the Windows node

```yaml
Type: Int32
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinuxVmIp4Address

This parameter specifies the static IP address to assign to the Linux node

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsVmIp4Address

This parameter specifies the static IP address to assign to the Windows node

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClusterJoinToken

The cluster join token used for joining the existing cluster.
The parameter can only be omitted if a control plane node is already deployed
on this machine in which case the token is acquired from the node.

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiscoveryTokenHash

The discovery token hash used for joining an existing cluster.
The parameter can only be omitted if a control plane node is already deployed
on this machine in which case the token is acquired from the node.

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ControlPlane

When adding a Linux node, this parameter indicates whether the node will run the control plane.

```yaml
Type: SwitchParameter
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headless

This parameter is useful for automation without user interaction.
The default user input will be applied.

```yaml
Type: SwitchParameter
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutSeconds

This parameter specifies the maximum wait for a kubernetes node to reach the Ready state

```yaml
Type: Int32
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -JsonConfigString

Input parameters based on a JSON string.
No other parameters may be specified.

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
No other parameters may be specified.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[Akslite PowerShell Reference](./index.md)
