---
title:  Deploy Azure Stack HCI on a single server
description: This article describes Azure Stack HCI OS configuration on a single server
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: kerimhanif
ms.lastreviewed: 05/18/2022
ms.date: 05/24/2022
---

# Deploy Azure Stack HCI on a single server

> Applies to: Azure Stack HCI, version 21H2

This article describes how to use PowerShell to deploy Azure Stack HCI on a single server that contains all NVMe or SSD drives, creating a single-node cluster. It also describes how to add servers to the cluster (scale-out) later.

Note that you can't yet use Windows Admin Center to install Azure Stack HCI on a single server. For more info, see [Using Azure Stack HCI on a single server](../concepts/single-server-clusters.md).

## Prerequisites

- A server from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/catalog) that's certified for use as a single-node cluster and configured with all NVMe or all SSD drives.
- For network, hardware and other requirements, see [Azure Stack HCI network and domain requirements](../deploy/operating-system.md#determine-hardware-and-network-requirements).
- Optionally, [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) to register and manage the server once it has been configured.

## Deploy on a single server

Here are the steps to install the Azure Stack HCI OS on a single server, create the single-node cluster, register the cluster with Azure, and create volumes.

1. Install the Azure Stack HCI OS on your server. For more information, see [Deploy the Azure Stack HCI OS](../deploy/operating-system.md#manual-deployment) onto your server.
2. Configure the server utilizing the [Server Configuration Tool](/windows-server/administration/server-core/server-core-sconfig) (SConfig).
3. Install the required roles and features using the following command.

   ```powershell
   Install-WindowsFeature -Name "BitLocker", "Data-Center-Bridging", "Failover-Clustering", "FS-FileServer", "FS-Data-Deduplication", "Hyper-V", "Hyper-V-PowerShell", "RSAT-AD-Powershell", "RSAT-Clustering-PowerShell", "NetworkATC", "Storage-Replica" -IncludeAllSubFeature -IncludeManagementTools
   ```

4. Use PowerShell to [create a cluster](../deploy/create-cluster-powershell.md), skipping creating a cluster witness.

   Here's an example of creating the cluster and then enabling Storage Spaces Direct while disabling the storage cache:

   ```powershell
   New-Cluster -Name <cluster-name> -Node <node-name> -NOSTORAGE
   ```

   ```powershell
   Enable-ClusterStorageSpacesDirect -CacheState Disabled 
   ```

5. Use [PowerShell](../deploy/register-with-azure.md#register-a-cluster-using-powershell) or [Windows Admin Center](../deploy/register-with-azure.md#register-a-cluster-using-windows-admin-center) to register the cluster.
6. [Create volumes](../manage/create-volumes.md#create-volumes-using-windows-powershell) with PowerShell without any storage tiers.

   Here's an example:

   ```powershell
   New-Volume -FriendlyName "Volume1" -Size 1TB -ProvisioningType Thin
   ```

## Updating single-node clusters

To install updates in Windows Admin Center, use Server Manager > Updates, PowerShell, or connect via Remote Desktop and use Server Configuration tool (Sconfig). You can't use the Cluster Manager > Updates tool to update single-node clusters for now. For solution updates (such as driver and firmware updates), see your solution vendor.

## Adding servers to a single-node cluster (optional)

You can add servers to your single-node cluster, also known as scaling out, though there are some manual steps you must take to properly configure Storage Spaces Direct fault domains (`FaultDomainAwarenessDefault`) in the process. These steps aren't present when adding servers to clusters with two or more servers.

1. Validate the cluster by specifying the existing server and the new server: [Validate an Azure Stack HCI cluster - Azure Stack HCI | Microsoft Docs](../deploy/validate.md).
2. If cluster validation was successful, add the new server to the cluster: [Add or remove servers for an Azure Stack HCI cluster - Azure Stack HCI | Microsoft Docs](../manage/add-cluster.md).
3. Change the storage pool's fault domain awareness default parameter from `PhysicalDisk` to `StorageScaleUnit`.

   ```powershell
   Set-Storagepool -Friendlyname S2D* -FaultDomainAwarenessDefault StorageScaleUnit
   ```

   > [!NOTE]
   > After changing the fault-domain awareness, data copies are spread across servers in the cluster, making the 
      cluster resilient to faults at the entire server level. The volume fault domain is derived from the storage pool's 
      default settings and the resiliency will remain as two-way mirror unless you change it. This means that any new 
      volumes you create in Windows Admin Center or PowerShell will use `StorageScaleUnit` as the fault domain 
      setting and will have a two-way mirror resiliency setting.

4. Delete the existing cluster performance history volume as its `FaultDomainAwarenessDefault` is set to `PhysicalDisk`.

   ```powershell
   Stop-ClusterPerformanceHistory -DeleteHistory
   ```

5. Run the following command to recreate the cluster performance history volume, the `FaultDomainAwarenessDefault` should be automatically set to `StorageScaleUnit`.

   ```powershell
   Start-ClusterPerformanceHistory
   ```

6. To change the fault domain on existing volumes after scale-out, do the following:
    1. Create a new volume that's thinly provisioned and has the same size as the old volume.
    2. Migrate all VMs and data from old volume to new volume.
    3. Delete the old volume.

7. [Set up a cluster witness](../manage/witness.md).

## Next steps

- [Deploy workload – AVD](../deploy/virtual-desktop-infrastructure.md)
- [Deploy workload – AKS-HCI](/azure-stack/aks-hci/overview)
- [Deploy workload – Azure Arc-enabled data services](/azure/azure-arc/data/overview)
