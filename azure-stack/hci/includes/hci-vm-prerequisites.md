---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 06/21/2024
---

- Access to an Azure subscription with the appropriate RBAC role and permissions assigned. For more information, see [RBAC roles for Azure Stack HCI Arc VM management](../hci/manage/assign-vm-rbac-roles.md#about-builtin-rbac-roles).
- Access to a resource group where you want to provision the VM.
- Access to one or more VM images on your Azure Stack HCI cluster. These VM images could be created by one of the following procedures:
    - [VM image starting from an image in Azure Marketplace](../hci/manage/virtual-machine-image-azure-marketplace.md).
    - [VM image starting from an image in Azure Storage account](../hci/manage/virtual-machine-image-storage-account.md).
    - [VM image starting from an image in local share on your cluster](../hci/manage/virtual-machine-image-local-share.md).
- A custom location for your Azure Stack HCI cluster that you'll use to provision VMs. The custom location will also show up in the **Overview** page for Azure Stack HCI cluster.

