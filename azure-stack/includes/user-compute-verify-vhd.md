---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 2/1/2021
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

Before uploading your VHD, you must validate that the VHD meets the requirements. VHDs that don't meet the requirements will fail to load in Azure Stack Hub.

1. You will use the PowerShell modules found with Hyper-V. Activating Hyper-V installs supporting PowerShell modules. You can check that you have the module by opening PowerShell with an elevated prompt and running the following cmdlet:

    ```powershell  
    Get-Command -Module hyper-v
    ```

    If you do not have the Hyper-V commands, see, see [Working with Hyper-V and Windows PowerShell](/virtualization/hyper-v-on-windows/quick-start/try-hyper-v-powershell). 

2. Get the path to your VHD on your machine. Run the following cmdlet:

    ```powershell  
    get-vhd <path-to-your-VHD>
    ```

    The cmdlet will return the VHD object and display the attributes, such as:
    
    ```powershell  
    ComputerName            : YOURMACHINENAME
    Path                    : <path-to-your-VHD>
    VhdFormat               : VHD
    VhdType                 : Fixed
    FileSize                : 68719477248
    Size                    : 68719476736
    MinimumSize             : 32212254720
    LogicalSectorSize       : 512
    PhysicalSectorSize      : 512
    BlockSize               : 0
    ParentPath              :
    DiskIdentifier          : 3C084D21-652A-4C0E-B2D1-63A8E8E64C0C
    FragmentationPercentage : 0
    Alignment               : 1
    Attached                : False
    DiskNumber              :
    IsPMEMCompatible        : False
    AddressAbstractionType  : None
    Number                  :
    ```

3. With the VHD object, check that meets the requirements for Azure Stack Hub.
    - [VHD is of fixed type.](#vhd-is-of-fixed-type)
    - [VHD has minimum virtual size of at least 20 MB.](#vhd-has-minimum-virtual-size-of-at-least-20-mb)
    - [VHD is aligned.](#vhd-is-aligned)
    - [VHD blob length = virtual size + vhd footer length (512).](#vhd-blob-length) 
    
    In addition, Azure Stack Hub only supports images from [generation one (1) VMs.](#generation-one-vms)

4. If your VHD is not compatible with Azure Stack Hub, you will need to return to the source image and Hyper-V, create a VHD that meets the requirements, and upload. To minimize possible corruption in the upload process, use AzCopy.

### How to fix your VHD

The following requirements must be met for compatibility of your VHD with Azure Stack Hub.

#### VHD is of fixed type
**Identify**: Use `get-vhd` cmdlet to get the VHD object.  
**Fix**: You can convert a VHDX file to VHD, convert a dynamically expanding disk to a fixed-size disk, but you can't change a VM's generation.
Use [Hyper-V Manager or PowerShell](/azure/virtual-machines/windows/prepare-for-upload-vhd-image#use-hyper-v-manager-to-convert-the-disk) to convert the disk.

### VHD has minimum virtual size of at least 20 MB
**Identify**: Use `get-vhd` cmdlet to get the VHD object.  
**Fix**: Use [Hyper-V Manager or PowerShell](/azure/virtual-machines/windows/prepare-for-upload-vhd-image#use-hyper-v-manager-to-resize-the-disk) to resize the disk. 

### VHD is aligned
**Identify**: Use `get-vhd` cmdlet to get the VHD object.  
**Fix**: The virtual size must be a multiple of one (1) MB. 

Disks must have a virtual size aligned to 1 MiB. If your VHD is a fraction of 1 MiB, you'll need to resize the disk to a multiple of 1 MiB. Disks that are fractions of a MiB cause errors when creating images from the uploaded VHD. 
To verify the size you can use the PowerShell Get-VHD cmdlet to show "Size", which must be a multiple of 1 MiB in Azure, and "FileSize", which will be equal to "Size" plus 512 bytes for the VHD footer.

Use [Hyper-V Manager or PowerShell](/azure/virtual-machines/windows/prepare-for-upload-vhd-image#use-hyper-v-manager-to-resize-the-disk) to resize the disk. 


### VHD blob length
**Identify**: Use the `get-vhd` cmdlet to show `Size`   
**Fix**: The VHD blob length = virtual size + vhd footer length (512). A small footer at the end of the blob describes the properties of the VHD. `Size` must be a multiple of 1 MiB in Azure, and `FileSize`, which will be equal to `Size` + 512 bytes for the VHD footer.

Use [Hyper-V Manager or PowerShell](/azure/virtual-machines/windows/prepare-for-upload-vhd-image#use-hyper-v-manager-to-resize-the-disk) to resize the disk. 

### Generation one VMs
**Identify**: To confirm if your virtual machine is Generation 1, use the cmdlet `Get-VM | Format-Table Name, Generation`.  
**Fix**: You will need to recreate your VM in your hypervisor (Hyper-V).