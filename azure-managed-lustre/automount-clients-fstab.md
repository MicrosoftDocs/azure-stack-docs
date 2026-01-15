---
title: Automatically Mount Lustre Clients with fstab
description: Learn how to automount Lustre clients by using fstab.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.date: 11/11/2024
ms.reviewer: dsundarraj

---

# Automatically mount clients to an Azure Managed Lustre file system by using fstab

This article describes how to automount Lustre clients by using fstab so that you can automatically mount your Azure Managed Lustre directory when the Lustre client virtual machine (VM) restarts.

## Prerequisites

Before you can update the /etc/fstab file of your Azure Managed Lustre client, you must create your Azure Managed Lustre file system. For more information, see [Create an Azure Managed Lustre file system by using the Azure portal](create-file-system-portal.md).

## Procedure

To update the /etc/fstab file in your Lustre client VM:

1. Connect to your Managed Lustre client VM and open the **/etc/fstab** file in an editor.
1. Add the line detailed in this section to the **/etc/fstab** file.
1. Save the file.

### Syntax

```bash
<MGS IP address>@tcp:/lustrefs </mount_point> lustre <Mount options> <Backup method> <File system check>
```

### Example

```bash
<MGS IP Address>@tcp:/lustrefs </mount_point> lustre defaults,noatime,flock,_netdev,x-systemd.automount,x-systemd.requires=network.service 0 0
```

> [!NOTE]
> You can copy the example and add the appropriate Lustre Management Service (MGS) IP address and mount point for a functional default setup.

### Parameters

The following parameters are required.

| Name | Description |
|----------|-----------|
| `MGS IP address` | IP address provided in the portal. |
| `/mount_point` | Directory that you want to mount your Managed Lustre file system to. |
| `Mount options` | See the [mount options table](#mount-options) for recommended settings. |
| `Backup method` | Binary option that indicates whether dumping should back up the file system. We don't recommend this method for use, and it should be set at `0`.|
| `File system check` | Indicates the order in which `fsck` checks file systems at startup. Set the value to `0`, which indicates that `fsck` doesn't run at startup. |

### Mount options

You can include mount options on the fstab line. Each value is comma separated. We recommend that you include the following options by default, unless you know that your setup requires a different configuration.

| Name  | Description |
|----------|-----------|
| `defaults` | Tells the operating system to use the default mount options. You can list the default mount options after the file system is mounted by viewing the output of the `mount` command. |
| `noatime` | Turns off updates for `inode` access times. If you want to update `inode` access times, remove this mount option. |
| `flock` | Mounts your file system with file locking enabled. If you don't want file locking enabled, remove this mount option. |
| `_netdev` | Tells the operating system that the file system resides on a device that requires network access. This option prevents the instance from mounting the file system until the network is enabled on the client. |
| `x-systemd.automount` | Helps ensure that the automatic mounter doesn't run until the network connectivity is online. This option is used with `x-systemd.requires=network.service`.|
| `x-systemd.requires=network.service` | Helps ensure that the automatic mounter doesn't run until the network connectivity is online. This option is used with `x-systemd.automount`. Note that `network.service` might not be known to all distributions, which might cause problems with other file systems. You can exclude it from the fstab line if it's causing problems.|

## Conclusion

Your Lustre client VM is now configured to mount an Azure Managed Lustre file system whenever it restarts.

In some cases, your Lustre client VM might need to start regardless of the status of your mounted Azure Managed Lustre file system. In these cases, add the `nofail` option to your file system's entry in your /etc/fstab file.
