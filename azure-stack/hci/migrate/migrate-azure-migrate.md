---
title: Use Azure Migrate to move Hyper-V VMs to Azure Stack HCI (preview)
description: Learn about how to use Azure Migrate to migrate Windows and Linux VMs to your Azure Stack HCI cluster (preview).
author: alkohli
ms.topic: overview
ms.date: 07/28/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Overview of Azure Migrate based migration for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the migrate process for Hyper-V migration to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Before you begin

Before you migrate your VMs, make sure that you have satisfied all the requirements and [prerequisites](../index.yml).


## Migrate VMs

1. Go to the Azure portal. In the top search bar, search for and select **Azure Migrate**.
1. Select Server, databases and web apps. 
1. On the **Migration tools** tile, select the number against **Azure Stack HCI** under **Replications**. 
1. On the **Replications** page, select Refresh and then view the progress. 
1. Once a VM’s “Migration status” gets to “Ready to migrate” state, click to start the “Migration” or
1. Select “Migrate” option at the top of the page to start migrating multiple VMs in bulk
1. Select whether or not you would like to shutdown VMs before migration and click ‘Migrate’’ to start migration(s)
Once the migration is complete you will see a green checkmark and “Completed” in the replication monitoring view in Azure Migrate

The following diagram shows the workflow of the solution:

:::image type="content" source="media/azure-migrate-workflow-1.png" alt-text="Diagram that shows a high-level workflow for migration using Azure Migrate.":::


## Next steps

- [Review the prerequisites](../index.yml) for Hyper-V VM migration to Azure Stack HCI.
