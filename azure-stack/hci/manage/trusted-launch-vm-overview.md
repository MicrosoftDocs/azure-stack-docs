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

This article introduces Trusted launch for Azure Arc virtual machines (VMs) on Azure Stack HCI, version 23H2. Trusted launch protects VMs against boot kits, rootkits, and kernel-level malware.

## Introduction

Trusted launch for Azure Arc VMs supports secure boot, virtual TPM (trusted platform module), and VM guest boot integrity monitoring.

Trusted launch is a security type that is specified when creating Arc VMs on Azure Stack HCI.

## Benefits

A few of the benefits of using Trusted launch include:

- Securely deploy VMs with verified boot loaders, OS kernels, and drivers.

- Protect VMs against boot malware such as rootkits and boot kits.

- Securely protect keys, certificates, and secrets in VMs.

- Preserve virtual TPM (vTPM) state during VM migration or VM failover within an Azure Stack HCI cluster. This is of value to applications such as BitLocker that rely on vTPM state.

- Verify boot integrity of the guest that runs in the virtual machine.

## Capabilities

The following capabilities are supported:

- Secure boot.
- vTPM.
- vTPM state transfer when VM migrates or fails over within a cluster.
- Virtualization-based security (VBS), provided that the guest operating system running in the VM can enable and make use of VBS.

> [!NOTE]
> VM guest boot integrity verification is only supported in supported Azure regions.

## Guest operating systems

The following VM guest images from Azure Marketplace are supported:

- Windows Server 2022 Datacenter: Azure Edition - Gen2
- Windows Server 2022 Datacenter: Azure Edition Core - Gen2
- Windows Server 2022 Datacenter: Azure Edition Hotpatch - Gen2
- Windows 11 Enterprise multi-session, version 22H2 - Gen2
- Windows 11 Enterprise multi-session, version 22H2 + Microsoft 365 Apps (Preview) - Gen2
- Windows 11 Enterprise multi-session, version 21H2- Gen2
- Windows 11 Enterprise multi-session, version 21H2 + Microsoft 365 Apps - Gen2
- Windows 10 Enterprise multi-session, version 21H2 - Gen2
- Windows 10 Enterprise multi-session, version 21H2 + Microsoft 365 Apps - Gen2

> [!NOTE]
> VM guest images obtained outside of Azure Marketplace are not supported.

## Next steps

- [Deploy Trusted launch Arc VMs](trusted-launch-arc-vm.md).