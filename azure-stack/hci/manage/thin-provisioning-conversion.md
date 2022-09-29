---
title: Thin provisioning conversion for version 22H2 (preview)
description: Learn how to convert to thin provisioning for version 22H2 (preview)
author: dansisson
ms.topic: how-to
ms.date: 09/30/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Thin provisioning conversion for version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

Storage thin provisioning improves storage efficiency and simplifies management. In Azure Stack HCI version 22H2, existing fixed provisioned volumes can be converted inline to thin volumes using Windows PowerShell.

Fixed provisioning allocates the full size of a volume from the storage pool at the time of creation. This however is inefficient as a portion of the storage pool's resources are depleted despite the volume being empty.

Converting from fixed to thin provisioned volumes returns any unused storage back to the pool for other volumes to leverage. As data is added or removed from the volume, the storage allocation will increase and decrease accordingly.

:::image type="content" source="media/thin-provisioning-conversion/fixed-to-thin-provisioning.png" alt-text="Diagram showing both fixed and thin provisioned volumes." lightbox="media/thin-provisioning-conversion/fixed-to-thin-provisioning.png":::

The following conversion scenarios are *not* supported:

- Scaling down, such as converting a three-way mirror to a two-way mirror.
- Scaling from or to a mirror-accelerated parity volume.
- Scaling from a nested two-way mirror or a nested mirror-accelerated parity volume.

> [!NOTE]
> In this preview release, only one Azure Stack HCI deployment per Active Directory domain is supported.

## Use PowerShell to convert volumes

Use Windows PowerShell to convert from fixed to thin provisioning. Run PowerShell as Administrator and do the following:

1. Check the volume's allocated size, size, and provisioning type by running the following command:

    ```powershell
    Get-VirtualDisk -FriendlyName <name> | FL AllocatedSize, Size, ProvisioningType
    ```

    This shows sample output for the above command:

    :::image type="content" source="media/thin-provisioning-conversion/get-virtual-disk.png" alt-text="Screenshot of PowerShell output window." lightbox="media/thin-provisioning-conversion/get-virtual-disk.png":::

1. Convert the volume from fixed to thin provisioned as follows:

      <!---:::image type="content" source="media/pp3-release-notes/Picture3.png" alt-text="Screenshot of Active Directory Users Object window." lightbox="media/pp3-release-notes/Picture3.png":::--->

    **For a non-tiered volume**, run the following command:

   ```powershell
    Set-VirtualDisk -FriendlyName <volume_name> -ProvisioningType Thin 
   ```

    **For a tiered volume**, run the following commands:

   ```powershell
    Get-StorageTier <mirror_tier> | Set-StorageTier -ProvisioningType Thin
    Get-StorageTier <parity_tier> | Set-StorageTier -ProvisioningType Thin
   ```

1. Remount the volume for the change to take effect. A remount is needed as Resilient File System (ReFS) only recognizes the provisioning type at mount time.

    **For single-node clusters**, complete the following steps:

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

    **For two-node and greater clusters**, do the following:

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