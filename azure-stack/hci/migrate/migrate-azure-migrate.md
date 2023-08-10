---
title: Migrate Hyper V VMs to Azure Stack HCI using Azure Migrate (preview)
description: Learn about how to to migrate Windows and Linux VMs to your Azure Stack HCI cluster using Azure Migrate  (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/10/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Migrate Hyper-V VMs to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to migrate the Hyper-V virtual machines (VMs) to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Before you begin

Before you migrate your VMs: 

- Make sure that you have replicated the VM on your Azure Stack HCI cluster. To replicate a VM, use the instructions in [Replicate Hyper-V VMs to Azure Stack HCI using Azure Migrate](../index.yml).
- If the replication is still in progress, wait for the replication to complete.


## Migrate VMs

1. In the Azure portal, go to your **Azure Migrate project > Servers, databases and webapps**.

1. On the **Migration tools** tile, select the number against **Azure Stack HCI** under **Replications**.

    :::image type="content" source="media/migrate-replicated-virtual-machine-1.png" alt-text="Screenshot Azure Migrate project > Server, databases and webapps in Azure portal.":::

1. On the **Azure Stack HCI migration > Replications** page, select **Refresh** and then view the replication progress. When the initial replication is complete, the VM **Migration status** changes to **Ready to migrate**.

    :::image type="content" source="media/migrate-replicated-virtual-machine-1a.png" alt-text="Screenshot Azure Migrate: Migration and modernization > Replications in Azure portal with migration status Ready to migrate.":::

1. From the top command bar, select **Migrate** to migrate multiple VMs that are ready.  

    :::image type="content" source="media/migrate-replicated-virtual-machine-2.png" alt-text="Screenshot Azure Migrate: Migration and modernization > Replications in Azure portal with Migrate option selected.":::

    Alternatively, you can select **Migrate** from the context menu for a single VM that is ready to migrate.

    :::image type="content" source="media/migrate-replicated-virtual-machine-3.png" alt-text="Screenshot of Migrate page in Azure portal with Migrate option selected from context menu.":::


1. On the **Migrate** page:
    1. Review the details of the VM(s) that you want to migrate.
    1. Select whether or not you would like to shut down VM(s) before migration. We recommend that you shut down VMs as that ensures no data is lost.
    1. Select **Migrate** to start the migration. A notification appears that the migration has started.

    :::image type="content" source="media/migrate-replicated-virtual-machine-3a.png" alt-text="Screenshot of Migrate page with context menu in Azure portal.":::
    
1. Refresh the page periodically to view the migration status. You can also select the migration status at any time to view the progress details. 

    :::image type="content" source="media/migrate-replicated-virtual-machine-3b.png" alt-text="Screenshot of Migrate page with migration status selected in Azure portal.":::

    The **Planned failover** blade indicates the various migration tasks in progress.
    :::image type="content" source="media/migrate-replicated-virtual-machine-3c.png" alt-text="Screenshot of PLanned failover for a VM in Azure portal.":::

    The migration status changes from **Migration in progress** to **Completed** when the migration is complete.

    :::image type="content" source="media/migrate-replicated-virtual-machine-4.png" alt-text="Screenshot of Migrate page with Migration status as completed in Azure portal.":::

Once the migration is complete, the VMs are running on your Azure Stack HCI cluster. You can view the VMs in the Azure portal.

 
## Verify migration

1. In the Azure portal, go to your **Azure Stack HCI resource > Virtual machines**.
1. In the list of VMs in the right-pane, verify that the VMs that you migrated are present.

    :::image type="content" source="media/verify-migrated-virtual-machine-1.png" alt-text="Screenshot of Azure Stack HCI > Virtual machines in Azure portal.":::

1. Select a VM to view its details. Verify that the VM:
    1. The VM is running. The corresponding source VM in the Hyper-V server is turned off.
    1. The VM has the same disk and network configuration as the source VM. 
    1. The VM behaves as expected.
    1. Your applications work as expected.

    :::image type="content" source="media/verify-migrated-virtual-machine-2.png" alt-text="Screenshot of migrated VM details in Azure portal.":::

1. Sign into the VM. Verify that the VM is running as expected.

1. In the Azure portal, select the ellipses ... next to the VM and select **Complete migration**. 

    :::image type="content" source="media/complete-migration-virtual-machine-1.png" alt-text="Screenshot of Replications view with complete migration selected from the context menu in Azure portal.":::

    Alternatively, select the VM name. 

    :::image type="content" source="media/complete-migration-virtual-machine-2.png" alt-text="Screenshot of Replications view with a VM selected in Azure portal.":::

    From the top command bar, select **Complete migration**. When prompted for confirmation, select **Yes** to continue. Repeat this action for all the migrated VMs.

    :::image type="content" source="media/complete-migration-virtual-machine-3.png" alt-text="Screenshot of confirmation to complete migration in Azure portal.":::

    This action starts a deletion job that you can track from the **Jobs** page.

    :::image type="content" source="media/complete-migration-virtual-machine-4.png" alt-text="Screenshot of Jobs page with deletion job selected in Azure portal.":::

    After the migrate resource is deleted, it is also removed it from the **Replications** view. You'll see the migrated VM disappear from the list of the VMs. 

    :::image type="content" source="media/complete-migration-virtual-machine-5.png" alt-text="Screenshot of Replications page with VM not showing in the list in Azure portal.":::

1. After the migration is complete, delete the source VM from Hyper-V server.
    1. In the Hyper-V manager, select the source VM that you migrated.
    1. Verify that the VM is turned off.
    1. Right-click and from the context menu, select **Delete...**. This action should delete the source VM.

    :::image type="content" source="media/delete-source-virtual-machine-hyperv-manager-1.png" alt-text="Screenshot of source VM in Hyper V Manager with delete selected from the context menu.":::
    
    Alternatively, you can use PowerShell to delete the VM. For more information, see, [Delete VM from Hyper-V server](/powershell/module/hyper-v/remove-vm?view=windowsserver2022-ps&preserve-view=true).

1. The last step is to delete the VM from the Failover Cluster Manager.
    1. In the Failover Cluster Manager, connect to the Hyper-V cluster and go to **Roles**.
    1. Select the VM that you migrated. Verify that the VM is turned off.
    1. Right-click and from the context menu, select **Remove**. When prompted for confirmation, select **Yes** to continue. This action should delete the VM from the Failover Cluster Manager.


## Next steps

- [Review the prerequisites](../index.yml) for Hyper-V VM migration to Azure Stack HCI.
