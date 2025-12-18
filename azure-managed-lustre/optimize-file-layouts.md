---
title: Optimize file and directory Layouts in Azure Managed Lustre
description: Start here to learn how to optimize file and directory layouts in Azure Managed Lustre.
ms.date: 12/17/2025
ms.custom: horz-monitor
ms.topic: how-to
author: barbisch
ms.author: rohogue
ms.service: azure-managed-lustre
---

# Optimize file and directory layouts in Azure Managed Lustre

This article provides information on scaling file and directory layouts for maximum performance with AMLFS.

## Overview

Azure Managed Lustre (AMLFS) uses the Lustre file system's advanced file and directory striping capabilities to deliver scalable, high-performance storage. Understanding how files and directories are distributed across storage nodes is essential to maximize performance and efficiently manage large datasets. This article outlines the default file and directory layouts for AMLFS and provides recommendations for advanced optimization.

## File and directory striping in AMLFS

A key performance feature of Lustre—and by extension, AMLFS—is its ability to stripe (or shard) both files and directories across multiple storage resources to balance and optimize system capabilities. The number of Object Storage Targets (OSTs) and Metadata Target Servers (MDTs) deployed with your AMLFS instance determines how files and directories are distributed. Larger AMLFS deployments typically have more OSTs and MDTs, increasing both capacity and parallel performance.

To view the number of OSTs and MDTs in your deployment, run the following command on any client node with Lustre mounted:

```bash
lfs df -h
```

## Default file layouts in AMLFS

By default, AMLFS uses a Progressive File Layout (PFL) for all files. PFL adapts striping based on file size to balance performance and resource usage. The layout is preset at the root of your file system with the following command:

```bash
lfs setstripe -E 1G -c 1 -E 100G -c 5 -E 500G -c 10 -E -1 -c -1 [/lustrefs]
```

- Files smaller than 1 GB are stored on a single OST, minimizing overhead and maximizing performance for small files.
- Data from 1 GB to 101 GB is striped across 5 OSTs.
- Data from 101 GB to 601 GB is striped across 10 OSTs.
- Data larger than 601 GB is striped across all available OSTs, maximizing throughput for large files.
- If your deployment has fewer than 10 OSTs, AMLFS uses the maximum number available according to the sizes referenced previously.

This default layout is suitable for most use cases. Advanced users can customize file striping for specific performance requirements using the lfs setstripe command. For example, to maximize parallel throughput for a single large file by always striping it across all OSTs, try creating the file using:

```bash
lfs setstripe -c -1 [file]
```

File is automatically striped across all available OSTs regardless of file size.

This striping may benefit highly parallel workloads that depend on maximum read throughput from a single file across many mounted clients.

It's not advisable for use on small files.

> [!NOTE]
> Modifying striping parameters is an advanced operation. Improper use may impact performance or storage efficiency. Consult the [Lustre Manual](https://doc.lustre.org/lustre_manual.pdf) and use `lfs setstripe -h` for detailed options. Benchmark new configurations before applying them in production environments.

## Directory size and organization

Lustre supports hierarchical namespaces, which differ from flat object storage systems such as Blob Storage. When planning directory structures, keep the following best practices in mind:

- Organize data into hierarchical structures with multiple directories rather than a single, large directory. This multi-directory structure reduces contention for parallel workloads and improves overall metadata performance.
- While Lustre can technically manage hundreds of millions of entries per directory and greater, large directories can cause performance degradation or lock contention when high-concurrency metadata access or directory scan operations (such as with `ls -lR` or `rm -Rf`) are required.
- Minimize repeated parallel scans of large directories, especially scans that include the Linux stat operation such as `ls -l`, to avoid metadata bottlenecks.

## Optimizing directory layouts with multiple MDTs

Large AMLFS deployments (over 1 PiB on many SKUs, or 2.5 PiB on others) are provisioned with multiple MDTs to scale metadata operations and file counts. Each MDT can linearly scale the maximum metadata operations per second and maximum file counts possible when properly configured and depending on your average file sizes.

To check how many MDTs are available, run the following command from a mounted client:

```bash
lfs df -h
```

If your deployment has only one MDT, default layout optimizations are sufficient while heeding the best practices from the previous section about directory size. With multiple MDTs, AMLFS automatically rotates directories round robin across MDTs using the following default root-level command that is run when your AMLFS is first deployed:

```bash
lfs setdirstripe -D -i -1 -c 1 --max-inherit=-1 --max-inherit-rr=-1 [/lustrefs]
```

- This sets a round-robin directory placement policy for all directories created under the root, distributing them evenly across MDTs to balance performance.
- Workloads with many directories in a hierarchical structure automatically benefit from this layout, maximizing metadata throughput and scalability.

This default scheme eliminates the need for manual directory placement and is suitable for most users. In addition, including a hierarchical directory scheme with multiple directories instead of single large directories help automatically balance your metadata workload across the MDTs of your AMLFS instance.

## Advanced directory layout options

Advanced users can further customize directory placement using `lfs setdirstripe` from any Lustre client to:

- Stripe a single large directory across multiple MDTs for increased metadata performance using the `-c` parameter of `lfs setdirstripe`. This can increase parallel file access of a large directory by striping it across multiple MDTs but may not be beneficial to parallel directory scans.
- Assign specific MDTs to critical or high-performance directories.
- Rebalance directories after creation with `lfs migrate`.

> [!IMPORTANT]
> These optimizations are advanced and should be approached with care. Refer to the [Lustre Manual](https://doc.lustre.org/lustre_manual.pdf) and use `lfs setdirstripe -h` for help before making changes beyond the default configuration. Be sure to benchmark any changes before deploying them to your production workloads.

## Next steps

In this article, you learned how AMLFS automatically applies optimized file and directory layouts for most workloads. To learn more about Azure Managed Lustre, see the [Azure Managed Lustre documentation](/azure/azure-managed-lustre/).
