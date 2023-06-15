---
title: Capacity planning using Azure Site Recovery (preview)
description: Learn about capacity planning for Azure Site Recovery.
author: ronmiab
ms.author: robess
ms.topic: conceptual
ms.reviewer: rtiberiu
ms.lastreviewed: 03/07/2023
ms.date: 03/07/2023
---

# Capacity planning using Azure Site Recovery (preview)

As an organization, it's imperative to adopt a business continuity and disaster recovery (BCDR) strategy that keeps your data safe, apps available, and workloads online during planned and unplanned outages.

Through the replication of virtual machines (VMs) workloads from a primary site to a secondary location, Azure Site Recovery on Azure Stack Hub provides services that can support the safety of organizational data, application availability, and workloads during outages. For example, when an outage occurs at your primary site, you fail over to a secondary location to access your apps. As soon as the primary site is running again, you can fail back to it. For more information, see [About Site Recovery](../operator/azure-site-recovery-overview.md).

To enable replication of VMs across two Azure Stack Hub stamps, two environments need to be configured:

- **Source** environment:
    - The Azure Stack Hub stamp where tenant VMs are running.
- **Target** environment:
    - The Azure Site Recovery Resource Provider and dependencies run here.

:::image type="content" source="../operator/media/azure-site-recovery/capacity-planning/source-and-target.png" alt-text="Snapshot of replication of VMs across two Azure Stack Hub stamps."lightbox="media/azure-site-recovery/capacity-planning/source-and-target.png":::

An essential component for the success of a business continuity and disaster recovery plan is capacity planning. During capacity planning, there are a few factors to consider:

- Recovery time objectives (RTO) and recovery point objectives (RPO) for the specific workloads that you want to protect.

- Workloads and the application characteristics.
    - How often the data changes within the respective VM?
    - How much data is generated or removed?
    - How the application design looks and more?

- VM sizes, the number of disks, and how each VM is tied to other VMs.
    - For solutions that would require several VMs,    understand what order those VMs need to be started in and more.

- Network bandwidth between the source and target environments. Note, this component could affect RPOs.

Each of these points is important and have a broad implication when building a BCDR plan.

The following sections list the main points to consider from an Azure Site Recovery perspective. Note, each BCDR plan is different and is based on the specifics of the workloads you plan to protect therefore this list isn't comprehensive.

## Source considerations

In the source environment, Azure Stack Hub runs the Azure Site Recovery VM Appliance. The VM is a Standard DS4_V2 (8 vCPUs, 28-Gb memory, 32 data disks) VM that is running in the Azure Stack Hub User subscription.

On the source environment, consider the following areas:

- Quota:
    - You should have sufficient quota for creating the Azure Site Recovery VM Appliance. One or multiple depending on the overall plan.

- Storage for the Azure Site Recovery VM Appliance:

    - The Azure Site Recovery VM Appliance itself has the data requirements defined by its VM size.
    - When planning for capacity, make sure the Appliance VM has enough storage to exercise the fail-back and re-protect mechanisms.

    > [!NOTE]
    > If there are storage limitations, the fail-back and re-protect may fail with `An internal error occurred` message. Users should check the event logs on the appliance to confirm the actual Azure Resource Manager error. For more information, see [Known issues for Azure Site Recovery](../operator/azure-site-recovery-known-issues.md).

- Bandwidth:

    - The initial replication generates high bandwidth usage.
    - Changes on each VM, or deltas changes, are replicated depending on the replication policies and each type of application.  

## Target considerations

In the target environment, there are two parts to consider for capacity planning:

- The Azure Site Recovery service requirements. How much is consumed to run Azure Site Recovery, without necessarily protecting any workloads.

- The protected workloads requirements.

The target environment will require one ASR Vault created for each ASR Appliance that will protect VMs from the source (one appliance per vault). While this is not a limitation from a capacity perspective, it will need to be taken into account when planning the design of the overall environment.

## Azure Site Recovery RP resources

Installing Azure Site Recovery on Azure Stack Hub involves adding two dependencies and the Azure Site Recovery Resource Provider (RP) itself:


- Azure Stack Hub Event Hubs

- Azure Site Recovery dependency service

- Azure Site Recovery

:::image type="content" source="../operator/media/azure-site-recovery/capacity-planning/three-services.png" alt-text="Screenshot of the three services to install Azure Site Recovery on Azure Stack Hub."lightbox="media/azure-site-recovery/capacity-planning/three-services.png":::

These three services are created on the Azure Stack Hub Admin subscription and managed by Azure Stack Hub itself, therefore there's no configuration required. However, as with any service, these resources consume memory, storage, and have certain vCPUs allocated.

|Service            | vCore  | Memory     | Disk Size  |
|-------------------|--------|------------|------------|
|Event Hubs         | 16     | 91 GB      | 800 GB     |
|Dependency Service | 12     | 42 GB      | 600 GB     |
|Azure Site Recovery| 12     | 42 GB      | 300 GB     |
|**Total**          | **40** | **175 GB** | **1700 GB**|

> [!NOTE]
> The above resources are Azure Stack Hub services on the Administration side of Azure Stack Hub. Once installed, the platform manages these resources.

## Protected workloads

When creating the BCDR plan, consider all aspects of the protected workloads. The following list isn't complete and should be treated as a starting point:

- VM size, number of disks, disk size, IOPS, data churn, and new data created.

- Network bandwidth considerations:
    - The network bandwidth that's required for delta replication.
    - The amount of throughput, on the target environment, that Azure Site Recovery can get from source environment.
    - The number of VMs to batch at a time. Based on the estimated bandwidth to complete initial replication in a given amount of time.
    - The RPO that can be achieved for a given bandwidth.
    - The effect on the desired RPO if lower bandwidth is provisioned.

- Storage considerations:
    - How much data is required for the initial replication?
    - How many recovery points are held and how data increases, for each protected VM, during these intervals?
    - How many quotas need to be assigned to the target Azure Stack hub user subscriptions, so that users have sufficient allocation?
    - The cache storage account for replication.

    > [!IMPORTANT]
    > There are complex requirements depending on the type of workloads protected, the scenario used, the number of VMs and disks protected, and the overall state of the system. For more information, see [Site Recovery Capacity Planner](../operator/azure-site-recovery-capacity-planning.md).

- Compute considerations:
    - When failover occurs, the VMs are started on the target Azure Stack Hub user Subscriptions. Enough quota allocation must be in place to be able to start these VM resources.
    - During the protection of the VM, when the protected VM is active on the source environment, no VM-related-resources like vCPU, memory, etc. are consumed on the target environment. These resources become relevant only during a failover process such as test failover.

For the scope of Azure Site Recovery on Azure Stack Hub, here's a starting point for calculations, especially for the cache storage account used:

1. If there's a failover, during normal operations, multiply the number of disks replicated by the average RPO. For example, you might have (2MB * 250s). The cache storage account is normally a few KB to 500 MB per disk.

2. If there's a failover, given a worst case scenario, multiply the number of disks replicated by the average RPO over a full day.

    > [!IMPORTANT]
    > If some parts of Azure Site Recovery aren't working, but others are working, there can be at most one day of difflog in the storage account before Azure Site Recovery decides to timeout.

3. Failback to new VM. Calculate the sum of the disks size of each batch.
    - The entire disk needs to be copied to the cache storage account for the target VM to apply since the target is an empty disk.
    - The associated data is deleted once copied, but it's likely to see a peak usage with the sum of all disk sizes.

Create the BDCR plan based on the specifics of the solution you're trying to protect.

The following table is an example of tests run in our environments. You can use this insight to get a baseline for your own application, but each workload differs:

#### Configuration

|Block size    |Throughput/disk |
|--------------|----------------|
|2 MB          |2 MB/s          |
|64 KB         |2 MB/s          |
|8 KB          |1 MB/s          |
|8 KB          |2 MB/s          |

#### Result

|Number of disks supported|Total throughput|Total OPS|Bottleneck                         |
|-------------------------|----------------|---------|-----------------------------------|
|68                       |136 MB/s        |68       |storage                            |
|60                       |120 MB/s        |2048     |storage                            |
|28                       |28 MB/s         |3584     |Azure Site Recovery CPU and memory   |
|16                       |32 MB/s         |4096     |                                   |

> [!NOTE]
> 8Kb is the smallest block size of data Azure Site Recovery supports. Any changes less than 8Kb are treated as 8Kb.

To test further, we generated a consistent type of workload; for example, consistent storage changes in blocks of 8 Kb that total up to 1 MB/s per disk. This scenario isn't likely in a real workload, given that changes can happen at various times of the day, or in spikes of various sizes.

To replicate these random patterns, we've also tested scenarios with:

- 120 VMs (80 Windows, 40 Linux) protected through the same Azure Site Recovery VM appliance.
    - Each VM generating at random intervals, at least twice per hour, random blocks totaling 5 Gb of data across five files.
    - Replication succeeded across all 120 VMs with a low-to-medium load on the Azure Site Recovery services.

    > [!NOTE]
    > These numbers should be used as a baseline only. They don't necessarily scale linearly. Adding another batch of the same number of VMs might have less impact than the initial one. The results are highly dependent on the type of workloads used.

## How should you plan and test

Applications and solution workloads have certain recovery time objective (RTO) and recovery point objective (RPO) requirements. Effective business continuity and disaster recovery (BCDR) design takes advantage of both the platform-level capabilities that meet these requirements, as we use the solution specific mechanisms. To design BCDR capabilities, capture platform disaster recovery (DR) requirements and consider all these factors in your design:

- Application and data availability requirements:
    - RTO and RPO requirements for each workload.
    - Support for active-active and active-passive availability patterns.

- Support for multi-region deployments for failover, with component proximity for performance. You may experience application operations with reduced functionality or degraded performance during an outage.

    > [!NOTE]
    > The application might know natively to run on, or have certain components that are able to run across multiple Azure Stack Hub environments. In that case, you can use Azure Site Recovery to replicate only the VMs with the components that don't have this functionality; for example, a front-end or back-end type solution, in which you can deploy the front-ends across Azure Stack Hub environments.

- Avoid using overlapping IP address ranges in production and DR networks.
    - Production and DR networks that have overlapping IP addresses require a failover process that can complicate and delay application failover. When possible, plan for a BCDR network architecture that provides concurrent connectivity to all sites.

- Sizing your target environments:
    - If you're using the source and target in a 1:1 manner, allocate slightly more storage on your target environment. This is due to the way the history of the disks bookmarks happen. This allocation isn't a 2x increase, since it only includes changes to the data. Depending on the type of data and the changes expected, and replication policies having a 1.5x to 2x more storage on the target ensure that failover processes introduce no concerns.
    - You might consider having the target Azure Stack Hub environment as the target for multiple source Azure Stack Hub sources. In this case, you're lowering the overall cost, but must plan for what happens when certain workloads go down; for example, which source must be prioritized.
    - If your target environment is used for running other workloads, the BCDR plan must include the behavior of these workloads. For example, you can run the Dev/Test VMs on the target environment, and if an issue occurs with your source environment, you can turn off all the VMs on the target to ensure sufficient resources are available to start the protected VMs.

The BCDR should be tested and validated regularly. You can do this by using test failover processes, or by moving the entire workloads to validate the flows end-to-end.
