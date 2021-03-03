---
title: Quickstart to create Kubernetes clusters on Azure Stack HCI using Windows PowerShell
description: Learn how to create Kubernetes clusters on Azure Stack HCI with Windows PowerShell
author: jessicaguan
ms.topic: quickstart
ms.date: 2/10/2021
ms.author: jeguan
---

# Quickstart: Create Kubernetes clusters on Azure Stack HCI using Windows PowerShell

> Applies to: AKS on Azure Stack HCI, AKS runtime on Windows Server 2019 Datacenter

In this quickstart, you learn how to use Windows PowerShell to create an Azure Kubernetes cluster on Azure Stack HCI. You then learn how to scale your Kubernetes cluster and upgrade the Kubernetes version of your cluster. To instead use Windows Admin Center, see [Set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center](setup.md).

## Before you begin

 - Make sure you have an Azure Stack Kubernetes host set up. If you don't, see [Quickstart: Set up an Azure Kubernetes Service host on Azure Stack HCI using PowerShell](./setup-powershell.md).
 - Make sure you have the latest Aks-Hci PowerShell module installed. If you don't, see [Download and install the AksHci PowerShell module](./setup-powershell.md#step-1-download-and-install-the-akshci-powershell-module).

## Step 1: Create a Kubernetes cluster

After installing your Azure Kubernetes Service host, you are ready to deploy a Kubernetes cluster.

Open PowerShell as an administrator and run the following [New-AksHciCluster](./new-akshcicluster) command.

```powershell
New-AksHciCluster -name mycluster
```

### Check your deployed clusters

To get a list of your deployed Azure Kubernetes Service host and Kubernetes clusters, run the following command.

```powershell
Get-AksHciCluster
```

## Step 2: Scale a Kubernetes cluster

If you need to scale your cluster up or down, you can change the number of control plane nodes, Linux worker nodes, or Windows worker nodes using the [Set-AksHciClusterNodeCount](./set-akshciclusternodecount) command.

To scale control plane nodes, run the following command.

```powershell
Set-AksHciClusterNodeCount –name mycluster -controlPlaneNodeCount 3
```

To scale the worker nodes, run the following command.

```powershell
Set-AksHciClusterNodeCount –name mycluster -linuxNodeCount 3 -windowsNodeCount 1
```

The control plane nodes and the worker nodes must be scaled independently.

## Step 3: Upgrade Kubernetes version

To see if there are any upgrades available for your Kubernetes cluster, run the following command.

```powershell
Get-AksHciClusterUpgrades -name mycluster
```

To update to the latest Kubernetes version, run the following command.

```powershell
Update-AksHciCluster -name mycluster -kubernetesVersion <k8s version>
```

Running this command without specifying the Kubernetes version will upgrade the cluster to the latest version. If you want to upgrade to a different version that is not the latest, use the [Update-AksHciCluster](./update-akshcicluster) with the `-kubernetesVersion` parameter and your desired version as the value (that is, v1.18.8).

## Step 4: Access your clusters using kubectl

To access your Kubernetes clusters using kubectl, run the [Get-AksHciCredential](./get-akshcicredential) command. This will use the specified cluster's kubeconfig file as the default kubeconfig file for kubectl.

```powershell
Get-AksHciCredential -name mycluster
```

## Delete a Kubernetes cluster

If you need to delete a Kubernetes cluster, run the following command.

```powershell
Remove-AksHciCluster -name mycluster
```

## Get logs

To get logs from your all your pods, run the [Get-AksHciLogs](./get-akshcilogs) command. This command will create an output zipped folder called `akshcilogs.zip` in your working directory. The full path to the `akshcilogs.zip` folder will be the output after running the command below.

```powershell
Get-AksHciLogs
```

In this quickstart, you learned how to create, scale, and upgrade the Kubernetes version of a cluster using PowerShell.

## Next steps

- [Connect your clusters to Azure Arc for Kubernetes](./connect-to-arc.md).
- [Deploy a Linux application on your Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md).
