--- 
title: Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate 
description: Learn prerequisites for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 09/05/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Prerequisites for Hyper-V VM migration to Azure Stack HCI using Azure Migrate

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the prerequisite tasks you need to complete before you begin the process to migrate Hyper-V virtual machines (VMs) to Azure Stack HCI.

Make sure to [review the requirements](migrate-hyperv-prerequisites.md) for migration if you haven't already.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

The following list contains the prerequisites that must be met to migrate Hyper-V VMs to Azure Stack HCI. Some prerequisites apply to the source Hyper-V server, some to the target Azure Stack HCI cluster, and others to both.

|Prerequisite|Applies to|More information|
|--|--|--|
|Open required firewall ports.|source, target|[Port access](/azure/migrate/migrate-support-matrix-hyper-v#port-access).<br>[URL access](/azure/migrate/migrate-appliance#url-access).|
|Configure SAN policy on Windows VMs.|source|[Configure SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy).|
|Deploy, configure and register an Azure Stack HCI cluster.|target|[Register a cluster](../deploy/deployment-quickstart.md).|
|Configure Arc Resource Bridge and create a custom location on one of the nodes of the Azure HCI cluster.|target|[Azure Arc VM management prerequisites](../manage/azure-arc-vm-management-prerequisites.md).<br>[Set up Azure Arc VM management using command line](../manage/deploy-arc-resource-bridge-using-command-line.md?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2).|
|Create storage path(s) for the Arc Resource Bridge for storing VM configuration and OS disks.|target| [az azurestackhci storagepath create](/cli/azure/azurestackhci/storagepath) command.|
|Enable contributor and user administrator access on the subscription for the Azure Migrate project.|both|[Steps to assign an Azure role](/azure/role-based-access-control/role-assignments-steps).|
|Create an Azure Migrate project|source, target|[Create Azure migrate project](#create-an-azure-migrate-project).|

## Create an Azure Migrate project

Before you can migrate, create an Azure Migrate project in Azure portal.

1. On the Azure portal home page, select **Azure Migrate**.

1. On the **Get started** page, under **Servers, databases and web apps**, select **Discover, assess and migrate**.

    :::image type="content" source="media/migrate-prerequisites/project-get-started.png" alt-text="Screenshot of Get started page in Azure portal." lightbox="media/migrate-prerequisites/project-get-started.png":::

1. On the **Servers, databases and web apps** page, select **Create project**.

1. On the **Create project** page:
    1. Enter your subscription.
    1. Enter the resource group, or select it if it already exists.
    1. Enter the new project name.
    1. Select a geography region.

    :::image type="content" source="media/migrate-prerequisites/project-create.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/migrate-prerequisites/project-create.png":::

1. When finished, select **Create**.

## Next steps

- [Discover the source appliance](migrate-hyperv-prerequisites.md).
