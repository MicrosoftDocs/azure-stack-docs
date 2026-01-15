---
title: Use quotas in Azure Managed Lustre file systems
description: Learn how to set and configure quotas for Azure Managed Lustre file systems. 
ms.topic: how-to
ms.date: 11/11/2024
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: blepore

---

# Use quotas in Azure Managed Lustre file systems

In this article, you learn how to set and configure quotas for Azure Managed Lustre file systems. Quotas allow a system administrator to limit the amount of storage that users can consume in a file system. You can set quotas for individual users, groups, or projects.

## Prerequisites

- Existing Azure Managed Lustre file system - create one using the [Azure portal](create-file-system-portal.md), [Azure Resource Manager](create-file-system-resource-manager.md), or [Terraform](create-aml-file-system-terraform.md). To learn more about blob integration, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites).

## Quota types

Azure Managed Lustre supports the following types of quotas:

- **User quotas**: Limits the amount of storage that an individual user can consume in a file system. A user quota for a specific user can be different from the quotas of other users.
- **Group quotas**: Limits the amount of storage that a group of users can consume in a file system. A group quota applies to all users who are members of a specific group.
- **Project quotas**: Limits the amount of storage that a project can consume in a file system. A project quota applies to all files or directories associated with a project. A project can include multiple directories or individual files located in different directories within a file system.

The following limit quotas can be applied to user, group, or project quotas:

- **Block quotas**: Limits the amount of storage that a user, group, or project can consume in a file system. You configure the storage size in kilobytes.
- **Inode quotas**: Limits the number of files that a user, group, or project can create in a file system. You configure the maximum number of inodes as an integer.

> [!NOTE]
> Quotas *don't* apply to the root user. Quotas set for the root user are not enforced. Similarly, writing data as the root user using the sudo command bypasses enforcement of the quota.

## Set and view quotas for a file system

To set quotas for a file system, you use the `lfs setquota` command. The `lfs setquota` command allows you to set quotas for individual users, groups, or projects. To view quotas for a file system, you use the `lfs quota` command.

### Set quotas for a file system

To set a quota for a user, group, or project, use the following syntax:

```bash
lfs setquota {-u|--user|-g|--group|-p|--project} username|groupname|projectid
             [-b block_softlimit] [-B block_hardlimit]
             [-i inode_softlimit] [-I inode_hardlimit]
             /mount_point
```

The command uses the following parameters:

- `-u` or `--user` specifies a user to set a quota for.
- `-g` or `--group` specifies a group to set a quota for.
- `-p` or `--project` specifies a project to set a quota for.
- `-b` specifies the soft limit for block quotas. `-B` specifies the hard limit for block quotas. To learn more about limits, see [Limits and grace periods for quotas](#limits-and-grace-periods-for-quotas).
- `-i` specifies the soft limit for inode quotas. `-I` specifies the hard limit for inode quotas.
- `/mount_point` specifies the mount point of the file system.

### [User quotas](#tab/user-quotas)

The following example sets a block quota with a soft limit of 1 TB and a hard limit of 2 TB for the user `user1` on the file system mounted to `/mnt/fs1`:

```bash
sudo lfs setquota -u user1 -b 1T -B 2T /mnt/fs1
```

### [Group quotas](#tab/group-quotas)

The following example sets an inode quota with a soft limit of 2500 and a hard limit of 5000 for the group `group1` on the file system mounted to `/mnt/fs1`:

```bash
sudo lfs setquota -g group1 -i 2500 -I 5000 /mnt/fs1
```

### [Project quotas](#tab/project-quotas)

The following example sets a block quota with a hard limit of 1 TB and an inode quota with a hard limit of 5000 for the project `project1` on the file system mounted to `/mnt/fs1`:

```bash
sudo lfs setquota -p project1 -B 1T -I 5000 /mnt/fs1
```

---

### View quotas for a file system

To view quotas for a file system, use the `lfs quota` command. You can view information about user quotas, group quotas, project quotas, and grace periods.

The following examples show different ways to display quotas on the file system mounted to `/mnt/fs1`:

| Command | Description |
| --- | --- |
| `lfs quota /mnt/fs1` | Displays general quota information (disk usage and limits) for the user running the command and the user's primary group. |
| `lfs quota -u user1 /mnt/fs1` | Displays general quota information for the user `user1` in the file system. |
| `lfs quota -g group1 /mnt/fs1` | Displays general quota information for the group `group1` in the file system. |
| `lfs quota -p project1 /mnt/fs1` | Displays general quota information for the project `project1` in the file system. |
| `lfs quota -t -u /mnt/fs1` | Displays block and inode grace periods for user quotas. |
| `lfs quota -t -g /mnt/fs1` | Displays block and inode grace periods for group quotas. |
| `lfs quota -t -p /mnt/fs1` | Displays block and inode grace periods for project quotas. |

## Limits and grace periods for quotas

Azure Managed Lustre enforces user, group, and project quotas as either a hard limit or a soft limit with a configurable grace period.

The hard limit is the absolute limit. If a user exceeds the hard limit, a block or inode allocation fails with a `Disk quota exceeded` message. Users who reach their quota hard limit must delete enough files or directories to get under the quota limit before they can write to the file system again.

The soft limit must be smaller than the hard limit. If a user exceeds the soft limit, the user can continue to exceed the quota until the grace period elapses or until the hard limit is reached. After the grace period ends, the soft limit converts to a hard limit and users are blocked from any further write operations until their usage returns below the defined block quota or inode quota limits. A user doesn't receive a notification or warning when the grace period begins.

The grace period defaults to one week, and applies to all users (for user quotas), groups (for group quotas), or projects (for project quotas). In other words, you can't apply different grace periods to different user quotas. The same restriction applies to group quotas and project quota. However, you *can* set different grace periods for inode and block quotas.

The grace period setting can vary for user, group, and project quotas, but the change applies to all entities within each of the three categories.

### Set grace periods for quotas

To set a grace period for a quota, use the following syntax:

```bash
sudo lfs setquota -t {-u|-g|-p}
             [-b block_grace]
             [-i inode_grace]
             /mount_point
```

The command uses the following parameters:

- `-t` specifies that you're setting a grace period.
- `-u`sets a grace period for all users.
- `-g` sets a grace period for all groups.
- `-p` sets a grace period for all projects.
- `-b` specifies the grace period for block quotas. `-i` specifies the grace period for inode quotas. Both `block_grace` and `inode_grace` values are in seconds by default. You can also use `XXwXXdXXhXXmXXs` format to specify the grace period in weeks, days, hours, minutes, or seconds.

No values are allowed after `-u`, `-g`, or `-p`. By default, the grace period is one week.

### [User quotas](#tab/user-quotas)

The following example sets the block quota grace period to five days (`5d`) for all users in the file system `fs1`:

```bash
sudo lfs setquota -t -u -b 5d /mnt/fs1
```

### [Group quotas](#tab/group-quotas)

The following example sets the inode quota grace period to one week, three days (`1w3d`) for all groups in the file system `fs1`:

```bash
sudo lfs setquota -t -g -i 1w3d /mnt/fs1
```

### [Project quotas](#tab/project-quotas)

The following example sets the block quota grace period to two weeks (`2w`) for all projects in the file system `fs1`:

```bash
sudo lfs setquota -t -p -b 2w /mnt/fs1
```

---

## Next steps

In this article, you learned how to set and configure quotas for Azure Managed Lustre file systems. To learn more about Azure Managed Lustre, see the [Azure Managed Lustre documentation](/azure/azure-managed-lustre/).
