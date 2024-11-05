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

Before you can set quotas for a file system, you must have the following:

- An Azure Managed Lustre file system
- A client that is connected to the file system

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

To remove quotas for a file system, you use the `lfs quota` command with the `-r` option. The `-r` option removes quotas for individual users, groups, or projects.

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

## Soft limit and grace period for quotas

When a user exceeds their quota, a grace period is initiated. During the grace period, the user can continue to write data to the file system. The grace period is typically 7 days. After the grace period expires, the user can no longer write data to the file system until they reduce their storage usage below the quota limit.

## Next steps

In this article, you learned how to set and configure quotas for Azure Managed Lustre file systems. To learn more about Azure Managed Lustre, see the [Azure Managed Lustre documentation]().
