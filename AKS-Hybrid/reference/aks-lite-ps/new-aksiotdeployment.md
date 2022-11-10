---
title: New-AksIotDeployment for AKS Lite
author: rcheeran
description: The New-AksIotDeployment PowerShell command creates a new AksIot deployment 
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# New-AksIotDeployment

## Synopsis

Creates a new AksIot deployment on this machine.

## Syntax

### fromJsonConfigFile (Default)

```
New-AksIotDeployment [-JsonConfigFilePath <String>] [<CommonParameters>]
```

### fromParameters

```
New-AksIotDeployment [-WorkloadType <WorkloadType>] [-NetworkPlugin <NetworkPlugin>] [-AcceptEula <String>]
 [-LinuxVmCpuCount <Int32>] [-LinuxVmMemoryInMB <Int32>] [-LinuxVmDataSizeInGB <Int32>]
 [-WindowsVmCpuCount <Int32>] [-WindowsVmMemoryInMB <Int32>] [-VswitchName <String>]
 [-LinuxVmIp4Address <String>] [-WindowsVmIp4Address <String>] [-ControlPlaneEndpointIp <String>]
 [-ServiceIPRangeStart <String>] [-ServiceIPRangeEnd <String>] [-Ip4PrefixLength <Int32>]
 [-Ip4GatewayAddress <String>] [-DnsServers <String[]>] [-ServiceIPRangeSize <Int32>] [-SingleMachineCluster]
 [-JoinCluster] [-ControlPlaneEndpointPort <Int32>] [-ClusterJoinToken <String>] [-DiscoveryTokenHash <String>]
 [-ControlPlane] [-Headless] [-TimeoutSeconds <Int32>] [<CommonParameters>]
```

### fromJsonConfigString

```
New-AksIotDeployment -JsonConfigString <String> [<CommonParameters>]
```

## Description

Creates a new AksIot deployment with a Linux node, and optionally a Windows node, on this machine.
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
New-AksIotDeployment `
  -WorkloadType Linux `
  -LinuxVmCpuCount 2 `
  -LinuxVmMemoryInMB 4096 `
  -LinuxVmDataSizeInGB 4 `
  -vswitchName aksiotswitch `
  -LinuxVmIp4Address 192.168.1.2 `
  -ip4PrefixLength 24 `
  -ip4GatewayAddress 192.168.1.1 `
  -DnsServers "192.168.1.1"
```

### Example 2

```
New-AksIotDeployment `
  -WorkloadType Linux `
  -LinuxVmCpuCount 2 `
  -LinuxVmMemoryInMB 4096 `
  -LinuxVmDataSizeInGB 4 `
  -vswitchName aksiotswitch `
  -LinuxVmIp4Address 192.168.1.2 `
  -ip4PrefixLength 24 `
  -ip4GatewayAddress 192.168.1.1 `
  -DnsServers "192.168.1.1" `
  -JoinCluster -ControlPlaneEndpointIp 192.168.1.100 `
  -ControlPlaneEndpointPort 6443 -ClusterJoinToken \<token\> `
  -DiscoveryTokenHash \<hash\>
```

### Example 3

```
New-AksIotDeployment -WorkloadType LinuxAndWindows -LinuxVmCpuCount 2 -LinuxVmMemoryInMB 4096 -LinuxVmDataSizeInGB 4 -WindowsVmCpuCount 2 -WindowsVmMemoryInMB 4096 -vswitchName aksiotswitch -LinuxVmIp4Address 192.168.1.2 -WindowsVmIp4Address 192.168.1.3 -ip4PrefixLength 24 -ip4GatewayAddress 192.168.1.1 -DnsServers "192.168.1.1" -ServiceIPRangeStart 192.168.1.5 -ServiceIPRangeEnd 192.168.1.10 -ControlPlaneEndpointIp 192.168.1.4
```

### Example 4

```
New-AksIotDeployment -WorkloadType Linux -LinuxVmCpuCount 2 -LinuxVmMemoryInMB 4096 -LinuxVmDataSizeInGB 4 -ServiceIPRangeSize 10 -SingleMachineCluster
```

### Example 5

```
New-AksIotDeployment -WorkloadType LinuxAndWindows -LinuxVmCpuCount 2 -LinuxVmMemoryInMB 4096 -LinuxVmDataSizeInGB 4 -WindowsVmCpuCount 2 -WindowsVmMemoryInMB 4096 -SingleMachineCluster
```

## Parameters

### -WorkloadType

This parameter indicates whether a 'Linux' node or a 'Windows' node, or both at the same time with 'LinuxAndWindows', should be created.

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

### -NetworkPlugin

This parameter allows to chose the CNI for the cluster

```yaml
Type: NetworkPlugin
Parameter Sets: fromParameters
Aliases:
Accepted values: calico, flannel

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AcceptEula

When set to 'yes', this parameter allows to bypass the EULA dialogue.

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

### -VswitchName

Name of an existing external virtual switch the nodes get attached to.
The switch needs to be pre-created and the user needs to ensure that virtual machines are capable of
obtaining an IP address to this switch.
For instance, the switch needs to be attached to a physical
network adapter that is in 'Connected' state.

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

### -ControlPlaneEndpointIp

This parameter allows defining a specific IP address to be used as the control plane endpoint IP for the
deployment.
This is useful for scenarios where the control plane has to be made highly available, or when the new
deployment joins an existing cluster.
If not specified, the endpoint will equal the local Linux node's IP address when creating a new cluster.

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

### -ServiceIPRangeStart

Start of the IP range for kubernetes service resources.
When specified, the IP range is used by kubernetes
service resources as a pool for IP addresses.
Application workloads that get exposed through a service
will use IPs from that pool.
The IP range should start and end in the same subnet of the virtual switch.

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

### -ServiceIPRangeEnd

End of the IP range for kubernetes service resources.
The IP range should start and end in the same subnet of the virtual switch.

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

### -Ip4PrefixLength

This parameter defines the address prefix to use for static IP assignment for the node

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

### -Ip4GatewayAddress

This parameter specifies the address of the gateway to use for static IP assignment for the node

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

### -DnsServers

The DNS servers to use for static IP assignment for the node

```yaml
Type: String[]
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceIPRangeSize

This parameter only applies to the single machine cluster scenario.
The parameter defines the number of
IPs reserved for the services and the services will be hosted in this IP range determined internally.
When this parameter is not specified or 0, the services will be hosted on the Linux VM's IP address with
the specified port number.
The VM IP address can be obtained by calling Get-AksIotLinuxNodeAddr.

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

### -SingleMachineCluster

This parameter indicates that a new single machine cluster hooked to an internal switch will be created.

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

### -JoinCluster

This parameter indicates that the new deployment will join an existing remote cluster.

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

### -ControlPlaneEndpointPort

When joining an existing cluster, this parameter specifies the port of the remote control plane endpoint.

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

### -ClusterJoinToken

The cluster join token used for joining an existing cluster

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

The discovery token hash used for joining an existing cluster

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

This parameter indicates that the Linux node of this deployment will join an existing cluster as a node
that runs the control plane

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
