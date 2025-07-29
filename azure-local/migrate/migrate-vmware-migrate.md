---
title: Migrate VMware VMs to Azure Local using Azure Migrate
description: Learn about how to to migrate VMware VMs to your Azure Local instance using Azure Migrate.
author: alkohli
ms.topic: how-to
ms.date: 10/31/2024
ms.author: alkohli
ms.reviewer: alkohli
---

# Migrate VMware VMs to Azure Local using Azure Migrate

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to migrate the VMware virtual machines (VMs) to Azure Local using Azure Migrate and includes the steps to verify the migration.

## Before you begin

Before you migrate your VMware VMs:

- Make sure that you have replicated the VMware VMs on your Azure Local instance. To replicate a VM, use the instructions in [Replicate VMware VMs to Azure Local using Azure Migrate](migrate-vmware-replicate.md).
- Make sure the replication has completed and the migration status is **Ready to replicate**.


## Migrate VMware VMs

1. In the Azure portal, go to your **Azure Migrate project > Servers, databases and web apps**.

1. On the **Migration tools** tile, select **Overview**.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-1.png" alt-text="Screenshot of Server, databases and webapps page in Azure Migrate in Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-1.png":::

1. Go to **Azure Local migration > Replications**.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-11.png" alt-text="Screenshot showing Replications in Azure Local migration in Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-11.png":::

1. From the top command bar of the **Replications** page, select **Migrate** to migrate multiple VMs that are ready.  

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-2.png" alt-text="Screenshot with Replications page in Azure portal with Migrate option selected." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-2.png":::

    Alternatively, you can select **Migrate** from the context menu for a single VM that is ready to migrate.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3.png" alt-text="Screenshot of Migrate page in Azure portal with Migrate option selected from context menu." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3.png":::


1. On the **Migrate** page:
    1. Review the details of the VMs that you want to migrate.
    1. Select whether or not you would like to shut down VMs before migration. We recommend that you shut down VMs as that ensures no data is lost.
    1. Select **Migrate** to start the migration. A notification appears that the migration has started.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-a.png" alt-text="Screenshot of Migrate page with context menu in Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-a.png":::
    
1. Refresh the page periodically to view the migration status. You can also select the migration status at any time to view the progress details.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-b.png" alt-text="Screenshot of Migrate page with migration status selected in Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-b.png":::

    The **Planned failover** blade indicates the various migration tasks in progress.
    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-c.png" alt-text="Screenshot of Planned failover for a VM in Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-3-c.png":::

    The migration status changes from **Migration in progress** to **Completed** when the migration is complete.

    :::image type="content" source="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-4.png" alt-text="Screenshot of Migrate page with Migration status as completed in Azure portal." lightbox="./media/migrate-vmware-migrate/migrate-replicated-virtual-machine-4.png":::

Once the migration is complete, the VMs are running on your Azure Local instance. You can view the VMs in the Azure portal.

## Verify and complete migration

> [!IMPORTANT]
> After verifying the status of the migrated VM, be sure to **complete migration** as detailed below. Failing to do so may lead to unexpected behavior.

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

1. In the Azure portal, select the ellipses ... next to the VM and select **Complete migration**.

    :::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-1.png" alt-text="Screenshot of Replications view with complete migration selected from the context menu in Azure portal." lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-1.png":::

    Alternatively, select the VM name.

    :::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-2.png" alt-text="Screenshot of Replications view with a VM selected in Azure portal."lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-2.png":::

    From the top command bar, select **Complete migration**. When prompted for confirmation, select **Yes** to continue. 

    :::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-3.png" alt-text="Screenshot of confirmation to complete migration in Azure portal."lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-3.png":::

    Repeat this action for all the migrated VMs.

    :::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-3-a.png" alt-text="Screenshot of multiple VMs completing migration in Azure portal."lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-3-a.png":::

    The **Complete migration** action starts the **Delete protected item** job that you can track from the  **Jobs**  page. This job will only clean up the replication by deleting the delete protected item job - this will not affect your migrated VM.  
    
   <!--:::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-4.png" alt-text="Screenshot of Jobs page with deletion job selected in Azure portal."lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-4.png":::-- old one-->

    Completing the migration or deleting the protected item will automatically remove any leftover seed files, such as the seed.iso file attached to the migrated VM and seed disks used during replication. These files can occupy significant space on the target Azure Local system, so it's important to finalize the migration after verifying the VMs. If migrations are not completed, these files will continue to occupy space on the target system.

    After the migrate resource is deleted, it is also removed from the **Replications** view. You'll also see the migrated VM job disappear from the **Replications** view.

    :::image type="content" source="./media/migrate-vmware-migrate/complete-migration-virtual-machine-5.png" alt-text="Screenshot of Replications page with VM not showing in the list in Azure portal."lightbox="./media/migrate-vmware-migrate/complete-migration-virtual-machine-5.png":::

## Clean up

Once you have verified that migration is complete and no more machines need to be migrated, the last step is to clean up. Cleanup requires deletion of the following resources created during migration:

- Source VMs and the associated VM disks from VMware vCenter.
- Source VMware appliance and target Azure Local appliance VMs.


## Enable guest management

After migrating a VM, you may want to enable guest management on that VM. For more information, see [Enable guest management](../manage/manage-arc-virtual-machines.md#enable-guest-management).

Enabling guest management is supported only on Windows Server 2016 or later, and on Linux guests with Linux Integration Services. For more information, see [Supported Guest OS](/virtualization/hyper-v-on-windows/user-guide/make-integration-service#supported-guest-os).


## Next steps

- If you experience any issues during migration, see [Troubleshoot VMware migration issues](./migrate-troubleshoot.md).
