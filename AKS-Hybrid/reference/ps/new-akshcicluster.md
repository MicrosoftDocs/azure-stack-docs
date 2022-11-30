---
title: New-AksHciCluster for AKS on Azure Stack HCI and Windows Server
author: sethmanheim
description: The New-AksHciCluster PowerShell command creates a new managed Kubernetes cluster.
ms.topic: reference
ms.date: 11/30/2022
ms.author: sethm
ms.lastreviewed: 
ms.reviewer: mikek

---


# New-AksHciCluster

## Synopsis

Create a new managed Kubernetes cluster.

## Syntax

```powershell
New-AksHciCluster -name <String>
                 [-nodePoolName <String>]
                 [-nodeCount <int>]
                 [-osType {linux, windows}]
                 [-kubernetesVersion <String>]
                 [-controlPlaneNodeCount <int>]
                 [-nodeCount <int>]
                 [-controlPlaneVmSize <VmSize>]
                 [-loadBalancerVmSize <VmSize>]
                 [-loadBalancerSettings <loadBalancer>]
                 [-nodeVmSize <VmSize>]
                 [-taints <Taint>]
                 [-nodeMaxPodCount <int>]
                 [-vnet <Virtual Network>]
                 [-primaryNetworkPlugin <Network Plugin>]   
                 [-enableAdAuth]
                 [-enableMonitoring]
                 [-enableAutoScaler] 
                 [-enableAzureRBAC] 
                 [-autoScalerProfileName]
```

## Description

Create a new Azure Kubernetes Service on Azure Stack HCI or Windows Server cluster.

## Examples

### New AKS on Azure Stack HCI and Windows Server cluster with required parameter

```powershell
New-AksHciCluster -name mycluster
```

> [!NOTE]
> Do not include hyphens in cluster names, or the cluster creation may fail.

This example deploys a cluster with one control plane node, a Linux node pool called `mycluster-linux` with a node count of 1, and an empty Windows node pool called `mycluster-windows`. You can still scale the worker nodes with the [Set-AksHciCluster](set-akshcicluster.md) command, or you can scale by node pool using the [Set-AksHciNodePool](set-akshcinodepool.md) command.

```shell
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

```shell
ProvisioningState     : provisioned
KubernetesVersion     : v1.20.7
NodePools             : nodepool1
WindowsNodeCount      : 0
LinuxNodeCount        : 0
ControlPlaneNodeCount : 1
Name                  : mycluster
```

> [!NOTE]
> If you are using the new parameter set as shown in the example above, the `WindowsNodeCount` and `LinuxNodeCount` fields in the output will not be accurate and always show as `0`. To get an accurate count of your Windows or Linux nodes, use the [Get-AksHciNodePool](get-akshcinodepool.md) command.

This command deploys a cluster with its default values. The deployed cluster is the same cluster as the second example command.

### New AKS-HCI cluster with a Linux node pool

```powershell
New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -nodeVmSize Standard_K8S3_v1 -osType linux
```

### New AKS-HCI cluster with a Windows node pool

```powershell
New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -nodeVmSize Standard_K8S3_v1 -osType Windows -osSku Windows2022
```

### New AKS-HCI cluster with a Linux node pool and taints

```powershell
New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -osType linux -taints sku=gpu:NoSchedule
```

### New AKS-HCI cluster with a Linux node pool and max pod count

```powershell
New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 1 -osType linux -nodeMaxPodCount 100
```

### New AKS-HCI cluster with custom VM sizes

```powershell
New-AksHciCluster -name mycluster -controlPlaneVmSize Standard_D4s_v3 -loadBalancerVmSize Standard_A4_v2 -nodePoolName nodepool1 -nodeCount 3 -nodeVmSize Standard_D8s_v3
```

### New AKS-HCI cluster with highly available control plane nodes

```powershell
New-AksHciCluster -name mycluster -controlPlaneNodeCount 3 -nodePoolName nodepool1 -nodeCount 3
```

### New AKS-HCI cluster with monitoring enabled

```powershell
New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 3 -enableMonitoring
```

### New AKS-HCI cluster with AD auth enabled

```powershell
New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 3 -enableAdAuth
```

### New AKS-HCI cluster with a specific Kubernetes version

```powershell
New-AksHciCluster -name mycluster -nodePoolName nodepool1 -nodeCount 3 -kubernetesVersion v1.21.2
```

### New AKS-HCI cluster with autoscaler enabled and the default autoscaler configuration profile

```powershell
New-AksHciCluster -name mycluster -enableAutoScaler $true
```

### New AKS-HCI cluster with autoscaler enabled and a named autoscaler configuration profile

```powershell
New-AksHciCluster -name mycluster -enableAutoScaler $true -autoScalerProfileName myAutoScalerProfile
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

Specifies the version of Kubernetes that you want to deploy. The default is the latest version. To get a list of available versions, run [Get-AksHciKubernetesVersion](get-akshcikubernetesversion.md).

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

The size of your control plane VM. Default is `Standard_A4_V2`. To get a list of available VM sizes, run [Get-AksHciVmSize](get-akshcivmsize.md).

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

The size of your load balancer VM. Default is `Standard_A4_V2`. To get a list of available VM sizes, run [Get-AksHciVmSize](get-akshcivmsize.md).

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

The maximum number of pods deployable to a node. This number must be greater than 50.

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

The name of your node pool. This is a new parameter as part of the new node pool experience.

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

The number of nodes in your node pool. If the parameter `-nodePoolName` is used, the default value is 1. This is a new parameter as part of the new node pool experience.

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

The size of the nodes or VMs in your node pool. If the parameter `-nodePoolName` is used, the default value is Standard_K8S3_v1. This is a new parameter as part of the new node pool experience.

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

The OS type of the nodes in your node pool. The value must be either "Linux" or "Windows". If the parameter `-nodePoolName` is used, the default value is "Linux". This is a new parameter as part of the new node pool experience.

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

The name of the `AksHciNetworkSetting` object created with [New-AksHciClusterNetwork](new-akshciclusternetwork.md).

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

Enables Active Directory in your Kubernetes cluster.

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

Enables Prometheus monitoring.

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

Enables the autoscaler.

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

### -enableAzureRBAC

Enables Azure RBAC on the cluster.

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

The name of the autoscaler configuration profile.

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

## Next steps

[AksHci PowerShell Reference](index.md)
