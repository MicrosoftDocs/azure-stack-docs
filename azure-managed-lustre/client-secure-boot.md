---
title: Use Secure Boot with Azure Managed Lustre file system
description: Learn how Azure Managed Lustre client software behaves when Secure Boot is enabled on Trusted Launch and Confidential VMs, and how to configure secure boot keys when required.
ms.topic: concept
author: wolfang-desalvador
ms.author: wolfang-desalvador
ms.reviewer: rohogue
ms.date: 12/11/2025
---

# Use Secure Boot with Azure Managed Lustre file system

This article explains how Azure Managed Lustre client software behaves when Secure Boot is enabled on Azure virtual machines (VMs). It also describes when you must customize Secure Boot UEFI keys so that the Azure Managed Lustre kernel modules load successfully.

## When to use this article

Use this article if you:

- Plan to enable Secure Boot on Azure VMs that mount an Azure Managed Lustre file system.
- Use Trusted Launch VMs or Confidential VMs and want to confirm how the Azure Managed Lustre client behaves.

## How Azure Managed Lustre client signing works

Azure Managed Lustre client kernel modules are signed with the **Azure Services Linux Kmod PCA** certificate. When Secure Boot is enabled on a VM, the UEFI firmware and operating system verify that each boot component and kernel module is signed by a trusted certificate before it can run.

To load Azure Managed Lustre clients on a Secure Boot–enabled VM, the Azure Services Linux Kmod PCA certificate must be present in the VM's trusted key databases. The certificate can be provided either by the UEFI firmware itself or by a custom VM image that configures Secure Boot UEFI keys.

## Trusted Launch virtual machines

For VMs with **Trusted Launch** enabled, the Azure Services Linux Kmod PCA certificate is already included in the UEFI firmware provided by Azure. 

Because the certificate is trusted by default:

- Azure Managed Lustre client kernel modules can load when Secure Boot is enabled.
- You don't need any extra configuration to use the Azure Managed Lustre client on Trusted Launch VMs.

This default trust is intended to provide a smoother experience when you install and use Azure Managed Lustre client software with Secure Boot turned on. 

For more information about Secure Boot and UEFI key customization for Trusted Launch VMs, see [Trusted Launch secure boot custom UEFI keys](https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch-secure-boot-custom-uefi).

For more information about Trusted Launch VMs, see [Trusted launch for Azure virtual machines](https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch).

## Confidential virtual machines

For **Azure Confidential** VMs, the Azure Services Linux Kmod PCA certificate isn't included by default in the UEFI firmware. As a result, Secure Boot doesn't initially trust the signature of the Azure Managed Lustre kernel modules.

To successfully load and mount Azure Managed Lustre clients on Confidential VMs with Secure Boot enabled, you must add the Azure Services Linux Kmod PCA certificate into the VM image's trusted key databases by customizing the Secure Boot UEFI keys. 

For detailed guidance on customizing Secure Boot keys for Secure Boot–enabled Azure VMs, see [Trusted Launch secure boot custom UEFI keys](https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch-secure-boot-custom-uefi).

For an overview of Confidential VMs, see [What are Azure confidential virtual machines?](https://learn.microsoft.com/en-us/azure/confidential-computing/confidential-vm-overview).

## Related content

- Learn how to [install Azure Managed Lustre client software](client-install.md).
- Review how to [connect clients to an Azure Managed Lustre file system](connect-clients.md).


