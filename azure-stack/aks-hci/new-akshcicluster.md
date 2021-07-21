---
title: New-AksHciCluster
author: jessicaguan
description: The New-AksHciCluster PowerShell command creates a new managed Kubernetes cluster.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---


# New-AksHciCluster

## Synopsis
Create a new managed Kubernetes cluster.

## Syntax

```powershell
New-AksHciCluster -name <String>
                 [-kubernetesVersion <String>]
                 [-controlPlaneNodeCount <int>]
                 [-linuxNodeCount <int>]
                 [-windowsNodeCount <int>]
                 [-controlPlaneVmSize <VmSize>]
                 [-loadBalancerVmSize <VmSize>]
                 [-linuxNodeVmSize <VmSize>]
                 [-windowsNodeVmSize <VmSize>]
                 [-vnet <Virtual Network>]
                 [-primaryNetworkPlugin <Network Plugin>]   
                 [-enableAdAuth]
                 [-enableMonitoring]
                 [-clusterStorageContainer]
```

> [!NOTE]
> The the parameter set above is going to be deprecated in a future release. This will still be supported and will be the default behavior when running `New-AksHciCluster` with the only required parameter `-name`. AKS on Azure Stack HCI is introducting node pools to its cluster deployment experience and is now supporting the following parameter set.  The old parameter set will still be supported and remain the default behavior when running `New-AksHciCluster` with the only required parameter `-name` while you are onboarding to the new node pool experience and until the old parameters are fully deprecated. Please see [here](use-node-pools.md) for more information on the new node pool experience.

```powershell
New-AksHciCluster -name <String>
                 [-kubernetesVersion <String>]
                 [-controlPlaneNodeCount <int>]
                 [-controlPlaneVmSize <VmSize>]
                 [-loadBalancerVmSize <VmSize>]
                 [-nodePoolName <String>]
                 [-nodeCount <int>]
                 [-nodeVmSize <VmSize>]
                 [-osType {linux, windows}]
                 [-vnet <Virtual Network>]
                 [-primaryNetworkPlugin <Network Plugin>]   
                 [-enableAdAuth]
                 [-enableMonitoring]
                 [-clusterStorageContainer]
```


| Parameters to be deprecated | Parameters introduced |
| -------------------- | ----------------|
| linuxNodeCount | nodePoolName |
| windowsNodeCount | nodeCount |
| linuxNodeVmSize | nodeVmSize |
| windowsNodeVmSize | osType |

## Description

Create a new Azure Kubernetes Service on Azure Stack HCI cluster.

## Examples

### New AKS-HCI cluster with required parameters

```powershell
PS C:\> New-AksHciCluster -name mycluster
```

### New AKS-HCI cluster with node pool

```powershell
PS C:\ New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -nodeVmSize Standard_K8S3_v1 -osType linux
```

## Parameters

### -name
The name of your Kubernetes cluster.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -kubernetesVersion
The version of Kubernetes that you want to deploy. The default is the latest version. To get a list of available versions, run `Get-AksHciKubernetesVersion`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: v1.18.8 or later
Accept pipeline input: False
Accept wildcard characters: False
```

### -controlPlaneNodeCount
The number of nodes in your control plane. Default is 1.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -controlPlaneVmSize
The size of your control plane VM. Default is Standard_A4_V2. To get a list of available VM sizes, run `Get-AksHciVmSize`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_A4_V2
Accept pipeline input: False
Accept wildcard characters: False
```

### -loadBalancerVmSize
The size of your load balancer VM. Default is Standard_A4_V2. To get a list of available VM sizes, run `Get-AksHciVmSize`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_A4_V2
Accept pipeline input: False
Accept wildcard characters: False
```

### -linuxNodeCount 
The number of Linux nodes in your Kubernetes cluster. Default is 1. **This parameter will be deprecated in a future release**

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -windowsNodeCount
The number of Windows nodes in your Kubernetes cluster. Default is 0. You can only deploy Windows nodes if you are running Kubernetes v1.18.8 or higher. **This parameter will be deprecated in a future release**

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```


### -linuxNodeVmSize
The size of your Linux Node VM. Default is Standard_K8S3_v1. To get a list of available VM sizes, run `Get-AksHciVmSize`. **This parameter will be deprecated in a future release**

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_K8S3_v1
Accept pipeline input: False
Accept wildcard characters: False
```

### -windowsNodeVmSize
The size of your Windows Node VM. Default is Standard_K8S3_v1. To get a list of available VM sizes, run `Get-AksHciVmSize`. **This parameter will be deprecated in a future release**

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_K8S3_v1
Accept pipeline input: False
Accept wildcard characters: False
```

### -nodePoolName
The name of your node pool. **This is a new parameter as part of the new node pool experience.**

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -nodeCount
The number of nodes in your node pool. **This is a new parameter as part of the new node pool experience.**

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -nodeVmSize
The size of the nodes or VMs in your node pool. **This is a new parameter as part of the new node pool experience.**

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -osType
TThe OS type of the nodes in your node pool. The value must be either *Linux* or *Windows*. **This is a new parameter as part of the new node pool experience.**

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vnet
The name of the AksHciNetworkSetting object created with New-AksHciNetworkSetting command.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -primaryNetworkPlugin
The network plug-in to be used for your deployment. This parameter takes in either `flannel` or `calico`. Calico is available for both Linux and Windows workload clusters.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: calico
Accept pipeline input: False
Accept wildcard characters: False
```

### -enableADAuth
Use this flag to enable Active Directory in your Kubernetes cluster.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -enableMonitoring
Use this flag to enable Prometheus monitoring.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- ### -enableSecretsEncryption
Use this flag to enable encryption in your Kubernetes secrets.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -enableCsiSmb
Use this flag to enable an SMB CSI driver during deployment.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -enableCsiNfs
Use this flag to enable an NFS CSI driver during deployment.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
--->

### -enableMonitoring
Use this flag to enable Prometheus monitoring.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### -clusterStorageContainer
The name of the storage container that is associated with the cluster.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: flannel
Accept pipeline input: False
Accept wildcard characters: False
```