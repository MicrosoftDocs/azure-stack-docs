---
title: Review requirements for VMware VM migration to Azure Local using Azure Migrate (preview) 
description: Learn the system requirements for VMware migration to Azure Local using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 10/08/2025
ms.author: alkohli
ms.custom: references_regions
---

# Review requirements for VMware VM migration to Azure Local using Azure Migrate (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article lists the system requirements for migrating VMware virtual machines (VMs) to Azure Local using Azure Migrate.

[!INCLUDE [important](../includes/hci-preview.md)]

## Supported configurations

The following operating systems (OSs) are supported for the VMware source appliance, target appliance, and for the guest VMs that you are migrating.


|Component  |Supported configurations |
|---------|---------|
|Source environment     |Both the vCenter and ESXi hosts in the source environment must be running one of the following supported versions:<br>- VMware vCenter Server and ESXi 8.0<br>- VMware vCenter Server and ESXi 7<br>- VMware vCenter Server and ESXi 6.7<br>- VMware vCenter Server and ESXi 6.5    |
|Source appliance     |Windows Server 2022          |
|Target environment     |Azure Local 2311.2 or later         |
|Target appliance     |Windows Server 2022         |
|Guest operating systems    | [Supported Guest Operating Systems on Azure Local](/windows-server/virtualization/hyper-v/supported-windows-guest-operating-systems-for-hyper-v-on-windows) |


\*To migrate Windows Server 2008 R2 VMs, see the [FAQ](./migrate-faq.yml).

## Supported geographies

You can create an Azure Migrate project in many geographies in the Azure public cloud. Here's a list of supported geographies for migration to Azure Local:

|Geography|Metadata storage locations|
|-|-|
|Asia-Pacific|South East Asia, East Asia|
|Europe|North Europe, West Europe|
|United States|Central US, West US2|

Keep in mind the following information as you create a project:

- The project geography is only used to store the discovered metadata. Your VMware source environment and Azure Local target environment do not need to be located in the same geography/region as your Azure migrate project.
- When you create a project, you select a geography. The project and related resources are created in one of the regions in the geography. The region is allocated by the Azure Migrate service. Azure Migrate doesn't move or store customer data outside of the region allocated.
- Your Azure Migrate project must be in the same tenant as your Azure Local instance. The project can recognize Azure Local instances across subscriptions, but it will not work with an Azure Local instance registered in a separate Azure tenant.

## Azure portal requirements

For more information on Azure subscriptions and roles, see [Azure roles, Azure AD roles, and classic subscription administrator roles](/azure/role-based-access-control/rbac-and-directory-admin-roles).

|Level|Permissions|
|-|-|
|Tenant|Application administrator|
|Subscription|Contributor, User Access Administrator|

For any subscriptions hosting resources used in migration, such as Azure Migrate project subscriptions and target Azure Local instance subscriptions, the **Microsoft.DataReplication** resource provider must be registered. For more information, see [register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types).

:::image type="content" source="./media/migrate-vmware-requirements/migrate-resource-providers.png" alt-text="Screenshot showing Azure Local Docs Subscription page." lightbox="./media/migrate-vmware-requirements/migrate-resource-providers.png":::

## Source VMware server requirements

- The source VMware server used for migration should have sufficient resources to create a Windows Server 2022 VM with a minimum of 16 GB memory, 80 GB disk, and 8 vCPUs.

- Ensure that vCenter Server permission requirements are met. For more information, see [VMware vSphere requirements (agentless)](/azure/migrate/migrate-support-matrix-vmware-migration#agentless-migration).

- Before you begin, for all VMware VMs, bring all the disks online and persist the drive letter. For more information, see how to [configure a SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy) to bring the disks online.

- The VMware source environment must be able to initiate a network connection with the target Azure Local instance, either by being on the same on-premises network or by using a VPN.

- Verify that none of the VMs you plan to migrate have the Azure Connected Machine Agent installed. For more information, see [FAQ](migrate-faq.yml).

## Target Azure Local system requirements

- The target system must be running Azure Local.

- An Azure Arc resource bridge must exist on Azure Local for migration. The Azure Arc resource bridge is automatically created during the deployment. To verify that an Arc resource bridge exists on your Azure Local system, see [Deploy using Azure portal](../deploy/deploy-via-portal.md).  

- Make sure that a logical network is configured on your Azure Arc resource bridge. For more information, see [Create a logical network](../manage/create-logical-networks.md).

- Make sure that a custom storage path is configured on your Azure Arc resource bridge for migration. For more information, see [Create a storage path](../manage/create-storage-path.md).

- The Azure Local target system must be able to initiate a network connection with the VMware source environment, either by being on the same on-premises network or by using a VPN.

## Azure Migrate project requirements

- If you have an existing Azure Migrate project with VM discovery complete, you need to [create a new Azure Migrate project](./migrate-vmware-prerequisites.md#create-an-azure-migrate-project) for migration to Azure Local. You can't use existing Azure Migrate projects for migration.

- You must have only one source appliance per Azure Migrate project for Azure Local migrations. This means you can't use the same Azure Migrate project for both a VMware source and a Hyper-V source. Make sure to create a new project for each source you wish to migrate from.

- You must have only one target appliance per Azure Migrate project for Azure Local migrations. This means you can't use the same Azure Migrate project for a single source appliance to migrate to multiple target appliances across different Azure Local instances.

- In general, Azure Migrate projects must have a 1:1 pairing of only 1 source appliance and 1 target appliance per project.

## Next steps

- [Complete the prerequisites](migrate-vmware-prerequisites.md).
