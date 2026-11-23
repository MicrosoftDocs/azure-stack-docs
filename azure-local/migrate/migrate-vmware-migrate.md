---
title: Migrate VMware VMs to Azure Local using Azure Catalyst
description: Learn about how to migrate VMware VMs to your Azure Local instance using Azure Catalyst.
author: scompton1045
ms.topic: how-to
ms.date: 11/13/2026
ms.author: scompton
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
---

# Migrate VMware VMs to Azure Local using Azure Catalyst

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article describes how to migrate the VMware virtual machines (VMs) to Azure Local using Azure Catalyst. It also includes the steps to verify the migration.

## Before you begin

Before you migrate your VMware VMs:

- Replicate the VMware VMs on your Azure Local instance. To replicate a VM, use the instructions in [Replicate VMware VMs to Azure Local using Azure Catalyst](migrate-vmware-replicate.md).
- Ensure the replication is complete and the migration status is **Ready to migrate**.


## Migrate VMware VMs

1. In the Azure portal, go to your project and select **Server replication**.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-11.png" alt-text="Screenshot of the Server replication page for a project in the Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-11.png":::

1. From the command bar, select **Migrate** to migrate multiple VMs that are ready.  

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-2.png" alt-text="Screenshot of the Server replication page with Migrate highlighted on the command bar." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-2.png":::

    Alternatively, select **Ready to migrate** for a single VM, or select **...** next to the VM and then select **Migrate**.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3.png" alt-text="Screenshot of the Server replication page with Migrate selected from the context menu for a VM." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3.png":::


1. On the **Migrate** page:
    1. Review the details of the VMs that you want to migrate.
    1. Select whether or not you would like to shut down VMs before migration. We recommend that you shut down VMs as that ensures no data is lost.
    1. Select **Migrate** to start the migration. A notification appears that the migration has started.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-a.png" alt-text="Screenshot of Migrate page with context menu in Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-a.png":::
    
1. Refresh the page periodically to view the migration status. You can also select the migration status at any time to view the progress details.

    The **Planned failover** blade indicates the various migration tasks in progress.
    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-c.png" alt-text="Screenshot of Planned failover for a VM in Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-c.png":::

    The migration status changes from **Migration in progress** to **Completed** when the migration is complete.

Once the migration is complete, the VMs are running on your Azure Local instance. You can view the VMs in the Azure portal.

## Verify and complete migration

> [!IMPORTANT]
> After verifying the status of the migrated VM, be sure to **complete migration** as detailed below. Don't manually delete the seed disks or other replication artifacts. Failing to complete migration or deleting these artifacts can cause unexpected behavior.

1. In the Azure portal, go to your Azure Local resource, then select **Virtual machines**.
1. In the list of VMs in the right-pane, verify that the VMware VMs that you migrated are present.

    :::image type="content" source="./media/migrate-vmware-migrate/verify-migrated-virtual-machine-1.png" alt-text="Screenshot of Azure Local > Virtual machines in Azure portal." lightbox="./media/migrate-vmware-migrate/verify-migrated-virtual-machine-1.png":::

1. Select a VM to view its details. Verify that:
    1. The VM is running. The corresponding source VM on the source ESX server is turned off.
    1. The VM has the disk and network configuration as configured during replication.
  
    :::image type="content" source="./media/migrate-vmware-migrate/verify-migrated-virtual-machine-2-a.png" alt-text="Screenshot of migrated VM details in Azure portal." lightbox="./media/migrate-vmware-migrate/verify-migrated-virtual-machine-2-a.png":::

1. Sign into the VM using Hyper-V VMConnect. Verify that:
    1. The VM behaves as expected.
    1. Your applications work as expected.

1. In the Azure portal, go to your project and select **Server replication**. Select **...** next to the VM, and then select **Complete migration**.

    Alternatively, select the VM name.

    :::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-2.png" alt-text="Screenshot of Replications view with a VM selected in Azure portal."lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-2.png":::

    From the top command bar, select **Complete migration**. When prompted for confirmation, select **Yes** to continue. 

    :::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-3.png" alt-text="Screenshot of confirmation to complete migration in Azure portal."lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-3.png":::

    Repeat this action for all the migrated VMs.

    The **Complete migration** action starts the **Delete protected item** job, which you can track on the **Jobs** page of your project. This job removes the replication state and service-managed replication artifacts without affecting the migrated VM.
    
    :::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-4.png" alt-text="Screenshot of the Jobs page with a Delete protected item job highlighted." lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-4.png":::

    A seed disk is a temporary disk that contains the replicated source data used to create the final migrated disk. As part of its cleanup, the standard **Complete migration** operation deletes seed disks and other replication artifacts, such as a seed ISO attached to the migrated VM. If you don't complete migration, these artifacts remain on the target system and continue to use storage.

    After the migrated resource is deleted, it's also removed from the **Server replication** view. The source VM is no longer protected, and you can enable replication again for the same source VM if needed.

## Clean up

Once you have verified that migration is complete and no more machines need to be migrated, the last step is to clean up. Cleanup requires deletion of the following resources created during migration:

- Source VMs and the associated VM disks from VMware vCenter.
- Source VMware appliance and target Azure Local appliance VMs.


## Enable guest management

After migrating a VM, you might want to enable guest management on that VM. For more information, see [Enable guest management](../manage/manage-arc-virtual-machines.md#enable-guest-management).

You can enable guest management only on Windows Server 2016 or later, and on Linux guests with Linux Integration Services. For more information, see [Supported Guest OS](/windows-server/virtualization/hyper-v/make-integration-service#supported-guest-os).


## Next steps

- If you experience any issues during migration, see [Troubleshoot VMware migration issues](./migrate-troubleshoot.md).
