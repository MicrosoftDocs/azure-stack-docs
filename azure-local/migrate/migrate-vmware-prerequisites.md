--- 
title: Prerequisites for VMware VM migration to Azure Local using Azure Migrate (preview)
description: Learn prerequisites for VMware migration to Azure Local using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 09/30/2025
ms.author: alkohli
---

# Prerequisites for VMware migration to Azure Local using Azure Migrate (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the prerequisite tasks you need to complete before you begin the process to migrate VMware virtual machines (VMs) to Azure Local. Make sure to [review the requirements](migrate-vmware-requirements.md) for migration if you haven't already.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

The following list contains the prerequisites that must be met to migrate VMware VMs to Azure Local. Some prerequisites apply to the source VMware server, some to the target Azure Local instance, and others to both.

|Prerequisite|Applies to|More information|
|--|--|--|
|Open required VMware firewall ports.|source| **3389** – Inbound connections on port 3389 to allow remote desktop connections to the appliance. <br> **44368** – Inbound connections on port 44368 to remotely access the appliance management app by using the URL: *https:\//\<appliance-ip-or-name\>:44368*. <br> **443** – Inbound and outbound connections on port 443 to communicate with Azure Migrate services orchestrating replication and migration, and to allow the appliance to communicate with vCenter Server. <br> **902** – Inbound and outbound connections on port 902 for the appliance to replicate data from snapshots of ESXi hosts and send heartbeat traffic to vCenter. <br> **445** – Inbound and outbound connections on port 445 (SMB) to communicate between source and target appliance.|
|Open required Hyper-V firewall ports.|target|**3389** – Inbound connections on port 3389 to allow remote desktop connections to the appliance. <br> **44368** – Inbound connections on port 44368 to remotely access the appliance management app by using the URL: *https:\//\<appliance-ip-or-name\>:44368*. <br> **445** – Inbound and outbound connections on port 445 (SMB) to communicate between source and target appliance. <br> **5985, 5986** – Inbound and outbound connections on port 5985 (WinRM) to communicate from appliance to host.|
|Allow required URLs |source, <br> target |[URL access](/azure/migrate/migrate-appliance#url-access) and <br> **\*.siterecovery.azure.com** |
|Configure SAN/disks policy on VMs. |source|[Configure SAN/disks policy](migrate-troubleshoot.md#disks-on-migrated-vms-are-offline).|
|Deploy, configure, and register an Azure Local instance.|target|[Create and register an Azure Local instance](../deploy/deployment-introduction.md).|
| Verify a successful deployment. | target | [Verify a successful deployment](../deploy/deploy-via-portal.md#verify-a-successful-deployment). |
|Verify and make a note of the custom location created during deployment on the Azure Local system.|target|[Verify a successful deployment](../deploy/deploy-via-portal.md#verify-a-successful-deployment).|
|Create a custom storage path for the Azure Arc resource bridge for storing VM configuration and OS disks.|target| [Create storage path](../manage/create-storage-path.md).|
|Create a logical network for the Azure Arc resource bridge for VMs to use.|target|[Create a logical network.](../manage/create-logical-networks.md)|
|Enable contributor and user administrator access on the subscription for the Azure Migrate project.|both|[Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).|
|Create an Azure Migrate project|source, target|[Create an Azure Migrate project](#create-an-azure-migrate-project).|


## Create an Azure Migrate project

Before you can migrate, create an Azure Migrate project in Azure portal using the following procedure. For more information, see [Create and manage projects](/azure/migrate/create-manage-projects#create-a-project-for-the-first-time).

1. On the Azure portal home page, select **Azure Migrate**.

1. On the **Get started** page, under **Servers, databases and web apps**, select **Discover, assess and migrate**.

    :::image type="content" source="media/migrate-vmware-prerequisites/project-get-started.png" alt-text="Screenshot of Get started page in Azure portal." lightbox="media/migrate-vmware-prerequisites/project-get-started.png":::

1. On the **Servers, databases and web apps** page, select **Create project**.

1. On the **Create project** page:
    1. Enter your subscription. Make sure that the chosen subscription is associated with the same Azure tenant as the Azure Local instance.
    1. Enter the resource group, or select it if it already exists.
    1. Enter the new project name.
    1. Select a supported geography region that you previously created. For more information, see [Supported geographies](migrate-vmware-requirements.md#supported-geographies).

    :::image type="content" source="media/migrate-vmware-prerequisites/project-create.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/migrate-vmware-prerequisites/project-create.png":::

1. When finished, select **Create**.

## Next steps

- [Discover and replicate VMware VMs](migrate-vmware-replicate.md).
