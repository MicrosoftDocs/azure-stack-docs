---
title: Tutorial - Upgrade a cluster in AKS enabled by Azure Arc
description: In this tutorial, learn how to upgrade an existing cluster in AKS enabled by Arc to the latest available Kubernetes version.
ms.topic: tutorial
ms.date: 01/05/2024
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
author: sethmanheim
# Intent: As an IT Pro, I need step-by-step instructions on how to upgrade an existing cluster to the latest Kubernetes version.
# Keyword: upgrade cluster upgrade Kubernetes
---

# Tutorial: Upgrade Kubernetes in AKS enabled by Azure Arc

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

As part of managing the application and cluster lifecycle, you might want to upgrade to the latest available version of Kubernetes when you're using AKS enabled by Azure Arc.

This tutorial, part seven of seven, describes how to upgrade a Kubernetes cluster. You'll learn how to:

> [!div class="checklist"]
> * Identify current and available Kubernetes versions
> * Upgrade the Kubernetes version of Kubernetes nodes
> * Upgrade the OS version of Kubernetes nodes
> * Upgrade a Kubernetes cluster to the latest version
> * Validate a successful upgrade
> * Remove a Kubernetes cluster

## What are the available update options?

There are several types of updates, which can happen independently from each other and in certain supported combinations:

* [Update the AKS host](update-akshci-host-powershell.md) to the latest version.
* Update an AKS workload cluster to a new Kubernetes version.
* Update the AKS container hosts to a newer version of the operating system.
* Combined update of operating system and Kubernetes version.

All updates are performed in a rolling flow in order to avoid outages in workload availability. When a new Kubernetes worker node with a newer build is brought into the cluster, resources are moved from the old node to the new node. Once this is completed successfully, the old node is decommissioned and removed from the cluster.

The examples in this tutorial assume that the workload cluster, `mycluster`, is currently on Kubernetes version 1.18.8, and uses an operating system version more than 30 days old.

## Before you begin

In previous tutorials, you learned how to package an application into a container image, upload it to the Azure Container Registry, and create a Kubernetes cluster. Then you deployed the application to the cluster. If you haven't completed these steps, start with [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-application.md).

## Update the Kubernetes version of a workload cluster

You must upgrade the PowerShell modules and the AKS host first, before updating the Kubernetes version.

> [!IMPORTANT]
> Updating a workload cluster to a newer version of Kubernetes only works if the target Kubernetes version is supported by the current operating system version. To check for the supported operating system and Kubernetes version combinations, use the `Get-AksHciUpdates` command.

Use the following steps to update the Kubernetes version:

1. To get the current version of your workload cluster, run the following command:

   ```powershell
   Get-AksHciCluster
   ```

   ```output
   ProvisioningState     : provisioned
   KubernetesVersion     : v1.20.7
   NodePools             : linuxnodepool
   WindowsNodeCount      : 0
   LinuxNodeCount        : 0
   ControlPlaneNodeCount : 1
   Name                  : mycluster   
   ```

1. To get the available Kubernetes versions, run the following command:

   ```powershell
   Get-AksHciKubernetesVersion
   ```

   ```output
   OrchestratorType OrchestratorVersion OS      IsPreview
   ---------------- ------------------- --      ---------
   Kubernetes       v1.19.9             Linux       False
   Kubernetes       v1.19.11            Linux       False
   Kubernetes       v1.20.5             Linux       False
   Kubernetes       v1.20.7             Linux       False
   Kubernetes       v1.21.1             Linux       False
   Kubernetes       v1.19.9             Windows     False
   Kubernetes       v1.19.11            Windows     False
   Kubernetes       v1.20.5             Windows     False
   Kubernetes       v1.20.7             Windows     False
   Kubernetes       v1.21.1             Windows     False
   ```

   The output shows the Kubernetes versions and operating systems on which the version is available. You can see that there are more upgrade versions available. However, when upgrading clusters, you can't skip versions. For example, v1.18.xx --> v1.19.xx is allowed, but v1.18.xx --> v1.20.xx is not.

1. Initiate the Kubernetes version update

   To update the Kubernetes version, run the following command:

   ```powershell
   Update-AksHciCluster -name mycluster -kubernetesVersion v1.21.1
   ```

   > [!NOTE]
   > This command only updates the existing cluster nodes in the `mycluster` workload cluster to the new version of Kubernetes.

## Update only the operating system version

> [!IMPORTANT]
> You can update a workload cluster to a newer version of the operating system without changing the Kubernetes version, but that works only if the new operating system version does not require a different Kubernetes version.

Use the steps in the following example to update the OS version:

1. To get available workload cluster updates, run the following command:

   ```powershell
   Get-AksHciClusterUpdates -name mycluster
   ```

   ```output
   details                             kubernetesversion                operatingsystemversion
   -------                             -----------------                ----------------------
   This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.19.9  @{mariner=April 2021; windows=April 2021}
   This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.20.5  @{mariner=April 2021; windows=April 2021}
   ```

1. To initiate the operating system version update, run the following command:

   ```powershell
   Update-AksHciCluster -clusterName mycluster -kubernetesVersion v1.21.1 -operatingSystem
   ```

## Update both the OS and the Kubernetes version

> [!IMPORTANT]
> Updating a workload cluster to a newer version of the operating system and Kubernetes version is supported.

The following example assumes there's a new Kubernetes version available, and the current version number is v1.20.7.

1. To get all available workload cluster updates, run the following command:

   ```powershell
   Get-AksHciClusterUpdates -name mycluster
   ```

   ```output
   details                             kubernetesversion                  operatingsystemversion
   -------                             -----------------                  ----------------------
   This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.19.9    @{mariner=April 2021; windows=April 2021}
   This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.20.5    @{mariner=April 2021; windows=April 2021}
   ```

1. To initiate the workload cluster update, run the following command:

   ```powershell
   Update-AksHciCluster -name mycluster -kubernetesVersion v1.21.1
   ```

## Validate an upgrade

Confirm that the upgrade was successful using the [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) command as follows:

```powershell
Get-AksHciCluster -name mycluster
```

The following example output shows the cluster runs *KubernetesVersion v1.21.1*:

```output
ProvisioningState     : provisioned
KubernetesVersion     : v1.21.1
NodePools             : linuxnodepool
WindowsNodeCount      : 0
LinuxNodeCount        : 0
ControlPlaneNodeCount : 1
Name                  : mycluster
```

## Delete the cluster

As this tutorial is the last part of the series, you might want to delete the cluster. Use the [Remove-AksHciCluster](./reference/ps/remove-akshcicluster.md) command to remove the resource group, container service, and all related resources:

```powershell
Remove-AksHciCluster -name mycluster
```

## Next steps

In this tutorial, you upgraded a Kubernetes cluster on Windows Server. You learned how to:

> [!div class="checklist"]
> * Identify current and available Kubernetes versions
> * Upgrade the Kubernetes version of Kubernetes nodes
> * Upgrade the OS version of Kubernetes nodes
> * Upgrade a Kubernetes cluster to the latest version
> * Validate a successful upgrade

For more information about AKS enabled by Azure Arc, see the [AKS overview](./overview.md) and [clusters and workloads](./kubernetes-concepts.md).
