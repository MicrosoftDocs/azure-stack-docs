---
title: Optimize storage with ReFS deduplication and compression in Azure Stack HCI and Windows Server
description: Learn how to use ReFS deduplication and compression in Azure Stack HCI and Windows Server to optimize storage.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 10/17/2023
---

# Optimize storage with ReFS deduplication and compression in Azure Stack HCI and Windows Server

> Applies to: Azure Stack HCI, version 23H2 (preview), Windows Server 2025

This article describes the Resilient File System (ReFS) deduplication and compression feature and how to use it in Azure Stack HCI and Windows Server clusters to optimize storage.

## What is ReFS deduplication and compression?

The data deduplication and compression feature allows you to maximize your available storage and cut down on storage costs. When enabled, this feature helps remove and consolidate redundant data, resulting in substantial storage savings ranging from 80%-95% for virtual desktop infrastructure (VDI) workloads.

The ReFS deduplication and compression solution is designed specifically for active workloads, such as VDI. It uses weak references to reduce rehash frequency right before deduplication and [ReFS block cloning](/windows-server/storage/refs/block-cloning) to reduce data movement, enabling operations that only involve metadata. This solution introduces a compression engine that identifies when data blocks were last used, compressing only the unused data to optimize CPU usage. Additonally, there is a user-enabled deduplication service that allows you to initiate one-time or scheduled jobs, modify job settings, and monitor file changes to optimize for job duration.

## Characteristics of ReFS deduplication and compression

The ReFS deduplication and compression solution has the following characteristics:

- Utilizes a post-process approach
- Operates at the data block level
- Utilizes fixed block size (dependent on cluster size)
- Compatible with both all-flash and hybrid systems
- Supports various resiliency settings, including two-way mirror, nested two-way mirror, three-way mirror, and mirror accelerated parity
- Operates in three modes: deduplication only, compression only, and deduplication and compression (default mode)
- Implements file change tracking to optimize for job duration

## Phases of ReFS deduplication and compression

The optimization process comprises the following phases that occur sequentially and depend on the specified mode. If an optimization run reaches a duration limit, then the compression might not run.

- **Initialization phase.** During this phase, the volume is scanned, and weak references are placed on blocks within the volume.

- **Data deduplication and compression phase.** During this phase, the redundant blocks are single-instanced and tracked using ReFS block cloning. If compression is enabled, blocks are evaluated based on access frequency and compressed if they are not frequently used.

## Turn on ReFS deduplication and compression

You can turn on ReFS deduplication and compression using `ReFSUtil` *or* Windows Admin Center and PowerShell. If you are using `ReFSUtil`, it will be a one-time manual run with no file change tracking. However, if you opt for Windows Admin Center or PowerShell, you get benefits, such as the ability to run one-time or scheduled jobs, customize job settings, and enable file change tracking for faster subsequent runs. Once you enable the feature via Windows Admin Center or PowerShell, you cannot run the feature using `ReFSUtil`.

The following sections describe how to turn on this feature using Windows Admin Center and PowerShell. For information about how to use `ReFSUtil`, see [ReFSUtil](/windows-server/administration/windows-commands/refsutil).

# [Windows Admin Center](#tab/windowsadmincenter)

In Windows Admin Center, a schedule can be applied for ReFS deduplication and compression to run on an existing volume or a brand new volume during volume creation.

Follow these steps to enable ReFS deduplication and compression via Windows Admin Center:

1. Connect to a cluster, and then on the **Tools** pane on the left, select **Volumes**.

1. On the **Volumes** page, select the **Inventory** tab, select the appropriate volume, and then select **Settings**. To turn on ReFS deduplication and compression for a brand new volume, select **+Create**.

1. On the **Volume settings** pane on the right, under **More options** dropdown, select the **Use ReFS deduplication and compression** checkbox.

1. Select the days of the week when ReFS deduplication and compression should run, the time for a job to start running, and maximum duration (default is unlimited), and then select **Save**.

    The following screenshot shows that ReFS deduplication and compression will run on Friday and Saturday at 10:40 AM with a maximum duration of 2 hours, starting from 9/22/2023. If the **Start** date was changed to 9/21/2023, the first run will still be 9/22/2023 10:40AM as that's the first Friday after 9/21/2023.

   :::image type="content" source="media/refs-deduplication-compression/select-refs-dedup-and-compression-settings.png" alt-text="Screenshot that displays the settings for the ReFS deduplication and compression feature." lightbox=""media/refs-deduplication-compression/select-refs-dedup-and-compression-settings.png":::

1. Verify the changes in the **Properties** section of the volume. The schedule appears under the **Properties** section and displays the savings breakdown and next scheduled run time. These savings are updated after each run, and you can observe the performance impact in the charts under the **Performance** section.

    :::image type="content" source="media/refs-deduplication-compression/volume-properties.png" alt-text="Screenshot of the properties section of a volume showing the savings breakdown and next scheduled run time." lightbox=""media/refs-deduplication-compression/volume-properties.png":::

# [PowerShell](#tab/powershell)

You can initiate ReFS deduplication and compression manually or automate to run as scheduled jobs. The jobs are set at the cluster shared volume (CSV) level for each cluster and can be customized based on modes, duration, system resource usage, and more.

Follow these steps to turn on ReFS deduplication and compression via PowerShell:

1. Run the following cmdlet to enable ReFS deduplication and compression on a specific volume:

    ```powershell
    Enable-ReFSDedup -Volume <path> -Type <Dedup | DedupAndCompress | Compress> 
    ```

    where:
    `-Type` is a required parameter and can take one of the following values:
    - **Dedup**: Enables deduplication only.
    - **DedupAndCompress**: Enables both deduplication and compression. This is the default option.
    - **Compress**: Enables compression only.

    > [!NOTE]
    > - All commands to modify settings on a given volume must run on the owner node.
    > - To change the `Type` parameter, you must [disable the ReFS deduplication and compression](#turn-off-refs-deduplication-and-compression) feature and then enable it again with the new `Type` parameter.

1. After enabling ReFS deduplication and compression, verify its status on the CSV. Run the following cmdlet and ensure the `Enabled` field in the output dsplays as `True`.

    ```powershell
    Get-ReFSDedupStatus -Volume <path> | FL
    ```

    Here's a sample output of the `Get-ReFSDedupStatus` cmdlet where the `Enabled` field displays as `True`:

    ```output
    PS C:\Users\wolfpack> Get-ReFSDedupStatus -Volume C:\ClusterStorage\Volumel\ | FL
    Volume                                    : C:\ClusterStorage\Volumel\
    Enabled                                   : True
    Type                                      : DedupAndCompress
    Status                                    : --
    Used                                      : 2.32 TiB
    Deduped                                   :  0 B
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
    VolumeTotale lusters                      : 1343209472
    VolumeTotalAllocatedelusters              : 502127950
    VolumeTotalAllocatedCompressibleClusters  : 0
    VolumeTota1InUseCompressibleClusters      : 0
    VolumeTota1Compressedelusters             : 0
    ```

    After enabling the feature, you can run a one-time job manually or schedule recurring jobs as needed.

### Manually run ReFS deduplication and compression jobs

- To start a job immediately, run the following cmdlet:

    ```powershell
    Start-ReFSDedupJob -Volume <string> -Duration <timespan> -FullRun -CompressionFormat <LZ4 | ZSTD> 
    ```
    > [!NOTE]
    >
    > - The first run after enabling this feature is always a full scan and optimization of the entire volume. If the `FullRun` parameter is specified, the optimization will cover the entire volume rather than just new or unoptimized data.
    > - If you don't specify a compression format, the default algorithm is LZ4. You can change the algorithm from one run to another as needed.
    > - You can specify more parameters for more complex use cases. The above cmdlet is for the most simple use case.
    > - The Full Run, Excluded folder, Excluded file extensions, and Minimum last modified time hours filters apply only when running deduplication, and don't apply when running compression.  

- To stop a running job, run the following cmdlet. Note that this cmdlet will work for in-progress scheduled jobs too.

    ```powershell
    Stop-ReFSDedupJob -Volume <path>
    ```

- To view the progress, savings, and status of a job, run the following cmdlet:

    ```powershell
    Get-ReFSDedupStatus -Volume <path> | FL
    ```

### Schedule recurring ReFS deduplication and compression jobs

Set a reoccurring schedule to run storage optimizations for the volume. You can then view, set or modify, suspend, resume, or clear the job schedule.

- To view the job schedule, run the following cmdlet:

    ```powershell
    Get-ReFSDedupSchedule -Volume <path> | fl
    ```

    Here's a sample output of the cmdlet usage:

    ```output
    PS C:\Users\wolfpack > Get-ReFSDedupSchedu1e -Volume C:\ClusterStorage\Volumel\ | FL

    Volume						    : C:\ClusterStorage\Volumel\
    Enabled						    : True
    Type						    : DedupAndCompress
    CpuPercentage					: Automatic
    ConcurrentOpenFiles				: Automatic
    MinimumLastModifiedTimeHours	: 0
    ExcludeFileExtension			: {}
    ExcludeFolder					: {}
    CpuPercentage					: 0
    CompressionFormat				: LZ4
    CompressionLevel				: 1
    CompressionChunkSize			: 4 KiB
    CompressionTuning				: 70
    RecompressionTuning				: 40
    DecompressionTuning				: 30
    Start						    : N/A
    Duration					    : N/A
    Days						    : None
    Suspended					    : False
    ```

- To set or modify a schedule, run the following cmdlet:

    ```powershell
    Set-ReFSDedupSchedule -Volume <path> -Start <datetime> -Days <days> -Duration <timespan> -CompressionFormat <LZ4 | ZSTD> -CompressionLevel <uint16> -CompressionChunkSize <uint32> 
    ```

---

## Turn off ReFS deduplication and compression

After enabling ReFS deduplication and compression, you can turn it off by either suspending scheduled jobs or disabling the feature on a specific volume.

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

Here's a sample output of the cmdlet usage:

```output
PS C:\Users\wolfpack> Suspend-RePSDedupSchedu1e -Volume C:\ClusterStorage\Volumel\_ 
PS C:\Users\wolfpack> Get-ReFSDedupSchedu1e -Volume C:\ClusterStorage\Volumel\ | FL

Volume						    : C:\ClusterStorage\Volumel\ 
Enabled						    : True
Type						    : DedupAndCompress
CpuPercentage					: Automatic
ConcurrentOpenFiles				: Automatic
MinimumLastModifiedTimeHours    : 0
ExcludeFileExtension			: {}
ExcludeFolder					: {}
CpuPercentage					: 0
CompressionFormat				: LZ4
CompressionLevel				: 1
CompressionChunkSize			: 4 KiB 
CompressionTuning				: 70
RecompressionTuning				: 40
DecompressionTuning				: 30
Start						    : N/A
Duration					    : N/A
Days						    : EveryDay
Suspended					    : True
```

---

### Disable ReFS deduplication and compression on a volume

Disabling ReFS deduplication and compression on a volume stops any in-progress runs and cancels future scheduled jobs. In addition, related volume metadata isn't  retained, and file change tracking is stopped. Disabling this feature doesn't undo deduplication or compression, as all the operations occur at the metadata layer. Overtime, the data returns to its original state as the volume incurs reads and writes. You can perform decompression operations using `ReFSUtil` <!--Do we need the last sentence here?-->.

# [Windows Admin Center](#tab/windowsadmincenter)

Follow these steps to suspend scheduled jobs using Windows Admin Center:

1. Connect to a cluster, and then on the **Tools** pane on the left, select **Volumes**.

1. On the **Volumes** page, select the **Inventory** tab, select the appropriate volume, and then select **Settings**.

1. On the **Volume settings** pane on the right, under **More options** dropdown, deselect the **Use ReFS deduplication and compression** checkbox, and then select **Save**.

# [PowerShell](#tab/powershell)

Use the following cmdlet to suspend the scheduled job and check the status:

```powershell
Disable-ReFSDedup -Volume <path>
```

---

## Frequently asked questions (FAQs)

This section answers frequently asked questions about ReFS deduplication and compression.

### Is the ReFS deduplication and compression feature different from Windows Data Deduplication?

Yes, this feature is entirely different from the [Windows Data Deduplication](/windows-server/storage/data-deduplication/overview) feature.

> [!IMPORTANT]
> We don't support enabling both ReFS deduplication and compression and Windows Data Deduplication simultaneously.

ReFS deduplication and compression is specifically designed for active workloads, focusing on minimizing performance impact after optimization. Unlike Windows Data Deduplication, ReFS deduplication and compression doesn't use a chunk store to store deduped data, and there is no physical data movement involved. The solution relies on ReFS block cloning to enable metadata-only operations. Windows Data Deduplication may provide better storage savings due to its use of variable block sizes, it is also suitable for a broader range of workload types, such as General-purpose file servers (GPFS), backup targets, and more.

### What happens when the duration limit is reached before the volume is fully optimized?

The duration limit is in place to prevent any performance impact on customer workloads caused by the optimization job during business hours. A deduplication service monitors the optimized parts of a volume and incoming file modifications. This data is utilized in future jobs to reduce optimization time. For example, if a volume is only 30% processed in the first run due to the duration limit, the subsequent run will address the remaining 70% as well as any new data.

## Known issues

The following section lists the known issues that currently exist with ReFS deduplication and compression.

### ReFS deduplication and compression job completed (either successfully or was cancelled) and storage savings are not listed in `Get-ReFSDedupStatus` or Windows Admin Center.

The temporary workaround for this issue is to initiate a one-time job and the results will update immediately.

```powershell
Start-ReFSDedupJob -Volume <path>
```

**Compression performance impact**

<!--waiting on data from Arjun-->

### Event log

<!--Mas to help w/ current state-->

### Sending stopped monitoring Event Tracing for Windows (ETW) events after disabling ReFS deduplication and compression on a volume.

Once ReFS deduplication and compression is disabled on a volume, the ETW channel for ReFS deduplication logs repeated stopped monitoring events. However, we don't anticipate significant usage impact because of this issue.

### Job failed event not logged if volume is moved to another node during compression.

If the CSV is moved to another node while compression is in progress, the job failed event isn't logged in the ReFS deduplication channel. However, we don't anticipate significant usage impact because of this issue.

## Next steps

- [Manage volume](./manage-volumes.md)