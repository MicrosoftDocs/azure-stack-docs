---
title: Migrate Hyper V VMs to Azure Stack HCI using Azure Migrate (preview)
description: Learn about how to to migrate Windows and Linux VMs to your Azure Stack HCI cluster using Azure Migrate  (preview).
author: alkohli
ms.topic: how-to
ms.date: 07/19/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
ms.custom: linux-related-content
---

# Migrate Hyper-V VMs to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to migrate the Hyper-V virtual machines (VMs) to Azure Stack HCI using Azure Migrate and includes the steps to verify the migration.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Before you begin

Before you migrate your VMs:

- Make sure that you have replicated the VM on your Azure Stack HCI cluster. To replicate a VM, use the instructions in [Replicate Hyper-V VMs to Azure Stack HCI using Azure Migrate](migrate-hyperv-replicate.md).
- Make sure the replication has completed and the migration status is **Ready to migrate**.


## Migrate VMs

1. In the Azure portal, go to your **Azure Migrate project > Servers, databases and web apps**.

1. On the **Migration tools** tile, select **Overview**.

    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-1.png" alt-text="Screenshot Azure Migrate project > Server, databases and webapps in Azure portal." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-1.png":::

1. Go to **Azure Stack HCI migration > Replications**.

    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-11.png" alt-text="Screenshot showing Azure Stack HCI migration > Replications in Azure portal." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-11.png":::

1. From the top command bar of the **Replications** page, select **Migrate** to migrate multiple VMs that are ready.  

    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-2.png" alt-text="Screenshot Azure Migrate: Migration and modernization > Replications in Azure portal with Migrate option selected." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-2.png":::

    Alternatively, you can select **Migrate** from the context menu for a single VM that is ready to migrate.

    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-3.png" alt-text="Screenshot of Migrate page in Azure portal with Migrate option selected from context menu." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-3.png":::


1. On the **Migrate** page:
    1. Review the details of the VM(s) that you want to migrate.
    1. Select whether or not you would like to shut down VM(s) before migration. We recommend that you shut down VMs as that ensures no data is lost.
    1. Select **Migrate** to start the migration. A notification appears that the migration has started.

    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-3a.png" alt-text="Screenshot of Migrate page with context menu in Azure portal." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-3a.png":::
    
1. Refresh the page periodically to view the migration status. You can also select the migration status at any time to view the progress details. 

    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-3b.png" alt-text="Screenshot of Migrate page with migration status selected in Azure portal." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-3b.png":::

    The **Planned failover** blade indicates the various migration tasks in progress.
    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-3c.png" alt-text="Screenshot of Planned failover for a VM in Azure portal." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-3c.png":::

    The migration status changes from **Migration in progress** to **Completed** when the migration is complete.

    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-4.png" alt-text="Screenshot of Migrate page with Migration status as completed in Azure portal." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-4.png":::

Once the migration is complete, the VMs are running on your Azure Stack HCI cluster. You can view the VMs in the Azure portal.

 
## Verify migration

1. In the Azure portal, go to your **Azure Stack HCI cluster resource > Virtual machines**.
1. In the list of VMs in the right-pane, verify that the VMs that you migrated are present.

    :::image type="content" source="./media/migrate-azure-migrate/verify-migrated-virtual-machine-1.png" alt-text="Screenshot of Azure Stack HCI > Virtual machines in Azure portal." lightbox="./media/migrate-azure-migrate/verify-migrated-virtual-machine-1.png":::

1. Select a VM to view its details. Verify that:
    1. The VM is running. The corresponding source VM in the Hyper-V server is turned off.
    1. The VM has the disk and network configuration as configured during replication.
  
    :::image type="content" source="./media/migrate-azure-migrate/verify-migrated-virtual-machine-2.png" alt-text="Screenshot of migrated VM details in Azure portal." lightbox="./media/migrate-azure-migrate/verify-migrated-virtual-machine-2.png":::

1. Sign into the VM using Hyper-V VMConnect. Verify that:
    1. The VM behaves as expected.
    1. Your applications work as expected.

1. In the Azure portal, select the ellipses ... next to the VM and select **Complete migration**.

    :::image type="content" source="./media/migrate-azure-migrate/complete-migration-virtual-machine-1.png" alt-text="Screenshot of Replications view with complete migration selected from the context menu in Azure portal." lightbox="./media/migrate-azure-migrate/complete-migration-virtual-machine-1.png":::

    Alternatively, select the VM name.

    :::image type="content" source="./media/migrate-azure-migrate/complete-migration-virtual-machine-2.png" alt-text="Screenshot of Replications view with a VM selected in Azure portal."lightbox="./media/migrate-azure-migrate/complete-migration-virtual-machine-2.png":::

    From the top command bar, select **Complete migration**. When prompted for confirmation, select **Yes** to continue. Repeat this action for all the migrated VMs.

    :::image type="content" source="./media/migrate-azure-migrate/complete-migration-virtual-machine-3.png" alt-text="Screenshot of confirmation to complete migration in Azure portal."lightbox="./media/migrate-azure-migrate/complete-migration-virtual-machine-3.png":::

    This action starts the **Delete protected item** job that you can track from the **Jobs** page. This job will only clean up the replication by deleting the delete protected item job - this will not affect your migrated VM.  
    
    :::image type="content" source="./media/migrate-azure-migrate/complete-migration-virtual-machine-4.png" alt-text="Screenshot of Jobs page with deletion job selected in Azure portal."lightbox="./media/migrate-azure-migrate/complete-migration-virtual-machine-4.png":::

    After the migrate resource is deleted, it is also removed from the **Replications** view. You'll also see the migrated VM job disappear from the **Replications** view.

    :::image type="content" source="./media/migrate-azure-migrate/complete-migration-virtual-machine-5.png" alt-text="Screenshot of Replications page with VM not showing in the list in Azure portal."lightbox="./media/migrate-azure-migrate/complete-migration-virtual-machine-5.png":::

## Clean up

Once you have verified that migration is complete and no more servers need to be migrated, the last step is to clean up. Cleanup requires deletion of the following resources created during migration:

- Source VMs and the associated VM disks from the Hyper-V server and the Failover Cluster Manager.
- Source and target appliance VMs.


## Next steps

- If you experience any issues during migration, see [Troubleshoot migration issues](./migrate-troubleshoot.md).
