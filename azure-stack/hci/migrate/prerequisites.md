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

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes the prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate.

## Before you begin

Complete the following tasks before you proceed with migration:

1. Go to the [Azure Preview Portal](https://aka.ms/HCIMigratePP).

1. Open Azure Migrate and create a new Azure Migrate project.

1. Create a storage account. Use the same Azure subscription and the resource group that you used for your Azure Migrate project.

1. Open required firewall ports following these articles:

    - [Port access](https://learn.microsoft.com/azure/migrate/migrate-support-matrix-hyper-v#port-access).
    - [URL access](https://learn.microsoft.com/azure/migrate/migrate-appliance#url-access).

1. Deploy, configure and [register a target Azure Stack HCI cluster](https://learn.microsoft.com/azure-stack/hci/deploy/deployment-quickstart).

1. [Configure SAN policy](https://learn.microsoft.com/azure/migrate/prepare-for-migration#configure-san-policy) on Windows VMs.

1. Configure Arc Resource Bridge and then create a custom location on one of the nodes of the target HCI cluster, following the instructions in these articles:

    a. [Azure Arc VM management prerequisites](https://learn.microsoft.com/en-us/azure-stack/hci/manage/azure-arc-vm-management-prerequisites).
    
    b. [Set up Azure Arc VM management using command line](https://learn.microsoft.com/azure-stack/hci/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2).
    
    c.  Create a storage path(s) for the Arc Resource Bridge for storing VM configuration and OS disks using [az azurestackhci storagepath create](https://learn.microsoft.com/en-us/cli/azure/azurestackhci/storagepath?view=azure-cli-latest#az-azurestackhci-storagepath-create).
    
    :::image type="content" source="../media/migrate/migrate-create-project.png" alt-text="Screenshot showing project creation." lightbox="../media/migrate/migrate-create-project.png":::

## Next steps

- Perform [Discovery](migrate.md).
