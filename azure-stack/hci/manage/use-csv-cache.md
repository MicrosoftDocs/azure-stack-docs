---
title: Use the CSV in-memory read cache with Azure Stack HCI and Windows Server clusters
description: This topic describes how to use system memory to boost performance.
author: jasongerend
ms.author: jgerend
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/18/2021
---

# Use the CSV in-memory read cache

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

This topic describes how to use system memory to boost the performance of Azure Stack HCI by caching frequent reads. Writes cannot be cached in memory.

Azure Stack HCI is compatible with the Cluster Shared Volume (CSV) in-memory read cache. Using system memory to cache reads can improve performance for applications like Hyper-V, which uses unbuffered I/O to access VHD or VHDX files. (Unbuffered I/Os are any operations that are not cached by the Windows Cache Manager.)

Because the in-memory cache is server-local, it improves data locality: recent reads are cached in memory on the same host where the virtual machine (VM) is running, reducing how often reads go over the network. This results in lower latency and better storage performance.

Note that the CSV in-memory read cache is different from the [storage pool cache](../concepts/cache.md).

## Planning considerations

The in-memory read cache is most effective for read-intensive workloads, such as Virtual Desktop Infrastructure (VDI). Conversely, if the workload is extremely write-intensive, the cache may introduce more overhead than value and should be disabled.

You can use up to 80% of total physical memory for the CSV in-memory read cache. Be careful to leave enough memory for your VMs!

  > [!NOTE]
  > Certain microbenchmarking tools like DISKSPD and [VM Fleet](https://github.com/Microsoft/diskspd/tree/master/Frameworks/VMFleet) may produce worse results with the CSV in-memory read cache enabled than without it. By default VM Fleet creates one 10 GiB VHDX per VM – approximately 1 TiB total for 100 VMs – and then performs *uniformly random* reads and writes to them. Unlike real workloads, the reads don't follow any predictable or repetitive pattern, so the in-memory cache is not effective and just incurs overhead.

## Configuring the in-memory read cache

The CSV in-memory read cache is available in Azure Stack HCI, Windows Server 2019, and Windows Server 2016 with the same functionality. In Azure Stack HCI and Windows Server 2019, it's on by default with 1 gibibyte (GiB) allocated. In Windows Server 2016, it's off by default.

| OS version          | Default CSV cache size |
|---------------------|------------------------|
| Azure Stack HCI     | 1 GiB                  |
| Windows Server 2019 | 1 GiB                  |
| Windows Server 2016 | 0 (disabled)           |

### Configure the cache using Windows Admin Center

To configure the cache using Windows Admin Center, select **Settings** at the very bottom of the **Tools** menu on the left. Then go to **Storage > In-memory cache**. A checkbox enables or disables the cache, and you can also specify the maximum memory per server to be allocated to the cache. Be sure to click **Save** at the bottom of the page after making your changes.

:::image type="content" source="media/use-csv-cache/in-memory-cache.png" alt-text="In Windows Admin Center, a checkbox enables or disables the cache. You can also specify the maximum memory per server to be allocated to the cache." lightbox="media/use-csv-cache/in-memory-cache.png":::

### Configure the cache using PowerShell

To see how much memory is allocated using PowerShell, run:

```PowerShell
(Get-Cluster).BlockCacheSize
```

The value returned is in mebibytes (MiB) per server. For example, `1024` represents 1 GiB.

To change how much memory is allocated, modify this value using PowerShell. For example, to allocate 2 GiB per server, run:

```PowerShell
(Get-Cluster).BlockCacheSize = 2048
```

For changes to take effect immediately, pause and then resume your CSV volumes, or move them between servers. For example, use this PowerShell fragment to move each CSV to another server node and back again:

```PowerShell
Get-ClusterSharedVolume | ForEach {
    $Owner = $_.OwnerNode
    $_ | Move-ClusterSharedVolume
    $_ | Move-ClusterSharedVolume -Node $Owner
}
```

## Next steps

For related information, see also:

- [Understand the storage pool cache](../concepts/cache.md)
- [Use Cluster Shared Volumes in a failover cluster](/windows-server/failover-clustering/failover-cluster-csvs#enable-the-csv-cache-for-read-intensive-workloads-optional)
