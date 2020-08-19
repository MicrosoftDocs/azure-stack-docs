---
title: ove a specialized VM from on-premises to Azure Stack Hub
description: Learn how to move a specialized VM from on-premises to Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 8/18/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 8/18/2020

# Intent: As an Azure Stack Hub user, I wan to learn about how where to find more information developing solutions.
# Keywords: Develop solutions with Azure Stack Hub

---

# Move a specialized VM from on-premises to Azure Stack Hub

You can add a virtual machine (VM) image from your on-premesis environment. YOu can create your image as a virtual hard disk (VHD) and upload the image to a storage account in your Azure Stack Hub instance. You can then create a VM from the VHD.

## How to move an image

Custom images come in two forms: **generalized** and **specialized**.

- **Generalized image**

  A generalized disk image is one that has been prepared with **Sysprep** to remove any unique information (such as user accounts), enabling it to be reused to create multiple VMs. This is a good option for marketplace items.

- **Specialized image**

  A specialized disk image is a copy of a virtual hard disk (VHD) from an existing VM that contains the user accounts, applications, and other state data from your original VM. This is typically the format in which VMs are migrated to Azure Stack Hub.

#### [Portal - Windows VM](#tab/port-win)

This is a stub.

#### [Portal - Linux VM](#tab/port-linux)

This is a stub.

#### [PowerShell - Windows VM](#tab/ps-win)

This is a stub.

#### [PowerShell - Linux VM](#tab/port-linux)

This is a stub.

---

## Next steps

[DIntroduction to Azure Stack Hub VMs](azure-stack-compute-overview.md)
