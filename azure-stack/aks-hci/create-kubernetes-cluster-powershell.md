---
title: Quickstart to create Kubernetes clusters on Azure Stack HCI using Windows PowerShell
description: Learn how to create Kubernetes clusters on Azure Stack HCI with Windows PowerShell
author: jessicaguan
ms.topic: quickstart
ms.date: 09/22/2020
ms.author: jeguan
---

# Quickstart: Create Kubernetes clusters on Azure Stack HCI using Windows PowerShell

> Applies to: AKS on Azure Stack HCI, AKS runtime on Windows Server 2019 Datacenter

In this quickstart, you learn how to use Windows PowerShell to create a Kubernetes cluster on Azure Stack HCI. You then learn how to scale your Kubernetes cluster and upgrade the Kubernetes version of your cluster. To instead use Windows Admin Center, see [Set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center](setup.md).

## Before you begin

 - Make sure you have an Azure Stack Kubernetes host set up. If you don't, see [Quickstart: Set up an Azure Kubernetes Service host on Azure Stack HCI using PowerShell](./setup-powershell.md).
 - Make sure you have the latest Aks-Hci PowerShell module installed. If don't, see [Download and install the AksHci PowerShell module](./setup-powershell.md#step-1-download-and-install-the-akshci-powershell-module).

## Step 1: Create a Kubernetes cluster

After installing your Azure Kubernetes Service host, you are ready to deploy a Kubernetes cluster.

Open PowerShell as an administrator and run the following command.

   ```powershell
   New-AksHciCluster -clusterName <String>
                    [-kubernetesVersion <String>]
                    [-controlPlaneNodeCount <int>]
                    [-linuxNodeCount <int>]
                    [-windowsNodeCount <int>]
                    [-controlPlaneVmSize <VmSize>]
                    [-loadBalancerVmSize <VmSize>]
                    [-linuxNodeVmSize <VmSize>]
                    [-windowsNodeVmSize <VmSize>]
   ```

### Example

   ```powershell
   New-AksHciCluster -clusterName mynewcluster -kubernetesVersion v1.18.8 -controlPlaneNodeCount 1 -linuxNodeCount 1 -windowsNodeCount 0 
   ```

### Required parameters

`-clusterName`

The alphanumeric name of your Kubernetes cluster.

### Optional parameters

`-kubernetesVersion`

The version of Kubernetes that you want to deploy. Default is v1.18.8. To get a list of available versions, run `Get-AksHciKubernetesVersion`.

`-controlPlaneNodeCount`

The number of nodes in your control plane. Default is 1.

`-linuxNodeCount`

The number of Linux nodes in your Kubernetes cluster. Default is 1.

`-windowsNodeCount`

The number of Windows nodes in your Kubernetes cluster. Default is 0. You can only deploy Windows nodes if you are running Kubernetes v1.18.8.

`-controlPlaneVmSize`

The size of your control plane VM. Default is Standard_A2_v2. To get a list of available VM sizes, run `Get-AksHciVmSize`.

`-loadBalancerVmSize`

The size of your load balancer VM. Default is Standard_A2_V2. To get a list of available VM sizes, run `Get-AksHciVmSize`.

`-linuxNodeVmSize`

The size of your Linux Node VM. Default is  Standard_K8S3_v1. To get a list of available VM sizes, run `Get-AksHciVmSize`.

`-windowsNodeVmSize`

The size of your Windows Node VM. Default is  Standard_K8S3_v1. To get a list of available VM sizes, run `Get-AksHciVmSize`.

### Check your deployed clusters

To get a list of your deployed Azure Kubernetes Service host and Kubernetes clusters, run the following command.

```powershell
Get-AksHciCluster
```

## Step 2: Scale a Kubernetes cluster

If you need to scale your cluster up or down, you can change the number of control plane nodes, Linux worker nodes, or Windows worker nodes.

To scale control plane nodes, run the following command.

```powershell
Set-AksHciClusterNodeCount –clusterName <String>
                           -controlPlaneNodeCount <int>
```

To scale the worker nodes, run the following command.

```powershell
Set-AksHciClusterNodeCount –clusterName <String>
                           -linuxNodeCount <int>
                           -windowsNodeCount <int>
```

The control plane nodes and the worker nodes must be scaled independently.

### Example

```powershell
Set-AksHciClusterNodeCount –clusterName mynewcluster -controlPlaneNodeCount 3
```

```powershell
Set-AksHciClusterNodeCount –clusterName mynewcluster -linuxNodeCount 2 -windowsNodeCount 2 
```

## Step 3: Upgrade Kubernetes version

To see the list of available Kubernetes versions, run the following command.

```powershell
Get-AksHciKubernetesVersion
```

To update to the next Kubernetes version, run the following command.

```powershell
Update-AksHciCluster -clusterName <String>
                     [-patch]
```
Every Kubernetes version has a major release, a minor version, and a patch version. For example, in v1.18.6, 1 is the major release, 18 is the minor version, and 6 is the patch version. Over time, AKS-HCI will support one major release, three minor releases, and two patches per minor release for a total of 6 supported versions. However, for this preview release, we support a total of 4 releases - v1.16.10, v1.16.15, v1.17.11, v1.18.8. 

When the parameter `patch` is added while running `Update-AksHciCluster`, the command upgrades to the next patch version (if any) for the minor version. When the command is run without the parameter `patch`, the default upgrade experience is to the next minor release. To make this easier, the following table contains all possible update experiences:

| Current release           | Kubernetes updated version without -patch         | Kubernetes updated version with -patch
| ---------------------------- | ------------ | -------------------------------- |
| v1.16.10           |     v1.17.11      | v1.16.15
| v1.16.15            | v1.17.11 | in place add-on upgrade
| v1.17.11           |  v1.18.8          | in place add-on upgrade
| v1.18.8             | in place add-on upgrade   | in place add-on upgrade

In place add-on upgrade updates all the Kubernetes add-ons like CSI that AKS-HCI manages for you. This upgrade does not change the OS version of the node. It also does not change the Kubernetes version.

### Example - Upgrade Kubernetes version to the next minor version

```powershell
Update-AksHciCluster -clusterName mynewcluster
```

### Example - Upgrade Kubernetes version to the next patch version

```powershell
Update-AksHciCluster -clusterName mynewcluster -patch
```


## Step 4: Access your clusters using kubectl

To access your Kubernetes clusters using kubectl, run the following command. This will use the specified cluster's kubeconfig file as the default kubeconfig file for kubectl.

```powershell
Get-AksHciCredential -clusterName <String>
                     [-outputLocation <String>]
```

### Example

```powershell
Get-AksHciCredential -clusterName mynewcluster
```

### Required Parameters

`clusterName`

The name of the cluster.

### Optional Parameters

`outputLocation`

The location were you want the kubeconfig downloaded. Default is `%USERPROFILE%\.kube`.

## Delete a Kubernetes cluster

If you need to delete a Kubernetes cluster, run the following command.

```powershell
Remove-AksHciCluster -clusterName
```

### Example

```powershell
Remove-AksHciCluster -clusterName mynewcluster
```

## Get logs

To get logs from your all your pods, run the following command. This command will create an output zipped folder called `akshcilogs` in the path `C:\wssd\akshcilogs`.

```powershell
Get-AksHciLogs
```

In this quickstart, you learned how to create, scale, and upgrade the Kubernetes version of a cluster using PowerShell.

## Next steps

- [Connect your clusters to Azure Arc for Kubernetes](./connect-to-arc.md).
- [Deploy a Linux application on your Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md).
