---
title: Expand an Azure Managed Lustre file system by using the Azure portal
description: Learn how to expand Azure Managed Lustre storage capacity and throughput without downtime, and optionally rebalance data and metadata after expansion.
ms.topic: how-to
author: wolfgang-desalvador
ms.author: wdesalvador
ms.date: 10/06/2026

#customer intent: As an IT pro, I want to expand an Azure Managed Lustre file system without interrupting running workloads and optionally rebalance existing data and metadata.
---

# Expand an Azure Managed Lustre file system by using the Azure portal

This article explains how to expand the storage capacity and throughput of an existing Azure Managed Lustre file system by using the Azure portal. In-place expansion lets you add capacity as your workloads grow, without redeploying the file system, migrating data to another file system, or interrupting running jobs. The file system stays online and mounted while clients continue reading and writing.

File system expansion is generally available. To enable expansion for your subscription, [open a support ticket](https://portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview). Optional data and metadata rebalancing after expansion is available in public preview.

> [!IMPORTANT]
> Rebalancing is **on by default** when you expand through Azure CLI, the Azure StorageCache Management SDK, Bicep, Terraform, or ARM templates. In the Azure portal, rebalancing is **off by default**, and you can opt in.

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/pricing/purchase-options/azure-account) before you begin.
- An existing Azure Managed Lustre file system.
- The expansion feature enabled on your subscription. To request access, [open a support ticket](https://portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) and Microsoft will enable the file system expansion feature on your subscription. After enablement, the **Expand** action appears on the **Overview** page of each file system in that subscription.
- Enough available IP addresses in the existing file system subnet for the expanded configuration. Expansion adds Object Storage Servers (OSSs) that host the new Object Storage Targets (OSTs) and, when applicable, Metadata Servers (MDSs). Allow address space for service nodes, including the temporary utility VM used during rebalancing, and other resources that share the subnet. Plan for the target capacity, not just the current capacity, by reviewing [Network size requirements](amlfs-prerequisites.md#network-size-requirements). The existing [subnet access and permissions](amlfs-prerequisites.md#subnet-access-and-permissions) must also allow connectivity for the new nodes.
- If you're expanding a file system again, the file system must be **Available**, and any rebalancing job from the previous expansion must have finished. To confirm the file system is **Available**, open the file system in the Azure portal and check **Status** on its **Overview** page.

## How expansion works

Before you expand a file system, review the following behaviors and limitations:

- **Expansion only increases capacity and throughput.** You can't shrink a file system or reduce its capacity or throughput after expansion.
- **Capacity increases follow the throughput tier increment.** Each increase must be a multiple of the increment for the file system's throughput tier. Maximum throughput increases in proportion to capacity, with the same bandwidth per TiB. For example, the 250 MBps per TiB tier expands in increments of 8 TiB. Each increment adds 2,000 MBps (2 GB/s) of maximum throughput. For the increments and limits for each tier, see [Throughput configurations](create-file-system-portal.md#throughput-configurations).
- **The tier's maximum capacity still applies.** The expanded file system can't exceed the maximum supported capacity for its throughput tier. The same limits apply when you create or expand a file system. For details, see [Azure Managed Lustre scale targets](create-file-system-portal.md#throughput-configurations).
- **No downtime is expected.** The file system remains available throughout expansion. Existing mounts remain valid, and clients can continue to access data without stopping running jobs.
- **Existing content doesn't move during expansion.** Expansion adds OSTs and, when applicable, Metadata Targets (MDTs). New targets provide capacity for newly created content, but existing file data and directory trees remain on their original targets until [rebalancing runs after expansion](#rebalancing-after-expansion-preview). If rebalancing isn't enabled, existing placement remains unchanged.
- **Billing follows the final capacity reached.** You're billed for the final capacity and throughput of the file system. In the unlikely event that the expansion request can't be fully satisfied due to regional capacity availability, you're billed only for the final capacity and throughput achieved, not for any requested capacity that wasn't provisioned.

## Rebalancing after expansion (preview)

Lustre stores file data across OSTs and file and directory metadata on MDTs. Newly added targets start empty. Existing file layouts and directory trees don't automatically move to them when the file system expands.

Rebalancing redistributes existing file data across the expanded set of OSTs and directory metadata across the available MDTs. It spreads capacity utilization, I/O demand, metadata load, and file counts across the original and newly added targets, helping both new and existing datasets benefit from the expanded file system's performance.

Data and metadata rebalancing is optional and available in public preview. The defaults are:

- **Azure CLI, Azure StorageCache Management SDK, Bicep, Terraform, and ARM templates:** Rebalancing is **on by default** when you submit an expansion job through these interfaces.
- **Azure portal:** Rebalancing is **off by default** and **opt-in**. The **Perform data and metadata rebalancing after expansion (Preview)** checkbox is unchecked by default. Select it to enable automatic data and metadata rebalancing after expansion.

When enabled, rebalancing starts automatically after expansion completes successfully.

Rebalancing runs in the background and is designed to consume minimal cluster resources while client workloads continue. It takes time: the duration depends on the amount of existing data and how much data must move to balance utilization across the original and newly added OSTs. Larger datasets or more data movement generally require more time. The file system remains **Available** while rebalancing runs; this status doesn't indicate that rebalancing has finished.

If you leave the checkbox unchecked, no automatic rebalancing runs after expansion. Existing data and metadata placement remains unchanged, and newly created content can use the added targets. You can choose whether to rebalance based on your workload and operational timing. For more information about Lustre data placement, see [Optimize file and directory layouts](optimize-file-layouts.md).

## Expand a file system

1. Sign in to [the Azure portal](https://portal.azure.com/).

1. Go to the Azure Managed Lustre file system that you want to expand.

1. On the file system's **Overview** page, select **Expand**.

1. On the **Resize file system** pane, enter the new **Storage capacity**. The pane also shows the resulting **Maximum throughput**. Values round up to the increment for your throughput tier, and the new capacity must be larger than the current capacity.

   > [!NOTE]
   > After expansion is enabled for your subscription, you can choose sizes up to the default maximum for your throughput tier without an extra enablement request. For larger sizes, including multi-pebibyte (PiB) file systems, [open a support ticket](https://portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) with your requested size so Microsoft can enable larger file system sizes for your subscription. For more details, see the [maximum supported capacity](create-file-system-portal.md#throughput-configurations) for your throughput tier and Blob integration configuration.

1. To opt in to automatic data and metadata rebalancing after expansion completes successfully, select **Perform data and metadata rebalancing after expansion (Preview)**. This optional checkbox is unchecked by default. Leave it unchecked to expand without rebalancing.

1. Review the new capacity, throughput, and rebalancing selection. Select the acknowledgment checkbox to confirm that you understand the change, and then select **Save**.

   > [!IMPORTANT]
   > Expansion can't be reversed. You can't reduce the file system's capacity or throughput after expanding it.

1. Monitor progress on the **Resize file system** pane. When you're ready, select **Close**.

## Expand with automation

You can also expand a file system through an expansion job on the existing file system resource. Subscription enablement, capacity increments, and tier limits apply to all interfaces. Use a CLI extension, SDK, or resource API version that supports expansion jobs.

| Tool | Expansion approach |
| --- | --- |
| Azure CLI | Use [az amlfs expansion create](/cli/azure/amlfs/expansion#az-amlfs-expansion-create) in the `amlfs` extension. Specify the resource group, file system name, expansion job name, file system location, and target capacity with `--new-storage-capacity`. Use `az amlfs expansion show` to check the job. |
| Azure StorageCache Management SDK | Use the SDK's expansion job operations to create a job under the existing file system and retrieve its status. Use a package version that exposes expansion jobs; method and model names depend on the SDK language and version. For example, see [ExpansionJobsOperations in the Python SDK](/python/api/azure-mgmt-storagecache/azure.mgmt.storagecache.operations.expansionjobsoperations). |
| Bicep | Declare the existing file system with `existing`, then declare a `Microsoft.StorageCache/amlFilesystems/expansionJobs` child resource with the file system as its `parent`. Set `properties.newStorageCapacityTiB` to the target capacity. |
| Terraform | Use the AzAPI provider's `azapi_resource` for `Microsoft.StorageCache/amlFilesystems/expansionJobs`, with the existing file system's resource ID as `parent_id`. Set `body.properties.newStorageCapacityTiB` to the target capacity. Review the plan before applying it to ensure that the file system isn't replaced. |
| ARM templates | Deploy a `Microsoft.StorageCache/amlFilesystems/expansionJobs` child resource under the existing file system. Set `properties.newStorageCapacityTiB` to the target capacity. |

The target capacity is the total file system size after expansion, not the amount to add. The expansion job resource is available in API version `2026-01-01`. For the resource definitions, required properties, and syntax for Bicep, ARM templates, and Terraform AzAPI, see the [expansion jobs resource reference](/azure/templates/microsoft.storagecache/amlfilesystems/expansionjobs).

> [!IMPORTANT]
> The portal's off-by-default rebalancing setting doesn't apply to expansion jobs submitted through these automation interfaces. Data and metadata rebalancing is on by default and starts automatically after expansion finishes successfully.

## Monitor the expansion

While expansion runs, **Status** on the **Overview** page shows **Expanding**, along with a completion percentage. The file system remains available during this time.

When expansion finishes, **Status** returns to **Available**, and the **Overview** page shows the new storage capacity and throughput.

If rebalancing is enabled, either by opting in through the portal or by using the default behavior of an automation interface, data and metadata rebalancing starts automatically after expansion finishes successfully. The completion of expansion doesn't mean that rebalancing has also finished.

## Handle expansion errors

An expansion might not complete, for example, if the operation is interrupted or if the system can't add all of the requested capacity. If an error occurs:

- **The file system remains available.** An expansion error doesn't take the file system offline. Your data stays intact and accessible, and clients can continue working with the capacity that was successfully provisioned.
- **Billing follows the final capacity achieved.** In the unlikely event that the system can't satisfy the full request due to regional capacity availability or other issues, you pay only for the final storage capacity and throughput achieved, not for requested capacity that wasn't provisioned.
- **Contact support.** If an expansion fails or doesn't reach the capacity you need, [open a support ticket](https://portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) so Microsoft can investigate.
- **You can retry expansion.** After the file system returns to **Available** and any rebalancing job from the previous expansion finishes, you can start a new expansion to reach your target capacity, subject to the same [increment and upper-limit rules](#how-expansion-works).

## Related content

- [Create an Azure Managed Lustre file system by using the Azure portal](create-file-system-portal.md)
- [Optimize file and directory layouts](optimize-file-layouts.md)
- [Optimize Azure Managed Lustre performance](optimize-performance.md)