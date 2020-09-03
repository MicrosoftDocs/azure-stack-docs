---
title: Use the CSV in-memory read cache with Azure Stack HCI
description: This topic describes how to use system memory to boost performance.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/03/2020
---

# Use the CSV in-memory read cache with Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic describes how to use system memory to boost the performance of Azure Stack HCI.

Azure Stack HCI is compatible with the Cluster Shared Volume (CSV) in-memory read cache. Using system memory to cache reads can improve performance for applications like Hyper-V, which uses unbuffered I/O to access VHD or VHDX files. (Unbuffered IOs are any operations that are not cached by the Windows Cache Manager.)

Because the in-memory cache is server-local, it improves data locality: recent reads are cached in memory on the same host where the virtual machine is running, reducing how often reads go over the network. This results in lower latency and better storage performance.

## Planning considerations

The in-memory read cache is most effective for read-intensive workloads, such as Virtual Desktop Infrastructure (VDI). Conversely, if the workload is extremely write-intensive, the cache may introduce more overhead than value and should be disabled.

You can use up to 80% of total physical memory for the CSV in-memory read cache. Be careful to leave enough memory for your virtual machines!

  > [!NOTE]
  > Certain microbenchmarking tools like DISKSPD and [VM Fleet](https://github.com/Microsoft/diskspd/tree/master/Frameworks/VMFleet) may produce worse results with the CSV in-memory read cache enabled than without it. By default VM Fleet creates one 10 GiB VHDX per virtual machine – approximately 1 TiB total for 100 VMs – and then performs *uniformly random* reads and writes to them. Unlike real workloads, the reads don't follow any predictable or repetitive pattern, so the in-memory cache is not effective and just incurs overhead.

## Configuring the in-memory read cache

The CSV in-memory read cache is available in both Windows Server 2019 and Windows Server 2016 with the same functionality. In Windows Server 2019, it's on by default with 1 gibibyte (GiB) allocated. In Windows Server 2016, it's off by default.

| OS version          | Default CSV cache size |
|---------------------|------------------------|
| Windows Server 2016 | 0 (disabled)           |
| Windows Server 2019 | 1 GiB                  |

To see how much memory is allocated using PowerShell, run:

```PowerShell
(Get-Cluster).BlockCacheSize
```

The value returned is in mebibytes (MiB) per server. For example, `1024` represents 1 GiB.

To change how much memory is allocated, modify this value using PowerShell. For example, to allocate 2 GiB per server, run:

```PowerShell
(Get-Cluster).BlockCacheSize = 2048
```

For changes to take effect immediately, pause then resume your CSV volumes, or move them between servers. For example, use this PowerShell fragment to move each CSV to another server node and back again:

```PowerShell
Get-ClusterSharedVolume | ForEach {
    $Owner = $_.OwnerNode
    $_ | Move-ClusterSharedVolume
    $_ | Move-ClusterSharedVolume -Node $Owner
}
```

## Next steps

For related information, see also:

- [Understand the server-side cache](../concepts/cache.md)
- [Use Cluster Shared Volumes in a failover cluster](/windows-server/failover-clustering/failover-cluster-csvs#enable-the-csv-cache-for-read-intensive-workloads-optional)
