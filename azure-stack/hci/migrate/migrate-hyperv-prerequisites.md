--- 
title: Prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 07/20/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the prerequisite tasks you need to complete before proceeding with Hyper-V migration to Azure Stack HCI.

You can use the Azure Migrate platform to move on-premises Hyper-V VMs to your Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Create a new project

You use Azure migrate to create a new migration project, associated storage account, and resources. Azure Migrate is a feature of Azure accessed from the Azure Preview Portal.

1. Go to the [Azure Preview Portal](https://aka.ms/HCIMigratePP).

1. In the Azure Preview Portal, select **Azure Migrate** abd then select **Servers, databases and web apps** to create a new Azure Migrate project.

1. On the **Create project** page, enter your subscription and resource group, or select them if pre-existing.

1. Enter the new project name and select a region in the selector field.

1. Select **Create**.

1. Once the project has been successfully created, select **Storage accounts**.

1. On the **Storage accounts** page, select **Create**.

1. On the **Create a storage account** page, under **Project details**, select the same subscription and the resource group that you used to create the Azure Migrate project.

1. Under **Instance details**, do the following:
    1. Enter a name for the storage account.
    1. Select a region.
    1. Choose either **Standard** or **Premium** performance.
    1. Select a redundancy level.

1. When finished, select **Review**.

1. If all looks good, select **Create**.

1. Once project deployment is complete, select **Resource groups**.

1. On the **Resource groups** page, select your new resource group.

1. Under the **Resources** list, verify that the following resources are listed:
    - Arc Resource Bridge resource
    - Azure Stack HCI resource
    - Custom location resource
    - Storage path resource(s)
    
You are now finished using Azure Migrate to create a new project.

## Configure the infrastructure

Next, you need to open ports, configure the target cluster, set SAN policy, configure the Arc Resource Bridge, and set up Azure Arc VM management as detailed below:

1. Open required firewall ports, following the instructions in these articles:

    - [Port access](/azure/migrate/migrate-support-matrix-hyper-v#port-access).
    - [URL access](/azure/migrate/migrate-appliance#url-access).

1. Deploy, configure and [register a target Azure Stack HCI cluster](/deploy/deployment-quickstart).

1. [Configure SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy) on Windows VMs.

1. Configure Arc Resource Bridge and then create a custom location on one of the nodes of the target HCI cluster, following the instructions in these articles:

    a. [Azure Arc VM management prerequisites](../manage/azure-arc-vm-management-prerequisites).
    
    b. [Set up Azure Arc VM management using command line](../hci/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2).
    
    c. Create a storage path(s) for the Arc Resource Bridge for storing VM configuration and OS disks using the [az azurestackhci storagepath create](/cli/azure/azurestackhci/storagepath?view=azure-cli-latest#az-azurestackhci-storagepath-create) command.


## Next steps

- Perform source appliance [discovery](migrate-hyperv-discover.md).
