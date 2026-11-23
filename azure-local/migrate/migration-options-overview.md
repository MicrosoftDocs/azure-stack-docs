---
title: Options for migrating virtual machines to Azure Local
description: Learn about the available migration options for migrating VM workloads to your Azure Local.
author: scompton1045
ms.topic: overview
ms.date: 11/09/2026
ms.author: scompton
ms.subservice: hyperconverged
---

# Options to migrate VM workloads to Azure Local

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article provides an overview of the options available for migrating virtual machine (VM) workloads to your Azure Local instance.

## Migration options

To migrate VM workloads and their data to your Azure Local instance, several options are available. These options are classified either as first-party or third-party. Select the option that best suits your current infrastructure and migration goals.

## First-party migration options

First-party migration options are provided by Microsoft. These options are built into the Azure Local platform and are available to you at no additional cost.

<a name="azure-migrate"></a>

### Azure Catalyst

The primary first-party migration option is [Azure Catalyst](./migration-azure-migrate-overview.md) (formerly Azure Migrate), which is available on systems running Azure Local. Azure Catalyst is a central hub for tools to discover, assess, and migrate on-premises servers, apps, and data to the Microsoft Azure cloud.

You can use Azure Catalyst to migrate the following types of VMs to Azure Local:

- [Hyper-V VMs (Preview)](./migration-azure-migrate-overview.md)
- [VMware VMs](./migration-azure-migrate-vmware-overview.md)

**Considerations for Azure Catalyst**

Azure Catalyst requires both a source appliance in your on-premises environment and a target appliance in your Azure Local instance. This setup is necessary for every Azure Catalyst project. For more information, see [Source VMware requirements](migrate-vmware-requirements.md#source-vmware-server-requirements) and [Source Hyper-V requirements](migrate-hyperv-requirements.md#source-hyper-v-requirements).

- **Hyper-V migrations:** Support is currently in preview.
- **VMware migrations:** Azure Catalyst doesn't provide VDDK packages, and access to them might be restricted. If a supported VDDK package isn't available to your organization, use a [third-party migration option](#third-party-migration-options).

By default, Azure Catalyst provisions all migrated VMs as Azure Local VMs enabled by Azure Arc. For more information on VM types for Azure Local, see [Types of VMs on Azure Local](../concepts/compare-vm-management-capabilities.md#types-of-vms-on-azure-local).

If your source VMs are already onboarded as Azure Arc-enabled servers, you can retain their existing Azure Arc resources during migration instead of projecting new ones. For more information, see [Reuse Azure Arc-enabled server resources when you migrate VMs to Azure Local](./migrate-arc-reuse.md).

If your Azure Local instance is in Azure Government, see [Migrate VMs to Azure Local in Azure Government](./migrate-azure-government.md) for the steps that differ.

To replicate and migrate VMs by using PowerShell, Azure CLI, or Terraform instead of the Azure portal, see [Migrate VMs to Azure Local using PowerShell, Azure CLI, or Terraform](./migrate-via-powershell.md).


## Third-party migration options

The following third-party migration options are offered by Microsoft partners.

- [Carbonite](https://www.carbonite.com/business/products/migration/)  
- [Commvault](https://www.commvault.com/)  
- [Veeam](https://www.veeam.com/)  

## Next steps

To learn more about migration using Azure Catalyst, see:
- [Hyper-V migration to Azure Local](./migration-azure-migrate-overview.md).
- [VMware migration to Azure Local](./migration-azure-migrate-vmware-overview.md).
