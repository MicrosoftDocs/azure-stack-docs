---
title: Concepts - Upgrade the Azure Kubernetes Service on Azure Stack HCI and Windows Server host using PowerShell
description: Learn about using PowerShell to upgrade the Azure Kubernetes Service on Azure Stack HCI host.
ms.topic: conceptual
ms.date: 05/16/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek
author: sethmanheim

# Intent: As an IT Pro, I need instructions on how to use PowerShell in order to upgrade my AKS on Azure Stack HCI host.
# Keyword: PowerShell AKS on Azure Stack HCI updates

---

# Upgrade the AKS on Azure Stack HCI and Windows Server host using PowerShell

Updates to the Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server host always include the latest available version. Although updates to the host can happen independently from updates to the workload clusters, you must always update the host before updating a workload cluster.

All updates are done in a rolling update flow to avoid outages in AKS on Azure Stack HCI and Windows Server availability. When you bring a _new_ node with a newer build into the cluster, resources move from the _old_ node to the _new_ node. When you successfully remove the resources, the _old_ node is decommissioned and removed from the cluster.

> [!Note]  
> Microsoft recommends upgrading your AKS on Azure Stack HCI and Windows Server clusters within 30 days of a new release. If you do not update within this window, you have up to 90 days from your last upgrade before internal certificates and tokens expire. Once expired, the cluster will still be functional, however, you will need to call Microsoft Support to upgrade. Upon rebooting the cluster after the 90-day period, it will continue to remain in a non-functional state. For more information about internal certificates and tokens, visit  [Certificates and tokens](/azure-stack/aks-hci/certificates-update-after-sixty-days).

## Update the AKS on Azure Stack HCI and Windows Server host

The first step in any update flow is to run the [Update-AksHci](./reference/ps/update-akshci.md) command to update the AKS on Azure Stack HCI and Windows Server host. `Update-AksHci` takes no arguments and always updates the management cluster to the latest version. You must initiate this step before running [Update-AksHciCluster](./reference/ps/update-akshcicluster.md) to update the Kubernetes cluster to a new version.

> [!Important]
> The update command only works if you have installed the GA release or later. It will not work for releases older than the GA release. This update command updates the Azure Kubernetes Service host and the on-premise Microsoft operated cloud platform. This command does not update any existing AKS workload clusters. New AKS workload clusters created after updating the AKS host may differ from existing AKS workload clusters in their OS version and Kubernetes version.

We recommend updating AKS workload clusters immediately after updating the AKS host to get the newest OS versions and recent fixes. If a workload cluster is on an unsupported Kubernetes version in the next version of AKS on Azure Stack HCI and Windows Server, upgrade will fail.

## Example flow for updating the AKS on Azure Stack HCI and Windows Server host

### Update the PowerShell modules

Make sure you always have the latest PowerShell modules installed on the AKS on Azure Stack HCI and Windows Server nodes by executing the following command on all physical Azure Stack HCI nodes. 

> [!Important]
> You should close all open PowerShell windows and then open a fresh session to run the update command. If you do not close all PowerShell windows, you may end up with modules that are in-use and can't be updated.

```powershell
Update-Module -Name AksHci -Force -AcceptLicense
```

### Get the current AKS on Azure Stack HCI and Windows Server version

```powershell
PS C:\> Get-AksHciVersion                    
```

```output
1.0.0.10517
```

### Get available AKS on Azure Stack HCI and Windows Server updates

```powershell
Get-AksHciUpdates
```

The output shows the available versions this AKS on Azure Stack HCI and Windows Server host can be updated to.

```output
1.0.2.10723
```

### Initiate the AKS on Azure Stack HCI and Windows Server update

```powershell
PS C:\> Update-AksHci
```

### Verify the AKS on Azure Stack HCI and Windows ServerHost is updated

```powershell
PS C:\> Get-AksHciVersion
```

The output will show the updated version of the AKS on Azure Stack HCI and Windows Server host.

```output
1.0.2.10723
```

## Next steps

- [Update Kubernetes version of your AKS workload clusters](upgrade.md)



<!-- LINKS - external -->


<!-- LINKS - internal -->