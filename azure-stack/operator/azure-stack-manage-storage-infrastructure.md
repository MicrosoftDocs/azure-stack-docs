---
title: Manage storage infrastructure for Azure Stack Hub
titleSuffix: Azure Stack
description: Learn how to manage storage infrastructure for Azure Stack Hub. See how to monitor volumes and drives. View troubleshooting tips on adding drives to pools.
author: IngridAtMicrosoft

ms.topic: article
ms.date: 10/19/2020
ms.author: inhenkel
ms.lastreviewed: 5/4/2020
ms.reviewer: jiaha

# Intent: As an Azure Stack operator, I want to manage storage infrastructure in Azure Stack.
# Keyword: manage storage infrastructure azure stack

---

# Manage storage infrastructure for Azure Stack Hub
This article describes the health and operational status of Azure Stack Hub storage infrastructure resources. These resources include storage drives and volumes. The information in this topic helps you troubleshoot various issues, like when a drive can't be added to a pool.

## Volume states

To find out what state volumes are in, use the following PowerShell commands:

```powershell
$scaleunit_name = (Get-AzsScaleUnit)[0].name

$subsystem_name = (Get-AzsStorageSubSystem -ScaleUnit $scaleunit_name)[0].name

Get-AzsVolume -ScaleUnit $scaleunit_name -StorageSubSystem $subsystem_name | Select-Object VolumeLabel, HealthStatus, OperationalStatus, RepairStatus, Description, Action, TotalCapacityGB, RemainingCapacityGB
```

Here's an example of output showing a detached volume and a degraded/incomplete volume:

| VolumeLabel | HealthStatus | OperationalStatus |
|-------------|--------------|------------------------|
| ObjStore_1 | Unknown | Detached |
| ObjStore_2 | Warning | {Degraded, Incomplete} |

The following sections list the health and operational states:

### Volume health state: Healthy

| Operational state | Description |
|---|---|
| OK | The volume is healthy. |
| Suboptimal | Data isn't written evenly across drives.<br> <br>**Action:** Contact Support to optimize drive usage in the storage pool. Before you do, start the log file collection process using the guidance from https://aka.ms/azurestacklogfiles. You may have to restore from backup after the failed connection is restored. |

### Volume health state: Warning

When the volume is in a Warning health state, it means that one or more copies of your data are unavailable but Azure Stack Hub can still read at least one copy of your data.

| Operational state | Description |
|---|---|
| In service | Azure Stack Hub is repairing the volume, like  after adding or removing a drive. When the repair is complete, the volume should return to the OK health state.<br> <br>**Action:** Wait for Azure Stack Hub to finish repairing the volume and check the status afterward. |
| Incomplete | The resilience of the volume is reduced because one or more drives failed or are missing. However, the missing drives contain up-to-date copies of your data.<br> <br>**Action:** Reconnect any missing drives, replace any failed drives, and bring online any servers that are offline. |
| Degraded | The resilience of the volume is reduced because of one or more failed or missing drives as well as outdated copies of data on the drives.<br> <br>**Action:** Reconnect any missing drives, replace any failed drives, and bring online any servers that are offline. |

### Volume health state: Unhealthy

When a volume is in an Unhealthy health state, some or all of the data on the volume is currently inaccessible.

| Operational state | Description |
|---|---|
| No redundancy | The volume has lost data because too many drives failed.<br> <br>**Action:** Contact Support. Before you do, start the log file collection process using the guidance from https://aka.ms/azurestacklogfiles. |

### Volume health state: Unknown

The volume can also be in the Unknown health state if the virtual disk has become detached.

| Operational state | Description |
|---|---|
| Detached | A storage device failure occurred which may cause the volume to be inaccessible. Some data may be lost.<br> <br>**Action:** <br>1. Check the physical and network connectivity of all storage devices.<br>2. If all devices are connected correctly, contact Support. Before you do, start the log file collection process using the guidance from https://aka.ms/azurestacklogfiles. You may have to restore from backup after the failed connection is restored. |

## Drive states

Use the following PowerShell commands to monitor the state of drives:

```powershell
$scaleunit_name = (Get-AzsScaleUnit)[0].name

$subsystem_name = (Get-AzsStorageSubSystem -ScaleUnit $scaleunit_name)[0].name

Get-AzsDrive -ScaleUnit $scaleunit_name -StorageSubSystem $subsystem_name | Select-Object StorageNode, PhysicalLocation, HealthStatus, OperationalStatus, Description, Action, Usage, CanPool, CannotPoolReason, SerialNumber, Model, MediaType, CapacityGB
```

The following sections describe the health states a drive can be in:

### Drive health state: Healthy

| Operational state | Description |
|---|---|
| OK | The volume is healthy. |
| In service | The drive is doing some internal housekeeping operations. When the action is complete, the drive should return to the OK health state. |

### Drive health state: Warning

A drive in the Warning state can read and write data successfully but has an issue.

| Operational state | Description |
|---|---|
| Lost communication | Connectivity has been lost to the drive.<br> <br>**Action:** Bring all servers back online. If that doesn't fix it, reconnect the drive. If this state persists, replace the drive to ensure full resiliency. |
| Predictive failure | A failure of the drive is predicted to occur soon.<br> <br>**Action:** Replace the drive as soon as possible to ensure full resiliency. |
| IO error | There was a temporary error accessing the drive.<br> <br>**Action:** If this state persists, replace the drive to ensure full resiliency. |
| Transient error | There was a temporary error with the drive. This error usually means the drive was unresponsive, but it could also mean that the Storage Spaces Direct protective partition was inappropriately removed from the drive. <br> <br>**Action:** If this state persists, replace the drive to ensure full resiliency. |
| Abnormal latency | The drive is sometimes unresponsive and is showing signs of failure.<br> <br>**Action:** If this state persists, replace the drive to ensure full resiliency. |
| Removing from pool | Azure Stack Hub is in the process of removing the drive from its storage pool.<br> <br>**Action:** Wait for Azure Stack Hub to finish removing the drive, and check the status afterward.<br>If the status remains, contact Support. Before you do, start the log file collection process using the guidance from https://aka.ms/azurestacklogfiles. |
| Starting maintenance mode | Azure Stack Hub is in the process of putting the drive in maintenance mode. This state is temporary—the drive should soon be in the In maintenance mode state.<br> <br>**Action:** Wait for Azure Stack Hub to finish the process and check the status afterward. |
| In maintenance mode | The drive is in maintenance mode, halting reads and writes from the drive. This state usually means Azure Stack Hub administration tasks such as PNU or FRU are operating the drive. But the admin could also place the drive in maintenance mode.<br> <br>**Action:** Wait for Hub Azure Stack Hub to finish the administration task, and check the status afterward.<br>If the status remains, contact Support. Before you do, start the log file collection process using the guidance from https://aka.ms/azurestacklogfiles. |
| Stopping maintenance mode | Azure Stack Hub is in the process of bringing the drive back online. This state is temporary - the drive should soon be in another state, ideally Healthy.<br> <br>**Action:** Wait for Azure Stack Hub to finish the process and check the status afterward. |

### Drive health state: Unhealthy

A drive in the Unhealthy state can't currently be written to or accessed.

| Operational state | Description |
|---|---|
| Split | The drive has become separated from the pool.<br> <br>**Action:** Replace the drive with a new disk. If you must use this disk, remove the disk from the system, make sure there's no useful data on the disk, erase the disk, and then reseat the disk. |
| Not usable | The physical disk is quarantined because it's not supported by your solution vendor. Only disks that are approved for the solution and have the correct disk firmware are supported.<br> <br>**Action:** Replace the drive with a disk that has an approved manufacturer and model number for the solution. |
| Stale metadata | The replacement disk was previously used and may contain data from an unknown storage system. The disk is quarantined. <br> <br>**Action:** Replace the drive with a new disk. If you must use this disk, remove the disk from the system, make sure there's no useful data on the disk, erase the disk, and then reseat the disk. |
| Unrecognized metadata | Unrecognized metadata found on the drive, which usually means that the drive has metadata from a different pool on it.<br> <br>**Action:** Replace the drive with a new disk. If you must use this disk, remove the disk from the system, make sure there's no useful data on the disk, erase the disk, and then reseat the disk. |
| Failed media | The drive failed and won't be used by Storage Spaces anymore.<br> <br>**Action:** Replace the drive as soon as possible to ensure full resiliency. |
| Device hardware failure | There was a hardware failure on this drive. <br> <br>**Action:** Replace the drive as soon as possible to ensure full resiliency. |
| Updating firmware | Azure Stack Hub is updating the firmware on the drive. This state is temporary and usually lasts less than a minute and during which time other drives in the pool handle all reads and writes.<br> <br>**Action:** Wait for Azure Stack Hub to finish the updating and check the status afterward. |
| Starting | The drive is getting ready for operation. This state should be temporary—once complete, the drive should transition to a different operational state.<br> <br>**Action:** Wait for Azure Stack Hub to finish the operation and check the status afterward. |

## Reasons a drive can't be pooled

Some drives just aren't ready to be in Azure Stack Hub storage pool. You can find out why a drive isn't eligible for pooling by looking at the `CannotPoolReason` property of a drive. The following table gives a little more detail on each of the reasons.

| Reason | Description |
|---|---|
| Hardware not compliant | The drive isn't in the list of approved storage models specified by using the Health Service.<br> <br>**Action:** Replace the drive with a new disk. |
| Firmware not compliant | The firmware on the physical drive isn't in the list of approved firmware revisions by using the Health Service.<br> <br>**Action:** Replace the drive with a new disk. |
| In use by cluster | The drive is currently used by a Failover Cluster.<br> <br>**Action:** Replace the drive with a new disk. |
| Removable media | The drive is classified as a removable drive. <br> <br>**Action:** Replace the drive with a new disk. |
| Not healthy | The drive isn't in a healthy state and might need to be replaced.<br> <br>**Action:** Replace the drive with a new disk. |
| Insufficient capacity | There are partitions taking up the free space on the drive.<br> <br>**Action:** Replace the drive with a new disk. If you must use this disk, remove the disk from the system, make sure there's no useful data on the disk, erase the disk, and then reseat the disk. |
| Verification in progress | The Health Service is checking to see if the drive or firmware on the drive is approved for use.<br> <br>**Action:** Wait for Azure Stack Hub to finish the process, and check the status afterward. |
| Verification failed | The Health Service couldn't check to see if the drive or firmware on the drive is approved for use.<br> <br>**Action:** Contact Support. Before you do, start the log file collection process using the guidance from https://aka.ms/azurestacklogfiles. |
| Offline | The drive is offline. <br> <br>**Action:** Contact Support. Before you do, start the log file collection process using the guidance from https://aka.ms/azurestacklogfiles. |
