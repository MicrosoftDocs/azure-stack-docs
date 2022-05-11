---
title: Upgrade the Kubernetes version of AKS workload clusters using PowerShell
description: Learn how to upgrade the Kubernetes version of AKS workload clusters on Azure Stack HCI using PowerShell
ms.topic: article
ms.date: 04/15/2022
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
# Intent: As an IT Pro, I want to learn how to use PowerShell to upgrade the Kubernetes version of AKS workload clusters.
# Keyword: Upgrade the Kubernetes version 
---

# Upgrade the Kubernetes version of Azure Kubernetes Service clusters on Azure Stack HCI using PowerShell

There are two types of updates available for an Azure Kubernetes Service (AKS) workload cluster on Azure Stack HCI: 
- Updating the Kubernetes version of an AKS cluster
- Updating the operating system version of an AKS cluster without updating the Kubernetes version 

> [!NOTE]
> You can also use Windows Admin Center to [upgrade AKS workload clusters](upgrade-kubernetes.md).

We recommend updating an AKS workload cluster on Azure Stack HCI at least once every 60 days. New  Kubernetes version updates are available every 30 days. All updates are done in a rolling update flow to avoid outages in workload availability. When you bring a _new_ node with a newer build into the cluster, resources move from the _old_ node to the _new_ node. When the resources are successfully moved, the _old_ node is decommissioned and removed from the cluster.

> [!Important]
> Updating the AKS on Azure Stack HCI and Windows Server host is the first step in any update flow and must be initiated before running [`Update-AksHciCluster`](./reference/ps/update-akshcicluster.md). For information on updating the AKS host, see [update the AKS host on Azure Stack HCI](./update-akshci-host-powershell.md). 

## Get available Kubernetes versions
Use the `Get-AksHciKubernetesVersion` command to check for supported Kubernetes versions.

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

## Upgrade the Kubernetes version of a workload cluster using PowerShell

Use the [Update-AksHciCluster](./reference/ps/update-akshcicluster.md) PowerShell command to perform a Kubernetes minor update. This command also updates the operating system version of your container host OS.

```powershell
Update-AksHciCluster -name myCluster -kubernetesVersion v1.20.5
```

## Update the container operating system version without updating the Kubernetes version

Keep in mind that if you decide to upload a workload cluster to a newer version of the operating system without changing the Kubernetes version, it will not work unless the new operating system version does not require a different Kubernetes version. Run the [Update-AksHciCluster](./reference/ps/update-akshcicluster.md) command and specify the `operatingSystem` parameter to update the container hosts of AKS workload clusters to a newer version of the operating system. The example below assumes that the workload cluster `myCluster` currently has an operating system version that's more than 30 days old.

```powershell
Update-AksHciCluster -name myCluster -operatingSystem
```

## Next steps

In this article, you learned how to update AKS workload clusters on Azure Stack HCI. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).