---
title: Upgrade Windows Server VMs on Azure Stack HCI to Windows Server Azure Edition
description: Learn how to upgrade existing Windows Server VMs or Azure Stack HCI VMs to Windows Server Azure Edition.
ms.topic: how-to
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/22/2022
---

# Upgrade VMs to Windows Server Azure Edition

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

This article describes how to upgrade existing Windows Server virtual machines (VMs) running on your Azure Stack HCI cluster to Windows Server Azure Edition.

## Prerequisites

- Verify that your Azure Stack HCI cluster is configured to support Windows Server Azure Edition. Review the **Considerations** section in [Deploy Windows Server Azure Edition VMs](windows-server-azure-edition.md?tabs=hci#considerations).

- Ensure that [Azure Benefits](azure-benefits.md) is enabled and you are licensed to use Windows Server Azure Edition.

- Review VM compatibility. Windows Server Azure Edition only supports generation 2 VMs with Secure Boot enabled. Using [Windows Admin Center](vm.md#view-vm-details), you can view the generation of a specific VM from the **Inventory** tab, and the Secure Boot configuration in the **Security** section of VM settings.

- For Windows Server 2016 or Windows Server 2019 VMs, follow your typical update procedure to ensure that the latest cumulative update is applied to the VMs.

- Consider backing up the VM using your established backup process, or taking a Hyper-V production snapshot. After verifying that the upgrade was successful, you can delete the checkpoint to save disk space.

## Perform the upgrade

After all the prerequisites are completed, follow these steps:

1. Download the Windows Server Azure Edition installer .iso file to a storage location that is accessible to all Azure Stack HCI cluster nodes:

    - [Download English ISO](https://aka.ms/AAi4r31)
    - [Download Chinese ISO](https://aka.ms/AAi4bii)

1. Using Windows Admin Center, follow step 6 in [Change VM settings](vm.md#change-vm-settings) to attach the downloaded .iso file to each VM being upgraded.

1. Sign in to the VM as a user in the Administrators group.

1. Perform an [in-place upgrade of Windows Server](/windows-server/get-started/perform-in-place-upgrade#perform-the-upgrade) and run *setup.exe* on the .iso file.

## Next steps

- [Enable Hotpatch for Azure Edition Server Core VM](/windows-server/get-started/enable-hotpatch-azure-edition).
