---
title: Concepts - Upgrade the AKS host in AKS hybrid using PowerShell
description: Learn about using PowerShell to upgrade the AKS host in AKS hybrid.
ms.topic: conceptual
ms.date: 11/08/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek
author: sethmanheim

# Intent: As an IT Pro, I need instructions on how to use PowerShell in order to upgrade my AKS host in AKS hybrid.
# Keyword: PowerShell AKS hybrid updates

---

# Upgrade the AKS host in AKS hybrid using PowerShell

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to update the Azure Kubernetes Service host in AKS hybrid. 

[!INCLUDE [aks-hybrid-description](includes/aks-hybrid-description.md)]

## Overview of AKS host updates

Updates to the AKS host always include the latest available version. Although you can update the host independently of workload cluster updates, you must always update the host before updating a workload cluster.

To avoid outages and loss of AKS availability, rolling updates are performed. When you bring a new node with a newer build into the cluster, resources move from the old node to the new node. When you successfully remove the resources, the old node is decommissioned and removed from the cluster.

> [!Note]  
> Microsoft recommends upgrading your AKS clusters within 30 days of a new release. If you do not update within this window, you have up to 90 days from your last upgrade before internal certificates and tokens expire. Once the certificates and tokens expire, the cluster is still functional; however, you must call Microsoft Support to upgrade. When you reboot the cluster after the 90-day period, it remains in a non-functional state. For more information about internal certificates and tokens, see [Certificates and tokens](/azure-stack/aks-hci/certificates-update-after-sixty-days).

## Update the AKS host

The first step in any update flow is to run the [Update-AksHci](./reference/ps/update-akshci.md) command to update the AKS host. `Update-AksHci` takes no arguments and always updates the management cluster to the latest version. You must initiate this step before running [Update-AksHciCluster](./reference/ps/update-akshcicluster.md) to update the Kubernetes cluster to a new version.

> [!Important]
> The update command only works if you have installed the GA release or later. It will not work for earlier releases. This update command updates the AKS host and the on-premise Microsoft operated cloud platform. This command does not update any existing AKS workload clusters. New AKS workload clusters created after updating the AKS host may differ from existing AKS workload clusters in their OS version and Kubernetes version.

We recommend updating AKS workload clusters immediately after updating the AKS host to get the newest OS versions and recent fixes. If a workload cluster is on an unsupported Kubernetes version in the next version of AKS hybrid, the upgrade fails.

## Example flow for updating an AKS host

### Update the PowerShell modules

Make sure you always have the latest PowerShell modules installed on the AKS nodes by running the following command on all the physical nodes in your AKS deployment.

> [!Important]
> You should close all open PowerShell windows and then open a fresh session to run the update command. If you do not close all PowerShell windows, you may end up with modules that are in use and can't be updated.

```powershell
Update-Module -Name AksHci -Force -AcceptLicense
```

### Get the current AKS hybrid version

```powershell
PS C:\> Get-AksHciVersion                    
```

```output
1.0.0.10517
```

### Get the available AKS hybrid updates

```powershell
Get-AksHciUpdates
```

The output shows the available versions this AKS host can be updated to.

```output
1.0.2.10723
```

#### Versioning

Using version 1.0.2.10723 as an example, the following table shows how version numbers are constructed for AKS hybrid releases.

| Value | Meaning                                                                                             |
| ----- | --------------------------------------------------------------------------------------------------- |
| 1     | Major version: +1 for each release with a large breaking change                                     |
| 0     | Minor version: +1 for each release after the latest major version with a major functionality change |
| 2     | Feature & patch updates: +1 for each regular (typically monthly) release after the latest major version |
| 1     | Build type: Always 1 for public-facing builds                                                       |
| 0723  | Build creation date: Build creation date in mmdd format                                             |


### Initiate the AKS hybrid update

```powershell
PS C:\> Update-AksHci
```

### Verify the AKS host was updated

```powershell
PS C:\> Get-AksHciVersion
```

The output will show the updated version of the AKS on the AKS host.

```output
1.0.2.10723
```

## Next steps

- [Upgrade the Kubernetes version of your AKS workload clusters](upgrade.md)
