---
title: Use multiple node pools in AKS on Azure Stack HCI
description: Learn how to create and manage multiple node pools for a cluster in AKS on Azure Stack HCI
services: 
ms.topic: article
ms.date: 07/14/2021
---

# Create and manage multiple node pools for a cluster in Azure Kubernetes Service (AKS) on Azure Stack HCI

In AKS on Azure Stack HCI, nodes of the same configuration are now grouped together into *node pools*. These node pools contain the underlying VMs that run your applications. 

> [!NOTE]
> This feature enables higher control over how to create and manage multiple node pools. As a result, separate commands are required for  create/update/delete. Previously, cluster operations through [New-AksHciCluster](new-akshcicluster.md) or [Set-AksHciCluster](set-akshcicluster.md) were the only option to create/scale a cluster with one Windows node pool and one Linux node pool. This feature exposes a separate operation set for node pools that require the use of the node pool commands [New-AksHciNodePool](new-akshcinodepool.md), [Set-AksHciNodePool](set-akshcinodepool.md), [Get-AksHciNodePool](get-akshcinodepool.md), and [Remove-AksHciNodePool](remove-akshcinodepool.md) to execute operations on an individual node pool. 

This article shows you how to create and manage multiple node pools in an AKS on Azure Stack HCI cluster.

## Before you bein

You need to have the AksHci PowerShell version 1.1.0 or later installed. If you already have the PowerShell module installed, run the following command to find the version.

```powershell
Get-Command -Module AksHci
```

## Create an AKS on Azure Stack HCI cluster

To get started, create an AKS on Azure Stack HCI cluster with a single node pool. The follow example uses the [New-AksHciCluster](new-akshcicluster.md) command to create a new Kubernetes cluster with one Linux node pool named *linuxnodepool* with 1 node. **If you already have a cluster deployed with an older version of AKS on Azure Stack HCI and you wish to continue using your old deployment, you can skip this step. You can still use the new set of node pool commands to add more node pool to your existing cluster.**

```powershell
New-AksHciCluster -name mycluster -nodePoolName linuxnodepool -nodeCount 1 -osType linux
```

> [!NOTE]
> The old parameter set for `New-AksHciCluster` will still be supported. However, it will be deprecated in a future relase.

## Add a node pool

The cluster named *mycluster* created in the pervios step has a single node pool. You can add a second node pool to the existing cluster using the [New-AksHciNodePool](new-akshcinodepool.md) command. the following example creates Windows node pool named *windowsnodepool* with 1 node.

```powershell
New-AksHciNodePool -clusterName mycluster -name windowsnodepool -count 1 -osType windows
```

## Get configuration information of a node pool

To see the configuration information of your node pools, use the [Get-AksHciNodePool](get-akshcinodepool.md) command.

```powershell
Get-AksHciNodePool -clusterName mycluster
```

Example Output
```output
ClusterName  : mycluster
NodePoolName : linuxnodepool
Version      : v1.20.7
OsType       : Linux
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed

ClusterName  : mycluster
NodePoolName : windowsnodepool
Version      : v1.20.7
OsType       : Windows
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

To see the configuration information of one specific node pool, use the `-name` parameter in [Get-AksHciNodePool](get-akshcinodepool.md)

```powershell
Get-AksHciNodePool -clusterName mycluster -name linuxnodepool
```

Example Output
```output
ClusterName  : mycluster
NodePoolName : linuxnodepool
Version      : v1.20.7
OsType       : Linux
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

```powershell
Get-AksHciNodePool -clusterName mycluster -name windowsnodepool
```

Example Output
```output
ClusterName  : mycluster
NodePoolName : windowsnodepool
Version      : v1.20.7
OsType       : Windows
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

> [!NOTE]
> If you use the new parameter sets in `New-AksHciCluster` to deploy a cluster and then run `Get-AksHciCluster` to get the cluster information, the fields `WindowsNodeCount` and `LinuxNodeCount` in the output will return `0`. To get the accurate number of nodes in each node pool, please use the command `Get-AksHciNodePool` with the specified cluster name. 

## Scale a node pool

You can scale the number of nodes up or down in a node pool.

To scale the number of nodes in a node pool, use the [Set-AksHciNodePool](set-akshcinodepool.md) command. The following example scales the number of nodes to 3 in the node pool named *linuxnodepool* in the cluster named *mycluster*.

```powershell
Set-AksHciNodePool -clusterName mycluster -name linuxnodepool -count 3
```

## Scale control plane nodes

The control plane nodes have not changed. The way in which they are created, scaled, and removed remains the same. You will still deploy control plane nodes with the [New-AksHciCluster](new-akshcicluster.md) command with the parameters `controlPlaneNodeCount` and `controlPlaneVmSize` with the default values as 1 and Standard_A4_V2 respectively if no values are given.

You may need to scale the control plane nodes as the workload demand of your applications change. To scale the control plane nodes, use the [Set-AksHciCluster](set-akshcicluster.md) command. The following example scales the control plane nodes to 3 in the existing cluster named *mycluster* that was created in the previous steps.

```powershell
Set-AksHciCluster -name mycluster -controlPlaneNodeCount 3
```

## Delete a node pool

If you need to delete a node pool, use the [Remove-AksHciNodePool](remove-akshcinodepool.md) command. The follow example removes the node pool named *windowsnodepool* in the cluster named *mycluster*.

```powershell
Remove-AksHciNodePool -clusterName mycluster -name windowsnodepool
```



