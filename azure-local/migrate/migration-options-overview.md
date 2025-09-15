---
title: Options for migrating virtual machines to Azure Local (preview)
description: Learn about the available migration options for migrating VM workloads to your Azure Local (preview).
author: alkohli
ms.topic: overview
ms.date: 07/28/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Options to migrate VM workloads to Azure Local (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article provides an overview of the options available for migrating virtual machine (VM) workloads to your Azure Local instance.

[!INCLUDE [important](../includes/hci-preview.md)]

## Migration options

To migrate VM workloads and their data to your Azure Local instance, several options are available. These options are classified either as first-party or third-party. Select the option that best suits your current infrastructure and migration goals.

## First-party migration options

First-party migration options are provided by Microsoft. These options are built into the Azure Local platform and are available to you at no additional cost.

### Azure Migrate

The primary first-party migration option is [Azure Migrate](./migration-azure-migrate-overview.md), which is available on systems running Azure Local. Azure Migrate is a central hub for tools to discover, assess, and migrate on-premises servers, apps, and data to the Microsoft Azure cloud.

You can use Azure Migrate to migrate the following types of VMs to Azure Local:

   - [Hyper-V VMs](./migration-azure-migrate-overview.md)
   - [VMware VMs](./migration-azure-migrate-vmware-overview.md)

**Considerations for Azure Migrate**

Azure Migrate requires both a source appliance in your on-premises environment and a target appliance in your Azure Local instance. This setup is necessary for every Azure Migrate project. For more information, see [Source VMware requirements](migrate-vmware-requirements.md#source-vmware-server-requirements) and [Source Hyper-V requirements](migrate-hyperv-requirements.md#source-hyper-v-requirements).  

By default, Azure Migrate provisions all migrated VMs as Azure Local VMs enabled by Azure Arc. For more information on VM types for Azure Local, see [Types of VMs on Azure Local](../concepts/compare-vm-management-capabilities.md#types-of-vms-on-azure-local). 


## Third-party migration options

The following third-party migration options are offered by Microsoft partners.

- [Carbonite](https://www.carbonite.com/business/products/migration/)  
- [Commvault](https://www.commvault.com/)  
- [Veeam](https://www.veeam.com/)  

## Next steps

To learn more about migration using Azure Migrate, see:
- [Hyper-V migration to Azure Local](./migration-azure-migrate-overview.md).
- [VMware migration to Azure Local](./migration-azure-migrate-vmware-overview.md).
