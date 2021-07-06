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

## General updating concepts
There are several types of updates, which can happen independently from each other and in certain supported combinations.

- Update the AKS on Azure Stack HCI host to the latest version see [Tutorial - Updating Azure Kubernetes Services (AKS) on Azure Stack HCI](tutorial-akshci-host-update.md).
- Update an AKS on Azure Stack HCI workload cluster to a new Kubernetes version.
- Update the AKS on Azure Stack HCI container hosts to a newer version of the operating system.
- Combined update of operating system and Kubernetes version.

All updates are done in a rolling update flow to avoid outages in workload availability. When a _new_ Kubernetes worker node with a newer build is brought into the cluster, resources are moved from the _old_ node to the _new_ node, and once this is completed successfully, the _old_ node is decommissioned and removed from the cluster.

The examples in this tutorial assume that the workload cluster, **myCluster**, is currently on Kubernetes version 1.18.8 and uses an operating system version more than 30 days old.

## Before you begin

In previous tutorials, an application was packaged into a container image. This image was uploaded to Azure Container Registry, and you created an AKS cluster. The application was then deployed to the AKS on Azure Stack HCI cluster. If you have not done these steps, and would like to follow along, start with [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-application.md).

## Update the Kubernetes version of a workload cluster

>[!Note]
>You have to upgrade the PowerShell Modules and AKS on Azure Stack HCI Host first. See the topic above for details.

>[!Important]
>Updating a workload cluster to a newer version of Kubernetes will only work if the target Kubernetes Version is supported by the current operating system version.
>To check for supported operating system - Kubernetes version combinations use the `Get-AksHciUpdateVersions` command.

### Example for updating the Kubernetes version of a workload cluster

Get the current version of your target cluster

```powershell
Get-AksHciCluster
```

```output
ProvisioningState     : Deployed
KubernetesVersion     : v1.19.7
Name                  : sandpit
ControlPlaneNodeCount : 1
WindowsNodeCount      : 0
LinuxNodeCount        : 0
```

## Get available cluster versions

Before you upgrade a cluster, use the [Get-AksHciClusterUpdates](get-akshciclusterupdates.md) command to check which Kubernetes releases are available for upgrade. If you followed [Tutorial 3 - Create Kubernetes Cluster](tutorial-kubernetes-deploy-cluster.md), your cluster is up to date with the latest default version. For this example, the cluster called *mycluster* is running on version *v1.16.14*.

```powershell
Get-AksHciClusterUpdates -name mycluster
```

In the following example, the current version is *v1.16.14*, and the available versions are shown under *kubernetesVersion*.

```Output
details                                                     kubernetesversion operatingsystemversion
-------                                                     ----------------- ----------------------
This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.16.15-kvapkg.2 @{mariner=February 2021; windows=Febru...
This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.17.16          @{mariner=February 2021; windows=Febru...
```

You can list available Kubernetes versions by running the [Get-AksHciKubernetesVersion](get-akshcikubernetesversion.md).

```powershell
Get-AksHciKubernetesVersion
```

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

In the output above, you can see that there are more upgrade versions available. However, when upgrading clusters, you cannot skip versions. (i.e. v1.16.xx --> v1.17.xx is allowed, but v1.16.xx --> v1.18.xx is not. To upgrade from v1.16.xx to v1.18.xx, the upgrades must go in this order: v1.16.xx --> v1.17.xx --> v1.18.xx)

## Upgrade a cluster

Use the [Update-AksHciCluster](update-akshcicluster.md) command to upgrade the cluster.

```powershell
Update-AksHciCluster -name mycluster -kubernetesVersion v1.17.16
```

> [!NOTE]
> You can only upgrade one minor version at a time. For example, you can upgrade from *v1.16.xx* to *v1.17.xx*, but cannot upgrade from *v1.16.x* to *v1.18.xx* directly. To upgrade from *v1.16.xx* to *v1.18.xx*, first upgrade from *v1.16.xx* to *v1.17.xx*, then perform another upgrade from *v1.17.xx* to *v1.18.xx*.

## Validate an upgrade

Confirm that the upgrade was successful using the [Get-AksHciCluster](get-akshcicluster.md) command as follows:

```powershell
Get-AksHciCluster -name mycluster
```

The following example output shows the cluster runs *KubernetesVersion v1.17.16*:

```Output
Name            : mycluster
Version         : v1.17.16
Control Planes  : 1
Linux Workers   : 1
Windows Workers : 0
Phase           : provisioned
Ready           : True
```

## Delete the cluster

As this tutorial is the last part of the series, you may want to delete the cluster.  Use the [Remove-AksHciCluster](remove-akshcicluster.md) command to remove the resource group, container service, and all related resources.

```powershell
Remove-AksHciCluster -name mycluster
```

## Next steps

In this tutorial, you upgraded Kubernetes in an AKS on Azure Stack HCI cluster. You learned how to:

> [!div class="checklist"]
> * Identify current and available Kubernetes versions
> * Upgrade the Kubernetes nodes
> * Validate a successful upgrade

For more information on AKS on Azure Stack HCI, see the [AKS on Azure Stack HCI overview](./overview.md) and [clusters and workloads](./kubernetes-concepts.md).

<!-- LINKS - external -->


<!-- LINKS - internal -->
