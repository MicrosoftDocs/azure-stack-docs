---
title: Use Secure Boot with Azure Managed Lustre file system
description: Learn to configure secure boot keys with Azure Managed Lustre file system.
ms.topic: how-to
author: wolfgang-desalvador
ms.author: wdesalvador
ms.reviewer: rohogue
ms.date: 04/23/2026
---

# Use Secure Boot with Azure Managed Lustre file system

This article explains how Azure Managed Lustre client software behaves when Secure Boot is enabled on Azure virtual machines (VMs). It also describes when you must customize Secure Boot Unified Extensible Firmware Interface (UEFI) keys so that the Azure Managed Lustre kernel modules load successfully.

## When to use this article

Use this article if you:

- Plan to enable Secure Boot on Azure VMs that mount an Azure Managed Lustre file system.
- Use Trusted Launch VMs or Confidential VMs and want to confirm how the Azure Managed Lustre client behaves.

## How Azure Managed Lustre client signing works

Azure Managed Lustre client kernel modules are signed with the **Azure Services Linux Kmod PCA** certificate. When Secure Boot is enabled on a VM, the UEFI firmware and operating system verify that each boot component and kernel module is signed by a trusted certificate before it can run.

To load Azure Managed Lustre clients on a Secure Boot–enabled VM, the Azure Services Linux Kmod PCA certificate must be present in the VM's trusted key databases. The certificate can come from either the UEFI firmware or from a custom VM image that configures Secure Boot UEFI keys.

## Trusted Launch virtual machines

For VMs with **Trusted Launch** enabled, the Azure Services Linux Kmod PCA certificate is already included in the UEFI firmware provided by Azure.

Because the certificate is trusted by default:

- Azure Managed Lustre client kernel modules can load when Secure Boot is enabled.
- You don't need any extra configuration to use the Azure Managed Lustre client on Trusted Launch VMs.

This default trust is intended to provide a smoother experience when you install and use Azure Managed Lustre client software with Secure Boot turned on.

For more information about Secure Boot and UEFI key customization for Trusted Launch VMs, see [Trusted Launch secure boot custom UEFI keys](/azure/virtual-machines/trusted-launch-secure-boot-custom-uefi).

For more information about Trusted Launch VMs, see [Trusted launch for Azure virtual machines](/azure/virtual-machines/trusted-launch).

## Confidential virtual machines

For **Azure Confidential** VMs, the Azure Services Linux Kmod PCA certificate isn't included by default in the UEFI firmware. As a result, Secure Boot doesn't initially trust the signature of the Azure Managed Lustre kernel modules.

To successfully load and mount Azure Managed Lustre clients on Confidential VMs with Secure Boot enabled, you must add the Azure Services Linux Kmod PCA certificate into the VM image's trusted key databases by customizing the Secure Boot UEFI keys.

For detailed guidance on customizing Secure Boot keys for Secure Boot–enabled Azure VMs, see [Trusted Launch secure boot custom UEFI keys](/azure/virtual-machines/trusted-launch-secure-boot-custom-uefi).

For an overview of Confidential VMs, see [What are Azure confidential virtual machines?](/azure/confidential-computing/confidential-vm-overview).

## DKMS-compiled modules and Secure Boot

When you install the Lustre client by using the **DKMS** method, the installation process compiles the kernel module from source on your VM instead of using a prebuilt and Microsoft-signed module. Because DKMS-compiled modules aren't signed by the Azure Services Linux Kmod PCA certificate, they don't load when Secure Boot is enabled unless you take extra steps.

If you use DKMS with Secure Boot enabled, you have two options:

- **Disable Secure Boot**: The simplest approach. If your security policy permits it, disable Secure Boot on the VM before installing the DKMS package.
- **Enroll a Machine Owner Key (MOK)**: Configure DKMS to sign modules with a self-generated key and enroll it in the UEFI MOK database. This approach maintains Secure Boot while allowing DKMS-compiled modules to load. For MOK enrollment instructions, refer to your distribution's DKMS documentation.

> [!NOTE]
> **Azure Linux 3 considerations**: Azure Linux 3 enables [kernel lockdown](https://man7.org/linux/man-pages/man7/kernel_lockdown.7.html) in integrity mode by default through the `lockdown=integrity` boot parameter. Kernel lockdown blocks loading of unsigned kernel modules independently of Secure Boot, so disabling Secure Boot alone doesn't let DKMS-compiled modules load on Azure Linux 3. To use DKMS on Azure Linux 3, **enroll a Machine Owner Key (MOK)** as described in the previous bullet. Removing the `lockdown=integrity` parameter from the boot configuration also lets unsigned modules load, but isn't recommended because it weakens the platform's security baseline.

> [!NOTE]
> If you use the **prebuilt kmod** install method, Secure Boot works without any extra configuration on Trusted Launch VMs (as described earlier). The DKMS Secure Boot limitation applies only to DKMS-compiled modules.

## Related content

- Learn how to [install Azure Managed Lustre client software](client-install.md).
- Review how to [connect clients to an Azure Managed Lustre file system](connect-clients.md).
