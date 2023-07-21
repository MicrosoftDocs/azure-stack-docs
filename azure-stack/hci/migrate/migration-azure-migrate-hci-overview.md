---
title: User Azure Migrate to move Hyper-V VMs to Azure Stack HCI (preview)
description: Learn about how to use Azure Migrate to migrate Windows and Linux VMs to your Azure Stack HCI cluster (preview).
author: alkohli
ms.topic: overview
ms.date: 07/21/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Overview Azure Migrate based migration for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

Azure Migration is a simplified, unified platform that is used to assess, migrate and modernize your on-premises VM workloads. You can use Azure Migrate to move your on-premises Hyper-V VMs to your Azure Stack HCI cluster.

This article describes a brief overview of the Azure Migrate solution used to migrate Hyper-V VMs to your Azure Stack Cluster including the benefits and the workflow of the solution.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Benefits

Using Azure Migrate to move your Hyper-V VMs to Azure Stack HCI offers the following benefits:

- This solution works with both Hyper-V and VMware VM. In this release, only the Hyper-V solution is made available.
- This solution results in a minimal downtime for the VM-based applications running on your on-premises servers.
- This solution keeps the application data on-premises only. The control plane is via the Azure and Azure portal can be used to start, run, and track your migration to Azure.


## Workflow

In the traditional Azure Migrate model, the data flows from on-premises to Azure. In this solution, the traditional model was modified so that the VMs and their related data remains on-premises.

The following diagram shows the workflow of the solution:



The solution has the following high-level steps:

1. **Prepare** - Review and complete the migration prerequisites. Deploy, configure and register your Azure Stack HCI cluster. This cluster will be the migration target. Create an Azure Migrate project in Azure.

    For more information, see [Review prerequisites for Azure Migrate]().

1. **Discover** - Create and configure an Azure Migrate appliance. Use this appliance to discover and assess your on-premises source Hyper-V servers.

    For more information, see [Discover Hyper-V VMs]().

1. **Replicate** - Create and configure the target appliance on your Azure Stack HCI. Select and replicate the VMs that were discovered in the previous step.

    For more information, see [Replicate Hyper-V VMs]().

1. **Migrate** - Once the replication is complete, select and migrate VMs to your Azure Stack HCI.

    For more information, see [Migrate Hyper-V VMs]().

1. **Verify** - After the migration is complete, verify that the VMs have booted successfully and the data has migrated properly. You can now pause the replication and decommission the source VMs.

    For more information, see [Verify Hyper-V VMs]().

If needed, [troubleshoot migration issues]().

## Next steps

- [Review the prerequisites](migrate-hyper-v-prerequisites.md) for Hyper-V VM migration to Azure Stack HCI.
