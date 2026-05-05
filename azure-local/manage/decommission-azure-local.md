---
title: Decommission Azure Local
description: Learn how to decommission Azure Local.
ms.topic: how-to
author: sipastak
ms.author: sipastak
ms.date: 05/04/2026
ms.service: azure-local
ms.subservice: hyperconverged
---

# Decommission Azure Local

This article explains how to decommission your Azure Local system.

Every Azure Local instance creates a set of resource objects in Azure during the deployment process. If you no longer need to use your Azure Local instance and decide to decommission the system, you can follow the steps to clean up the resources created during deployment. This process also applies to the scenario when you need to redeploy an Azure Local instance.

## Azure Local resources

The following table lists the Azure resources that must be cleaned up within the Azure portal:

|Number of resources  |Resource type  |
|---------|---------|
|1 per machine<sup>1</sup>  | Machine - Azure Arc  |
|1 |Azure Local |
|1 |Arc resource bridge |
|1<sup>2</sup> |Key vault |
|1 |Custom location |
|2<sup>3</sup> |Storage account |
|1 per workload volume |Azure Local storage path - Azure Arc |

<sup>1</sup> Cleaning up the Machine – Azure Arc resources for the individual nodes of the system is optional if you need to redeploy an Azure Local instance. To disconnect a machine from Azure Arc and delete the corresponding Azure resource, see [Manage and maintain the Azure Connected Machine agent - Azure Arc](/azure/azure-arc/servers/manage-agent?tabs=windows#step-2-disconnect-the-server-from-azure-arc).

<sup>2</sup> Delete only if you're using a dedicated key vault associated with your Azure Local deployment. If you're using a key vault shared with other Azure Local instances, don't delete the key vault as it affects the other instances.

<sup>3</sup> One storage account is created for cloud witness and one for key vault audit logs. Cloud witness is required for a 2-node deployment and optional for other cases.

> [!NOTE]
> In case the instance was deployed in a dedicated Azure resource group, the entire resource group should be deleted.

## Prerequisites

By default, there are **DoNotDelete** locks configured for the Azure resources created during Azure Local deployment. You must remove the **DoNotDelete** locks first before you delete these resources.

1. Open a web browser and navigate to the [Azure portal](https://portal.azure.com/).  In the Azure portal, search for the resource group name and select it. Expand **Settings** and go to **Locks**.

1. Choose the resources and select **Delete** to remove the locks.  

    :::image type="content" source="media/decommission-azure-local/delete-locks.png" alt-text="Screenshot of the Azure portal showing where to delete locks." border="false" lightbox="media/decommission-azure-local/delete-locks.png":::

## Delete resources

1. Open the resource group in the Azure portal.

1. Select the resources to be deleted.

1. Select **Delete**.

1. Enter "delete" to confirm deletion in **Delete Resources**.

    :::image type="content" source="media/decommission-azure-local/delete-resources.png" alt-text="Screenshot of the Azure portal showing where to delete resources." border="false" lightbox="media/decommission-azure-local/delete-resources.png":::
