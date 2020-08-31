
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

3. With the VHD object, check that it meets the requirements.
    - VHD is of fixed type.
    - VHD footer cookie has first eight (8) bytes **conectix** as expected.
    - VHD has minimum virtual size of at least 20 MB.
    - VHD is aligned, that is, the virtual size must be a multiple of one (1) MB.
    - VHD blob length = virtual size + vhd footer length (512). A small footer at the end of the blob describes the properties of the VHD. 
    
    In addition, Azure Stack Hub only supports images from generation one (1) VMs.

4. If your VHD is not compatible with Azure Stack Hub, you will need to return to the source image and Hyper-V and create a VHD that meets the requirements.