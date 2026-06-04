---
title: Optimize storage with ReFS deduplication in Azure Local
description: Learn how to use ReFS deduplication in Azure Local to optimize storage.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.date: 05/14/2026
ms.subservice: hyperconverged
---

# Optimize storage with ReFS deduplication in Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes the Resilient File System (ReFS) deduplication feature and how to use this feature in Azure Local to optimize storage.

## What is ReFS deduplication?

ReFS deduplication is a storage optimization feature that helps optimize storage usage and reduce storage cost. Use deduplication for active, performance-sensitive, or read-heavy workloads, such as [Azure virtual desktop infrastructure (VDI) on Azure Local](../deploy/virtual-desktop-infrastructure.md).

This feature uses [ReFS block cloning](/windows-server/storage/refs/block-cloning) to reduce data movement and enable metadata only operations. The feature operates at the data block level and uses fixed block size depending on the system size.

You can run ReFS deduplication as a one-time job or automate it with scheduled jobs. This feature works with both all-flash and hybrid systems. It supports various resiliency settings, such as two-way mirror, nested two-way mirror, three-way mirror, and mirror accelerated parity.

## Benefits

Here are the benefits of using ReFS deduplication:

- **Storage savings for active workloads.** ReFS deduplication is designed for active workloads, such as VDI, ensuring efficient performance in demanding environments.
- **Incremental deduplication.** It deduplicates only new or changed data instead of scanning the entire volume every time. This approach optimizes job duration and reduces the impact on system performance.

## Prerequisites

Before you begin, make sure that you complete the following prerequisites:

- You have access to a deployed and registered Azure Local instance.
- You create the cluster shared volume (CSV) on the instance and you have access to it.
- The CSV doesn't have the Windows Data Deduplication feature enabled already.

## Use ReFS deduplication

You can use ReFS deduplication through Windows Admin Center or PowerShell. PowerShell supports both manual and automated jobs, while Windows Admin Center supports only scheduled jobs. Regardless of the method, you can customize job settings and use file change tracking for quicker subsequent runs.

### Enable and run ReFS deduplication

# [Windows Admin Center](#tab/windowsadmincenter)

In Windows Admin Center, you can create a schedule for ReFS deduplication to run on an existing volume or a new volume during volume creation.

Follow these steps to enable ReFS deduplication through Windows Admin Center and set a schedule for when it should run:

1. Connect to a system. On the **Tools** pane on the left, select **Volumes**.

1. On the **Volumes** page, select the **Inventory** tab, select the appropriate volume, and then select **Settings**. To turn on ReFS deduplication for a new volume, select **+ Create**.

1. On the **Volume settings** pane on the right, under **More options** dropdown, select the **Use ReFS deduplication** checkbox.

1. Select the days of the week when ReFS deduplication should run, the time for a job to start running, and maximum duration (the default is unlimited), and then select **Save**.

    The following screenshot shows that ReFS deduplication runs on Friday and Saturday at 10:00 PM with a maximum duration of two hours, starting from Friday 9/27/2024. If you change the **Start** date to Monday 9/30/2024, the first run is 10/4/2024 10:00 PM as that's the first Friday after 9/30/2024.

    :::image type="content" source="media/refs-deduplication-and-compression/select-refs-deduplication-settings.png" alt-text="Screenshot of the Volume settings pane in Windows Admin Center showing ReFS deduplication schedule options including days, start time, and duration." lightbox="media/refs-deduplication-and-compression/select-refs-deduplication-settings.png":::

1. Verify the changes in the **Properties** section of the volume. The schedule appears under the **Properties** section and displays the savings breakdown and next scheduled run time. These savings are updated after each run, and you can observe the performance impact in the charts under the **Performance** section.

    :::image type="content" source="media/refs-deduplication-and-compression/volume-properties.png" alt-text="Screenshot of the volume properties section in Windows Admin Center displaying ReFS deduplication savings breakdown and the next scheduled run time." lightbox="media/refs-deduplication-and-compression/volume-properties.png":::

# [PowerShell](#tab/powershell)

To use ReFS deduplication through PowerShell, first enable the feature. Then, run it as a one-time manual job or automate it to run as scheduled jobs. The jobs are set at the CSV level for each system and can be customized based on duration, system resource usage, and more.

#### Enable ReFS deduplication

Follow these steps to enable ReFS deduplication through PowerShell:

1. Connect to your Azure Local instance and run PowerShell as an administrator.

1. You must run all the commands on the owner node to modify settings on a given volume. Run the following cmdlet to show all CSV owner nodes and the volume path:

    ```powershell
    Get-ClusterSharedVolume | FT Name, OwnerNode, SharedVolumeInfo
    ```

    Here's a sample output of the cmdlet usage:

    ```output
    Name                           OwnerNode   SharedVolumeInfo
    ----                           ---------   ----------------
    Cluster Virtual Disk (Volume1) hci-server1 {C:\ClusterStorage\Volume1}
    ```

1. Run the following cmdlet to enable ReFS deduplication on a specific volume:

    ```powershell
    Enable-ReFSDedup -Volume <path> -Type Dedup
    ```

    For example, run the following cmdlet to enable deduplication on a volume:

    ```powershell
    PS C:\Users\hciuser> Enable-ReFSDedup -Volume "C:\ClusterStorage\Volume1" -Type Dedup
    ```

1. After enabling ReFS deduplication, verify its status on the CSV. Run the following cmdlet and ensure the `Enabled` field in the output displays as `True` and the `Type` field displays as `Dedup`.

    ```powershell
    Get-ReFSDedupStatus -Volume <path> | FL
    ```

    Here's a sample output of the `Get-ReFSDedupStatus` cmdlet where the `Enabled` field displays as `True` and the `Type` field displays as `Dedup`:

    ```output
    PS C:\Users\hciuser> Get-ReFSDedupStatus -Volume "C:\ClusterStorage\Volume1" | FL
    Volume                                    : C:\ClusterStorage\Volume1
    Enabled                                   : True
    Type                                      : Dedup
    Status                                    : --
    Used                                      : 1.4 TiB
    Deduped                                   : 0 B
    ScannedOnLastRun                          : 0 B
    DedupedOnLastRun                          : 0 B
    LastRunTime                               : N/A
    LastRunDuration                           : N/A
    MextRunTime                               : N/A
    VolumeClusterSizeBytes                    : 4 KiB
    VolumeTotale lusters                      : 805289984
    VolumeTotalAllocatedelusters              : 353850628
    ```

#### Run ReFS deduplication

After you enable this feature, you can run a one-time job manually or schedule recurring jobs as needed.

Before you run, you should also consider the following:

- You can specify more parameters for more complex use cases. The cmdlet used in this section is for the simplest use case.
- The Excluded folder, Excluded file extensions, and Minimum last modified time hours filters apply when running deduplication.

**Manually run ReFS deduplication jobs**

- To start a job immediately, run the following cmdlet. After you start a job, its `State` might appear as `NotStarted` because it could still be in the initialization phase.

    ```powershell
    Start-ReFSDedupJob -Volume <path> -Duration <TimeSpan>
    ```

    For example, the following cmdlet starts a job immediately for a duration of 5 hours:

    ```powershell
    PS C:\Users\hciuser> $Duration = New-Timespan -Hours 5
    PS C:\Users\hciuser> Start-ReFSDedupJob -Volume "C:\ClusterStorage\Volume1" -Duration $Duration
    
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

    Volume                                            Type     Used     Deduped
    ------                                            ----     ----     -------
    C:\ClusterStorage\Volume1                         Dedup    1.38 TiB 0 B
    ```

**Schedule recurring ReFS deduplication jobs**

Set a recurring schedule to run storage optimizations for the volume. You can then view, set or modify, suspend, resume, or clear the job schedule.

- To set or modify a schedule, run the following cmdlet:

    ```powershell
    Set-ReFSDedupSchedule -Volume <Path> -Start <DateTime> -Days <DayOfWeek[]> -Duration <TimeSpan>
    ```

    For example, to set up a recurring job scheduled to run every Thursday at 8:30 AM for a duration of 5 hours, run the following cmdlet. Use `-Days EveryDay` if you want to run the job daily.

    ```powershell
    PS C:\Users\hciuser> $Start = "10/31/2023 08:30:00"
    PS C:\Users\hciuser> $Duration = New-Timespan -Hours 5
    PS C:\Users\hciuser> Set-ReFSDedupSchedule -Volume C:\ClusterStorage\Volume1 -Start $Start -Days "Thursday" -Duration $Duration
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
    Type                         : Dedup
    CpuPercentage                : Automatic
    ConcurrentOpenFiles          : Automatic
    MinimumLastModifiedTimeHours : 0
    ExcludeFileExtension         : {}
    ExcludeFolder                : {}
    CpuPercentage                : 0
    Start                        : 8:30:00 AM
    Duration                     : 00m:00.000s
    Days                         : Thursday
    Suspended                    : False
    ```

---

### Suspend scheduled jobs

When you suspend the schedule, it cancels any running jobs and stops scheduled runs in the future. This option keeps ReFS deduplication-related metadata and continues to track file changes for optimized future runs. You can resume the schedule at any time, and the schedule settings stay the same.

# [Windows Admin Center](#tab/windowsadmincenter)

To suspend scheduled jobs using Windows Admin Center, follow these steps:

1. Connect to a system. On the **Tools** pane on the left, select **Volumes**.

1. On the **Volumes** page, select the **Inventory** tab, select the appropriate volume, and then select **Settings**.

1. On the **Volume settings** pane on the right, under **More options** dropdown, clear the **Set Schedule** checkbox, and then select **Save**.

# [PowerShell](#tab/powershell)

To suspend the scheduled job and check the status using PowerShell, use the following cmdlet:

```powershell
Suspend-ReFSDedupSchedule -Volume <path> 
```

Here's a sample output of the cmdlet usage. The `Suspended` field displays as `True`.

```output

PS C:\Users\hciuser> Suspend-ReFSDedupSchedule -Volume "C:\ClusterStorage\Volume1"
PS C:\Users\user> Get-ReFSDedupSchedule -Volume "C:\ClusterStorage\Volume1" | FL


Volume                       : C:\ClusterStorage\Volume1
Enabled                      : True
Type                         : Dedup
CpuPercentage                : Automatic
ConcurrentOpenFiles          : Automatic
MinimumLastModifiedTimeHours : 0
ExcludeFileExtension         : {}
ExcludeFolder                : {}
CpuPercentage                : 0
Start                        : 8:30:00 AM
Duration                     : 00m:00.000s
Days                         : Thursday
Suspended                    : True
```

---

### Disable ReFS deduplication on a volume

When you disable ReFS deduplication on a volume, it stops any runs that are in progress and cancels future scheduled jobs. The process also removes related volume metadata and stops file change tracking.

> [!NOTE]
> When you disable this feature, it doesn't undo deduplication, as all the operations occur at the metadata layer. Over time, deduplicated data returns to its original state as the volume incurs reads and writes.

# [Windows Admin Center](#tab/windowsadmincenter)

Follow these steps to disable the feature using Windows Admin Center:

1. Connect to a system. On the **Tools** pane on the left, select **Volumes**.

1. On the **Volumes** page, select the **Inventory** tab, select the appropriate volume, and then select **Settings**.

1. On the **Volume settings** pane on the right, under **More options** dropdown, clear the **Use ReFS deduplication** checkbox, and then select **Save**.

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
Start                        : N/A
Duration                     : N/A
Days                         : None
Suspended                    : False
```

---

## Frequently asked questions (FAQs)

This section answers frequently asked questions about ReFS deduplication.

### Is the ReFS deduplication feature different from Windows Data Deduplication?

Yes, this feature is entirely different from the [Windows Data Deduplication](/windows-server/storage/data-deduplication/overview) feature.

> [!IMPORTANT]
> You can't enable both ReFS deduplication and Windows Data Deduplication simultaneously.

ReFS deduplication is designed for active workloads, focusing on minimizing performance impact after optimization. Unlike Windows Data Deduplication, ReFS deduplication doesn't use a chunk store to store deduped data, and there's no physical data movement involved. The feature relies on ReFS block cloning to enable metadata-only operations. Windows Data Deduplication might provide better storage savings due to its use of variable block sizes. It's also suitable for a broader range of workload types, such as General-purpose file servers (GPFS), backup targets, and more.

### What are the phases of ReFS deduplication?

The optimization process comprises the following phases that occur sequentially.

- **Initialization.** In this phase, the system scans the storage volume to identify redundant blocks of data.

- **Data deduplication.** In this phase, the redundant blocks are single-instanced and tracked using ReFS block cloning.

### What happens when the duration limit is reached before the volume is fully optimized?

The duration limit prevents any performance impact on customer workloads that the optimization job might cause during business hours. A deduplication service monitors the optimized parts of a volume and incoming file modifications. The service uses this data in future jobs to reduce optimization time. For example, if a volume is only 30% processed in the first run due to the duration limit, the subsequent run addresses the remaining 70% and any new data.

## Known issues

The following section lists the known issues that currently exist with ReFS deduplication.

### Scheduling jobs to run simultaneously on multiple CSVs within a single system can potentially trigger CSV movements and negatively affect performance

**Status:** Open.

We recommend and it's a best practice to stagger the start time of the jobs to avoid any overlap. However, if all jobs must run simultaneously, adjust the CPU allocation per job across all CSVs so that it amounts to less than 50% of the overall system CPU utilization. Keep in mind that imposing CPU limitations might result in longer job execution times.

### ReFS deduplication job completed (either successfully or was canceled) and storage savings aren't listed in `Get-ReFSDedupStatus` or Windows Admin Center

**Status:** Resolved.

As a temporary workaround, initiate a one-time job and the results update immediately.

```powershell
Start-ReFSDedupJob -Volume <path>
```

### Sending stopped monitoring Event Tracing for Windows (ETW) events after disabling ReFS deduplication on a volume

**Status:** Resolved.

When you disable ReFS deduplication on a volume, the ETW channel for ReFS deduplication logs repeated stopped monitoring events. However, we don't expect this issue to cause significant usage impact.

## Next steps

- [Manage volume](/windows-server/storage/storage-spaces/manage-volumes)
