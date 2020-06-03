---
title: Delete a VM (virtual machine) with dependencies on Azure Stack Hub 
description: How to delete a VM (virtual machine) with dependencies on Azure Stack Hub
author: mattbriggs

ms.topic: how-to
ms.date: 03/23/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 03/23/2020
zone_pivot_groups: delete-vms

# Intent: As an Azure Stack user, I want to delete a VM with dependencies in Azure Stack Hub.
# Keyword: virtual machine delete

---

# How to delete a VM (virtual machine) with dependencies on Azure Stack Hub

In this article you can find the steps to remove a VM and its dependencies in Azure Stack Hub.

When you create a new VM you typically create a new resource group and put all the dependencies in that resource group. When you want to delete the VM and all its dependencies you can delete the resource group. The Azure Resource Manager will handle the dependencies to successfully delete them. There are times when you cannot delete the resource group in order to remove the VM. For example, the VM may contain resources that are not dependenices of the VM that you would like to keep.

::: zone pivot="delete-vm-portal>"
## Delete a VM with dependencies using the portal

In the case where we cannot delete the resource group (either the dependencies are not in the same resource group, or there are other resources ), follow the steps below:

1. Open the Azure Stack user portal.
2. Select **Virtual machines**. Find your virtual machine, and then select your machine to open the Virtual machine blade.
3. Make a note of the resource group that contains the VM and VM dependencies.
4. Select **Networking** and make note of the networking interface.
5. Select **Disks** and make note of the OS disk and data disks.
6. Return to the **Virtual machine** blade, and select **Delete**.
7. Select **Resource groups** and then select the resource group.
8. Delete the dependencies by manually selecting them and then select delete.
    1. Type `Yes`.
    2. Wait for the resource to be completely deleted.
    3. You can delete the next dependency.
::: zone-end

::: zone pivot="delete-vm-ps"
## Delete a VM with dependencies using PowerShell

In the case where we cannot delete the resource group (either the dependencies are not in the same resource group, or there are other resources ), follow the steps below:

Connect to the your Azure Stack Hub environment.

```powershell
get-help
```

Retrieve the VM information and name of dependencies.

```powershell
get-help
```

Delete the VM.

```powershell
get-help
```

Delete each dependency.

```powershell
get-help
```

## Next steps

[Azure Stack Hub VM features](azure-stack-vm-considerations.md)