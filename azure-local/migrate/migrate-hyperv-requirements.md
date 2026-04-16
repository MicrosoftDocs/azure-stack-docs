---
title: Review requirements for Hyper-V VM migration to Azure Local using Azure Migrate (preview) 
description: Learn the system requirements for Hyper-V migration to Azure Local using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 09/25/2025
ms.author: alkohli
ms.subservice: hyperconverged
---

# Review requirements for Hyper-V VM migration to Azure Local using Azure Migrate (preview)

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article lists the system requirements for migrating Hyper-V virtual machines (VMs) to Azure Local using Azure Migrate.

[!INCLUDE [important](../includes/hci-preview.md)]

## Supported configurations

The following operating systems (OS) are supported for the source appliance, target appliance, and for the guest VMs that you are migrating.


|Component  |Supported configurations |
|---------|---------|
|Source environment     |Hyper-V on Windows Server 2025<br>Hyper-V on Windows Server 2022<br>Hyper-V on Windows Server 2019<br>Hyper-V on Windows Server 2016<br>Hyper-V on Windows Server 2012 R2         |
|Source appliance     |Windows Server 2022        |
|Target environment     |Azure Local 2311.2 or later         |
|Target appliance     |Windows Server 2022         |
|Guest operating systems    | [Supported Guest Operating Systems on Azure Local](/windows-server/virtualization/hyper-v/supported-windows-guest-operating-systems-for-hyper-v-on-windows) |

*To migrate Windows Server 2008 R2 VMs, see the [FAQ](migrate-faq.yml).


## Supported geographies

You can create an Azure Migrate project in many geographies in the Azure public cloud. Here's a list of supported geographies for migration to Azure Local:

|Geography|Metadata storage locations|
|-|-|
|Asia-Pacific|South East Asia, East Asia|
|Europe|North Europe, West Europe|
|United States| Central US, West US2|

Keep in mind the following information as you create a project:

- Project geography only stores the discovered metadata.
- When you create a project, you select a geography. The Azure Migrate service creates the project and related resources in one of the regions in the geography. The service allocates the region. Azure Migrate doesn't move or store customer data outside of the allocated region.

## Azure portal requirements

For more information on Azure subscriptions and roles, see [Azure roles, Azure AD roles, and classic subscription administrator roles](/azure/role-based-access-control/rbac-and-directory-admin-roles).

|Level|Permissions|
|-|-|
|Tenant|[Application Developer](/entra/identity/role-based-access-control/permissions-reference#application-developer)|
|Subscription|Contributor, User Access Administrator|

For any subscriptions that host resources used in migration, such as Azure Migrate project subscriptions and target Azure Local instance subscriptions, register the **Microsoft.DataReplication** resource provider. For more information, see [register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider-1).

:::image type="content" source="./media/migrate-hyperv-requirements/migrate-resource-providers.png" alt-text="Screenshot showing Azure Local Docs Subscription page." lightbox="./media/migrate-hyperv-requirements/migrate-resource-providers.png":::

## Source Hyper-V requirements

- Hyper-V Server supports both standalone server and cluster configurations.

    You can discover and migrate standalone (non-highly available) VMs on standalone Hyper-V hosts. However, you can't discover or migrate standalone VMs hosted on clustered Hyper-V hosts. To migrate these VMs, you need to [make them highly available](https://www.thomasmaurer.ch/2013/01/how-to-make-an-existing-hyper-v-virtual-machine-highly-available/).

- The source server used for migration should have sufficient resources to create a Windows Server 2022 VM with a minimum of 16 GB memory, 80 GB disk, and 8 vCPUs.

- In this release, you can only migrate VMs that have disks attached to the cluster shared volumes (CSV). If the VM disks aren't attached to the CSV, you can't migrate the disks.

- DAS and SMB shares on source system aren't supported for migrations to Azure Local.

- Before you begin, for all Windows VMs, bring all the disks online and persist the drive letter. For more information, see how to [configure a SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy) to bring the disks online.

- Verify that none of the VMs you plan to migrate have the Azure Connected Machine Agent installed. For more information, see [FAQ](migrate-faq.yml).

## Target Azure Local requirements

- The target system must be running Azure Local.

- An Azure Arc resource bridge must exist on the Azure Local system for migration. The Azure Arc resource bridge is automatically created during the deployment. To verify that an Azure Arc resource bridge exists on your Azure Local system, see [Deploy using Azure portal](../deploy/deploy-via-portal.md).  

- Ensure that a logical network is configured on your Azure Arc resource bridge. For more information, see [Create a logical network](../manage/create-logical-networks.md).

- Ensure that a custom storage path is configured on your Azure Arc resource bridge for migration. For more information, see [Create a storage path](../manage/create-storage-path.md).

## Azure Migrate project requirements

- If you have an existing Azure Migrate project with VM discovery complete, you need to [create a new Azure Migrate project](./migrate-vmware-prerequisites.md#create-an-azure-migrate-project) for migration to Azure Local. You can't use existing Azure Migrate projects for migration.

- You must have only one source appliance per Azure Migrate project for Azure Local migrations. This requirement means you can't use the same Azure Migrate project for both a VMware source and a Hyper-V source. Make sure to create a new project for each source you wish to migrate from.

- You must have only one target appliance per Azure Migrate project for Azure Local migrations. This requirement means you can't use the same Azure Migrate project for a single source appliance to migrate to multiple target appliances across different Azure Local instances.

- In general, Azure Migrate projects must have a 1:1 pairing of only one source appliance and one target appliance per project.

## Considerations for migrating Hyper-V VMs to Azure Local

- Azure Migrate retains the Hyper-V generation of the VM during migration. If the source Hyper-V VM is a Generation 1 VM, the migrated VM on Azure Local is also a Generation 1 VM. If the source Hyper-V VM is a Generation 2 VM, the migrated VM on Azure Local is also a Generation 2 VM. For more information on Generation 1 VM limitations, see [Azure Local VM management](../manage/azure-arc-vm-management-overview.md).

## Next steps

- [Complete the prerequisites](./migrate-hyperv-prerequisites.md).
