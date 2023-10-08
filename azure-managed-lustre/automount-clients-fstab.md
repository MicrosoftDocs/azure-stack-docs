---
title: Automatically mount Lustre clients with fstab
description: Describes how to automount lustre clients using fstab.
ms.topic: how-to
author: mvbishop
ms.author: mayabishop
ms.date: 07/26/2023
ms.lastreviewed: 07/26/2023
ms.reviewer: dsundarraj

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Automatically mount clients to an Azure Managed Lustre file system using fstab

This article describes how to automaount Lustre clients using fstab in order to automatically mount your Azure Managed Lustre directory when the Lustre client VM reboots.

## Prerequisites

Before you can update the **/etc/fstab** file of your Azure Managed Lustre client, make sure that you've already created your Azure Managed Lustre file system. For more information, see [Create an Azure Managed Lustre file system](create-file-system-portal.md).

## Procedure

To update the **/etc/fstab** file in your Lustre client VM:

1. Connect to your Managed Lustre client VM and open the **/etc/fstab** file in an editor.
1. Add the line detailed below to the /etc/fstab file.
1. Save the fstab file.

### Syntax

```bash
<MGS IP Address>@tcp:/lustrefs </mount_point> lustre <Mount Options> <Backup method> <Filesystem check>
```

### Example

```bash
<MGS IP Address>@tcp:/lustrefs </mount_point> lustre defaults,noatime,flock,_netdev,x-systemd.automount,x-systemd.requires=network.service 0 0
```
> [!NOTE]
> You can copy the example and input the appropriate MGS IP address and mount point for a functional default setup.

### Parameters

The following parameters are required.

| Name  | Value | Description |
|----------|-----------|-----------|
| MGS IP Address | | IP address provided in the portal |
| /mount_point | | directory that you want to mount your Managed Lustre system to. |
| Mount options | | See the table below for recommended settings.|
| Backup method | 0 | A binary option that indicates whether the file system should be backed up by dumping. This method is not recommended for use, and should be set at 0.|
| File system check | 0 | indicates the order in which fsck checks file systems at boot. this value will indicate that fsck will not run at startup. |

### Mount options

Mount options may be included in the fstab line. Each value is seperated by a comma. It is recommended that the following be included by default unless you know your setup requires a different configuration.

| Name  | Description |
|----------|-----------|
| defaults | This value tells the operating system to use the default mount options. You can list the default mount options after the file system has been mounted by viewing the output of the mount command. |
| noatime | Turns off inode access time updates. If you want to update inode access times, remove this mount option. |
| flock | Mounts your file system with file locking enabled. If you don't want file locking enabled, remove this mount option. |
| _netdev | The value tells the operating system that the file system resides on a device that requires network access. This option prevents the instance from mounting the file system until the network has been enabled on the client. |
| x-systemd.automount | Helps ensure that the auto mounter does not run until the network connectivity is online.  Used in conjunction with x-systemd.requires=netowrk.service|
| x-systemd.requires=network.service | Helps ensure that the auto mounter does not run until the network connectivity is online. Used in conjunction with x-systemd.automount |

## Conclusion

Your Lustre client VM is now configured to mount AMLFS whenever it restarts.

In some cases, your Lustre client VM might need to start regardless of the status of your mounted AMLFS file system. In these cases, add the nofail option to your file system's entry in your /etc/fstab file.

The fields in the line of code that you added to the /etc/fstab file do the following.

