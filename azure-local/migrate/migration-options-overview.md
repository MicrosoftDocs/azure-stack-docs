---
title: Options for migrating virtual machines to Azure Local (preview)
description: Learn about how to choose a migration option to migrate VM workloads to your Azure Local (preview).
author: alkohli
ms.topic: overview
ms.date: 05/15/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# About options to migrate VM workloads to Azure Local (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article provides an overview of some of the common options available for migrating virtual machine (VM) workloads to your Azure Local instance.

[!INCLUDE [important](../includes/hci-preview.md)]


## Migration options

To migrate VM workloads and their data to your Azure Local instance, several options are available. These options can be classified as first party, third party, and manual migration options. Each of these options is described in the following sections.

## First party migration options

First party migration options are provided by Microsoft. These options are built into the Azure Local platform and are available to you at no additional cost. The following first party migration options are available:

- [Azure Migrate](./migration-azure-migrate-overview.md). This option is only available on systems running Azure Local.
    - [For Hyper-V VMs](./migration-azure-migrate-overview.md).
    - [For VMware VMs](./migration-azure-migrate-vmware-overview.md).

- System Center Virtual Machine Manager (SCVMM). These options are only available on systems running Azure Stack HCI, version 22H2.
    - [For Hyper-V VMs](/system-center/vmm/deploy-manage-azure-stack-hci?view=sc-vmm-2022&preserve-view=true#step-8-migrate-vms-from-windows-server-to-azure-stack-hci-cluster)
    - [For VMware VMs](/system-center/vmm/deploy-manage-azure-stack-hci?view=sc-vmm-2022&preserve-view=true#step-9-migrate-vmware-workloads-to-azure-stack-hci-cluster-using-scvmm)


## Third party migration options

The following third-party migration options are offered by Microsoft partners.

- [Carbonite](https://www.carbonite.com/business/products/migration/)  
- [Commvault](https://www.commvault.com/)  
- [Veeam](https://www.veeam.com/)  


## Manual migration options

Manual migration options are provided by Microsoft. These options are available to you at no additional cost. These options are available only on systems running Azure Stack HCI, version 22H2.

The following manual migration options are available:

- [Migrate VMs manually to same hardware](migrate-cluster-same-hardware.md): This option is used when you want to migrate a Windows Server failover cluster to Azure Local using your existing hardware. This process installs the new operating system for Azure Local and retains your existing cluster settings and storage, and imports your VMs.

- [Migrate VMs manually to new hardware](migrate-cluster-new-hardware.md): This option is used when you want to migrate VMs from an existing Windows Server 2016 or later cluster to a new Azure Local instance. You migrate the VMs to the same hardware using PowerShell and Robocopy.

    If you have VMs on Windows 2012 R2 or older that you want to migrate, see [Migrating older VMs](migrate-cluster-new-hardware.md#migrating-older-vms).



## Next steps

To learn more about migration using Azure Migrate, see:
- [Hyper-V migration to Azure Local](./migration-azure-migrate-overview.md).
- [VMware migration to Azure Local](./migration-azure-migrate-vmware-overview.md).
