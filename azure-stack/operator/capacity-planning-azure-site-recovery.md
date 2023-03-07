---
title: Capacity Planning using Azure Site Recovery
description: Capacity planning uses Azure Stack Hub locations to keep data safe, apps available and workloads online during planned and unplanned outages.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: rtiberiu
ms.lastreviewed: 03/03/2023
ms.date: 03/03/2023
---

# Capacity planning using Azure Site Recovery

[!INCLUDE [applies-to](../../azure-stack/includes/hci-applies-to-22h2.md)]

As an organization, it's essential to adopt a business continuity and disaster recovery (BCDR) strategy. This strategy should keep your data safe, apps available, and workloads online during planned and unplanned outages.

Azure Site Recovery (ASR) on Azure Stack Hub helps ensure business continuity by keeping business apps and workloads running during outages. Azure Site Recovery on Azure Stack Hub replicates virtual machines (VMs) workloads from a primary site to a secondary location. When an outage occurs at your primary site, you fail over to a secondary location, and access apps from there. After the primary location is running again, you can fail back to it.

To enable replication of VMs across two Azure Stack Hub stamps, configure the following environments:

1. **Source** environment is the Azure Stack Hub stamp where tenant VMs are running.
2. **Target** environment is where the Azure Site Recovery Resource Provider and dependencies are running.

:::image type="content" source="../operator/media/azure-site-recovery/overview/source-and-target.png" alt-text="Example of replication of VMs across two Azure Stack Hub stamps.":::

Capacity planning is essential for the success of a business continuity and disaster recovery plan. In capacity planning, there are various factors that need to be considered:

- Recovery time objectives (RTO) and recovery point objectives (RPO) for the specific workloads that you want to protect.

- Workloads and the application characteristics.
    - How often the data changes within the respective VM
    - How much data is generated or removed
    - How the application design looks like and more.

- VM sizes, the number of disks, and how each VM is tied to other VMs.
    - For solutions that would require several VMs,    understand what order those VMs need to be started in and more.

- Network bandwidth between [source] and [target] environments. Note, this component could affect RPOs.

Each of these points is important and each has a broad implication when building a BCDR plan. The following sections list the main points to consider from an ASR perspective.

What's provided isn't a comprehensive list of things that need to be included in a BCDR plan. Each BCDR plan is different and is based on the specifics of the workloads you plan to protect.

## Source considerations

In the source environment, Azure Stack Hub runs the ASR VM Appliance. The VM is a Standard DS4_V2 (8 vCPUs, 28-Gb memory, 32 data disks) VM that is running in the Azure Stack Hub User subscription.

In the source environment, consider the following areas:

- Sufficient quota for creating the ASR VM Appliance. One or multiple depending on the overall plan.

- Storage for the ASR VM Appliance.

    - The ASR VM Appliance itself has the data requirements defined by its VM size.
    - When planning for capacity, make sure the Appliance VM has enough storage to exercise the failback and reprotect mechanisms.
    - If there are storage limitations, the failback and reprotect may fail with "An internal error occurred" message. Users should check the event logs on the appliance to confirm the actual Azure Resource Manager error. For more information, see Known issues.

- Bandwidth considerations

    - The initial replication generates high bandwidth usage.
    - Depending on the replication policies and each type of application, changes on each VM (deltas) are replicated.  

 

