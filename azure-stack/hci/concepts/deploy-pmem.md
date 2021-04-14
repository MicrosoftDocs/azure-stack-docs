---
title: Understand and deploy persistent memory 
description: This article provides details on what persistent memory is and how to deploy it as storage in Azure Stack HCI and Windows Server.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/14/2021
---

# Understand and deploy persistent memory

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019, Windows Server 2016, Windows Server (Semi-Annual Channel), Windows 10

Persistent memory (or PMem) is a new type of memory technology that that retains its content through power cycles and can be used as top-tier storage, which is why you may hear people refer to PMem as "storage-class memory" or SCM. This article provides background on persistent memory and explains how to deploy it as the top storage tier in Azure Stack HCI and Windows Server.

## What is persistent memory?

PMem is a type of non-volatile media that's slower than DRAM, but provides higher throughput than SSD and NVMe. Persistent memory modules come in much larger capacities and are less expensive per GB than DRAM modules, however they are still more expensive than NVMe. Memory contents remain even when system power goes down in the event of an unexpected power loss, user initiated shutdown, or system crash. This means that you can use PMem modules as ultra-fast, persistent storage.

Azure Stack HCI and Windows Server 2019 support using persistent memory as either a cache or a capacity drive. Given the pricing model, persistent memory provides the most value as either a cache or as a small amount of dedicated storage for memory mapping data. For more information about how to set up cache and capacity drives, see [Understanding the storage pool cache](cache.md) and [Plan volumes](plan-volumes.md). **Note that we need to provide Pmem guidance on these pages as well.**

## Persistent memory concepts

This section describes the basic concepts you'll need to understand in order to deploy PMem in Windows Server and Azure Stack HCI environments to reduce I/O bottlenecks and improve performance.

### Access methods

There are two methods for accessing persistent memory. They are:

1. **Block access**, which operates like storage for app compatibility. In this configuration, the data flows through the stack. You can use this configuration in combination with NTFS and ReFS, and it is the recommended configuration for most use cases.
1. **Direct access (DAX)**, which operates like memory to get the lowest latency. Note that you can only use DAX in combination with NTFS. **If you don't use DAX correctly, there is potential for data loss.** We strongly recommend that DAX be used in conjunction with [Block translation table (BTT)](#block-translation-table) to mitigate that risk. [Learn more about DAX](pmem-dax.md).

Azure Stack HCI only supports block access, with BTT turned on. **Tom: We should outline the differences, if any, for using PMem in Azure Stack HCI, Windows Server, and Windows 10 environments.**

### Regions

A region is a set of one or more PMem modules. Regions are often created as [interleaved sets](#understand-interleaved-sets) in which multiple PMem modules appear as a single logical virtual address space to increase throughput. To increase available bandwidth, adjacent virtual addresses are spread across multiple PMem modules. Regions can usually be created in a server platform's BIOS.

### Namespaces

To use PMem as storage, you must define at least one namespace, which is a contiguously addressed range of non-volatile memory that you can think of like a hard disk partition or LUN. You can create multiple namespaces using Windows PowerShell cmdlets to divide up the available raw capacity. Each PMem module contains a Label Storage Area (LSA) that stores the configuration metadata to define a namespace. **Tom: Is a "PmemDisk" in PowerShell actually a namespace? Are they the same thing, or something different? Do we need to go into namespace types, like Intel does? Which would be relevant to our users (Filesystem-DAX, Device Dax, Sector, or Raw)?**

### Block translation table

Unlike traditional solid-state drives, persistent memory modules do not protect against "torn writes" that can occur in the case of a power failure or system outage, putting data at risk. BTT mitigates this risk by providing atomic sector update semantics for persistent memory devices, essentially enabling block-like sector writes so that apps can avoid mixing old and new data in a failure scenario. We strongly recommend turning on BTT in most cases. Note that BTT is a property of the Pmem virtual disk itself, so it must be configured correctly very early. **We should definitely tell them how to do this, which will be a specific powershell command/flag when creating the virtual disk. Unfortunately, none of those PMEM powershell commands are documented.**

## Supported hardware

The following table shows supported persistent memory hardware for Azure Stack HCI and Windows Server.

| Persistent Memory Technology                                      | Windows Server 2016 | Azure Stack HCI v20H2/Windows Server 2019 |
|-------------------------------------------------------------------|--------------------------|--------------------------|
| **NVDIMM-N** in persistent mode                                  | Supported                | Supported                |
| **Intel Optane&trade; DC Persistent Memory** in App Direct Mode             | Not Supported            | Supported                |
| **Intel Optane&trade; DC Persistent Memory** in Memory Mode | Supported            | Supported                |

Intel Optane DC Persistent Memory supports both *Memory* (volatile) and *App Direct* (persistent) modes. To use persistent memory modules as storage, you must use App Direct mode. **Tom: Does Memory mode imply the use of DAX? Or not necessarily?**

> [!NOTE]
> When you restart a system that has multiple Intel&reg; Optane&trade; PMem modules in App Direct mode that are divided into multiple namespaces, you might lose access to some or all of the related logical storage disks. This issue occurs on Windows Server 2019 versions that are older than version 1903.
>
> This loss of access occurs because a PMem module is untrained or otherwise fails when the system starts. In such a case, all the storage namespaces on any PMem module on the system fail, including namespaces that do not physically map to the failed module.
>
> To restore access to all the namespaces, [replace the failed module](#replace-persistent-memory).
>
> If a module fails on Windows Server 2019 version 1903 or newer versions, you lose access only to namespaces that physically map to the affected module. Other namespaces are not affected.

## Configure persistent memory

Now, let's dive into how you configure persistent memory. **Tom: As far as I can tell, we skip creating the regions and setting the mode too App Direct with ipmctl. Does that need to be done first? Should we assume the user is using Intel PMem and link to the [Intel docs](https://software.intel.com/content/www/us/en/develop/articles/qsg-part3-windows-provisioning-with-optane-pmem.html), and/or include the steps here? At what point can the user begin using Windows Admin Center for the configuration (i.e., when will the disks show up in WAC? After you create the namespaces?) The Intel docs show screen shots of Device Manager, along with the PowerShell cmdlets.**

### Understand interleaved sets

Interleaved sets can usually be created in a server platform's BIOS to make multiple PMem devices appear as a single disk to the host operating system, increasing throughput for that disk.

> [!NOTE]
> Windows Server 2016 and Windows 10 Anniversary Edition do not support interleaved sets of PMem modules.

Recall that a persistent memory module resides in a standard DIMM (memory) slot, which puts data closer to the processor. This configuration reduces latency and improves fetch performance. To further increase throughput, two or more PMem modules create an n-way interleaved set to stripe read/write operations. The most common configurations are two-way or four-way interleaving.

You can use the `Get-PmemDisk` PowerShell cmdlet to review the configuration of such logical disks, as follows:

```PowerShell
Get-PmemDisk

DiskNumber Size   HealthStatus AtomicityType CanBeRemoved PhysicalDeviceIds UnsafeShutdownCount
---------- ----   ------------ ------------- ------------ ----------------- -------------------
2          252 GB Healthy      None          True         {20, 120}         0
3          252 GB Healthy      None          True         {1020, 1120}      0
```

We can see that the logical PMem disk #2 uses the physical devices Id20 and Id120, and logical PMem disk #3 uses the physical devices Id1020 and Id1120.

To retrieve further information about the interleaved set that a logical drive uses, run the `Get-PmemPhysicalDevice` cmdlet:

```PowerShell
(Get-PmemDisk)[0] | Get-PmemPhysicalDevice

DeviceId DeviceType           HealthStatus OperationalStatus PhysicalLocation FirmwareRevision Persistent memory size Volatile memory size
-------- ----------           ------------ ----------------- ---------------- ---------------- ---------------------- --------------------
20       Intel INVDIMM device Healthy      {Ok}              CPU1_DIMM_C1     102005310        126 GB                 0 GB
120      Intel INVDIMM device Healthy      {Ok}              CPU1_DIMM_F1     102005310        126 GB                 0 GB
```

### Configure interleaved sets

To configure an interleaved set, run the following cmdlet to review all the persistent memory regions that are not assigned to a logical PMem disk on the system:

```PowerShell
Get-PmemUnusedRegion

RegionId TotalSizeInBytes DeviceId
-------- ---------------- --------
       1     270582939648 {20, 120}
       3     270582939648 {1020, 1120}
```

To see all the PMem device information in the system, including device type, location, health and operational status, and so on, run the following cmdlet:

```PowerShell
Get-PmemPhysicalDevice

DeviceId DeviceType           HealthStatus OperationalStatus PhysicalLocation FirmwareRevision Persistent memory size Volatile
                                                                                                                      memory size
-------- ----------           ------------ ----------------- ---------------- ---------------- ---------------------- --------------
1020     Intel INVDIMM device Healthy      {Ok}              CPU2_DIMM_C1     102005310        126 GB                 0 GB
1120     Intel INVDIMM device Healthy      {Ok}              CPU2_DIMM_F1     102005310        126 GB                 0 GB
120      Intel INVDIMM device Healthy      {Ok}              CPU1_DIMM_F1     102005310        126 GB                 0 GB
20       Intel INVDIMM device Healthy      {Ok}              CPU1_DIMM_C1     102005310        126 GB                 0 GB
```

Because we have an available unused PMem region, we can create new persistent memory disks. We can use the unused region to create multiple persistent memory disks by running the following cmdlets:

```PowerShell
Get-PmemUnusedRegion | New-PmemDisk
Creating new persistent memory disk. This may take a few moments.
```

After this is done, we can see the results by running:

```PowerShell
Get-PmemDisk

DiskNumber Size   HealthStatus AtomicityType CanBeRemoved PhysicalDeviceIds UnsafeShutdownCount
---------- ----   ------------ ------------- ------------ ----------------- -------------------
2          252 GB Healthy      None          True         {20, 120}         0
3          252 GB Healthy      None          True         {1020, 1120}      0
```

It is worth noting that we can run `Get-PhysicalDisk | Where MediaType -eq SCM` instead of `Get-PmemDisk` to get the same results. The newly-created PMem disk corresponds one-to-one with drives that appear in PowerShell and in Windows Admin Center.

## Replace persistent memory

If you have to replace a failed module, you have to re-provision the PMem disk (refer to the steps that we outlined previously).

When you troubleshoot, you might have to use `Remove-PmemDisk`. This cmdlet removes a specific persistent memory disk. We can remove all current PMem disks by running the following cmdlets:

```PowerShell
Get-PmemDisk | Remove-PmemDisk

cmdlet Remove-PmemDisk at command pipeline position 1
Supply values for the following parameters:
DiskNumber: 2

This will remove the persistent memory disk(s) from the system and will result in data loss.
Remove the persistent memory disk(s)?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
Removing the persistent memory disk. This may take a few moments.
```

> [!IMPORTANT]
> Removing a persistent memory disk causes data loss on that disk.

Another cmdlet you might need is `Initialize-PmemPhysicalDevice`. This cmdlet initializes the label storage areas on the physical PMem devices, and can clear corrupted label storage information on the devices.

```PowerShell
Get-PmemPhysicalDevice | Initialize-PmemPhysicalDevice

This will initialize the label storage area on the physical persistent memory device(s) and will result in data loss.
Initializes the physical persistent memory device(s)?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
Initializing the physical persistent memory device. This may take a few moments.
Initializing the physical persistent memory device. This may take a few moments.
Initializing the physical persistent memory device. This may take a few moments.
Initializing the physical persistent memory device. This may take a few moments.
```

> [!IMPORTANT]
> `Initialize-PmemPhysicalDevice` causes data loss in persistent memory. Use it only as a last resort to fix persistent memory-related issues.

## PMem in action at Microsoft Ignite

To see some of the benefits of persistent memory, let's look at [this video](http://www.youtube.com/watch?v=8WMXkMLJORc) from Microsoft Ignite 2018.

Any storage system that provides fault tolerance necessarily makes distributed copies of writes. Such operations must traverse the network and amplify backend write traffic. For this reason, the absolute largest IOPS benchmark numbers are typically achieved by measuring reads only, especially if the storage system has common-sense optimizations to read from the local copy whenever possible. Storage Spaces Direct is optimized to do so.

**When measured by using only read operations, the cluster delivered 13,798,674 IOPS.**

If you watch the video closely, you'll notice that what's even more jaw-dropping is the latency. Even at over 13.7 M IOPS, the file system in Windows is reporting latency that's consistently less than 40 µs! (That's the symbol for microseconds, one-millionth of a second.) This speed is an order of magnitude faster than what typical all-flash vendors proudly advertise today.

Together, Storage Spaces Direct in Windows Server 2019 and Intel&reg; Optane&trade; DC persistent memory deliver breakthrough performance. This industry-leading HCI benchmark of over 13.7M IOPS, accompanied by predictable and extremely low latency, is more than double our previous industry-leading benchmark of 6.7M IOPS. What's more, this time we needed only 12 server nodes&mdash;25 percent fewer than before.

The test hardware was a 12-server cluster that was configured to use three-way mirroring and delimited ReFS volumes, **12** x Intel&reg; S2600WFT, **384 GiB** memory, 2 x 28-core "CascadeLake," **1.5 TB** Intel&reg; Optane&trade; DC persistent memory as cache, **32 TB** NVMe (4 x 8 TB Intel&reg; DC P4510) as capacity, **2** x Mellanox ConnectX-4 25 Gbps.

The following table shows the full performance numbers.

| Benchmark                   | Performance         |
|-----------------------------|---------------------|
| 4K 100% random read         | 13.8 million IOPS   |
| 4K 90/10% random read/write | 9.45 million IOPS   |
| 2 MB sequential read        | 549 GB/s throughput |

## Next steps

For related information, see also:

- [Storage Spaces Direct overview](/windows-server/storage/storage-spaces/storage-spaces-direct-overview)
- [Persistent memory health management](pmem-health.md)
- [Understanding the storage pool cache](cache.md)
