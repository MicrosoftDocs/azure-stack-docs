---
title: Concepts - Updating Azure Kubernetes Services on Azure Stack HCI
description: Learn about updates and upgrades in Azure Kubernetes Service on Azure Stack HCI.
ms.topic: conceptual
ms.date: 03/04/2021
ms.custom: fasttrack-edit
ms.author: mikek
author: mkostersitz
---

# Manage Azure Kubernetes Service on Azure Stack HCI updates and upgrades

There are several types of updates, which can happen independently from each other and in certain supported combinations.

- Update the AKS on Azure Stack HCI core system to the latest version.
- Update an AKS on Azure Stack HCI workload cluster to a new Kubernetes version.
- Update the container hosts to a newer version of the operating system.
- Combined update of the operating system and Kubernetes version.

All updates are done in a rolling update flow. When a *new* node with the newer build is brought into the cluster, resources are moved from the *old* node to the *new* node, and the *old* node is decommissioned.

The examples below assume that the workload cluster `myCluster` is currently on Kubernetes version 1.18.8 and has an operating system version that's more than 30 days old.

## Update the AKS on Azure Stack HCI host

> [!Important]
> Updating the AKS on Azure Stack HCI host is the first step in any update flow and must be initiated before running `Update-AksHciCluster`. The command doesn't need any arguments and always updates the management cluster to the latest version.

### Example flow for updating the AKS on Azure Stack HCI host

#### Get current AKS on Azure Stack HCI version

```powershell
PS C:\> Get-AksHciVersion                    
```

```output
0.9.6.1
```

#### Get available AKS on Azure Stack HCI updates

```powershell
Get-AksHciUpdates
```

The output shows the available versions this AKS on Azure Stack HCI host can be updated to.

```output
0.9.6.4
```

#### Initiate the AKS on Azure Stack HCI update

```powershell
PS C:\> Update-AksHci
```

#### Verify the AKS on Azure Stack HCI host is updated

```powershell
PS C:\> Get-AksHciVersion
```

The output shows the updated version of the AKS on Azure Stack HCI host.

```output
0.9.6.4
```

## Update the Kubernetes version of a workload cluster

>[!Important]
> Updating a workload cluster to a newer version of Kubernetes will only work if the target Kubernetes version is supported by the current operating system version.
> To check for supported operating system - Kubernetes version combinations use the `Get-AksHciUpdateVersions` command.

### Example for updating the Kubernetes version of a workload cluster

#### Get available Kubernetes versions

```powershell
PS C:\> Get-AksHciKubernetesVersion
```

```Output
Linux {v1.16.10, v1.16.15, v1.17.11, v1.17.13...}
Windows {v1.18.8, v1.18.10}
```

#### Initiate the Kubernetes version update

```powershell
PS C:\> Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.18.10
```

## Update only the operating system version 

> [!Important]
> Updating a target cluster to a newer version of the operating system without changing the Kubernetes version will only work if the new operating system version does not require a different Kubernetes version.

### Example for updating the operating system only

#### Get available workload cluster updates

```powershell
PS C:\> Get-AksHciClusterUpgrades -name mycluster
```

```output
details                                                     kubernetesversion operatingsystemversion
-------                                                     ----------------- ----------------------
This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.17.13          @{mariner=January 2021; windows=January 2021}
This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.18.12          @{mariner=January 2021; windows=January 2021}
This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.18.8           @{mariner=January 2021; windows=January 2021}
```

#### Initiate the operating system version update

```powershell
PS C:\> Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.18.8 -operatingSystem
```

## Update the OS version and the Kubernetes version

>[!Important]
>Updating a workload cluster to a newer version of the operating system and Kubernetes version is allowed.

The below example assumes there is a new Kubernetes version available and the version number is v1.18.12.

### Example for updating a workload cluster

#### Get all available workload cluster updates

```powershell
PS C:\> Get-AksHciClusterUpgrades -name mycluster
```

```output
details                                                     kubernetesversion operatingsystemversion
-------                                                     ----------------- ----------------------
This is a patch kubernetes upgrade. (i.e v1.1.X  to v1.1.Y) v1.17.13          @{mariner=January 2021; windows=January 2021}
This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.18.12          @{mariner=January 2021; windows=January 2021}
This is a minor kubernetes upgrade. (i.e v1.X.1 to v1.Y.1)  v1.18.8           @{mariner=January 2021; windows=January 2021}
```

#### Initiate the workload cluster update

```powershell
PS C:\> Update-AksHciCluster -clusterName myCluster -kubernetesVersion v1.18.12
```