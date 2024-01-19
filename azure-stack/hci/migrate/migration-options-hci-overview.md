---
title: Options for migrating virtual machines to Azure Stack HCI (preview)
description: Learn about how to choose a migration option to migrate VM workloads to your Azure Stack HCI cluster (preview).
author: alkohli
ms.topic: overview
ms.date: 01/19/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# About options to migrate VM workloads to Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article provides an overview of some of the common options available for migrating virtual machine (VM) workloads to your Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]


## Migration options

To migrate VM workloads and their data to your Azure Stack HCI cluster, several options are available. These options can be classified as first party, third party, and manual migration options. Each of these options is described in the following sections.

## First party migration options

First party migration options are provided by Microsoft. These options are built into the Azure Stack HCI platform and are available to you at no additional cost. The following first party migration options are available:

- [Azure Migrate](./migration-azure-migrate-hci-overview.md). This option is only available on systems running Azure Stack HCI, version 23H2.
- System Center Virtual Machine Manager (SCVMM). These options are only available on systems running Azure Stack HCI, version 22H2. 
    - [For Hyper-V VMs](/system-center/vmm/deploy-manage-azure-stack-hci?view=sc-vmm-2022&preserve-view=true#step-8-migrate-vms-from-windows-server-to-azure-stack-hci-cluster)
    - [For VMware VMs](/system-center/vmm/deploy-manage-azure-stack-hci?view=sc-vmm-2022&preserve-view=true#step-9-migrate-vmware-workloads-to-azure-stack-hci-cluster-using-scvmm)


## Third party migration options

Third party migration options are provided by Microsoft partners. These options are available to you at an additional cost. The following third party migration options are available:

- [Carbonite](https://www.carbonite.com/business/products/migration/)  
- [Commvault](https://www.commvault.com/)  
- [Veeam](https://www.veeam.com/)  
 


## Manual migration options

Manual migration options are provided by Microsoft. These options are available to you at no additional cost. These options are available only on systems running Azure Stack HCI, version 22H2. 

The following manual migration options are available:

- [Migrate VMs manually to same hardware](../deploy/migrate-cluster-same-hardware.md): This option is used when you want to migrate a Windows Server failover cluster to Azure Stack HCI using your existing server hardware. This process installs the new Azure Stack HCI operating system and retains your existing cluster settings and storage, and imports your VMs.

- [Migrate VMs manually to new hardware](../deploy/migrate-cluster-new-hardware.md): This option is used when you want to migrate VMs from an existing Windows Server 2016 or Windows Server 2019 cluster to a new Azure Stack HCI cluster. You migrate the VMs to the same hardware using PowerShell and Robocopy.

    If you have VMs on Windows 2012 R2 or older that you want to migrate, see [Migrating older VMs](../deploy/migrate-cluster-new-hardware.md#migrating-older-vms).



## Next steps

To learn more about migration using Azure Migrate, see [About Azure Migrate based migration for Azure Stack HCI ](./migration-azure-migrate-hci-overview.md)
