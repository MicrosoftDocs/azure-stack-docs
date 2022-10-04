---
title: Single server scale-out for Azure Stack HCI version 22H2
description: Learn how to scale out a single-server cluster for Azure Stack HCI version 22H2.
author: dansisson
ms.topic: how-to
ms.date: 10/04/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Single server scale-out for your Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

Azure Stack HCI version 22H2 supports inline fault domain and resiliency changes for single-server cluster scale-out. This article describes how you can scale out your Azure Stack HCI cluster.

## About single server cluster scale-out

Azure Stack HCI version 22H2 provides easy scaling options to go from a single-node cluster to a two-node cluster, and from a two-node cluster to a three-node cluster. The following diagram shows how a single server can be scaled out to a multi-node cluster on your Azure Stack HCI.

:::image type="content" source="media/single-node-scale-out/single-node-scale-out.png" alt-text="Diagram showing a single-node cluster to multi-node cluster scale-out." lightbox="media/single-node-scale-out/single-node-scale-out.png":::

## Inline fault domain changes

When scaling up from a single-server cluster to a two-node cluster, the storage fault domain first needs to be changed from type `PhysicalDisk` to `StorageScaleUnit`. The change needs to be applied to all virtual disks and storage tiers. Extra nodes can be created and the data is evenly balanced across all nodes in the cluster.

Complete the following steps to correctly set fault domains after adding a node:

1. Run PowerShell as Administrator.

1. Change the fault domain type of the storage pool:

    ```powershell
    Get-StoragePool -FriendlyName <name> | Set-StoragePool -FaultDomainAwarenessDefault StorageScaleUnit
    ```

1. Remove the **Cluster Performance History** volume:

    ```powershell
    Remove-VirtualDisk -FriendlyName ClusterPerformanceHistory
    ```

1. Generate new storage tiers and recreate the cluster performance history volume by running the following command:

    ```powershell
    Enable-ClusterStorageSpacesDirect -Verbose
    ```

1. Remove storage tiers that are no longer applicable by running the following command. See the [Storage tier summary table](/azure-stack/hci/manage/create-volumes.md#storage-tier-summary-table) for more information.

    ```powershell
    Remove-StorageTier -FriendlyName <tier_name>
    ```

1. Change the fault domain type of existing volumes:

    **For a non-tiered volume**, run the following command:

    ```powershell
    Set-VirtualDisk – FriendlyName <name> -FaultDomainAwareness StorageScaleUnit
    ```

    **For a tiered volume**, run the following commands:

    ```powershell
    Get-StorageTier -FriendlyName <mirror_tier> | Set-StorageTier -FaultDomainAwareness StorageScaleUnit
    Get-StorageTier -FriendlyName <parity_tier> | Set-StorageTier -FaultDomainAwareness StorageScaleUnit
    ```

    > [!NOTE]
    > The prior command doesn't work for changing from `StorageScaleUnit` to `PhysicalDisk`, or from `StorageScaleUnit` to `Node` or `Chassis` types.


## Inline resiliency changes

Once the inline fault domain changes are made, volume resiliency can be increased to handle node scale-out in the following scenarios.

Run the following command to check the progress of the resiliency changes. The repair operation should be observed for all volumes in the cluster.

```powershell
Get-StorageJob
```
This command displays only ongoing jobs.

### Single-node to two-node cluster

To remain as a two-way mirror, no action is required. To convert a two-way mirror to a nested two-way mirror, do the following:

**For a non-tiered volume**, run the following commands:

```powershell
Set-VirtualDisk -FriendlyName <name> -NumberOfDataCopies 4
Move-ClusterSharedVolume -name <name> -node <node>
```

A remount is needed as Resilient File System (ReFS) only recognizes provisioning type at mount time. 

**For a tiered volume**, run the following commands:

```powershell
Get-StorageTier -FriendlyName <mirror tier> | Set-StorageTier -NumberfOfDataCopies 4
Get-StorageTier -FriendlyName <parity tier> | Set-StorageTier -NumberfOfDataCopies 4
Move-ClusterSharedVolume -name <name> -node <node>
```

### Two-node to three-node+ cluster

To remain as a two-way mirror, no action is required. To convert a two-way mirror to a three-way or greater mirror, the following procedure is recommended.

Existing two-way mirror volumes can also take advantage of this using the following PowerShell commands. For example, for a single-node cluster or a three-node or greater cluster, you convert your two-way mirror volume into a three-way mirror volume.

The following scenarios are not supported:

- Scaling down, such as from a three-way mirror to a two-way mirror.
- Scaling to or from mirror-accelerated parity volumes.
- Scaling from nested two-way mirror or nested mirror-accelerated parity volumes.

**For a non-tiered volume**, run the following:

```powershell
Set-VirtualDisk -FriendlyName <name> -NumberOfDataCopies 3
Move-ClusterSharedVolume -name <name> -node <node>
```

A remount is needed as ReFS only recognizes provisioning type at mount time.

**For a tiered volume**, run the following commands:

```powershell
Get-StorageTier -FriendlyName <mirror tier> | Set-StorageTier -NumberfOfDataCopies 3
Get-StorageTier -FriendlyName <parity tier> | Set-StorageTier -NumberfOfDataCopies 3
Move-ClusterSharedVolume -name <name> -node <node>
```

## Next steps

See [ReFS](/windows-server/storage/refs/refs-overview) for more information.