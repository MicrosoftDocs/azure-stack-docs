---
title: New-AksHciCluster for AKS on Azure Stack HCI
author: mkostersitz
description: The New-AksHciCluster PowerShell command creates a new managed Kubernetes cluster.
ms.topic: reference
ms.date: 03/16/2022
ms.author: mikek 
ms.lastreviewed: 
ms.reviewer: jeguan

---


# New-AksHciCluster

## Synopsis
Create a new managed Kubernetes cluster.

## Syntax

```powershell
New-AksHciCluster -name <String>
                 [-nodePoolName <String>]
                 [-kubernetesVersion <String>]
                 [-controlPlaneNodeCount <int>]
                 [-linuxNodeCount <int>]
                 [-windowsNodeCount <int>]
                 [-controlPlaneVmSize <VmSize>]
                 [-loadBalancerVmSize <VmSize>]
                 [-loadBalancerSettings <loadBalancer>]
                 [-linuxNodeVmSize <VmSize>]
                 [-windowsNodeVmSize <VmSize>]
                 [-taints <Taint>]
                 [-nodeMaxPodCount <int>]
                 [-vnet <Virtual Network>]
                 [-primaryNetworkPlugin <Network Plugin>]   
                 [-enableAdAuth]
                 [-enableMonitoring]
                 [-enableAutoScaler] 
                 [-autoScalerProfileName]
```

> [!NOTE]
> The parameter set above is going to be deprecated in a future release. This set will still be supported and will be the default behavior when running `New-AksHciCluster` with the `-name` parameter, which is the only required parameter. AKS on Azure Stack HCI is introducing node pools to its cluster deployment experience and is now supporting the following parameter set. For more information on the new node pool experience, see [Create and manage multiple node pools for a cluster](../../use-node-pools.md).

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

### New AKS on Azure Stack HCI cluster with required parameter

```powershell
PS C:\> New-AksHciCluster -name mycluster
```

> [!NOTE]
> Do not include hyphens in cluster names, or the cluster creation may fail.

The example above deploys a cluster with one control plane node, a Linux node pool called *mycluster-linux* with a node count of one, and an empty Windows node pool called *mycluster-windows*. You can still scale the worker nodes with the [Set-AksHciCluster](set-akshcicluster.md) command or you can scale by node pool using the [Set-AksHciNodePool](set-akshcinodepool.md) command.

**Output**
```output
ProvisioningState     : provisioned
KubernetesVersion     : v1.20.7
NodePools             : {mycluster-linux, mycluster-windows}
WindowsNodeCount      : 0
LinuxNodeCount        : 1
ControlPlaneNodeCount : 1
Name                  : mycluster
```

### New AKS-HCI cluster with new parameter set's default values

```powershell
PS C:\ New-AksHciCluster -name mycluster -nodePoolName nodepool1
```

**Output**
```output
ProvisioningState     : provisioned
KubernetesVersion     : v1.20.7
NodePools             : nodepool1
WindowsNodeCount      : 0
LinuxNodeCount        : 0
ControlPlaneNodeCount : 1
Name                  : mycluster
```

> [!NOTE]
> If you are using the new parameter set as shown in the example above, the `WindowsNodeCount` and `LinuxNodeCount` fields in the output will not be accurate and always show as `0`. To get an accurage count of your Windows or Linux nodes, use the [Get-AksHciNodePool](get-akshcinodepool.md) command.

The command above deploys a cluster with its default values. The deployed cluster is the same cluster as the second example command deploys.

### New AKS-HCI cluster with a Linux node pool

```powershell
PS C:\> New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -nodeVmSize Standard_K8S3_v1 -osType linux
```

### New AKS-HCI cluster with a Windows node pool

```powershell
PS C:\> New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -nodeVmSize Standard_K8S3_v1 -osType windows
```

### New AKS-HCI cluster with a Linux node pool and taints

```powershell
PS C:\> New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -osType linux -taints sku=gpu:NoSchedule
```

### New AKS-HCI cluster with a Linux node pool and max pod count

```powershell
PS C:\> New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -osType linux -nodeMaxPodCount 100
```

### New AKS-HCI cluster with custom VM sizes

```powershell
PS C:\> New-AksHciCluster -name mycluster -controlPlaneVmSize Standard_D4s_v3 -loadBalancerVmSize Standard_A4_v2 -nodePoolName nodepool1 -nodeCount 3 -nodeVmSize Standard_D8s_v3
```

### New AKS-HCI cluster with highly available control plane nodes

```powershell
PS C:\> New-AksHciCluster -name mycluster -controlPlaneNodeCount 3 -nodePoolName nodepool1 -nodeCount 3
```

### New AKS-HCI cluster with monitoring enabled

```powershell
PS C:\> New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 3 -enableMonitoring
```

### New AKS-HCI cluster with AD auth enabled

```powershell
PS C:\> New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 3 -enableAdAuth
```

### New AKS-HCI cluster with a specific Kubernetes version

```powershell
PS C:\> New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 3 -kubernetesVersion v1.21.2
```
### New AKS-HCI cluster with auto scaler enabled and the default auto scaler configuration profile

```powershell
PS C:\> New-AksHciCluster -name mycluster -enableAutoScaler $true
```

### New AKS-HCI cluster with auto scaler enabled and a named auto scaler configuration profile

```powershell
PS C:\> New-AksHciCluster -name mycluster -enableAutoScaler $true -autoScalerProfileName myAutoScalerProfile
```

## Parameters

### -name
The name of your Kubernetes cluster. Do not include hyphens in cluster names, or the cluster creation may fail.

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
The version of Kubernetes that you want to deploy. The default is the latest version. To get a list of available versions, run [Get-AksHciKubernetesVersion](get-akshcikubernetesversion.md).

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value:  v1.20.7
Accept pipeline input: False
Accept wildcard characters: False
```

### -controlPlaneNodeCount
The number of nodes in your control plane. Default is one.

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
The size of your control plane VM. Default is Standard_A4_V2. To get a list of available VM sizes, run [Get-AksHciVmSize](get-akshcivmsize.md).

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
The size of your load balancer VM. Default is Standard_A4_V2. To get a list of available VM sizes, run [Get-AksHciVmSize](get-akshcivmsize.md).

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

### -loadBalancerSettings
The load balancer setting object that is created with [New-AksHciLoadBalancerSetting](new-akshciloadbalancersetting.md).

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

### -linuxNodeCount 
The number of Linux nodes in your Kubernetes cluster. Default is one. **This parameter will be deprecated in a future release.**

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
The number of Windows nodes in your Kubernetes cluster. Default is 0. **This parameter will be deprecated in a future release.**

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
The size of your Linux Node VM. Default is Standard_K8S3_v1. To get a list of available VM sizes, run `Get-AksHciVmSize`. **This parameter will be deprecated in a future release.**

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
The size of your Windows Node VM. Default is Standard_K8S3_v1. To get a list of available VM sizes, run `Get-AksHciVmSize`. **This parameter will be deprecated in a future release.**

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

### -taints
The node taints for the node pool. You can't change the node taints after the node pool is created.

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

### -nodeMaxPodCount
The maximum number of pods deployable to a node. This number needs to be greater than 50.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 110
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
The number of nodes in your node pool. If the parameter `-nodePoolName` is used, the default value is 1. **This is a new parameter as part of the new node pool experience.**

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

### -nodeVmSize
The size of the nodes or VMs in your node pool. If the parameter `-nodePoolName` is used, the default value is Standard_K8S3_v1. **This is a new parameter as part of the new node pool experience.**

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

### -osType
The OS type of the nodes in your node pool. The value must be either *Linux* or *Windows*. If the parameter `-nodePoolName` is used the default value is *Linux*. **This is a new parameter as part of the new node pool experience.**

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```

### -vnet
The name of the AksHciNetworkSetting object created with [New-AksHciClusterNetwork](new-akshciclusternetwork.md) command.

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
The network plug-in to be used for your deployment. This parameter uses either `flannel` or `calico`. Calico is available for both Linux and Windows workload clusters.

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

### -enableAutoScaler
Use this flag to enable the auto scaler
```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -autoScalerProfileName
The name of the auto scaler configuration profile
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
## Next steps

[AksHci PowerShell Reference](index.md)