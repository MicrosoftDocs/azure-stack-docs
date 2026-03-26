--- 
title: Prerequisites for VMware VM migration to Azure Local using Azure Migrate
description: Learn prerequisites for VMware migration to Azure Local using Azure Migrate.
author: alkohli
ms.topic: how-to
ms.date: 03/26/2026
ms.author: alkohli
ms.subservice: hyperconverged
---

# Prerequisites for VMware migration to Azure Local using Azure Migrate

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article describes the prerequisite tasks you need to complete before you begin the process to migrate VMware virtual machines (VMs) to Azure Local. Make sure to [review the requirements](migrate-vmware-requirements.md) for migration if you haven't already.

## Prerequisites

The following list contains the prerequisites and considerations that you must meet to migrate VMware VMs to Azure Local. Some prerequisites apply to the source VMware server, some to the target Azure Local instance, and others to both.

|Prerequisite|Applies to|More information|
|--|--|--|
|Open required VMware firewall ports.|source| **3389** – Inbound connections on port 3389 to allow remote desktop connections to the appliance. <br> **44368** – Inbound connections on port 44368 to remotely access the appliance management app by using the URL: *https:\//\<appliance-ip-or-name\>:44368*. <br> **443** – Inbound and outbound connections on port 443 to communicate with Azure Migrate services orchestrating replication and migration, and to allow the appliance to communicate with vCenter Server. <br> **902** – Inbound and outbound connections on port 902 for the appliance to replicate data from snapshots of ESXi hosts and send heartbeat traffic to vCenter. <br> **445** – Inbound and outbound connections on port 445 (SMB) to communicate between source and target appliance.|
|Open required Hyper-V firewall ports.|target|**3389** – Inbound connections on port 3389 to allow remote desktop connections to the appliance. <br> **44368** – Inbound connections on port 44368 to remotely access the appliance management app by using the URL: *https:\//\<appliance-ip-or-name\>:44368*. <br> **445** – Inbound and outbound connections on port 445 (SMB) to communicate between source and target appliance. <br> **5985, 5986** – Inbound and outbound connections on port 5985 (WinRM) to communicate from appliance to host.|
|Allow required URLs |source, <br> target |[URL access](/azure/migrate/migrate-appliance#url-access) and <br> **\*.siterecovery.azure.com** |
|Configure SAN/disks policy on VMs. |source|[Configure SAN/disks policy](migrate-troubleshoot.md#disks-on-migrated-vms-are-offline).|
| Install Hyper-V Linux Integration Services on Linux VMs | source | Rebuild the Linux init image so it contains the necessary Hyper-V drivers.<br>Rebuilding the init image ensures that the VM boots on Azure Local. Most new versions of Linux distributions include this service. |
| Verify secure boot status of guest VMs | source | Secure Boot settings are preserved for UEFI (Generation 2) VMs during migration. Configure Secure Boot as intended on the source VM before migration. If you modify Secure Boot settings, allow up to 30 minutes for the Azure Migrate discovery service to detect the change before initiating migration. |
| Disable BitLocker on Windows VMs. | source | BitLocker must be disabled on VMs before migration.|
| Encrypted disks/volumes aren't supported. | source | Decrypt any encrypted disks or volumes on VMs before migration.|
| Shared disks aren't supported. | source | Ensure that VMs don't have any shared disks attached before migration. |
| Uninstall Azure Connected Machine Agent on source VMs (if present) | source | If the source VM is Arc-enabled, ensure that you uninstall the Azure Connected Machine Agent before initiating replication. See [Azure Migrate FAQ](migrate-faq.yml?&tabs=vmware-and-hyper-v-vms#i-have-the-azure-connected-machine-agent-deployed-on-my-source-vms-that-i-wish-to-migrate-do-i-need-to-uninstall-the-agent-on-my-vms-before-migration) for more information. |
| Review snapshot-based backup solutions | source | If you use snapshot-based backups on VMware VMs, make sure they don't run at the same time as Azure Migrate replication cycles. Concurrent snapshot operations can interfere with replication cycles. See [Replication Cycles](/azure/migrate/concepts-vmware-agentless-migration#replication-cycles) for more information. |
|Deploy, configure, and register an Azure Local instance.|target|[Create and register an Azure Local instance](../deploy/deployment-introduction.md).|
| Verify a successful deployment. | target | [Verify a successful deployment](../deploy/deploy-via-portal.md#verify-a-successful-deployment). |
|Verify and make a note of the custom location created during deployment on the Azure Local system.|target|[Verify a successful deployment](../deploy/deploy-via-portal.md#verify-a-successful-deployment).|
|Create a custom storage path for the Azure Arc resource bridge for storing VM configuration and OS disks.|target| [Create storage path](../manage/create-storage-path.md).|
|Create a logical network for the Azure Arc resource bridge for VMs to use.|target|[Create a logical network.](../manage/create-logical-networks.md)|
|Enable contributor and user administrator access on the subscription for the Azure Migrate project.|both|[Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).|
|Create an Azure Migrate project|source, target|[Create an Azure Migrate project](#create-an-azure-migrate-project).|

## Create an Azure Migrate project

Before you can migrate, create an Azure Migrate project in the Azure portal by using the following procedure. For more information, see [Create and manage projects](/azure/migrate/create-manage-projects#create-a-project-for-the-first-time).

1. On the Azure portal home page, select **Azure Migrate**.

1. On **Get started**, select **Create project**.

    :::image type="content" source="media/migrate-vmware-prerequisites/project-get-started.png" alt-text="Screenshot of Get started page in Azure portal." lightbox="media/migrate-vmware-prerequisites/project-get-started.png":::

1. On **Create project**:
    1. Enter your subscription. Make sure that the chosen subscription is associated with the same Azure tenant as the Azure Local instance.
    1. Enter the resource group, or select it if it already exists.
    1. Enter the new project name.
    1. Select a supported geography region that you previously created. For more information, see [Supported geographies](migrate-vmware-requirements.md#supported-geographies).

    :::image type="content" source="media/migrate-vmware-prerequisites/project-create.png" alt-text="Screenshot of Create Project page in Azure portal." lightbox="media/migrate-vmware-prerequisites/project-create.png":::

1. When finished, select **Create**.

## Next steps

- [Discover and replicate VMware VMs](migrate-vmware-replicate.md).
