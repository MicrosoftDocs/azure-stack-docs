---
title: Upgrade the Kubernetes version on AKS on Azure Stack HCI
description: Learn how to upgrade the Kubernetes version on AKS on Azure Stack HCI host and workload clusters
ms.topic: article
ms.date: 03/02/2021
author: jessicaguan
ms.author: jeguan
---

# Upgrade the Kubernetes version on AKS on Azure Stack HCI

After deploying Azure Kubernetes Service on Azure Stack HCI, upgrades to the host and workload clusters are managed by the customer. During an upgrade, you may not be able to perform new cluster operations. After the upgrade completes, you will not be able to revert to older versions.

## Upgrade the Azure Kubernetes Service on Azure Stack HCI host

We recommend upgrading the Azure Kubernetes Service on Azure Stack HCI host every 30 days. If the host is not running on the latest version, then support could be lost in your deployment.

Use the [Get-AksHciUpdates](get-akshciupdates.md) command to see the available Kubernetes updates for Azure Kubernetes Service on Azure Stack HCI.

```powershell
Get-AksHciUpdates
```

Use the [Update-AksHci](update-akshci.md) command to upgrade the host to the latest Kubernetes version.

```powershell
Update-AksHci
```

## Upgrade the Azure Kubernetes Service on Azure Stack HCI workload clusters

We recommend upgrading a workload cluster at least once every 60 days. Upgrades are available every 30 days. 

Use the [Get-AksHciClusterUpgrades](get-akshciclusterupgrades.md) command to see any available upgrades for your Kubernetes cluster. The following example gets the available upgrades for a cluster named *mycluster*.

```powershell
Get-AksHciClusterUpgrades -name mycluster
```

Use the [Update-AksHciCluster](update-akshcicluster.md) command to update a workload cluster. The following example upgrades a cluster named *mycluster* to the v1.18.8 version. You can change the value for the parameter `-kubernetesVersion` to the version you would like to upgrade to.

```powershell
Update-AksHciCluster -name mycluster -kubernetesVersion v1.18.8
``` 

If you would like to also upgrade to the latest operating system version, run the following command:

```powershell
Update-AksHciCluster -name mycluster -kubernetesVersion v1.18.8 -operatingSystem
```

The `-operatingSystem` parameter will automatically update the operating system of the specified cluster to the latest version.


## Next steps

In this article, you learned how to upgrade the Azure Kubernetes Service on Azure Stack HCI host and clusters. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
