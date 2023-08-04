--- 
title: Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate 
description: Learn prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/04/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the prerequisite tasks you need to complete before you proceed to migrate Hyper-V VMs to Azure Stack HCI.

You can use the Azure Migrate platform to move on-premises Hyper-V VMs to your Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

The following list the prerequisites that must be met to migrate Hyper-V VMs to Azure Stack HCI. Some prerequisites apply to the source Hyper-V server, some to the target Azure Stack HCI cluster, and others to both.

|Prerequisite|Applies to|Resource|
|--|--|--|
|Open required firewall ports.|both|[Port access](/azure/migrate/migrate-support-matrix-hyper-v#port-access).<br>[URL access](/azure/migrate/migrate-appliance#url-access).|
|Configure SAN policy on Windows VMs.|source|[Configure SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy).|
|Deploy, configure and register a Azure Stack HCI cluster.|target|[Register a cluster](/deploy/deployment-quickstart.md).|
|Configure Arc Resource Bridge and create a custom location on one of the nodes of the Azure HCI cluster.|target|[Azure Arc VM management prerequisites](/manage/azure-arc-vm-management-prerequisites).<br>[Set up Azure Arc VM management using command line](/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2).|
|Create storage path(s) for the Arc Resource Bridge for storing VM configuration and OS disks.|target| [az azurestackhci storagepath create](/cli/azure/azurestackhci/storagepath) command.|

In addition, an Azure Migrate project and storage account are created, as described below.

## Before you begin

Before the migration process takes place, an Azure Migrate project and associated storage account must be created in Azure portal. No on-premises data is stored or transferred between the source and target via Azure portal.

### Create an Azure Migrate project

Azure Migrate is an Azure feature that you can access from the Azure portal.

1. Go to the [Azure portal](https://aka.ms/HCIMigratePP) and select **Azure Migrate**.

    :::image type="content" source="media/project-get-started.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/project-get-started.png":::

1. Select **Servers, databases and web apps** to create a new Azure Migrate project.

    :::image type="content" source="media/project-assessment-tools.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/project-assessment-tools.png":::

1. On the **Create project** page, enter your subscription and resource group, or select them if pre-existing.

    :::image type="content" source="media/project-create.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/project-create.png":::

1. Enter the new project name and select a geography region in the selector field.

1. Select **Create**.

### Create a storage account

After the Azure Migrate project is created, you create a storage account for it.

> [!NOTE]
> Only fields on the **Basics** tab need to be filled out or altered. You can ignore the remaining tabs (and options therein) as the default options and values displayed on those tabs are used.

1. Select **Storage accounts**.

1. On the **Storage accounts** page, select **Create**.

    :::image type="content" source="media/tab-basics.png" alt-text="Screenshot of Basic tab page in Azure portal." lightbox="media/tab-basics.png":::

1. On the **Basics** tab, under **Project details**, select the same subscription and resource group that you used to create the Azure Migrate project. If needed,select **Create new** to create a new resource group.

1. Under **Instance details**, follow these steps:
    1. Enter a name for the storage account.
    1. Select a geographical region.
    1. Choose either **Standard** or **Premium** performance.
    1. Select a redundancy level.

1. When done, select **Review**.

1. Review all information on the **Review** tab of the **Create a storage account** page. If everything looks good, select **Create**.

    :::image type="content" source="media/tab-review.png" alt-text="Screenshot of Review tab page in Azure portal." lightbox="media/tab-review.png":::

1. The project template deployment will begin to your selected resource group. When deployment is complete, select **Go to resource**.

    :::image type="content" source="media/deployment-complete.png" alt-text="Screenshot of Review tab page in Azure portal." lightbox="media/deployment-complete.png":::

1. On the resource group page, under **Resources**, verify there is a resource listed for each of the following:

- Azure Migrate project resource
- Azure Migrate project storage account resource
- Azure Stack HCI cluster resource
- Arc Resource Bridge resource
- Custom location resource
- Storage path resource(s)

:::image type="content" source="media/project-resources.png" alt-text="Screenshot of all project resources Azure portal." lightbox="media/project-resources.png":::

## Next steps

- [Discover source appliance](migrate-hyperv-prerequisites.md).
