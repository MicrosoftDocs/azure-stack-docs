--- 
title: Prerequisites for VMware VM migration to Azure Stack HCI using Azure Migrate (preview)
description: Learn prerequisites for VMware migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 05/20/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Prerequisites for VMware migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the prerequisite tasks you need to complete before you begin the process to migrate Hyper-V virtual machines (VMs) to Azure Stack HCI. Make sure to [review the requirements](migrate-vmware-requirements.md) for migration if you haven't already.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

The following list contains the prerequisites that must be met to migrate VMware VMs to Azure Stack HCI. Some prerequisites apply to the source VMware server, some to the target Azure Stack HCI cluster, and others to both.

|Prerequisite|Applies to|More information|
|--|--|--|
|Open required VMware firewall ports.|source| [Port access](/azure/migrate/migrate-support-matrix-vmware-migration#port-requirements-agentless)<br>TCP port 443 inbound.|
|Open required Hyper-V firewall ports.|target|[Port access](/azure/migrate/migrate-support-matrix-hyper-v#port-access).<br>[URL access](/azure/migrate/migrate-appliance#url-access).|
|Configure SAN policy on VMware VMs.|source|[Configure SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy).|
|Deploy, configure, and register an Azure Stack HCI cluster.|target|[Create and register an Azure Stack HCI cluster](../deploy/deployment-introduction.md).|
| Verify a successful deployment. | target | [Verify a successful deployment](../deploy/deploy-via-portal.md#verify-a-successful-deployment). |
|Verify and make a note of the custom location created during deployment on the Azure Stack HCI system.|target|[Verify a successful deployment](../deploy/deploy-via-portal.md#verify-a-successful-deployment).|
|Create a custom storage path for the Arc Resource Bridge for storing VM configuration and OS disks.|target| [Create storage path](../manage/create-storage-path.md).|
|Create a logical network for the Arc Resource Bridge for VMs to use.|target|[Create a logical network.](../manage/create-logical-networks.md)|
|Enable contributor and user administrator access on the subscription for the Azure Migrate project.|both|[Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).|
|Create an Azure Migrate project|source, target|[Create an Azure Migrate project](#create-an-azure-migrate-project).|
<!-- check port access, sub access-->

## Create an Azure Migrate project

<!--CHECK add an include here-->Before you can migrate, create an Azure Migrate project in Azure portal using the following procedure. For more information, see [Create and manage projects](/azure/migrate/create-manage-projects).

1. On the Azure portal home page, select **Azure Migrate**.

1. On the **Get started** page, under **Servers, databases and web apps**, select **Discover, assess and migrate**.

    :::image type="content" source="media/migrate-vmware-prerequisites/project-get-started.png" alt-text="Screenshot of Get started page in Azure portal." lightbox="media/migrate-vmware-prerequisites/project-get-started.png":::

1. On the **Servers, databases and web apps** page, select **Create project**.

1. On the **Create project** page:
    1. Enter your subscription.
    1. Enter the resource group, or select it if it already exists.
    1. Enter the new project name.
    1. Select a supported geography region that you previously created. For more information, see [Supported geographies](migrate-vmware-requirements.md#supported-geographies).

    :::image type="content" source="media/migrate-vmware-prerequisites/project-create.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/migrate-vmware-prerequisites/project-create.png":::

1. When finished, select **Create**.

## Next steps

- [Discover and replicate VMware VMs](migrate-vmware-replicate.md).
