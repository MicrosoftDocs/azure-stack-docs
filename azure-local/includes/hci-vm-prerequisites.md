---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 04/10/2025
---

- You need to have access to an Azure subscription with the appropriate Azure role-based access control (RBAC) role and permissions assigned. For more information, see [RBAC roles for Azure Local VM management](../manage/assign-vm-rbac-roles.md#about-built-in-rbac-roles).
- You need to have access to a resource group where you want to provision the VM.
- You need to have access to one or more VM images on your Azure Local instance. These VM images can be created by using one of the following procedures:

    - [VM image starting from an image in Azure Marketplace](../manage/virtual-machine-image-azure-marketplace.md).
    - [VM image starting from an image in an Azure Storage account](../manage/virtual-machine-image-storage-account.md).
    - [VM image starting from an image in a local share](../manage/virtual-machine-image-local-share.md).
- You need to have a custom location for your Azure Local instance that you use to provision VMs. The custom location shows up on the **Overview** page for your Azure Local instance.