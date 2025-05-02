---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 04/10/2025
---

- Access to an Azure subscription with the appropriate RBAC role and permissions assigned. For more information, see [RBAC roles for Azure Local VM management](../manage/assign-vm-rbac-roles.md#about-built-in-rbac-roles).
- Access to a resource group where you want to provision the VM.
- Access to one or more VM images on your Azure Local. These VM images could be created by one of the following procedures:
    - [VM image starting from an image in Azure Marketplace](../manage/virtual-machine-image-azure-marketplace.md).
    - [VM image starting from an image in Azure Storage account](../manage/virtual-machine-image-storage-account.md).
    - [VM image starting from an image in a local share](../manage/virtual-machine-image-local-share.md).
- A custom location for your Azure Local that you'll use to provision VMs. The custom location will also show up in the **Overview** page for Azure Local.