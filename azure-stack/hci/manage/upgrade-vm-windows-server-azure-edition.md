---
title: Upgrade Windows Server VMs on Azure Stack HCI to Windows Server Azure Edition
description: Learn how to upgrade existing Windows Server VMs or Azure Stack HCI VMs to Windows Server Azure Edition.
ms.topic: how-to
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/01/2022
---

# Upgrade VMs to Windows Server Azure Edition

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

This article describes how to upgrade existing Windows Server virtual machines (VMs) running on your Azure Stack HCI cluster to Windows Server Azure Edition.

## Prerequisites

- Verify that your Azure Stack HCI cluster is configured to support Windows Server Azure Edition. Review the **Considerations** section in [Deploy Windows Server Azure Edition VMs](windows-server-azure-edition.md?tabs=hci#considerations).

- Ensure that [Azure Benefits](azure-benefits.md) is enabled and you are licensed to use Windows Server Azure Edition.

- Review VM compatibility. Windows Server Azure Edition only supports generation 2 VMs with Secure Boot enabled. Using [Windows Admin Center](vm.md#view-vm-details), you can view the generation of a specific VM from the **Inventory** tab, and the Secure Boot configuration in the **Security** section of VM settings.

- Follow your typical update procedure to ensure that the latest cumulative update is applied to the VMs.

- Consider backing up the VM using your established backup process, or taking a Hyper-V production snapshot. After verifying that the upgrade was successful, you can delete the checkpoint to save disk space.

## Perform the upgrade using ISO file

After all the prerequisites are completed, follow these steps:

1. Download the Windows Server Azure Edition installer .iso file to a storage location that is accessible to all Azure Stack HCI cluster nodes:

    - [Download English ISO](https://aka.ms/AAi4r31)
    - [Download Chinese ISO](https://aka.ms/AAi4bii)

1. Using Windows Admin Center, under **Tools**, select **Virtual machines**.

1. Click the **Inventory** tab on the right, select the VM being upgraded, then select **Settings**.

1. On the **Settings** page for the VM, select **Disks**.

1. Select the option **Use an existing virtual hard disk or ISO image file**. Browse to the location of the .iso file, then select **Save disk settings**. This will attach the downloaded .iso file to the VM being upgraded.

   :::image type="content" source="media/upgrade-vm-windows-server-azure-edition/vm-settings-iso.png" alt-text="Screenshot of Screenshot for VM Settings Disk page" lightbox="media/upgrade-vm-windows-server-azure-edition/vm-settings-iso.png":::

1. Under **Tools**, select **Virtual machines** again.

1. Click the **Inventory** tab on the right, select the checkbox next to the VM being upgraded, then select **Connect**.

1. Sign in to the VM as a user of the local Administrators group.

1. Perform an [in-place upgrade of Windows Server](/windows-server/get-started/perform-in-place-upgrade#perform-the-upgrade) and then run *setup.exe* on the .iso file.

## Next steps

- [Enable Hotpatch for Azure Edition Server Core VM](/windows-server/get-started/enable-hotpatch-azure-edition).
- Learn more about [Windows Server Azure Edition VMs](windows-server-azure-edition.md).
