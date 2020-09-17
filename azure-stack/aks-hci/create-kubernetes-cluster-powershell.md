---
title: Quickstart to create Kubernetes clusters on Azure Stack HCI using Windows PowerShell
description: Learn how to create Kubernetes clusters on Azure Stack HCI with Windows PowerShell
author: jessicaguan
ms.topic: quickstart
ms.date: 09/21/2020
ms.author: jeguan
---

# Quickstart: Create Kubernetes clusters on Azure Stack HCI using Windows PowerShell

> Applies to: Azure Stack HCI

In this quickstart, you'll learn how to use Windows PowerShell to create a Kubernetes cluster on Azure Stack HCI.

## Before you begin

Before you begin, make sure you:

- Have a 2-4 node Azure Stack HCI cluster or a single node Azure Stack HCI. **We recommend having a 2-4 node Azure Stack HCI cluster.** If you don't, follow instructions on how to create one [here](./system-requirements.md).

## Step 1: Create a Kubernetes cluster

After installing your Azure Kubernetes Service host, you are ready to deploy a Kubernetes cluster.

Open PowerShell as an administrator and run the following command.

   ```powershell
   New-AksHciCluster -clusterName
                    [-kubernetesVersion]
                    [-controlPlaneNodeCount]
                    [-linuxNodeCount]
                    [-windowsNodeCount]
                    [-controlPlaneVmSize]
                    [-loadBalancerVmSize]
                    [-linuxNodeVmSize]
                    [-windowsNodeVmSize]
   ```

### Required parameters

`-clusterName`

The alphanumeric name of your Kubernetes cluster.

### Optional parameters

`-kubernetesVersion`

The version of Kubernetes that you want to deploy. Default is v1.18.6. To get a list of available versions, run `Get-AksHciKubernetesVersion`.

`-controlPlaneNodeCount`

The number of nodes in your control plane. Default is 1.

`-linuxNodeCount`

The number of Linux nodes in your Kubernetes cluster. Default is 1.

`-windowsNodeCount`

The number of Windows nodes in your Kubernetes cluster. Default is 0.

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
Set-AksHciClusterNodeCount –clusterName
                           -controlPlaneNodeCount
```

To scale the worker nodes, run the following command.

```powershell
Set-AksHciClusterNodeCount –clusterName
                           -linuxNodeCount
                           -windowsNodeCount
```

The control plane nodes and the worker nodes must be scaled independently.

## Step 3: Upgrade Kubernetes version

To see the current Kubernetes version you're running, run the following command.

```powershell
Get-AksHciKubernetesVersion
```

To upgrade to the next Kubernetes version, run the following command.

```powershell
Update-AksHciCluster -clusterName
```

If you want to use Windows nodes, the minimum required version is v1.1.8.6.

## Step 4: Access your clusters using kubectl

To access your Azure Kubernetes Service host or Kubernetes cluster using kubectl, run the following command. This will use the specified cluster's kubeconfig file as the default kubeconfig file for kubectl.

```powershell
Set-AksHciKubeConfig -clusterName
```

## Delete a Kubernetes cluster

If you need to delete a Kubernetes cluster, run the following command.

```powershell
Remove-AksHciCluster -clusterName
```

## Get logs

To get logs from your all your pods, run the following command. This command will create an output zipped folder called `akshcilogs` in the path `C:\wssd\akshcilogs`.

```powershell
Get-AksHciLogs
```

In this quickstart, you learned how to create, scale, and upgrade a Kubernetes cluster with PowerShell.

## Next steps

- Connect your clusters to Azure Arc for Kubernetes with [these instructions](./connect-to-arc.md).
- Deploy a Linux application with [these instructions](./deploy-linux-application.md).
- Deploy a Windows application with [these instructions](./deploy-windows-application.md).
