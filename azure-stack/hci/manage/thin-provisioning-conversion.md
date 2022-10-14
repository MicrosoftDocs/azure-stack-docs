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

> Applies to: Azure Stack HCI, version 22H2

This article describes how you can use Windows PowerShell to convert existing fixed provisioned volumes to thin provisioned volumes inline on your Azure Stack HCI cluster.

## Fixed versus thin provisioning

Fixed provisioning allocates the full size of a volume from the storage pool at the time of creation. This method is inefficient as a portion of the storage pool's resources are depleted despite the volume being empty.

Converting from fixed to thin provisioned volumes returns any unused storage back to the pool for other volumes to leverage. As data is added or removed from the volume, the storage allocation will increase and decrease accordingly.

:::image type="content" source="media/thin-provisioning-conversion/fixed-to-thin-provisioning.png" alt-text="Diagram showing both fixed and thin provisioned volumes." lightbox="media/thin-provisioning-conversion/fixed-to-thin-provisioning.png":::

## Use PowerShell to convert volumes

Use PowerShell to convert from fixed to thin provisioning as follows:

1. Run PowerShell as Administrator.
1. Check the volume's allocated size, size, and provisioning type.

    **For a non-tiered volume**, run the following command:

    ```powershell
    Get-VirtualDisk -FriendlyName <volume_name> | FL AllocatedSize, Size, ProvisioningType
    ```

    Here is a sample output for the preceding command:

    ```powershell
    PS C:\> New-Volume -FriendlyName NonTierVol -Size 5TB -ProvisioningType Fixed

    DriveLetter  FriendlyName  FileSystemType  DriveType  HealthStatus  OperationalStatus
    -----------  ------------  --------------  ---------  ------------  -----------------
                 NonTierVol    CSVFS_ReFS      Fixed      Healthy       OK

    PS C:\> Get-VirtualDisk -FriendlyName NonTierVol | FL AllocatedSize, Size, ProvisioningType

    Allocated Size   : 5497558138880
    Size             : 5497558138880
    ProvisioningType : Fixed
    ```
    
    **For a tiered volume**, run the following command:
    
    ```powershell
    Get-StorageTier -FriendlyName <volume_name*> | FL AllocatedSize, Size, ProvisioningType
   ```
   
   Here is a sample output for the preceding command:

   ```powershell
   PS C:\> Get-StorageTier -FriendlyName TierVol* | FL AllocatedSize, Size, ProvisioningType
   
   AllocatedSize    : 80530636800
   Size             : 80530636800
   ProvisioningType : Fixed
   
   AllocatedSize    : 26843545600
   Size             : 26843545600
   ProvisioningType : Fixed
   ```
    
1. Convert the volume from fixed to thin provisioned as follows:

    **For a non-tiered volume**, run the following command:

   ```powershell
    Set-VirtualDisk -FriendlyName <volume_name> -ProvisioningType Thin 
   ```
    
    **For a tiered volume**, run the following command:
    
   ```powershell
    Get-StorageTier <volume_name*> | Set-StorageTier -ProvisioningType Thin
   ```

1. Remount the volume for the change to take effect. A remount is needed as Resilient File System (ReFS) only recognizes the provisioning type at mount time.

    **For single-server clusters**, complete the following steps. Workloads may experience minor interruptions, it is recommended to do this operation during maintenance hours.

    1. Get the cluster shared volume (CSV) name:

        ```powershell
        Get-ClusterSharedVolume
        ```

    1. Next, take the volume offline:

        ```powershell
        Stop-ClusterResource -Name <name>
        ```
        
        Here is a sample output for the preceding command:

        ```powershell
        PS C:\> Stop-ClusterResource -Name "Cluster Virtual Disk (TierVol)"
        
        Name                           State   Node
        ----                           -----   ----
        Cluster Virtual Disk (TierVol) Offline NodeA
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
        Here is a sample output for the preceding command:

        ```powershell
        PS C:\> Get-ClusterSharedVolume
        
        Name                               State  Node
        ----                               -----  ----
        Cluster Virtual Disk (NonTierVol)  Online NodeA
        Cluster Virtual Disk (TierVol)     Online NodeB
        
        PS C:\> Move-ClusterSharedVolume -Name "Cluster Virtual Disk (TierVol)" -Node NodeA
        
        Name                           State         Node
        ----                           -----         ----
        Cluster Virtual Disk (TierVol) Online        NodeA
    
    1. Then move the CSV back to its original node:

       ```powershell
        Move-ClusterSharedVolume -Name <name> -Node <original_node>
        ```

1. (Optional) Space reclamation after fixed to thin conversion occurs naturally over time. To speed up the process, run slab consolidation from the node that the volume resides using the following command:

    ```powershell
    Get-Volume -FriendlyName <name> | Optimize-Volume -SlabConsolidate
    ```
    
    > [!NOTE]
    > Slab consolidation runs with low priority by default. To complete slab consolidation faster but with a small impact to foreground I/O, run the above command with the `-NormalPriority` parameter.

1. Confirm that `ProvisioningType` is set to `Thin` and `AllocatedSize` is less than the volume size (`Size`):

    **For a non-tiered volume**, run the following command:
    
    ```powershell
    Get-VirtualDisk -FriendlyName <volume_name> | FL AllocatedSize, Size, ProvisioningType
    ```
    **For a tiered volume**, run the following command:

   ```powershell
    Get-StorageTier -FriendlyName <volume_name*> | FL AllocatedSize, Size, ProvisioningType
   ```

## Next steps

Learn more about [storage thin provisioning](thin-provisioning.md).
