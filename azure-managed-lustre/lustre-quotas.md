---
title: Work with quotas in Azure Managed Lustre file systems
description: Learn how to set and configure quotas for Azure Managed Lustre file systems. 
ms.topic: how-to
ms.date: 11/05/2024
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: blepore

---

# Work with quotas in Azure Managed Lustre file systems

In this article, you learn how to set and configure quotas for Azure Managed Lustre file systems. Quotas allow a system administrator to limit the amount of storage that users can consume in a file system. You can set quotas for individual users, groups, or projects.

## Prerequisites

- Existing Azure Managed Lustre file system - create one using the [Azure portal](create-file-system-portal.md), [Azure Resource Manager](create-file-system-resource-manager.md), or [Terraform](create-aml-file-system-terraform.md). To learn more about blob integration, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional).

## Quota types

Azure Managed Lustre supports the following types of quotas:

- **User quotas**: Limits the amount of storage that an individual user can consume in a file system. A user quota for a specific user can be different from the quotas of other users.
- **Group quotas**: Limits the amount of storage that a group of users can consume in a file system. A group quota applies to all users who are members of a specific group.
- **Project quotas**: Limits the amount of storage that a project can consume in a file system. A project quota applies to all files or directories associated with a project. A project can include multiple directories or individual files located in different directories within a file system.
- **Block quotas**: Limits the amount of storage that a user, group, or project can consume in a file system. You configure the storage size in kilobytes.
- **Inode quotas**: Limits the number of files that a user, group, or project can create in a file system. You configure the maximum number of inodes as an integer.

## Set quotas for a file system

To set quotas for a file system, you use the `lfs quota` command. The `lfs quota` command allows you to set quotas for individual users, groups, or projects.

The following example sets a quota of 1 TB for the user `user1` in the file system `fs1`:

```bash
lfs quota -u user1 -b 1T /mnt/fs1
```

The following example sets a quota of 1 TB for the group `group1` in the file system `fs1`:

```bash
lfs quota -g group1 -b 1T /mnt/fs1
```

The following example sets a quota of 1 TB for the project `project1` in the file system `fs1`:

```bash
lfs quota -p project1 -b 1T /mnt/fs1
```

## Display quotas for a file system

To view quotas for a file system, you use the `lfs quota` command with the `-l` option. The `-l` option displays quotas in a detailed format.

The following example displays quotas for the file system `fs1`:

```bash
lfs quota -l /mnt/fs1
```

## Remove quotas for a file system

To remove quotas for a file system, use the `lfs quota` command with the `-r` option. The `-r` option removes quotas for individual users, groups, or projects.

The following example removes quotas for the user `user1` in the file system `fs1`:

```bash
lfs quota -u user1 -r /mnt/fs1
```

The following example removes quotas for the group `group1` in the file system `fs1`:

```bash
lfs quota -g group1 -r /mnt/fs1
```

The following example removes quotas for the project `project1` in the file system `fs1`:

```bash
lfs quota -p project1 -r /mnt/fs1
```

## Limits and grace periods for quotas

Azure Managed Lustre enforces user, group, and project quotas as either a hard limit or a soft limit with a configurable grace period.

The hard limit is the absolute limit. If a user exceeds the hard limit, a block or inode allocation fails with a `Disk quota exceeded` message. Users who reach their quota hard limit must delete enough files or directories to get under the quota limit before they can write to the file system again.

The soft limit must be smaller than the hard limit. If a user exceeds the soft limit, the user can continue to exceed the quota until the grace period has elapsed or until the hard limit is reached. After the grace period ends, the soft limit converts to a hard limit and users are blocked from any further write operations until their usage returns below the defined block quota or inode quota limits. A user doesn't receive a notification or warning when the grace period begins.

The grace period defaults to one week, and applies to all users (for user quotas), groups (for group quotas), or projects (for project quotas). In other words, you can't apply different grace periods to different user quotas. The same restriction applies to group quotas and project quota. However, you *can* set different grace periods for inode and block quotas.

The grace period setting can vary for user, group, and project quotas, but the change applies to all entities within each of the three categories.

### Set soft limits for quotas

To set a soft limit for a quota, use the following syntax:

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
- `-b` specifies the soft limit for block quotas. `-B` specifies the hard limit for block quotas.
- `-i` specifies the soft limit for inode quotas. `-I` specifies the hard limit for inode quotas.
- `/mount_point` specifies the mount point of the file system.

The following example sets a soft limit of 1 TB and a hard limit of 2 TB for the user `user1` in the file system `fs1`:

```bash
lfs setquota -u user1 -b 1T -B 2T /mnt/fs1
```

### Set grace periods for quotas

To set a grace period for a quota, use the following syntax:

```bash
lfs setquota -t {-u|-g|-p}
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

The following example sets the block quota grace period to 5 days for the user `user1` in the file system `fs1`:

```bash
lfs setquota -t -u user1 -b 5d /mnt/fs1
```

The following example sets the inode quota grace period to 1 week, 3 days for the group `group1` in the file system `fs1`:

```bash
lfs setquota -t -g group1 -i 1w3d /mnt/fs1
```

## Next steps

In this article, you learned how to set and configure quotas for Azure Managed Lustre file systems. To learn more about Azure Managed Lustre, see the [Azure Managed Lustre documentation]().
