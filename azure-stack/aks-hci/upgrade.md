---
title: Upgrade the Kubernetes version of AKS workload clusters
description: Learn how to upgrade the Kubernetes version of AKS workload clusters on Azure Stack HCI
ms.topic: article
ms.date: 03/02/2021
author: jessicaguan
ms.author: jeguan
---

# Update the Kubernetes version of AKS clusters on Azure Stack HCI

> [!IMPORTANT]
> The March release of AKS on Azure Stack HCI cannot be updated from a pervious release. If you want to deploy the March release on your Azure Stack HCI cluster, you must start a fresh installation. You can deploy using [PowerShell](kubernetes-walkthrough-powershell.md) or [Windows Admin Center](./setup.md).

This article describes the following update options for AKS workload clusters on Azure Stack HCI: 
- Update an AKS on Azure Stack HCI workload cluster to a new Kubernetes version.
- Update the container hosts of AKS workload clusters to a newer version of the operating system.
- Combined update of the operating system and Kubernetes version of AKS workload clusters.

We recommend updating an AKS workload cluster on Azure Stack HCI at least once every 60 days. New updates are available every 30 days.
All updates are done in a rolling update flow. When a *new* node with the newer build is brought into the cluster, resources are moved from the *old* node to the *new* node, and the *old* node is decommissioned.

> [!Important]
> Updating the AKS on Azure Stack HCI host is the first step in any update flow and must be initiated before running [`Update-AksHciCluster`](./update-akshcicluster.md). For information on updating the AKS host, visit [how to update AKS host on Azure Stack HCI](./update-aks-hci-concepts.md). 


## Get available Kubernetes versions
Use the `Get-AksHciKubernetesVersion` command to check for supported operating system and Kubernetes version combinations.

```powershell
PS C:\> Get-AksHciKubernetesVersion
```

```Output
Linux {v1.16.10, v1.16.15, v1.17.11, v1.17.13...}
Windows {v1.18.8, v1.18.10}
```

## Update the Kubernetes version of a workload cluster

> [!Important]
> Updating a workload cluster to a newer version of Kubernetes will only work if the target Kubernetes version is supported by the current operating system version.

#### Get available workload cluster updates
The example below assumes that the workload cluster `mycluster` is currently on Kubernetes version 1.17.11.
```powershell
PS C:\> Get-AksHciClusterUpdates -name mycluster
```

```output
details                                                     kubernetesversion operatingsystemversion
-------                                                     ----------------- ----------------------
This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.17.13          @{mariner=January 2021; windows=January 2021}
This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.18.10          @{mariner=January 2021; windows=January 2021}
```

As seen from the output above, you can either update your cluster to v1.17.13 or to v1.18.10.

#### Initiate the Kubernetes version update
Use the [Update-AksHciCluster](update-akshcicluster.md) PowerShell command to update myCluster from v1.17.11 to v1.18.10  without changing the container operating system of the cluster.
```powershell
PS C:\> Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.18.10
```

## Update the container operating system version 

> [!Important]
> Updating a workload cluster to a newer version of the operating system without changing the Kubernetes version will only work if the new operating system version does not require a different Kubernetes version.

Run the `Update-AksHciCluster` command by specifying the `operatingSystem` flag. This flag updates the container hosts of AKS workload clusters to a newer version of the operating system. When running `Update-AksHciCluster`, make sure the `kubernetesVersion` specifies the current Kubernetes version of your cluster to only update the container hosts' OS of your cluster. The example below assumes that the workload cluster `myCluster` is currently on Kubernetes version 1.18.8 and has an operating system version that's more than 30 days old.

```powershell
PS C:\> Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.18.8 -operatingSystem
```

## Update the OS version of a workload cluster

> [!Important]
> Updating a workload cluster to a newer version of the operating system and Kubernetes version is allowed.

#### Get all available workload cluster updates
The examples below assume that the workload cluster `myCluster` is currently on Kubernetes version 1.18.8 and has an operating system version that's more than 30 days old.

```powershell
PS C:\> Get-AksHciClusterUpdates -name mycluster
```

```output
details                                                     kubernetesversion operatingsystemversion
-------                                                     ----------------- ----------------------
This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.18.10          @{mariner=January 2021; windows=January 2021}
```

#### Initiate the workload cluster update
You can run the [Update-AksHciCluster](update-akshcicluster.md) PowerShell command with the new Kubernetes version and the `-operatingSystem` flag to update the workload cluster's Kubernetes version as well as the container hosts' operating systems.

```powershell
PS C:\> Update-AksHciCluster -clusterName mycluster -operatingSystem
```

## Update the Kubernetes version of a workload cluster using Windows Admin Center
The Kubernetes version of a workload cluster can also be updated through Windows Admin Center. To update the Kubernetes version, follow these steps: 

1. On the Windows Admin Center connections page, connect to your management cluster.
2. Select the **Azure Kubernetes Service** tool from the tools list. When the tool loads, you will be presented with the Overview page.
3. Select the workload cluster you wish to update.
4. Select **Updates** to navigate to the Updates page.
5. Select **Update now** to upgrade your Kubernetes version. 

## Next steps

In this article, you learned how to update AKS workload clusters on Azure Stack HCI. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
