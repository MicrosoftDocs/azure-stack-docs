---
title: Tiered checkpoints for AI training with Azure Managed Lustre
description: Learn how to use Azure Managed Lustre with Azure Blob Storage as a tiered checkpoint architecture for large-scale AI training workloads.
ms.date: 06/30/2026
ms.topic: concept-article
author: wolfgang-desalvador
ms.author: akashdubey
ms.service: azure-managed-lustre
---

# Tiered checkpoints for AI training with Azure Managed Lustre

Azure Managed Lustre, combined with Azure Blob Storage, provides a tiered checkpointing architecture designed for large-scale AI training workloads. This scenario uses Azure Managed Lustre as a high-bandwidth, POSIX-compliant Accelerator Layer close to GPU compute, and Azure Blob Storage as a durable, cost-efficient Core Storage Layer for long-term checkpoint retention.

This article describes when to use tiered checkpointing, how the architecture works, and what performance you can expect.

## When to use this scenario

Consider tiered checkpointing with Azure Managed Lustre when your workload meets one or more of the following conditions:

- You train large foundation models (for example, LLMs in the tens to hundreds of billions of parameters) that generate large, frequent checkpoints.
- You need to minimize checkpoint write time to reduce GPU idle cycles during training.
- You need durable, long-term retention of checkpoints for recovery or experiment reproducibility.
- You want to decouple checkpoint write performance from object storage by separating the Accelerator Layer and the Core Storage Layer.
- You run distributed training on GPU clusters (for example, Azure ND-series virtual machines) that require a shared POSIX file system.

## Architecture

The tiered checkpointing architecture uses the Hierarchical Storage Management (HSM) capabilities of Azure Managed Lustre to create a two-tier design:

- **Accelerator Layer – Azure Managed Lustre**: A high-performance, POSIX-compliant parallel file system mounted directly on GPU compute nodes. Checkpoints are written at the full provisioned bandwidth of the file system (for example, 64 GB/s on an AMLFS 500 tier with 128 TiB of capacity).
- **Core Storage Layer – Azure Blob Storage**: A durable, scalable, and cost-optimized object store for checkpoint archival and long-term retention.

Training checkpoints are written from GPU nodes to Azure Managed Lustre through the native Lustre client. Completed checkpoints are then asynchronously replicated to Azure Blob Storage using the Azure Managed Lustre Blob integration auto-export feature.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        Training Compute Cluster                         │
└─────────────────────────────┬───────────────────────────────────────────┘
                              │ Write checkpoints at full AMLFS bandwidth
                              ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    Azure Managed Lustre (AMLFS)                         │
│                                                                         │
│   /lustrefs/checkpoints/modelA/                                         │
│   ├── global_epoch1_step1/                                              │
│   ├── global_epoch1_step2/                                              │
│   └── global_epoch1_stepN/                                              │
└─────────────────────────────┬───────────────────────────────────────────┘
                              │ Asynchronous HSM archive (auto-export)
                              ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       Azure Blob Storage                                │
│                                                                         │
│  - Recovery                                                             │
│  - Long-term retention                                                  │
│  - Cost-optimized archive                                               │
└─────────────────────────────────────────────────────────────────────────┘
```

### How the data flow works

1. **Checkpoint write** – The AI training framework writes checkpoints directly to Azure Managed Lustre through the POSIX interface. Writes use the full provisioned bandwidth of the file system, minimizing GPU stall time.
1. **Local durability** – Azure Managed Lustre provides locally redundant storage (LRS) resiliency. Once a checkpoint is committed to the file system, it persists independently of the lifecycle of the GPU compute nodes.
1. **Asynchronous archive** – The AMLFS Blob integration auto-export feature continuously and automatically transfers completed checkpoints to Azure Blob Storage without user intervention. Archival is decoupled from the training loop, so it doesn't impact write throughput to GPUs.
1. **Recovery** – Archived checkpoints can be rehydrated back to Azure Managed Lustre on demand through import jobs.

> [!NOTE]
> You can enable auto-export on the Azure Managed Lustre file system from the Azure portal or the Azure CLI at any time. For more information, see [Export data using auto-export jobs](auto-export.md).

## Managing file system capacity

Use **retention-based deletion** to manage the capacity of the Accelerator Layer. Implement a custom deletion policy that removes outdated checkpoints from Azure Managed Lustre based on age, step number, or model epoch.

> [!IMPORTANT]
> In the current Azure Managed Lustre Blob integration, deletes, renames, and moves you perform on the AMLFS side aren't propagated to the Azure Blob Storage account. Plan your retention and naming strategy accordingly. This behavior might change in future releases and will be documented as a breaking change.

## Restarting from a checkpoint

Keep the latest checkpoint data and metadata resident on Azure Managed Lustre. This configuration provides the fastest restart path and reduces recovery time for large AI training jobs.

If you delete checkpoint files from Azure Managed Lustre, use an import job (from the Azure portal or Azure CLI) to rehydrate the archived checkpoints from Azure Blob Storage back onto the file system. For more information, see [Import data using manual import jobs](create-import-job.md).

## Checkpoint write performance

Checkpoint writes from GPU nodes to Azure Managed Lustre run at the full provisioned bandwidth of the file system. For example, on an AMLFS 500 tier with 128 TiB of capacity, the file system delivers approximately 64 GB/s of write throughput. So, a ~912 GiB checkpoint (representative of an LLAMA 3 70B training step) commits to the Accelerator Layer in roughly 15 seconds. This performance minimizes GPU stall time during training and decouples checkpoint commit latency from the slower, asynchronous archive to Azure Blob Storage.

By default, the data mover between Azure Managed Lustre and Azure Blob Storage is configured to deliver approximately 7.5 GB/s, aligned with the default ingress limit of an Azure Blob Storage account. If your workload requires higher sustained archive throughput, [open a support ticket](https://ms.portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) to explore options.

## Next steps

- [Create an Azure Managed Lustre file system](create-file-system-portal.md)
- [Integrate Azure Managed Lustre with Azure Blob Storage](blob-integration.md)
- [Configure auto-export jobs](auto-export.md)
