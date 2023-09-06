---
title: Options for migrating virtual machines to Azure Stack HCI (preview)
description: Learn about how to choose a migration option to migrate VM workloads to your Azure Stack HCI cluster (preview).
author: alkohli
ms.topic: overview
ms.date: 09/06/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Migration options to migrate VM workloads to Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article provides an overview of some of the common options available to let you migrate virtual machine (VM) workloads to your Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]


## Migration options

To migrate VM workloads and their data to your Azure Stack HCI cluster, several options are available. These options can be classified as first party, third party, and manual migration options. Each of these options is described in the following sections.

## First party migration options

First party migration options are provided by Microsoft. These options are built into the Azure Stack HCI platform and are available to you at no additional cost. The following first party migration options are available:

- [Azure Migrate](./migration-azure-migrate-hci-overview.md)
- [Software Centre for virtual machine migration]
    - [For Hyper-V VMs](/system-center/vmm/deploy-manage-azure-stack-hci?view=sc-vmm-2022#step-8-migrate-vms-from-windows-server-to-azure-stack-hci-cluster)
    - [For VMware VMs](/system-center/vmm/deploy-manage-azure-stack-hci?view=sc-vmm-2022#step-9-migrate-vmware-workloads-to-azure-stack-hci-cluster-using-scvmm)
- [Storage Migration Service](#storage-migration-service)
- [Windows Admin Center](#windows-admin-center)
- [Azure Site Recovery](../manage/azure-site-recovery.md#protect-vm-workloads-with-azure-site-recovery-on-azure-stack-hci-preview)
 

## Third party migration options

Third party migration options are provided by Microsoft partners. These options are available to you at an additional cost. The following third party migration options are available:

- [VEEAM](#veeam)
- [Commvault](#commvault)

## Manual migration options

Manual migration options are provided by Microsoft. These options are available to you at no additional cost. The following manual migration options are available:

- [Migrate VMs manually to same hardware](../deploy/migrate-cluster-same-hardware.md): This option is used when you want to migrate a Windows Server failover cluster to Azure Stack HCI using your existing server hardware. This process installs the new Azure Stack HCI operating system and retains your existing cluster settings and storage, and imports your VMs.

- [Migrate VMs manually to new hardware](../deploy/migrate-cluster-new-hardware.md): This option is used when you want to migrate VMs from an existing Windows Server 2016 or Windows Server 2019 cluster to a new Azure Stack HCI cluster. You migrate the VMs to the same hardware using PowerShell and Robocopy.

    If you have VMs on Windows 2012 R2 or older that you want to migrate, see [Migrating older VMs](../deploy/migrate-cluster-new-hardware.md#migrating-older-vms).


## Comparison summary

The following table summarizes the various migration options available to migrate your VM workloads to Azure Stack HCI:




## Next steps

To prepare for migration using Azure Migrate, see the following articles:

- [Review the requirements](./migrate-hyperv-requirements.md) for Hyper-V VM migration to Azure Stack HCI.
- [Complete the prerequisites](./migrate-hyperv-prerequisites.md) for Hyper-V VM migration to Azure Stack HCI.
