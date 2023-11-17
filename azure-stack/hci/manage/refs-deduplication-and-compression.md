---
title: Optimize storage with ReFS deduplication and compression in Azure Stack HCI (preview)
description: Learn how to use ReFS deduplication and compression in Azure Stack HCI to optimize storage.  (preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 11/17/2023
---

# Optimize storage with ReFS deduplication and compression in Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes the Resilient File System (ReFS) deduplication and compression feature and how to use this feature in Azure Stack HCI to optimize storage.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## What is ReFS deduplication and compression?

ReFS deduplication and compression is a storage optimization feature designed specifically for active workloads, such as [Azure virtual desktop infrastructure (VDI) on Azure Stack HCI](../deploy/virtual-desktop-infrastructure.md). This feature helps optimize storage usage and reduce storage cost.

This feature uses [ReFS block cloning](/windows-server/storage/refs/block-cloning) to reduce data movement and enable metadata only operations. The feature operates at the data block level and uses fixed block size depending on the cluster size. The compression engine generates a heatmap to identify if a block should be eligible for compression, optimizing for CPU usage.

You can run ReFS deduplication and compression as a one-time job or automate it with scheduled jobs. This feature works with both all-flash and hybrid systems and supports various resiliency settings, such as two-way mirror, nested two-way mirror, three-way mirror, and mirror accelerated parity.

## Benefits

Here are the benefits of using ReFS deduplication and compression:

- **Storage savings for active workloads.** Designed for active workloads, such as VDI, ensuring efficient performance in demanding environments.
- **Multiple modes.** Operates in three modes: deduplication only, compression only, and deduplication and compression (default mode), allowing optimization based on your needs.
- **Incremental deduplication.** Deduplicates only new or changed data as opposed to scanning the entire volume every time, optimizing job duration and reducing impact on system performance.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- You have access to an Azure Stack HCI cluster that is deployed and registered.
- You have the cluster shared volume (CSV) created on the cluster and you have access to it.
- The CSV doesn't have the Windows Data Deduplication feature enabled already.

## Use ReFS deduplication and compression

You can use ReFS deduplication and compression via Windows Admin Center or PowerShell. PowerShell allows both manual and automated jobs, whereas Windows Admin Center supports only scheduled jobs. Regardless of the method, you can customize job settings and utilize file change tracking for quicker subsequent runs.

### Enable and run ReFS deduplication and compression

# [Windows Admin Center](#tab/windowsadmincenter)

In Windows Admin Center, you can create a schedule for ReFS deduplication and compression to run on an existing volume or a new volume during volume creation.

Follow these steps to enable ReFS deduplication and compression via Windows Admin Center and set a schedule when it should run:

1. Connect to a cluster, and then on the **Tools** pane on the left, select **Volumes**.

1. On the **Volumes** page, select the **Inventory** tab, select the appropriate volume, and then select **Settings**. To turn on ReFS deduplication and compression for a new volume, select **+ Create**.

1. On the **Volume settings** pane on the right, under **More options** dropdown, select the **Use ReFS deduplication and compression** checkbox.

1. Select the days of the week when ReFS deduplication and compression should run, the time for a job to start running, and maximum duration (default is unlimited), and then select **Save**.

    The following screenshot shows that ReFS deduplication and compression runs on Friday and Saturday at 10:40 AM with a maximum duration of 2 hours, starting from 9/22/2023. If the **Start** date was changed to 9/21/2023, the first run will still be 9/22/2023 10:40AM as that's the first Friday after 9/21/2023.

    :::image type="content" source="media/refs-deduplication-compression/select-refs-deduplication-compression-settings.png" alt-text="Screenshot of the Volume settings pane displaying the ReFS deduplication and compression settings." lightbox="media/refs-deduplication-compression/select-refs-deduplication-compression-settings.png":::

1. Verify the changes in the **Properties** section of the volume. The schedule appears under the **Properties** section and displays the savings breakdown and next scheduled run time. These savings are updated after each run, and you can observe the performance impact in the charts under the **Performance** section.

    :::image type="content" source="media/refs-deduplication-compression/volume-properties.png" alt-text="Screenshot of the properties section of a volume showing the savings breakdown and next scheduled run time." lightbox="media/refs-deduplication-compression/volume-properties.png":::

# [PowerShell](#tab/powershell)

To use ReFS deduplication and compression via PowerShell, you first enable the feature and then run it as a one-time manual job or automate to run it as scheduled jobs. The jobs are set at the CSV level for each cluster and can be customized based on modes, duration, system resource usage, and more.

#### Enable ReFS deduplication and compression

Follow these steps to enable ReFS deduplication and compression via PowerShell:

1. Connect to your Azure Stack HCI cluster and run PowerShell as administrator.

1. You must run all the commands to modify settings on a given volume on the owner node. Run the following cmdlet to show all CSV owner nodes and volume path:

    ```powershell
    Get-ClusterSharedVolume | FT Name, OwnerNode, SharedVolumeInfo
    ```

    Here's a sample output of the cmdlet usage:

    ```output
    Name                           OwnerNode   SharedVolumeInfo
    ----                           ---------   ----------------
    Cluster Virtual Disk (Volume1) hci-server1 {C:\ClusterStorage\Volume1}
    ```

1. Run the following cmdlet to enable ReFS deduplication and compression on a specific volume:

    ```powershell
    Enable-ReFSDedup -Volume <path> -Type <Dedup | DedupAndCompress | Compress> 
    ```

    where:
    `Type` is a required parameter and can take one of the following values:
    - **Dedup**: Enables deduplication only.
    - **DedupAndCompress**: Enables both deduplication and compression. This is the default option.
    - **Compress**: Enables compression only.

    If you want to change the `Type` parameter, you must first [disable ReFS deduplication and compression](#disable-refs-deduplication-and-compression-on-a-volume) and then enable it again with the new `Type` parameter.

    For example, run the following cmdlet to enable both deduplication and compression on a volume:

    ```powershell
    PS C:\Users\hciuser> Enable-ReFSDedup -Volume "C:\ClusterStorage\Volume1" -Type DedupAndCompress
    ```

1. After enabling ReFS deduplication and compression, verify its status on the CSV. Run the following cmdlet and ensure the `Enabled` field in the output displays as `True` and the `Type` field displays the specified mode.

    ```powershell
    Get-ReFSDedupStatus -Volume <path> | FL
    ```

    Here's a sample output of the `Get-ReFSDedupStatus` cmdlet where the `Enabled` field displays as `True` and the `Type` field displays as `DedupAndCompress`:

    ```output
    PS C:\Users\hciuser> Get-ReFSDedupStatus -Volume "C:\ClusterStorage\Volume1" | FL
    Volume                                    : C:\ClusterStorage\Volume1
    Enabled                                   : True
    Type                                      : DedupAndCompress
    Status                                    : --
    Used                                      : 1.4 TiB
    Deduped                                   : 0 B
    Compressed                                : 0 B
    ScannedOnLastRun                          : 0 B
    DedupedOnLastRun                          : 0 B
    LastRunTime                               : N/A
    LastRunDuration                           : N/A
    MextRunTime                               : N/A
    CompressionFormat                         : Uncompressed
    CompressionLevel                          : 0
    CompressionChunkSize                      : 0 B
    VolumeClusterSizeBytes                    : 4 KiB
    VolumeTotale lusters                      : 805289984
    VolumeTotalAllocatedelusters              : 353850628
    VolumeTotalAllocatedCompressibleClusters  : 0
    VolumeTota1InUseCompressibleClusters      : 0
    VolumeTota1Compressedelusters             : 0
    ```

#### Run ReFS deduplication and compression

After you enable this feature, you can run a one-time job manually or schedule recurring jobs as needed.

Before you run, you should also factor these other considerations:

- The first run after enabling this feature is always a full scan and optimization of the entire volume. If the `FullRun` parameter is specified, the optimization covers the entire volume rather than new or unoptimized data.
- If you don't specify a compression format, the default algorithm is LZ4. You can change the algorithm from one run to another as needed.
- You can specify more parameters for more complex use cases. The cmdlet used in this section is for the simplest use case.
- The Full Run, Excluded folder, Excluded file extensions, and Minimum last modified time hours filters apply only when running deduplication, and don't apply when running compression.

**Manually run ReFS deduplication and compression jobs**

- To start a job immediately, run the following cmdlet. Once you start a job, its `State` might appear as `NotStarted` because it could still be in the initialization phase.

    ```powershell
    Start-ReFSDedupJob -Volume <path> -Duration <TimeSpan> -FullRun -CompressionFormat <LZ4 | ZSTD> 
    ```

    For example, the following cmdlet starts a job immediately for a duration of 5 hours using the LZ4 compression format:

    ```powershell
    PS C:\Users\hciuser> $Start = “10/31/2023 08:30:00”
    PS C:\Users\hciuser> $Duration = New-Timespan -Hours 5
    PS C:\Users\hciuser> Start-ReFSDedupJob -Volume "C:\ClusterStorage\Volume1" -FullRun -Duration $Duration -CompressionFormat LZ4
    
    Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
    --     ----            -------------   -----         -----------     --------             -------
    12     Job12                           NotStarted    True                                 Start-Re...
    ```

- To stop a running job, run the following cmdlet. This cmdlet works for in-progress scheduled jobs too.

    ```powershell
    Stop-ReFSDedupJob -Volume <path>
    ```

    For example, the following cmdlet stops the job that you started in the previous example:

    ```powershell
    PS C:\Users\hciuser> Stop-ReFSDedupJob -Volume "C:\ClusterStorage\Volume1"
    ```

- To view the progress, savings, and status of a job, run the following cmdlet:

    ```powershell
    Get-ReFSDedupStatus -Volume <path> | FL
    ```

    For example, the following cmdlet displays the status of a job:

    ```powershell
    PS C:\Users\hciuser> Get-ReFSDedupStatus -Volume "C:\ClusterStorage\Volume1"

    Volume                                            Type             Used     Deduped Compressed Format
    ------                                            ----             ----     ------- ---------- ------
    C:\ClusterStorage\Volume1 DedupAndCompress 1.38 TiB 0 B     0 B        Unc...
    ```

**Schedule recurring ReFS deduplication and compression jobs**

Set a reoccurring schedule to run storage optimizations for the volume. You can then view, set or modify, suspend, resume, or clear the job schedule.

- To set or modify a schedule, run the following cmdlet:

    ```powershell
    Set-ReFSDedupSchedule -Volume <Path> -Start <DateTime> -Days <DayOfWeek[]> -Duration <TimeSpan> -CompressionFormat <LZ4 | ZSTD> -CompressionLevel <UInt16> -CompressionChunkSize <UInt32> 
    ```

    For example, to set up a recurring job scheduled to run every Thursday at 8:30 AM for a duration of 5 hours in the LZ4 format, run the following cmdlet. Use `-Days EveryDay` if you want to run the job daily.

    ```powershell
    PS C:\Users\hciuser> $Start = “10/31/2023 08:30:00”
    PS C:\Users\hciuser> $Duration = New-Timespan -Hours 5
    PS C:\Users\hciuser> Set-ReFSDedupSchedule -Volume C:\ClusterStorage\Volume1 -Start $Start Days "Thursday" -Duration $Duration -CompressionFormat LZ4
    ```

- To view the job schedule, run the following cmdlet:

    ```powershell
    Get-ReFSDedupSchedule -Volume <path> | FL
    ```

    Here's the output of the job scheduled in the previous example:

    ```output
    PS C:\Users\hciuser> Get-ReFSDedupSchedule -Volume "C:\ClusterStorage\Volume1" | FL

    Volume                       : C:\ClusterStorage\Volume1
    Enabled                      : True
    Type                         : DedupAndCompress
    CpuPercentage                : Automatic
    ConcurrentOpenFiles          : Automatic
    MinimumLastModifiedTimeHours : 0
    ExcludeFileExtension         : {}
    ExcludeFolder                : {}
    CpuPercentage                : 0
    CompressionFormat            : LZ4
    CompressionLevel             : 1
    CompressionChunkSize         : 4 B
    CompressionTuning            : 70
    RecompressionTuning          : 40
    DecompressionTuning          : 30
    Start                        : 8:30:00 AM
    Duration                     : 00m:00.000s
    Days                         : Thursday
    Suspended                    : False
    ```

---

### Suspend scheduled jobs

Suspending the schedule cancels any running jobs and stops scheduled runs in the future. This option retains ReFS deduplication and compression-related metadata and continues to track file changes for optimized future runs. You can resume the schedule at any time, with the schedule settings preserved.

# [Windows Admin Center](#tab/windowsadmincenter)

Follow these steps to suspend scheduled jobs using Windows Admin Center:

1. Connect to a cluster, and then on the **Tools** pane on the left, select **Volumes**.

1. On the **Volumes** page, select the **Inventory** tab, select the appropriate volume, and then select **Settings**.

1. On the **Volume settings** pane on the right, under **More options** dropdown, deselect the **Set Schedule** checkbox, and then select **Save**.

# [PowerShell](#tab/powershell)

Use the following cmdlet to suspend the scheduled job and check the status using PowerShell:

```powershell
Suspend-ReFSDedupSchedule -Volume <path> 
```

Here's a sample output of the cmdlet usage. The `Suspended` field displays as `True`.

```output

PS C:\Users\hciuser> Suspend-ReFSDedupSchedule -Volume "C:\ClusterStorage\Volume1"
PS C:\Users\user> Get-ReFSDedupSchedule -Volume "C:\ClusterStorage\Volume1" | FL


Volume                       : C:\ClusterStorage\Volume1
Enabled                      : True
Type                         : DedupAndCompress
CpuPercentage                : Automatic
ConcurrentOpenFiles          : Automatic
MinimumLastModifiedTimeHours : 0
ExcludeFileExtension         : {}
ExcludeFolder                : {}
CpuPercentage                : 0
CompressionFormat            : LZ4
CompressionLevel             : 1
CompressionChunkSize         : 4 B
CompressionTuning            : 70
RecompressionTuning          : 40
DecompressionTuning          : 30
Start                        : 8:30:00 AM
Duration                     : 00m:00.000s
Days                         : Thursday
Suspended                    : True
```

---

### Disable ReFS deduplication and compression on a volume

Disabling ReFS deduplication and compression on a volume stops any runs that are in progress and cancels future scheduled jobs. In addition, related volume metadata isn't  retained, and file change tracking is stopped.

When you disable this feature, it doesn't undo deduplication or compression, as all the operations occur at the metadata layer. Over time, the data returns to its original state as the volume incurs reads and writes.

> [!NOTE]
> You can perform decompression operations using [`ReFSUtil`](/windows-server/administration/windows-commands/refsutil).

# [Windows Admin Center](#tab/windowsadmincenter)

Follow these steps to disable the feature using Windows Admin Center:

1. Connect to a cluster, and then on the **Tools** pane on the left, select **Volumes**.

1. On the **Volumes** page, select the **Inventory** tab, select the appropriate volume, and then select **Settings**.

1. On the **Volume settings** pane on the right, under **More options** dropdown, deselect the **Use ReFS deduplication and compression** checkbox, and then select **Save**.

# [PowerShell](#tab/powershell)

Use the following cmdlet to suspend the scheduled job and check the status:

```powershell
Disable-ReFSDedup -Volume <path>
```

Here's a sample output of the cmdlet usage. The `Enabled` field displays as `False` and the `Type` field displays as blank.

```output
PS C:\Users\hciuser> Disable-ReFSDedup -Volume "C:\ClusterStorage\Volume1"
PS C:\Users\hciuser> Get-ReFSDedupSchedule -Volume "C:\ClusterStorage\Volume1" | FL


Volume                       : C:\ClusterStorage\Volume1
Enabled                      : False
Type                         :
CpuPercentage                : Automatic
ConcurrentOpenFiles          : Automatic
MinimumLastModifiedTimeHours : 0
ExcludeFileExtension         : {}
ExcludeFolder                : {}
CpuPercentage                : 0
CompressionFormat            : LZ4
CompressionLevel             : 0
CompressionChunkSize         : 0 B
CompressionTuning            : 70
RecompressionTuning          : 40
DecompressionTuning          : 30
Start                        : N/A
Duration                     : N/A
Days                         : None
Suspended                    : False
```

---

## Frequently asked questions (FAQs)

This section answers frequently asked questions about ReFS deduplication and compression.

### Is the ReFS deduplication and compression feature different from Windows Data Deduplication?

Yes, this feature is entirely different from the [Windows Data Deduplication](/windows-server/storage/data-deduplication/overview) feature.

> [!IMPORTANT]
> We don't support enabling both ReFS deduplication and compression and Windows Data Deduplication simultaneously.

ReFS deduplication and compression is designed for active workloads, focusing on minimizing performance impact after optimization. Unlike Windows Data Deduplication, ReFS deduplication and compression doesn't use a chunk store to store deduped data, and there is no physical data movement involved. The feature relies on ReFS block cloning to enable metadata-only operations. Windows Data Deduplication might provide better storage savings due to its use of variable block sizes, it is also suitable for a broader range of workload types, such as General-purpose file servers (GPFS), backup targets, and more.

### What are the phases of ReFS deduplication and compression?

The optimization process comprises the following phases that occur sequentially and depend on the specified mode. If an optimization run reaches a duration limit, then the compression might not run.

- **Initialization.** In this phase, the storage volume is scanned to identify redundant blocks of data.

- **Data deduplication.** In this phase, the redundant blocks are single-instanced and tracked using ReFS block cloning.

- **Compression.** In this phase, a heatmap is generated to identify if a block should be eligible for compression. The default settings compress infrequently accessed or cold data to reduce their size. You can change the compression levels to adjust the range of blocks eligible for compression.

### What happens when the duration limit is reached before the volume is fully optimized?

The duration limit is in place to prevent any performance impact on customer workloads caused by the optimization job during business hours. A deduplication service monitors the optimized parts of a volume and incoming file modifications. This data is utilized in future jobs to reduce optimization time. For example, if a volume is only 30% processed in the first run due to the duration limit, the subsequent run addresses the remaining 70% and any new data.

## Known issues

The following section lists the known issues that currently exist with ReFS deduplication and compression.

### ReFS deduplication and compression job completed (either successfully or was canceled) and storage savings aren't listed in `Get-ReFSDedupStatus` or Windows Admin Center.

The temporary workaround for this issue is to initiate a one-time job and the results update immediately.

```powershell
Start-ReFSDedupJob -Volume <path>
```

<!--Need to update these section--commenting out for now.
### Compression performance impact

### Event log-->

### Sending stopped monitoring Event Tracing for Windows (ETW) events after disabling ReFS deduplication and compression on a volume.

Once ReFS deduplication and compression is disabled on a volume, the ETW channel for ReFS deduplication logs repeated stopped monitoring events. However, we don't anticipate significant usage impact because of this issue.

### Job failed event not logged if volume is moved to another node during compression.

If the CSV is moved to another server of the cluster while compression is in progress, the job failed event isn't logged in the ReFS deduplication channel. However, we don't anticipate significant usage impact because of this issue.

## Next steps

- [Manage volume](./manage-volumes.md).