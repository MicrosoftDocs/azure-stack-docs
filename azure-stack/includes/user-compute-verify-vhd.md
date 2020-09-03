---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 08/04/2020
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

Before uploading your VHD, you must validate that the VHD meets the requirements. VHDs that don't meet the requirements will fail to load in Azure Stack Hub.

1. You will use the PowerShell modules found with Hyper-V. Activating Hyper-V installs supporting PowerShell modules. You can check that you have the module by opening PowerShell with an elevated prompt and running the following cmdlet:

    ```powershell  
    Get-Command -Module hyper-v
    ```

    If you do not have the Hyper-V commands, see, see [Working with Hyper-V and Windows PowerShell](https://docs.microsoft.com/virtualization/hyper-v-on-windows/quick-start/try-hyper-v-powershell). 

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
    - [VHD is of fixed type.]()
    - [VHD footer cookie has first eight (8) bytes **conectix** as expected.]()
    - [VHD has minimum virtual size of at least 20 MB.]()
    - [VHD is aligned.]()
    - [VHD blob length = virtual size + vhd footer length (512).]() 
    
    In addition, Azure Stack Hub only supports images from [generation one (1) VMs.]()

4. If your VHD is not compatible with Azure Stack Hub, you will need to return to the source image and Hyper-V and create a VHD that meets the requirements.

### How to fix your VHD

#### VHD is of fixed type.
**Identify**: VHD object returned by `get-vhd`.  
**Fix**: You can convert a VHDX file to VHD, convert a dynamically expanding disk to a fixed-size disk, but you can't change a VM's generation.
Use Hyper-V Manager or PowerShell to convert the disk: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/prepare-for-upload-vhd-image#use-hyper-v-manager-to-convert-the-disk

### VHD footer cookie has first eight (8) bytes conectix as expected
**Identify**: A message is noted in the Azure Stack Hub logs.
```text  
Validation of blob https://storageaccount.your-azure-stack.com/container/your-vhd-upload.vhd.

Validation error: Only blobs formatted as VHDs can be imported.

Blob footer mismatch, Field: Cookie Expected : conectix Actual :
```

The connectix string on the blob footer is used by Microsoft to ensure that the file is a hard disk image. If the file does not have it, it means the VHD might be corrupted.

- The VHD was already updated without this string.
- The VHD got corrupted during the upload process.

You can use the DumpOffSet tool to check if your local VHD has the string.

```powershell  
<PathToDumpOffSetTool>\DumpOffset.exe -file "C:\PathToVhd\your-vhd-upload.vhd" -dumpbytes <Size from step above> 512
```

If the VHD doesn't have the string, then you will need to regenerate the VHD using Hyper-V so that it has the string.

If the VHD does have the string, then it was corrupted during the upload process. You should use AzCopy or Azure Data Explorer when uploading your VHD to your storage container.

**Fix**: 

### **Identify**: VHD has minimum virtual size of at least 20 MB.
**Identify**: VHD object returned by `get-vhd`.  
**Fix**: Use [Hyper-V Manager or PowerShell](/azure/virtual-machines/windows/prepare-for-upload-vhd-image#use-hyper-v-manager-to-resize-the-disk) to resize the disk. 

### VHD is aligned
**Identify**: VHD object returned by `get-vhd`.  
**Fix**: The virtual size must be a multiple of one (1) MB. 

Disks must have a virtual size aligned to 1 MiB. If your VHD is a fraction of 1 MiB, you'll need to resize the disk to a multiple of 1 MiB. Disks that are fractions of a MiB cause errors when creating images from the uploaded VHD. 
To verify the size you can use the PowerShell Get-VHD cmdlet to show "Size", which must be a multiple of 1 MiB in Azure, and "FileSize", which will be equal to "Size" plus 512 bytes for the VHD footer.

Use [Hyper-V Manager or PowerShell](/azure/virtual-machines/windows/prepare-for-upload-vhd-image#use-hyper-v-manager-to-resize-the-disk) to resize the disk. 


### VHD blob length = virtual size + vhd footer length (512). 
**Identify**: A small footer at the end of the blob describes the properties of the VHD.  
**Fix**: To verify the size you can use the `get-vhd` cmdlet to show `Size`, which must be a multiple of 1 MiB in Azure, and `FileSize`, which will be equal to `Size` + 512 bytes for the VHD footer.

Use [Hyper-V Manager or PowerShell](/azure/virtual-machines/windows/prepare-for-upload-vhd-image#use-hyper-v-manager-to-resize-the-disk) to resize the disk. 

### Generation one (1) VMs
**Identify**: To confirm if your virtual machine is Generation 1, use the 'Get-VM | Format-Table Name, Generation' PowerShell cmdlet.  
**Fix**: You will need to recreate your VM in your hypervisor (Hyper-V).