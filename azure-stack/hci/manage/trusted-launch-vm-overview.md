---
title: Introduction to Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2 (preview)
description: Learn about Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2 (preview).
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/08/2023
---

# Introduction to Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article introduces Trusted launch for Azure Arc virtual machines (VMs) on Azure Stack HCI, version 23H2. You can create a Trusted launch Arc VM using Azure portal or by using Azure Command-Line Interface (CLI).

## Introduction

Trusted launch for Azure Arc VMs supports secure boot, virtual TPM (trusted platform module), and VM guest boot integrity monitoring.

Trusted launch is a security type that is specified when creating Arc VMs on Azure Stack HCI.

## Capabilities and benefits

A few of the capabilities and benefits of using Trusted launch for Arc VMs include:

| Capability | Benefit |
| -- | -- |
| Secure boot. | Protection against malware-based rootkits and boot kits. Securely deploy VMs with verified boot loaders, OS kernels, and drivers. |
| vTPM. | Dedicated secure vault for keys and measurements. |
| vTPM. | Preserve virtual TPM (vTPM) state during VM migration or VM failover within an Azure Stack HCI cluster. This is of value to applications such as BitLocker that rely on vTPM state. |
| Virtualization-based security (VBS). | Guest operating system running in the VM must enable and make use of VBS. |

> [!NOTE]
> VM guest boot integrity verification is only supported in supported Azure regions.

## Guest operating system images

The following VM guest OS images from Azure Marketplace are supported:

| Name | Publisher | SKU | Version number |
| -- | -- | -- | -- |
| Windows 11 Enterprise multi-session, version 22H2 - Gen2 | microsoftwindowsdesktop | win11-22h2-avd | 22621.2428.231001 |
| Windows 11 Enterprise multi-session, version 22H2 + Microsoft 365 Apps (preview) - Gen2 | microsoftwindowsdesktop | win11-22h2-avd-m365 | 22621.382.220810 |
| Windows 11 Enterprise multi-session, version 21H2 - Gen2 | microsoftwindowsdesktop  | win11-21h2-avd | 22000.2538.231001 |
| Windows 11 Enterprise multi-session, version 21H2 + Microsoft 365 Apps - Gen2 | microsoftwindowsdesktop | win10-21h2-avd-m365-g2 | 19044.3570.231010 |

> [!NOTE]
> VM guest images obtained outside of Azure Marketplace are not supported.

## Next steps

- [Deploy Trusted launch Arc VMs](trusted-launch-vm-deploy.md).