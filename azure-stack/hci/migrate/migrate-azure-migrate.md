---
title: Migrate Hyper V VMs to Azure Stack HCI using Azure Migrate (preview)
description: Learn about how to to migrate Windows and Linux VMs to your Azure Stack HCI cluster using Azure Migrate  (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/08/2023
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

1. On the **Azure Stack HCI migration > Replications** page, select **Refresh** and then view the replication progress. You can migrate a VM when the **Migration status** is **Ready to migrate**.

    :::image type="content" source="media/migrate-replicated-virtual-machine-2.png" alt-text="Screenshot Azure Migrate: Migration and modernization > Replications in Azure portal.":::

1. From the top command bar, select **Migrate** to migrate all the VMs that are ready.  

    Alternatively, you can select **Migrate** from the context menu for a single VM that is ready to migrate.

    :::image type="content" source="media/migrate-replicated-virtual-machine-3.png" alt-text="Screenshot of Migrate page in Azure portal.":::


1. On the **Migrate** page:
    1. Review the details of the VM(s) that you want to migrate.
    1. Select whether or not you would like to shut down VM(s) before migration. We recommend that you shut down VMs as that ensures no data is lost.
    1. Select **Migrate** to start the migration. A notification appears that the migration has started.
    1. Refresh the page periodically to view the migration status. The migration status changes from **Migration in progress** to **Completed** when the migration is complete.

    :::image type="content" source="media/migrate-replicated-virtual-machine-4.png" alt-text="Screenshot of Migrate page with context menu in Azure portal.":::

Once the migration is complete, the VMs are running on your Azure Stack HCI cluster. You can view the VMs in the Azure portal.

 
## Verify migration

1. In the Azure portal, go to your **Azure Stack HCI resource > Virtual machines**.
1. In the list of VMs in the right-pane, verify that the VMs that you migrated are present.

    :::image type="content" source="media/verify-migrated-virtual-machine-1.png" alt-text="Screenshot of Azure Stack HCI > Virtual machines in Azure portal.":::

1. Select a VM to view its details. Verify that the VM:
    1. The VM is running.
    1. The VM has the same disk and network configuration as the source VM. 
    1. The VM behaves as expected.
    1. Your applications work as expected.

    :::image type="content" source="media/verify-migrated-virtual-machine-2.png" alt-text="Screenshot of Migrate page with context menu in Azure portal.":::

1. Sign into the VM. Verify that the VM is running as expected.

1. In the Azure portal, select the ellipses ... next to the VM and select **Complete migration**. Repeat this action for all the migrated VMs.

    :::image type="content" source="media/complete-migration-virtual-machine-1.png" alt-text="Screenshot of Migrate page with context menu in Azure portal.":::

    This action deletes the migrate resource and removes it from the **Replications** view.

1. Manually decommission the source VM by deleting it from Hyper-V and also Failover Cluster Manager


## Next steps

- [Review the prerequisites](../index.yml) for Hyper-V VM migration to Azure Stack HCI.
