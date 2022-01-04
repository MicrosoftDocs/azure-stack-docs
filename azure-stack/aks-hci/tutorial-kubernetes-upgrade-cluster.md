---
title: Tutorial - Upgrade a cluster in Azure Kubernetes Service on Azure Stack HCI
description: In this tutorial, learn how to upgrade an existing cluster to the latest available Kubernetes version.
services: container-service
ms.topic: tutorial
ms.date: 07/02/2021
ms.author: jeguan
author: v-susbo
---

# Tutorial: Upgrade Kubernetes in Azure Kubernetes Service on Azure Stack HCI

As part of the application and cluster lifecycle, you may wish to upgrade to the latest available version of Kubernetes.

In this tutorial, part seven of seven, a Kubernetes cluster is upgraded. You learn how to:

> [!div class="checklist"]
> * Identify current and available Kubernetes versions
> * Upgrade the Kubernetes version of Kubernetes nodes
> * Upgrade the OS version of Kubernetes nodes
> * Upgrade a Kubernetes cluster to the latest version
> * Validate a successful upgrade
> * Remove a Kubernetes cluster

## What are the options for updating?
There are several types of updates, which can happen independently from each other and in certain supported combinations:

- [Update the AKS on Azure Stack HCI host](update-akshci-host-powershell.md) to the latest version.
- Update an AKS on Azure Stack HCI workload cluster to a new Kubernetes version.
- Update the AKS on Azure Stack HCI container hosts to a newer version of the operating system.
- Combined update of operating system and Kubernetes version.

All updates are done in a rolling update flow to avoid outages in workload availability. When a _new_ Kubernetes worker node with a newer build is brought into the cluster, resources are moved from the _old_ node to the _new_ node, and once this is completed successfully, the _old_ node is decommissioned and removed from the cluster.

The examples in this tutorial assume that the workload cluster, `mycluster`, is currently on Kubernetes version 1.18.8 and uses an operating system version more than 30 days old.

## Before you begin

In previous tutorials, an application was packaged into a container image. This image was uploaded to Azure Container Registry, and you created an AKS cluster. The application was then deployed to the AKS on Azure Stack HCI cluster. If you have not done these steps, and would like to follow along, start with [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-application.md).

## Update the Kubernetes version of a workload cluster

You must upgrade the PowerShell modules and the AKS on Azure Stack HCI host first before updating the Kubernetes version.

> [!Important]
> Updating a workload cluster to a newer version of Kubernetes works only if the target Kubernetes version is supported by the current operating system version. To check for the supported operating system and Kubernetes version combinations, use the `Get-AksHciUpdates` command.

### Example for updating the Kubernetes version of a workload cluster

Use the steps in the following example to update the Kubernetes version:

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

### Example for updating only the operating system

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

### Example for updating a workload cluster

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

In this tutorial, you upgraded Kubernetes in an AKS on Azure Stack HCI cluster. You learned how to:

> [!div class="checklist"]
> * Identify current and available Kubernetes versions
> * Upgrade the Kubernetes version of Kubernetes nodes
> * Upgrade the OS version of Kubernetes nodes
> * Upgrade a Kubernetes cluster to the latest version
> * Validate a successful upgrade

For more information on AKS on Azure Stack HCI, see the [AKS on Azure Stack HCI overview](./overview.md) and [clusters and workloads](./kubernetes-concepts.md).

<!-- LINKS - external -->


<!-- LINKS - internal -->
