---
title: Upgrade the Kubernetes version of AKS workload clusters using PowerShell
description: Learn how to upgrade the Kubernetes version of AKS workload clusters on Azure Stack HCI using PowerShell
ms.topic: article
ms.date: 05/20/2021
author: jessicaguan
ms.author: jeguan
---

# Upgrade the Kubernetes version of AKS clusters on Azure Stack HCI using PowerShell

This article describes the following update options for AKS workload clusters on Azure Stack HCI: 
- Update an AKS on Azure Stack HCI workload cluster to a new Kubernetes version.
- [Update the container hosts](update-akshci-host-powershell.md) of AKS workload clusters to a newer version of the operating system.
- Combined update of the operating system and Kubernetes version of AKS workload clusters.
- Update AKS workload clusters using Windows Admin Center

We recommend updating an AKS workload cluster on Azure Stack HCI at least once every 60 days. New updates are available every 30 days. All updates are done in a rolling update flow to avoid outages in workload availability. When you bring a _new_ node with a newer build into the cluster, resources move from the _old_ node to the _new_ node, and when the resources are successfully moved, the _old_ node is decommissioned and removed from the cluster.

> [!Important]
> Updating the AKS on Azure Stack HCI host is the first step in any update flow and must be initiated before running [`Update-AksHciCluster`](./update-akshcicluster.md). For information on updating the AKS host, visit [how to update AKS host on Azure Stack HCI](./update-akshci-host-powershell.md). 


## Get available Kubernetes versions
Use the `Get-AksHciKubernetesVersion` command to check for supported operating system and Kubernetes version combinations.

```powershell
Get-AksHciKubernetesVersion
```
Sample output:
```Output
OrchestratorType OrchestratorVersion OS      IsPreview
---------------- ------------------- --      ---------
Kubernetes       v1.18.14            Linux       False
Kubernetes       v1.18.17            Linux       False
Kubernetes       v1.19.7             Linux       False
Kubernetes       v1.19.9             Linux       False
Kubernetes       v1.20.2             Linux       False
Kubernetes       v1.20.5             Linux       False
Kubernetes       v1.18.14            Windows     False
Kubernetes       v1.18.17            Windows     False
Kubernetes       v1.19.7             Windows     False
Kubernetes       v1.19.9             Windows     False
Kubernetes       v1.20.2             Windows     False
Kubernetes       v1.20.5             Windows     False
```

## Get available workload cluster updates
The example below assumes that the workload cluster `myCluster` is currently on Kubernetes version 1.19.7.
```powershell
Get-AksHciClusterUpdates -name myCluster
```

```output
details                                                     kubernetesversion operatingsystemversion
-------                                                     ----------------- ----------------------
This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.19.9           @{mariner=April 2021; windows=April 2021}
This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.20.5           @{mariner=April 2021; windows=April 2021}
```

As seen from the output above, you can either perform a patch update to v1.19.9 or a minor update to v1.20.5.

## Update the Kubernetes version of a workload cluster using PowerShell

### Perform a minor Kubernetes update and update the OS version
Use the [Update-AksHciCluster](update-akshcicluster.md) PowerShell command to perform a Kubernetes minor update and also update the operating system version of your container host OS. We recommend updating the OS version every time you update the Kubernetes version of your cluster.

```powershell
Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.20.5 -operatingSystem
```

### Perform a minor Kubernetes update without updating the OS version
Use the [Update-AksHciCluster](update-akshcicluster.md) PowerShell command to perform a Kubernetes minor update without updating the operating system version of your container host OS. Updating a workload cluster to a newer version of Kubernetes without updating the OS version will only work if the target Kubernetes version is supported by the current operating system version.

```powershell
Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.20.5
```

### Perform a patch Kubernetes update and update the OS version
Use the [Update-AksHciCluster](update-akshcicluster.md) PowerShell command to perform a Kubernetes patch update and also update the operating system version of your container host OS. We recommend updating the OS version every time you update the Kubernetes version of your cluster.

```powershell
Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.19.9 -operatingSystem
```

### Perform a patch Kubernetes update without updating the OS version
Use the [Update-AksHciCluster](update-akshcicluster.md) PowerShell command to perform a Kubernetes patch update without updating the operating system version of your container host OS. Updating a workload cluster to a newer version of Kubernetes without updating the OS version will only work if the target Kubernetes version is supported by the current operating system version.

```powershell
Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.19.9
```

## Update the container operating system version without updating the Kubernetes version

Updating a workload cluster to a newer version of the operating system without changing the Kubernetes version will only work if the new operating system version does not require a different Kubernetes version. Run the `Update-AksHciCluster` command by specifying the `operatingSystem` flag. This flag updates the container hosts of AKS workload clusters to a newer version of the operating system. When running `Update-AksHciCluster`, make sure the `kubernetesVersion` specifies the current Kubernetes version of your cluster to only update the container hosts' OS of your cluster. The example below assumes that the workload cluster `myCluster` is currently on Kubernetes version 1.19.7 and has an operating system version that's more than 30 days old.

```powershell
Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.19.7 -operatingSystem
```

## Next steps

In this article, you learned how to update AKS workload clusters on Azure Stack HCI. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
