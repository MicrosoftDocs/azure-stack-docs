---
title: Perform post deployment tasks on rack aware clusters (Preview)
description: Learn about the post deployment tasks that you need to perform on your newly deployed rack aware cluster (Preview).
author: alkohli
ms.topic: how-to
ms.date: 10/21/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Perform post deployment tasks on rack aware cluster (Preview)

::: moniker range=">=azloc-2510"

After deploying rack aware cluster, either through the [Azure portal](../deploy/rack-aware-cluster-deploy-portal.md) or using the [Azure Resource Manager deployment template](../deploy/rack-aware-cluster-deployment-via-template.md), you need to complete a set of post-deployments tasks. This article describes the typical tasks required once your rack aware cluster is successfully deployed and all machines are up and running.

[!INCLUDE [important](../includes/hci-preview.md)]

## Verify cluster status

Follow these steps to check the status of your cluster:

1. In the Azure portal, go to the **Overview** page of your Azure Local resource.
1. On the **Properties** tab, under **Configurations**, review the **Cluster type** value:
    - **Rack aware cluster** indicates that the Azure Local resource is a rack aware cluster.
    - **Standard** indicates the Azure Local resource is a standard single-rack cluster.

        :::image type="content" source="./media/rack-aware-cluster-post-deployment/check-cluster-status.png" alt-text="Screenshot of the cluster Overview page showing the cluster type as Rack aware cluster." lightbox="./media/rack-aware-cluster-post-deployment/check-cluster-status.png":::

## Verify machines status

Follow these steps to check the status of machines in your cluster:

1. In the Azure portal, go to your Azure Local resource page.
1. Under **Infrastructure**, select **Machines**.
1. Verify that the machines are grouped by local availability zone.

    :::image type="content" source="./media/rack-aware-cluster-post-deployment/check-machines-status.png" alt-text="Screenshot of the Machines page showing machines grouped by local availability zone." lightbox="./media/rack-aware-cluster-post-deployment/check-machines-status.png":::

## (Optional) Change the quorum witness to a local witness

By default, rack aware cluster uses a cloud witness. If your configuration requires it, you can change it to a local witness. For more information, see [Deploy a quorum witness](/windows-server/failover-clustering/deploy-quorum-witness?pivots=file-share-witness).

## (Optional) Create workload volumes

For 2+2 and larger rack aware cluster configurations, deployment via the Azure portal supports only **Express** mode. In this mode, infrastructure components, workload volumes, and storage paths are automatically created for each volume.

Here's is a sample output from a 4+4 rack aware cluster:

:::image type="content" source="./media/rack-aware-cluster-post-deployment/workload-volumes.png" alt-text="Screenshot of the Machines page showing machines grouped by local availability zone for 4+4 cluster." lightbox="./media/rack-aware-cluster-post-deployment/workload-volumes.png":::

If you want to create custom workload volumes instead of those created during cluster deployment, you can create either 2-way or 4-way mirror volumes, using either fixed or thin provisioning. Before adding the new volumes, you must delete the existing storage paths and volumes.

After creating new workload volumes, you must create storage paths for the new volumes. For detailed instructions, see [Create storage path for Azure Local](../manage/create-storage-path.md).

```output
#Create a four-copy volume on the storage pool, fixed provisioned:
New-Volume -FriendlyName “FourCopyVolumeFixed” -StoragePoolFriendlyName "SU1_Pool" -FileSystem CSVFS_ReFS -Size 500GB -ResiliencySettingName Mirror -PhysicalDiskRedundancy 3 -ProvisioningType Fixed           

#Create a four-copy volume on the storage pool, thinly provisioned:
New-Volume -FriendlyName “FourCopyVolumeThin” -StoragePoolFriendlyName "SU1_Pool" -FileSystem CSVFS_ReFS -Size 500GB -ResiliencySettingName Mirror -PhysicalDiskRedundancy 3 -ProvisioningType Thin

#Create a two-copy volume on the storage pool, fixed provisioned:
New-Volume -FriendlyName “TwoCopyVolumeFixed” -StoragePoolFriendlyName "SU1_Pool" -FileSystem CSVFS_ReFS -Size 500GB -ResiliencySettingName Mirror -PhysicalDiskRedundancy 1 -ProvisioningType Fixed

#Create a two-copy volume on the storage pool, thinly provisioned:
New-Volume -FriendlyName “TwoCopyVolumeThin” -StoragePoolFriendlyName "SU1_Pool" -FileSystem CSVFS_ReFS -Size 500GB -ResiliencySettingName Mirror -PhysicalDiskRedundancy 1 -ProvisioningType Thin
```

### Validate the volumes

To verify if the volume is configured as Rack Level Nested Mirror (RLNM), use the following command:

```cmd
spaceutil get-space -name <volume name>
```

This command returns details about the volume, including the `NestedFdType` and `MaxFdType` parameters.

The following table shows the expected output for each configuration:

|Configuration | Output|
|--|--|
| 4-way mirror with RLNM | `NestedFdType`: Node<br> `MaxFdType`: Rack|
| 2-way mirror with RLNM | `NestedFdType`: Unknown<br> `MaxFdType`: Rack |
| No RLNM, Storage domain is set to RACK | `NestedFdType`: (null)<br> `MaxFdType`: Rack |

Here's a sample output from a volume with RLNM 4-way mirror enabled:

```output
spaceutil get-space -name userstorage_1
 
Id                     : <ID>>
PoolId                 : <PoolID>>
Name                   : UserStorage_1
Description            : ASProtected;ASUser;
Usage                  : Data
DeviceNumber           : -1
InstancePath           : (null)
Health                 : Unknown
OperationalState       : Detached
IsManualAttach         : True
IsClustered            : True
Priority               : 5
DetachReason           : Policy
ProvisionedCapacity    : 4.30 TB
AllocatedCapacity      : 38.0 GB
FootprintOnPool        : 152 GB
Security               : O:BAG:SYD:(A;;FX;;;WD)(A;;FA;;;SY)(A;;FA;;;BA)
ProvisioningType       : Thin
AllocationSize         : 256 MB
MediaType              : Unknown
MinFdType              : Drive
NestedFdType           : Node
MaxFdType              : Rack
ScopeType              : Unknown
NumberOfScopes         : 0
NumberOfMetadataDrives : 0
ResiliencyType         : Mirror
FaultTolerance         : 3
NumberOfCopies         : 4
NumberOfGroups         : 1
NumberOfColumns        : 8
Interleave             : 256 KB
WriteCacheSize         : 0
WriteCacheReserveSize  : 0
ReadCacheSize          : 0
MinimumLogicalCopies   : 1
IsTiered               : False
Flags                  :
SnapshotId             :
ReserveId              :
MaxIops                : 0
MaxIoBandwidth         : 0
```

## Next steps

- [Add and repair nodes to a rack aware cluster](../concepts/rack-aware-cluster-add-server.md)
- [Provision VMs in a local availability zone](../concepts/rack-aware-cluster-provision-vm-local-availability-zone.md)

::: moniker-end

::: moniker range="<=azloc-2509"

This feature is available in Azure Local 2510 and later.

::: moniker-end
