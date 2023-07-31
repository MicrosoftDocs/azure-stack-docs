--- 
title: Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate 
description: Learn prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 07/31/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-21h2.md)]

This article describes the prerequisite tasks you need to complete before you proceed to migrate Hyper-V VMs to Azure Stack HCI.

You can use the Azure Migrate platform to move on-premises Hyper-V VMs to your Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Create an Azure Migrate project

Azure Migrate is an Azure feature that you can access from the Azure portal.

:::image type="content" source="media/prereq-placeholder.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/prereq-placeholder.png":::

1. Go to the [Azure portal](https://aka.ms/HCIMigratePP).

1. In the Azure portal, select **Azure Migrate** and then select **Servers, databases and web apps** to create a new Azure Migrate project.

1. On the **Create project** page, enter your subscription and resource group, or select them if pre-existing.

1. Enter the new project name and select a region in the selector field.

1. Select **Create**.

1. After the project is successfully created, select **Storage accounts**.

1. On the **Storage accounts** page, select **Create**.

1. On the **Create a storage account** page, under **Project details**, select the same subscription and the resource group that you used to create the Azure Migrate project.

1. Under **Instance details**, follow these steps:
    1. Enter a name for the storage account.
    1. Select a region.
    1. Choose either **Standard** or **Premium** performance.
    1. Select a redundancy level.

1. When finished, select **Review**.

1. If all looks good, select **Create**.

1. After project deployment is complete, select **Resource groups**.

1. On the **Resource groups** page, select your new resource group.

1. Under the **Resources** list, verify that the following resources are listed:
    - Arc Resource Bridge resource
    - Azure Stack HCI resource
    - Custom location resource
    - Storage path resource(s)
    
You have now created a new project using Azure Migrate.

## Configure the infrastructure

Next, you need to open ports, configure the target cluster, set SAN policy, configure the Arc Resource Bridge, and set up Azure Arc VM management as detailed below:

1. Open required firewall ports, following the instructions in these articles:

    - [Port access](/azure/migrate/migrate-support-matrix-hyper-v#port-access).
    - [URL access](/azure/migrate/migrate-appliance#url-access).

1. Deploy, configure and [register a target Azure Stack HCI cluster](/deploy/deployment-quickstart.md).

1. [Configure SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy) on Windows VMs.

1. Configure Arc Resource Bridge and then create a custom location on one of the nodes of the target HCI cluster, following the instructions in these articles:

    a. [Azure Arc VM management prerequisites](/manage/azure-arc-vm-management-prerequisites).
    
    b. [Set up Azure Arc VM management using command line](/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2).
    
    c. Create a storage path(s) for the Arc Resource Bridge for storing VM configuration and OS disks using the [az azurestackhci storagepath create](/cli/azure/azurestackhci/storagepath) command.


## Next steps

- [Discover source appliance](migrate-hyperv-prerequisites.md).
