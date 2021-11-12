---
title: Concepts - Upgrade the Azure Kubernetes Services (AKS) on Azure Stack HCI host using PowerShell
description: Learn about using PowerShell to upgrade the Azure Kubernetes Service (AKS) on Azure Stack HCI host.
ms.topic: conceptual
ms.date: 09/08/2021
ms.custom: 
ms.author: mikek
author: mkostersitz
---

# Upgrade the AKS on Azure Stack HCI host using PowerShell

Updates to the Azure Kubernetes Services (AKS) on Azure Stack HCI host always update to the latest available version. Updating the host can happen independently from updating the workload clusters, but you must always update the host before updating a workload cluster.

All updates are done in a rolling update flow to avoid outages in AKS on Azure Stack HCI availability. When you bring a _new_ node with a newer build into the cluster, resources move from the _old_ node to the _new_ node, and when the resources are successfully moved, the _old_ node is decommissioned and removed from the cluster.

> [!Note]
> It's recommended to always have the latest available version installed on the AKS on Azure Stack HCI host.

## Update the AKS on Azure Stack HCI host

The first step in any update flow is to update the AKS on Azure Stack HCI host by running the [Update-AksHci](./reference/ps/update-akshci.md) command. `Update-AksHci` takes no arguments and always updates the management cluster to the latest version. This step must be initiated before running [Update-AksHciCluster](./reference/ps/update-akshcicluster.md) to update the Kubernetes cluster to a new version.

> [!Important]
> The update command only works if you have installed the GA release or later. It will not work for releases older than the GA release. This update command updates the Azure Kubernetes Service host and the on-premise Microsoft operated cloud platform. This command does not update any existing AKS workload clusters. New AKS workload clusters created after updating the AKS host may differ from existing AKS workload clusters in their OS version and Kubernetes version.

We recommend updating AKS workload clusters immediately after updating the AKS host to get the newest OS versions and recent fixes. If a workload cluster is on an unsupported Kubernetes version in the next version of AKS on Azure Stack HCI, upgrade will fail.

## Example flow for updating the AKS on Azure Stack HCI host

### Update the PowerShell modules

Make sure you always have the latest PowerShell modules installed on the AKS on Azure Stack HCI nodes by executing the following command on all physical Azure Stack HCI nodes. 

> [!Important]
> You should close all open PowerShell windows and then open a fresh session to run the update command. If you do not close all PowerShell windows, you may end up with modules that are in-use and can't be updated.

```powershell
Update-Module -Name AksHci -Force
```

### Get current AKS on Azure Stack HCI version

```powershell
PS C:\> Get-AksHciVersion                    
```

```output
1.0.0.10517
```

### Get available AKS on Azure Stack HCI updates

```powershell
Get-AksHciUpdates
```

The output shows the available versions this AKS on Azure Stack HCI host can be updated to.

```output
1.0.2.10723
```

### Initiate the AKS on Azure Stack HCI update

```powershell
PS C:\> Update-AksHci
```

### Verify the AKS on Azure Stack HCIHost is updated

```powershell
PS C:\> Get-AksHciVersion
```

The output will show the updated version of the AKS on Azure Stack HCI host.

```output
1.0.2.10723
```

## Next steps

- [Update Kubernetes version of your AKS workload clusters](upgrade.md)



<!-- LINKS - external -->


<!-- LINKS - internal -->