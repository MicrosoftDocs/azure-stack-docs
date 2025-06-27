---
title: Overview for Trusted launch for Azure Local VMs enabled by Azure Arc
description: Learn about Trusted launch for Azure Local VMs enabled by Azure Arc.
ms.topic: concept-article
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 03/20/2025
---

# Introduction to Trusted launch for Azure Local VMs enabled by Azure Arc

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article introduces Trusted launch for Azure Local virtual machines (VMs) enabled by Azure Arc. You can create a Trusted launch for an Azure Local VM using the Azure portal or by using Azure Command-Line Interface (CLI).

## Introduction

Trusted launch for Azure Local VMs enables secure boot, installs a virtual Trusted Platform Module (vTPM) device, automatically transfers the vTPM state when the VM migrates or fails over to another machine within the system, and supports the ability to attest whether the VM started in a known good state.

Trusted launch is a security type that can be specified when you create Azure Local VMs. For more information, see [Trusted launch for Azure Local VMs enabled by Azure Arc](https://techcommunity.microsoft.com/t5/security-compliance-and-identity/trusted-launch-for-azure-arc-vms-on-azure-stack-hci-version-23h2/ba-p/3978051).

## Capabilities and benefits

| Capability | Benefit |
|----|----|
| Secure boot | Helps reduce risk of malware (rootkits) during boot by verifying that boot components are signed by trusted publishers. |
| vTPM | Virtualized version of a hardware TPM that serves as a dedicated vault for keys, certificates, and secrets.  |
| vTPM state transfer| Preserves vTPM when the VM migrates or fails over within a cluster. |
| Virtualization-based security (VBS) | Guest in the VM can create isolated regions of memory using VBS support. |

> [!NOTE]
> VM guest boot integrity verification isn't available.

## Guidance

- IgvmAgent is a component that is installed on all machines in the Azure Local system. It enables support for isolated VMs like Trusted launch for Azure Local VMs, for example.

- Trusted launch for Azure Local VMs currently supports only a select set of Azure Marketplace images. For a list of supported images, see [Guest operating system images](#guest-operating-system-images). When you create a Trusted launch VM in the Azure portal, the Image dropdown list shows only the images supported by Trusted launch. The Image dropdown appears blank if you select an unsupported image, including a custom image. The list also appears blank if none of the images available on your Azure Local system are supported by Trusted launch.

- As part of Trusted launch for Azure Local VM creation, Hyper-V creates VM files at a default location on disk to store the VM state. By default, access to those VM files is restricted to host server administrators only. If you store those VM files in a different location, you must ensure that the location is access restricted to host server administrators only.

- VM live migration network traffic isn't encrypted. We strongly recommend that you enable a network layer encryption technology such as IPsec to protect live migration network traffic.

## Guest operating system images

All Windows 11 images (excluding 24H2 Windows 11 SKUs) and Windows Server 2022 images from Azure Marketplace supported by Azure Local VMs are supported. See [Create Azure Local VM image using Azure Marketplace images](/azure-stack/hci/manage/virtual-machine-image-azure-marketplace?tabs=azurecli) for a list of all supported Windows 11 images.

> [!NOTE]
> VM guest images obtained outside of Azure Marketplace aren't supported.

## Backup and disaster recovery considerations

When working with Trusted launch for Azure Local VMs, make sure to understand the following key considerations and limitations related to backup and recovery:

- **Differences between Trusted launch for Azure Local VMs and standard Azure Local VMs**: Unlike standard Azure Local VMs, Trusted launch for Azure Local VMs uses a VM guest state protection key to protect the VM guest state, including the virtual TPM (vTPM) state, while at rest. The VM protection key is stored in a local key vault in the Azure Local system where the VM resides. Trusted launch for Azure Local VMs stores the VM guest state in two files: VM guest state and VM runtime state. To back up and restore a Trusted launch VM, a backup solution must back up and restore all the VM files, including guest state and the runtime state files, and additionally backup and restore the VM protection key.

- **Backup and disaster recovery tooling support**: Currently, Trusted launch for Azure Local VMs doesn't support any third-party or Microsoft-owned back up and disaster recovery tools, including but not limited to, Azure Backup, Azure Site Recovery, Veeam, and Commvault. If there arises a need to move a Trusted launch for Azure Local TVM to an alternate cluster, see the manual process [Manual backup and recovery of Trusted launch for Azure Local VMs](./trusted-launch-vm-import-key.md) to manage all the necessary files and VM protection key to ensure that the VM can be successfully restored.  

> [!NOTE]
> Trusted launch for Azure Local VMs restored on an alternate Azure Local system can't be managed from the Azure control plane.

## Next steps

- [Create Trusted launch for Azure Local VMs](create-arc-virtual-machines.md).
