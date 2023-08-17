--- 
title: Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate 
description: Learn prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/17/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the prerequisite tasks you need to complete before you begin the process to migrate Hyper-V VMs to Azure Stack HCI.

Make sure to [review the requirements](migrate-hyperv-prerequisites.md) for migration if you haven't already.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

The following list contains the prerequisites that must be met to migrate Hyper-V VMs to Azure Stack HCI. Some prerequisites apply to the source Hyper-V server, some to the target Azure Stack HCI cluster, and others to both.

|Prerequisite|Applies to|More information|
|--|--|--|
|Open required firewall ports.|both|[Port access](/azure/migrate/migrate-support-matrix-hyper-v#port-access).<br>[URL access](/azure/migrate/migrate-appliance#url-access).|
|Configure SAN policy on Windows VMs.|source|[Configure SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy).|
|Deploy, configure and register an Azure Stack HCI cluster.|target|[Register a cluster](../deploy/deployment-quickstart.md).|
|Configure Arc Resource Bridge and create a custom location on one of the nodes of the Azure HCI cluster.|target|[Azure Arc VM management prerequisites](../manage/azure-arc-vm-management-prerequisites.md).<br>[Set up Azure Arc VM management using command line](../manage/deploy-arc-resource-bridge-using-command-line.md?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2).|
|Create storage path(s) for the Arc Resource Bridge for storing VM configuration and OS disks.|target| [az azurestackhci storagepath create](/cli/azure/azurestackhci/storagepath) command.|
|Enable contributor and user administrator access on the subscription for the Azure Migrate project.|both|[Steps to assign an Azure role](/azure/role-based-access-control/role-assignments-steps).|
|Create an Azure Migrate project|both|[Create Azure migrate project](#create-an-azure-migrate-project).|
|Create a storage account|both|[Create storage account](#create-a-storage-account).|

## Before you begin

Before you migrate, create an Azure Migrate project and associated storage account in Azure portal. Azure portal doesn't store or transfer data between the source and target.

### Create an Azure Migrate project

Azure Migrate is an Azure feature that you can access from the Azure portal.

1. On the Azure portal home page, select **Azure Migrate**.

1. On the **Get started** page, under **Servers, databases and web apps**, select **Discover, assess and migrate**.

    :::image type="content" source="media/project-get-started.png" alt-text="Screenshot of Get started page in Azure portal." lightbox="media/project-get-started.png":::

1. On the **Servers, databases and web apps** page, select **Create project**.

1. On the **Create project** page:
    1. enter your subscription.
    1. Enter the resource group, or select it if pre-existing.
    1. Enter the new project name.
    1. Select a geography region.

    :::image type="content" source="media/project-create.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/project-create.png":::

1. When finished, select **Create**.

### Create a storage account

After the Azure Migrate project is created, you create a storage account for it.

1. On the Azure portal home page, select **Storage accounts**.

1. On the **Storage accounts** page, select **Create**.

1. On the **Basics** tab, under **Project details**, select the same subscription and resource group that you used to create the Azure Migrate project. If needed, select **Create new** to create a new resource group.

1. Under **Instance details**, follow these steps:
    1. Enter a name for the storage account.
    1. Select a geographical region.
    1. Choose either **Standard** or **Premium** performance.
    1. Select a redundancy level.
    
    :::image type="content" source="media/tab-basics.png" alt-text="Screenshot of Basic tab page in Azure portal." lightbox="media/tab-basics.png":::

1. When done, select **Review**.

    > [!NOTE]
    > Only fields on the **Basics** tab need to be filled out or altered. You can ignore the remaining tabs (and options therein) as the default options and values displayed on those tabs are recommended and are used.

1. Review all information on the **Review** tab of the **Create a storage account** page. If everything looks good, select **Create**.

    :::image type="content" source="media/tab-review.png" alt-text="Screenshot of Review tab page in Azure portal." lightbox="media/tab-review.png":::

1. The project template deployment will begin. When deployment is complete, select **Go to resource**.

    :::image type="content" source="media/deployment-complete.png" alt-text="Screenshot of deployment complete status display." lightbox="media/deployment-complete.png":::

1. On the resource group page, under **Resources**, verify there is a resource listed for each of the following:

    - Azure Migrate project resource
    - Azure Migrate project storage account resource
    - Azure Stack HCI cluster resource
    - Arc Resource Bridge resource
    - Custom location resource
    - Storage path resource(s)

    :::image type="content" source="media/project-resources.png" alt-text="Screenshot Resources list." lightbox="media/project-resources.png":::

## Next steps

- [Discover the source appliance](migrate-hyperv-prerequisites.md).
