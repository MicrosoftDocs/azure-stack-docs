---
title: Understand Direct Access (DAX) and create DAX volumes with persistent memory devices
description: This article provides information on DAX and how to configure it with PMem modules using the block translation table (BTT).
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/15/2021
---

# Understand DAX

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019, Windows Server 2016, Windows Server (Semi-Annual Channel), Windows 10 **Tom: We'll need to find out whether DAX even works with Azure Stack HCI, and find the guidance that SQL has provided to customers on the use of PMEM and DAX.**

**Direct access (DAX)**  treats persistent memory devices as byte-addressable memory to get the lowest latency, providing direct access to byte-addressable memory rather than following normal file system block I/O conventions. The app directly modifies the persistent memory, bypassing the software overhead of the I/O stack. When used properly by DAX-aware code (i.e. by memory mapping data), this can provide significant performance benefits. However, DAX has a number of compatibility issues, and it won’t provide significant benefits without DAX-aware code.

> [!IMPORTANT]
> **If you don't use DAX correctly, there is potential for data loss.** There are certain specific use cases for which using DAX is appropriate; however, we strongly recommend that DAX be used in conjunction with the block translation table (BTT) to enable block-like sector writes.

You can only use DAX with the NTFS file system. DAX is a property of the file system, so it must be specified when [formatting an NTFS volume](/powershell/module/storage/Format-Volume?view=windowsserver2019-ps&viewFallbackFrom=win10-ps).

The following figure shows an example of a DAX configuration:

![DAX stack](media/pmem/dax.png)

## Configure DAX by using Windows PowerShell

Use PowerShell cmdlets to create a DAX volume on a persistent memory disk. By using the **-IsDax** switch, we can format a volume to be DAX-enabled.

```PowerShell
Format-Volume -IsDax:$true
```

The following code snippet creates a DAX volume on a persistent memory disk.

```PowerShell
# Here we use the first pmem disk to create the volume as an example
$disk = (Get-PmemDisk)[0] | Get-PhysicalDisk | Get-Disk
# Initialize the disk to GPT if it is not initialized
If ($disk.partitionstyle -eq "RAW") {$disk | Initialize-Disk -PartitionStyle GPT}
# Create a partition with drive letter 'S' (can use any available drive letter)
$disk | New-Partition -DriveLetter S -UseMaximumSize

   DiskPath: \\?\scmld#ven_8980&dev_097a&subsys_89804151&rev_0018#3&1b1819f6&0&03018089fb63494db728d8418b3cbbf549997891#{53f56307-b6
bf-11d0-94f2-00a0c91efb8b}

PartitionNumber  DriveLetter Offset                                               Size Type
---------------  ----------- ------                                               ---- ----
2                S           16777216                                        251.98 GB Basic

# Format the volume with drive letter 'S' to DAX Volume
Format-Volume -FileSystem NTFS -IsDax:$true -DriveLetter S

DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining      Size
----------- ------------ -------------- --------- ------------ ----------------- -------------      ----
S                        NTFS           Fixed     Healthy      OK                    251.91 GB 251.98 GB

# Verify the volume is DAX enabled
Get-Partition -DriveLetter S | fl

UniqueId             : {00000000-0000-0000-0000-000100000000}SCMLD\VEN_8980&DEV_097A&SUBSYS_89804151&REV_0018\3&1B1819F6&0&03018089F
                       B63494DB728D8418B3CBBF549997891:WIN-8KGI228ULGA
AccessPaths          : {S:\, \\?\Volume{cf468ffa-ae17-4139-a575-717547d4df09}\}
DiskNumber           : 2
DiskPath             : \\?\scmld#ven_8980&dev_097a&subsys_89804151&rev_0018#3&1b1819f6&0&03018089fb63494db728d8418b3cbbf549997891#{5
                       3f56307-b6bf-11d0-94f2-00a0c91efb8b}
DriveLetter          : S
Guid                 : {cf468ffa-ae17-4139-a575-717547d4df09}
IsActive             : False
IsBoot               : False
IsHidden             : False
IsOffline            : False
IsReadOnly           : False
IsShadowCopy         : False
IsDAX                : True                   # <- True: DAX enabled
IsSystem             : False
NoDefaultDriveLetter : False
Offset               : 16777216
OperationalStatus    : Online
PartitionNumber      : 2
Size                 : 251.98 GB
Type                 : Basic
```

## Next steps

For related information, see also:

- [Understand and deploy persistent memory](deploy-pmem.md)
- [Persistent memory health management](pmem-health.md)
