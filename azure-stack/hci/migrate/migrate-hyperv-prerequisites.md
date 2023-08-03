--- 
title: Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate 
description: Learn prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/03/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the prerequisite tasks you need to complete before you proceed to migrate Hyper-V VMs to Azure Stack HCI.

You can use the Azure Migrate platform to move on-premises Hyper-V VMs to your Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## System requirements

You need to open ports, configure the target cluster, set SAN policy, configure the Arc Resource Bridge, and set up Azure Arc VM management as detailed below:

|Requirement|Resource|
|--|--|
|Open required firewall ports.|[Port access](/azure/migrate/migrate-support-matrix-hyper-v#port-access).<br>[URL access](/azure/migrate/migrate-appliance#url-access).|
|Deploy, configure and register a target Azure Stack HCI cluster.|[Register a cluster](/deploy/deployment-quickstart.md).|
|Configure SAN policy on Windows VMs.|[Configure SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy).|
|Configure Arc Resource Bridge and create a custom location on one of the nodes of the target HCI cluster.|[Azure Arc VM management prerequisites](/manage/azure-arc-vm-management-prerequisites).<br>[Set up Azure Arc VM management using command line](/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2).|
|Create storage path(s) for the Arc Resource Bridge for storing VM configuration and OS disks.|[az azurestackhci storagepath create](/cli/azure/azurestackhci/storagepath) command.|

## Create an Azure Migrate project

Azure Migrate is an Azure feature that you can access from the Azure portal.

1. Go to the [Azure portal](https://aka.ms/HCIMigratePP).

    :::image type="content" source="media/project-get-started.png" alt-text="Screenshot of Azure Migrate Get Started page." lightbox="media/project-get-started.png":::

1. In the Azure portal, select **Azure Migrate** and then select **Servers, databases and web apps** to create a new Azure Migrate project.

    :::image type="content" source="media/project-assessment-tools.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/project-assessment-tools.png":::

1. On the **Create project** page, enter your subscription and resource group, or select them if pre-existing.

    :::image type="content" source="media/project-create.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/project-create.png":::

1. Enter the new project name and select a geography region in the selector field.

1. Select **Create**.

## Create the storage account

After the project is created, you create a storage account for your Azure Migrate project.

1. Select **Storage accounts**.

1. On the **Storage accounts** page, select **Create**.

### Basic settings

Complete the following steps from the **Basics** tab of the **Create a storage account** page.

:::image type="content" source="media/tab-basics.png" alt-text="Screenshot of Basic tab page in Azure portal." lightbox="media/tab-basics.png":::

1. Under **Project details**, select the same subscription and resource group that you used to create the Azure Migrate project. If needed,select **Create new** to create a new resource group.

1. Under **Instance details**, follow these steps:
    1. Enter a name for the storage account.
    1. Select a region. You can deploy to an edge zone also.
    1. Choose either **Standard** or **Premium** performance.
    1. Select a redundancy level.

1. When finished, select **Review**.

1. If all looks good, select **Next: Advanced**.

### Advanced settings

Complete the following steps from the **Advanced** tab of the **Create a storage account** page.

:::image type="content" source="media/tab-advanced.png" alt-text="Screenshot of Advanced tab page in Azure portal." lightbox="media/tab-advanced.png":::

1. Under **Security**, follow these steps:

    1. Disable or enable settings as applicable to your storage account.
    1. Select the TLS version use from the dropdown.
    1. Select the scope for copy operations from the dropdown.

1. Under **Hierarchical Namespace**, enable this feature as needed.

1. When finished, select **Review**.

1. If all looks good, select **Next: Networking**.

### Networking settings

Complete the following steps from the **Networking** tab of the **Create a storage account** page.

:::image type="content" source="media/tab-networking.png" alt-text="Screenshot of Networking tab page in Azure portal." lightbox="media/tab-networking.png":::

1. Under **Network connectivity**, select the appropriate public access option for your environment.

1. Under **Network routing**, select a routing preference.

1. When finished, select **Review**.

1. If all looks good, select **Next: Data protection**.

### Data protection settings

Complete the following steps from the **Data protection** tab of the **Create a storage account** page.

:::image type="content" source="media/tab-data-protection.png" alt-text="Screenshot of Data Protection tab page in Azure portal." lightbox="media/tab-data-protection.png":::

1. Under **Recovery**, follow these steps as applicable to your environment:

    1. Enable point-in-time restore for containers.
    1. Enable soft delete for blobs.
    1. Enable soft delete for containers.
    1. Enable soft delete for file shares.

1. Under **Tracking**, enable versioning for blobs is applicable for your workloads.

1. When finished, select **Review**.

1. If all looks good, select **Next: Encryption**.

### Encryption settings

Complete the following steps from the **Encryption** tab of the **Create a storage account** page.

:::image type="content" source="media/tab-encryption.png" alt-text="Screenshot of Encryption tab page in Azure portal." lightbox="media/tab-encryption.png":::

1. When finished, select **Review**.

1. If all looks good, select **Next: Tags**.

### Tags settings

Complete the following steps from the **Tags** tab of the **Create a storage account** page.

:::image type="content" source="media/tab-tags.png" alt-text="Screenshot of Tags tab page in Azure portal." lightbox="media/tab-tags.png":::

1. Enter name/value pairs for each resource to categorize resources and groups as applicable. Repeat as needed.

1. When finished, select **Review**.

1. If all looks good, select **Next: Review**.

### Review settings

Review all settings on the **Review** tab of the **Create a storage account** page. If everything looks good, select **Create**.
:::image type="content" source="media/tab-review.png" alt-text="Screenshot of Review tab page in Azure portal." lightbox="media/tab-review.png":::

Project template deployment will begin to your selected resource group. When deployment is complete, select **Go to resource**.

:::image type="content" source="media/deployment-complete.png" alt-text="Screenshot of Review tab page in Azure portal." lightbox="media/deployment-complete.png":::

### Resource groups and properties

On the Resource Groups Overview page, under **Resources**, verify there is a resource listed for the migration project and a resource listed for the associated storage account.

:::image type="content" source="media/storage-resource-group.png" alt-text="Screenshot of the resource Group overview page in Azure portal." lightbox="media/storage-resource-group.png":::

1. Select the resource for the migration project.

    :::image type="content" source="media/storage-account-settings.png" alt-text="Screenshot of the storage account overview page in Azure portal." lightbox="media/storage-account-settings.png":::

1. Under **Properties**, verify that the following resources are listed:
    - Arc Resource Bridge resource
    - Azure Stack HCI resource
    - Custom location resource
    - Storage path resource(s)

## Next steps

- [Discover source appliance](migrate-hyperv-prerequisites.md).
