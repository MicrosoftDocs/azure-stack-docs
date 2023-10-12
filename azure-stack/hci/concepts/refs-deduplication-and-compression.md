---
title: Understand ReFS deduplication and compression
description: Understanding ReFS deduplication and compression on Azure Stack HCI and Windows Server clusters.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.date: 10/11/2023
---

# What is ReFS deduplication and compression?

> Applies to: Azure Stack HCI, version 23H2 (preview), Windows Server 2025

This article provides an overview of the Resilient File System (ReFS) deduplication and compression solution and describes how to 

The data deduplication and compression feature allows you to maximize your available storage and cut down on storage costs. When enabled, this feature helps remove and consolidate redundant data, resulting in substantial storage savings ranging from 80%-95% for virtual desktop infrastructure (VDI) workloads.

The ReFS deduplication and compression solution is designed specifically for active workloads, such as VDI. It uses weak references to reduce rehash frequency before deduplication, and ReFS block cloning reduces data movement, enabling operations that only involve metadata. This solution introduces a new compression engine that identifies when data blocks were last used, compressing only the unused data to optimize CPU usage. Additonally, there is a user-enabled deduplication service that allows you to initiate one-time or scheduled jobs, modify job settings, and monitor file changes to optimize for job duration.

## Characteristics of ReFS deduplication and compression

The ReFS deduplication and compression solution has the following characteristics:

- Post-process approach
- Operates at the data block level
- Utilizes fixed block size (dependent on cluster size)
- Compatible with both all-flash and hybrid systems
- Supported with the various resiliency settings, including 2-way mirror, nested 2-way mirror, 3-way mirror, and mirror accelerated parity
- Offers three modes: Deduplication only, Compression only, and Deduplication and compression (default mode)
- Implements file change tracking to optimize for job duration

# Enable ReFS deduplication and compression via PowerShell

You can initiate ReFS deduplication and compression manually or automate to run as scheduled jobs. The jobs are set at the cluster shared volume (CSV) level for each cluster and can be customized based on modes, duration, system resource usage, and more.

Follow these steps to enable eFS deduplication and compression via PowerShell:

1. Run the following cmdlet to enable ReFS deduplication and compression on a specific volume:

    ```powershell
    Enable-ReFSDedup -Volume <path> -Type <Dedup | DedupAndCompress | Compress> 
    ```

    where:
    `-Type` is a required parameter and can take one of the following values:
    - Dedup: Enables deduplication only
    - DedupAndCompress: Enables both deduplication and compression. This is the default option.
    - Compress: Enables compression only.

    > [!NOTE]
    > - All commands to modify settings on a given volume must run on the owner node.
    > - To change the `Type` parameter, you must disable the ReFS
    deduplication and compression feature and then enable it again with new `Type` parameter.

1. After enabling ReFS deduplication and compression, verify its status on the CSV. Run the following cmdlet and ensure the `Enabled` field in the output dsplays `True`.

    ```powershell
    Get-ReFSDedupStatus -Volume <path> | FL
    ```

    Here's an example of the expected output where the `Enabled`field displays as `True`:

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

![A screen shot of a computer program Description automatically
generated with low
confidence](./media/media/image1.png){width="5.604207130358705in"
height="2.7396030183727036in"}

After enabling the feature, you can run a one off job manually or
schedule reoccurring jobs.

## Option 1: Run ReFS Deduplication and Compression jobs manually

To start a job immediately, run the following cmdlet:

Start-ReFSDedupJob -Volume \<string\> -Duration \<timespan\> -FullRun
-CompressionFormat \<LZ4 \| ZSTD\>

 

**Notes:**

-   The first run after enabling this feature will always be a full
    scan/ optimization of the entire volume. If the FullRun parameter is
    specified, the entire volume will be optimized as opposed to only
    new data/ unoptimized data.

-   If a compression format is not specified, the default algorithm will
    be LZ4. The algorithm can be changed from one run to another.

-   There are more parameters that can be specified - the above cmdlet
    is for the most simple use cases.

-   The Full Run, Excluded folder, Excluded file extensions, and Minimum
    last modified time hours filters only apply when running
    deduplication, not compression.  

To stop a running job, use the following cmdlet. Note that this cmdlet
will work for in progress scheduled jobs too.

Stop-ReFSDedupJob -Volume \<path\>

To view the progress, savings, and status of a job, use the following
cmdlet.

Get-ReFSDedupStatus -Volume \<path\> \| FL

## Option 2: Set a schedule for jobs to run 

Set a reoccurring schedule to run storage optimizations for the volume.
The schedule can then be viewed, set/modified, suspended, resumed, or
cleared.

**To view the job schedule**, type:

Get-ReFSDedupSchedule -Volume \<path\> \| fl

![A screenshot of a computer program Description automatically generated
with medium
confidence](./media/media/image2.png){width="4.375031714785652in"
height="1.9062642169728783in"}

**To set or modify a schedule**, type:

Set-ReFSDedupSchedule -Volume \<path\> -Start \<datetime\> -Days
\<days\> -Duration \<timespan\> -CompressionFormat \<LZ4 \| ZSTD\>
-CompressionLevel \<uint16\> -CompressionChunkSize \<uint32\> 

# Use ReFS deduplication & compression in Windows Admin Center 

In Windows Admin Center, a schedule can be applied for ReFS
deduplication & compression to run on an existing volume or a brand new
volume during volume creation.

**Step 1:**

Navigate to Cluster Manager \> Volumes \> Inventory \> + New volume or
Volume Settings

**Step 2:**

Open the More options dropdown and check off "Use ReFS deduplication and
compression"

**Step 3:**

Select the day(s) of the week when ReFS deduplication and compression
should run, the time for a job to start running, and max. duration
(default is unlimited). Click Save.

In the example below, ReFS deduplication and compression will run on
Friday and Saturday at 10:40 AM with a maximum duration of 2 hours,
starting from 9/22/2023. If the Start date was changed to 9/21/2023, the
first run will still be 9/22/2023 10:40AM as that's the first Friday
after 9/21/2023.

![A screenshot of a computer Description automatically
generated](./media/media/image3.png){width="5.632826990376203in"
height="3.3857141294838144in"}

**Step 4:**

The schedule should appear in the volume properties page and display the
savings breakdown and next scheduled run time. The savings will be
updated after a run has been completed and the performance impact can be
observed in the charts below.

![A screenshot of a computer Description automatically
generated](./media/media/image4.png){width="5.679389763779527in"
height="3.424623797025372in"}

# ReFS deduplication & compression FAQ

This section answers frequently asked questions about ReFS deduplication
& compression.

## What are the phases of ReFS deduplication and compression? 

There are 3 phases in an optimization process. The first is the
initialization phase where the volume is scanned and weak references are
placed on blocks in the volume. The next phase is data deduplication,
where redundant blocks are single instanced and tracked using ReFS block
cloning. If compression is enabled, blocks are then evaluated based on
access frequency and compressed if it is not frequently used. These 3
phases happen in sequential order and depend on the Mode specified. If a
duration limit is hit during an optimization run, there is a chance that
ompression does not get to run.

## Is this feature different from the existing Windows Deduplication? 

Yes, this is a completely different feature from the Windows Data
Deduplication feature. It is **not** supported to enable solution at the
same time. ReFS deduplication & compression is designed for active
workloads and focuses on having a minimal performance impact post
optimization. There is no chunk store where all deduped data is stored
and no physical data movement in the ReFS deduplication and compression
solution. ReFS block cloning is leveraged to enable metadata only
operations. Windows Data Deduplication may provide better storage
savings due to its use of variable block sizes. It is also applicable to
a wider range of workload types such as General-purpose file servers
(GPFS), backup targets, and more.

## Is it possible to turn off this feature once enabled?

Yes, it is possible to turn this feature off once enabled, below are
some options:

**Option 1: Suspend scheduled jobs.**

Suspending the schedule will cancel any running jobs and stop scheduled
runs in the future. This option will keep ReFS deduplication &
compression related metadata and continue to track file changes for
optimized future runs. The schedule can be resumed at any time with the
schedule settings preserved.

**Windows Admin Center:** Navigate to Cluster Manager -\> Volumes -\>
Inventory -\> Volume Properties -\> Settings. Uncheck Set Schedule box
and click Save.

**PowerShell:** Use the following cmdlet to suspend the schedule and
check the status

Suspend-ReFSDedupSchedule -Volume \<path\>

> ![A screenshot of a computer program Description automatically
> generated with medium
> confidence](./media/media/image5.png){width="4.395865048118985in"
> height="1.9583475503062118in"}

**Option 2: Disable the feature on a volume**

Disabling ReFS deduplication and compression on a volume will stop any
in progress runs and cancel future scheduled jobs. In addition, related
volume metadata will not be kept and file change tracking will stop.
This will not undo deduplication or compression as all operations were
at the metadata layer. The data will return to its original state
overtime as the volume incurs reads and writes. Decompression operations
can be performed using ReFSUtil.

**Windows Admin Center:** Navigate to Cluster Manager -\> Volumes -\>
Inventory -\> Volume Properties -\> Settings. Uncheck Use ReFS
Deduplication and Compression and click Save.

**PowerShell:** Use the following cmdlet to disable the feature

Disable-ReFSDedup -Volume \<path\>

## What happens when the duration limit is met but the volume is not fully optimized yet? 

The duration limit exists to ensure any performance impact during an
optimization job does not affect customer workloads during business
hours. There is a deduplication service that tracks the parts of a
volume that has been optimized and incoming file modifications. This
information is leveraged in future subsequent jobs to reduce
optimization time. This means if a volume is only 30% processed in the
first run due to a duration limit, the next run will address the other
70% and any new data.

## How to run ReFS deduplication and compression? 

This feature can be accessed using ReFSUtil **or** PowerShell and
Windows Admin Center. If you are using ReFSUtil, it will be a one-off
manual run with no file change tracking. If using PowerShell or Windows
Admin Center, there are benefits like being able to run one off or
scheduled jobs, customize job settings, and file change tracking for
faster subsequent runs. If you've enabled the feature via PowerShell or
WC, you cannot then run the feature from ReFSUtil.

# Known Issues

## ReFS deduplication and compression job completed (either successfully or was cancelled) and storage savings are not listed in Get-ReFSDedupStatus or Windows Admin Center. 

This is a known bug that the team is working on fixing. The temporary
solution is to kick off a one off job and the results will update
immediately.

PowerShell:

Start-ReFSDedupJob -Volume \<path\>

## Compression performance impact 

*\<waiting on data from Arjun\>*

## Event log

\<Mas to help w/ current state\>

## Sending stopped monitoring ETW events after disabling ReFS deduplication and compression on a volume. 

Once ReFS deduplication and compression is disabled on a volume, the ETW
channel for ReFS deduplication will log repeated stopped monitoring
events. The team is currently working on a fix for this issue and does
not expect significant usage impact.

## Job failed event not logged if volume is moved to another node during compression

If the cluster shared volume is moved to another node as compression is
in progress, the job failed event is not logged in the ReFS
deduplication channel. The team is currently working on a fix for this
issue and does not expect a significant usage impact.
