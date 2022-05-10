---
title: Tutorial - Upgrade a cluster in Azure Kubernetes Service on Azure Stack HCI
description: In this tutorial, learn how to upgrade an existing cluster to the latest available Kubernetes version.
services: container-service
ms.topic: tutorial
ms.date: 07/02/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
author: mattbriggs
# Intent: As an IT Pro, I need step-by-step instructions on how to upgrade an existing AKS on Azure Stack HCI and Windows Server cluster to the latest Kubernetes version.
# Keyword: upgrade cluster upgrade Kubernetes
---

# Tutorial: Upgrade Kubernetes in Azure Kubernetes Service on Azure Stack HCI

As part of managing the application and cluster lifecycle, you may wish to upgrade to the latest available version of Kubernetes.

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

- [Update the AKS on Azure Stack HCI and Windows Server host](update-akshci-host-powershell.md) to the latest version.
- Update an AKS on Azure Stack HCI and Windows Server workload cluster to a new Kubernetes version.
- Update the AKS on Azure Stack HCI and Windows Server container hosts to a newer version of the operating system.
- Combined update of operating system and Kubernetes version.

All updates are performed in a rolling flow in order to avoid outages in workload availability. When a _new_ Kubernetes worker node with a newer build is brought into the cluster, resources are moved from the _old_ node to the _new_ node.  Once this is completed successfully, the _old_ node is decommissioned and removed from the cluster.

The examples in this tutorial assume that the workload cluster, `mycluster`, is currently on Kubernetes version 1.18.8, and uses an operating system version more than 30 days old.

## Before you begin

In previous tutorials, you learned how to package an application into a container image, upload it to the Azure Container Registry, and create an AKS cluster. Then you deployed the application to the AKS on Azure Stack HCI and Windows Server cluster. If you haven't completed these steps, start with [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-application.md).

## Update the Kubernetes version of a workload cluster

You must upgrade the PowerShell modules and the AKS on Azure Stack HCI and Windows Server host first before updating the Kubernetes version.

> [!Important]
> Updating a workload cluster to a newer version of Kubernetes works *only* if the target Kubernetes version is supported by the current operating system version. To check for the supported operating system and Kubernetes version combinations, use the `Get-AksHciUpdates` command.

### Update the Kubernetes version of a workload cluster: Example

Use the following steps to update the Kubernetes version:

1. To get the current version of your workload cluster, run the following command:

   ```powershell
   Get-AksHciCluster
   ```

   **Output**
   ```
   ProvisioningState     : provisioned
   KubernetesVersion     : v1.20.7
   NodePools             : linuxnodepool
   WindowsNodeCount      : 0
   LinuxNodeCount        : 0
   ControlPlaneNodeCount : 1
   Name                  : mycluster   
    ```

2. To get the available Kubernetes versions, run the following command:

   ```powershell
   PS C:\> Get-AksHciKubernetesVersion
   ```

   **Output**
   ```
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

   The output shows the Kubernetes versions and operating systems that the version is available on. You can see that there are more upgrade versions available. However, when upgrading clusters, you cannot skip versions. For example, v1.18.xx --> v1.19.xx is allowed, but v1.18.xx --> v1.20.xx is not.

3. Initiate the Kubernetes version update

   To update the Kubernetes version, run the following command:

   ```powershell
   PS C:\> Update-AksHciCluster -name mycluster -kubernetesVersion v1.21.1
   ```

   > [!Note]
   > This command only updates the existing cluster nodes in the `mycluster` workload cluster to the new version of Kubernetes.

## Update the operating system version only

> [!Important]
> You can update a workload cluster to a newer version of the operating system without changing the Kubernetes version, but it works only if the new operating system version does not require a different Kubernetes version.

### Update only the operating system: Example

Use the steps in the following example to update the OS version:

1. To get available workload cluster updates, run the following command:

   ```powershell
   PS C:\> Get-AksHciClusterUpdates -name mycluster
   ```

   ```output
   details                             kubernetesversion                operatingsystemversion
   -------                             -----------------                ----------------------
   This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.19.9  @{mariner=April 2021; windows=April 2021}
   This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.20.5  @{mariner=April 2021; windows=April 2021}
   ```

2. To initiate the operating system version update, run the following command:

   ```powershell
   PS C:\> Update-AksHciCluster -clusterName mycluster -kubernetesVersion v1.21.1 -operatingSystem
   ```

## Update both the OS and the Kubernetes version

> [!Important]
> Updating a workload cluster to a newer version of the operating system and Kubernetes version is supported.

### Update a workload cluster: Example

The example below assumes there's a new Kubernetes version available, and the current version number is v1.20.7.

1. To get all available workload cluster updates, run the following command:

   ```powershell 
   PS C:\> Get-AksHciClusterUpgrades -name mycluster
   ```

   ```output
   details                             kubernetesversion                  operatingsystemversion
   -------                             -----------------                  ----------------------
   This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.19.9    @{mariner=April 2021; windows=April 2021}
   This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.20.5    @{mariner=April 2021; windows=April 2021}
   ```

2. To initiate the workload cluster update, run the following command:

   ```powershell
   PS C:\> Update-AksHciCluster -clusterName mycluster -kubernetesVersion v1.21.1
   ```

## Validate an upgrade

Confirm that the upgrade was successful using the [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) command as follows:

```powershell
Get-AksHciCluster -name mycluster
```

The following example output shows the cluster runs *KubernetesVersion v1.21.1*:

**Output**
```
ProvisioningState     : provisioned
KubernetesVersion     : v1.21.1
NodePools             : linuxnodepool
WindowsNodeCount      : 0
LinuxNodeCount        : 0
ControlPlaneNodeCount : 1
Name                  : mycluster
```

## Delete the cluster

As this tutorial is the last part of the series, you may want to delete the cluster.  Use the [Remove-AksHciCluster](./reference/ps/remove-akshcicluster.md) command to remove the resource group, container service, and all related resources.

```powershell
Remove-AksHciCluster -name mycluster
```

## Next steps

In this tutorial, you upgraded Kubernetes in an AKS on Azure Stack HCI and Windows Server cluster. You learned how to:

> [!div class="checklist"]
> * Identify current and available Kubernetes versions
> * Upgrade the Kubernetes version of Kubernetes nodes
> * Upgrade the OS version of Kubernetes nodes
> * Upgrade a Kubernetes cluster to the latest version
> * Validate a successful upgrade

For more information on AKS on Azure Stack HCI and Windows Server, see the [AKS on Azure Stack HCI and Windows Server overview](./overview.md) and [clusters and workloads](./kubernetes-concepts.md).

<!-- LINKS - external -->


<!-- LINKS - internal -->
