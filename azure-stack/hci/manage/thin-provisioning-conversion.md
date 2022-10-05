---
title: Convert fixed to thin provisioned volumes on Azure Stack HCI
description: Convert fixed volumes to thin provisioned volumes on Azure Stack HCI.
author: dansisson
ms.topic: how-to
ms.date: 10/05/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Convert fixed to thin provisioned volumes on Azure Stack HCI

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article describes how you can use Windows PowerShell to convert existing fixed provisioned volumes to thin provisioned volumes inline on your Azure Stack HCI cluster.

## Fixed versus thin provisioning

Fixed provisioning allocates the full size of a volume from the storage pool at the time of creation. This method is inefficient as a portion of the storage pool's resources are depleted despite the volume being empty.

Converting from fixed to thin provisioned volumes returns any unused storage back to the pool for other volumes to leverage. As data is added or removed from the volume, the storage allocation will increase and decrease accordingly.

:::image type="content" source="media/thin-provisioning-conversion/fixed-to-thin-provisioning.png" alt-text="Diagram showing both fixed and thin provisioned volumes." lightbox="media/thin-provisioning-conversion/fixed-to-thin-provisioning.png":::

The following conversion scenarios are *not* supported:

- Scaling down, such as converting a three-way mirror to a two-way mirror.
- Scaling from or to a mirror-accelerated parity volume.
- Scaling from a nested two-way mirror or a nested mirror-accelerated parity volume.

## Use PowerShell to convert volumes

Use PowerShell to convert from fixed to thin provisioning as follows:

1. Run PowerShell as Administrator.
1. Check the volume's allocated size, size, and provisioning type. Run the following command:

    ```powershell
    Get-VirtualDisk -FriendlyName <name> | FL AllocatedSize, Size, ProvisioningType
    ```

    Here is a sample output for the preceding command:

    ```powershell
    PS C:\> New-Volume -FriendlyName DemoVolume -size 5TB -ProvisioningType Fixed

    DriveLetter  FriendlyName  FileSystemType  DriveType  HealthStatus  OperationalStatus
    -----------  ------------  --------------  ---------  ------------  -----------------
                 DemoVolume    CSVFS_ReFS      Fixed      Healthy       OK

    PS C:\> Get-VirtualDisk -FriendlyName DemoVolume | FL AllocatedSize, Size, ProvisioningType

    Allocated Size   : 5497558138880
    Size             : 5497558138880
    ProvisioningType : Fixed
    ```

1. Convert the volume from fixed to thin provisioned as follows:

    **For a non-tiered volume**, run the following command:

   ```powershell
    Set-VirtualDisk -FriendlyName <volume_name> -ProvisioningType Thin 
   ```

    **For a mirror-tiered volume**, run the following command:

   ```powershell
    Get-StorageTier <mirror_tier> | Set-StorageTier -ProvisioningType Thin
   ```

    **For a parity-tiered volume**, run the following command:

   ```powershell
    Get-StorageTier <parity_tier> | Set-StorageTier -ProvisioningType Thin
   ```

1. Remount the volume for the change to take effect. A remount is needed as Resilient File System (ReFS) only recognizes the provisioning type at mount time.

    **For single-server clusters**, complete the following steps:

    1. Get the cluster shared volume (CSV) name:

       ```powershell
        Get-ClusterSharedVolume
        ```

    1. Next, take the volume offline:

       ```powershell
        Stop-ClusterResource -Name <name>
        ```

    1. Then bring the volume back online:

       ```powershell
        Start-ClusterResource -Name <name>
        ```

    **For two-node and larger clusters**, do the following:

    1. Get the CSV name and node names:

       ```powershell
        Get-ClusterSharedVolume
        ```

    1. Next, move the CSV to another node to remount the volume:

       ```powershell
        Move-ClusterSharedVolume -Name <name> -Node <new_node>
        ```

    1. Then move the CSV back to its original node:

       ```powershell
        Move-ClusterSharedVolume -Name <name> -Node <original_node>
        ```

1. (Optional) Space reclamation after fixed to thin conversion occurs naturally over time. To speed up the process, run slab consolidation using the following command:

    ```powershell
    Get-Volume -FriendlyName <name > | Optimize-Volume -SlabConsolidate
    ```
    
    > [!NOTE]
    > Slab consolidation runs with low priority by default. To complete slab consolidation faster but with a small impact to foreground I/O, run the above command with the `-NormalPriority` parameter.

1. Confirm that `ProvisioningType` is set to `Thin` and `AllocatedSize` is less than the volume size (`Size`):

    ```powershell
    Get-VirtualDisk -FriendlyName <name> | FL AllocatedSize, Size, ProvisioningType
    ```

## Next steps

Learn more about [storage thin provisioning](thin-provisioning.md).