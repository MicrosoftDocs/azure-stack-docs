---
title: Delete a VM (virtual machine) with dependencies on Azure Stack Hub 
description: How to delete a VM (virtual machine) with dependencies on Azure Stack Hub
author: mattbriggs

ms.topic: how-to
ms.date: 06/03/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 06/03/2020
zone_pivot_groups: delete-vm

# Intent: As an Azure Stack user, I want to delete a VM with dependencies in Azure Stack Hub.
# Keyword: virtual machine delete

---

# How to delete a VM (virtual machine) with dependencies on Azure Stack Hub

In this article you can find the steps to remove a VM and its dependencies in Azure Stack Hub.

If you delete an Azure Stack Hub VM, Azure Stack Hub won't automatically remove the associated resources, such as the attached data disks, vNics, or the boot diagnostics disk storage container.

When you create a new VM you typically create a new resource group and put all the dependencies in that resource group. When you want to delete the VM and all its dependencies you can delete the resource group. The Azure Resource Manager will handle the dependencies to successfully delete them. There are times when you cannot delete the resource group in order to remove the VM. For example, the VM may contain resources that are not dependenices of the VM that you would like to keep.

::: zone pivot="delete-vm-portal"
[!INCLUDE [Delete a VM with dependencies using the portal](../includes/howto-vm-delete-portal.md)]
::: zone-end

::: zone pivot="delete-vm-ps"
[!INCLUDE [Delete a VM with dependencies using PowerShell](../includes/howto-vm-delete-ps.md)]
::: zone-end

## Next steps

[Azure Stack Hub VM features](azure-stack-vm-considerations.md)