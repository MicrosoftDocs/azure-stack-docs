---
title: Overview for Trusted launch for Azure Arc VMs on Azure Local, version 23H2
description: Learn about Trusted launch for Azure Arc VMs on Azure Local, version 23H2.
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.service: azure-stack-hci
ms.date: 01/07/2025
---

# Introduction to Trusted launch for Azure Arc VMs on Azure Local, version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article introduces Trusted launch for Azure Arc virtual machines (VMs) on Azure Local, version 23H2. You can create a Trusted launch Arc VM using Azure portal or by using Azure Command-Line Interface (CLI).


## Introduction

Trusted launch for Azure Arc VMs enables secure boot, installs a virtual Trusted Platform Module (vTPM) device, automatically transfers the vTPM state when the VM migrates or fails over to another machine within the system, and supports the ability to attest whether the VM started in a known good state.

Trusted launch is a security type that can be specified when creating Arc VMs on Azure Local. For more information, see [Trusted launch for Azure Arc VMs on Azure Local](https://techcommunity.microsoft.com/t5/security-compliance-and-identity/trusted-launch-for-azure-arc-vms-on-azure-stack-hci-version-23h2/ba-p/3978051).

## Capabilities and benefits

| Capability | Benefit |
|----|----|
| Secure boot | Helps reduce risk of malware (rootkits) during boot by verifying that boot components are signed by trusted publishers. |
| vTPM | Virtualized version of a hardware TPM that serves as a dedicated vault for keys, certificates, and secrets.  |
| vTPM state transfer| Preserves vTPM when the VM migrates or fails over within a cluster. |
| Virtualization-based security (VBS) | Guest in the VM can create isolated regions of memory using VBS support. |

> [!NOTE]
> VM guest boot integrity verification is not available.

## Guidance

- IgvmAgent is a component that is installed on all machines in the Azure Local system. It enables support for isolated VMs such as Trusted launch Arc VMs for example.

- As part of Trusted launch Arc VM creation, Hyper-V creates VM files at a default location on disk to store the VM state. By default, access to those VM files is restricted to host server administrators only. If you store those VM files in a different location, you must ensure that the location is access restricted to host server administrators only.

- VM live migration network traffic is not encrypted. We strongly recommend that you enable a network layer encryption technology such as IPsec to protect live migration network traffic.

<!--- VM live migration network traffic is not encrypted. We strongly recommend that you enable IPsec to protect live migration network traffic. For more information, see [Network Recommendations for a Hyper-V Cluster](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn550728(v=ws.11)#How_to_isolate_the_network_traffic_on_a_Hyper-V_cluster).-->

## Guest operating system images

All Windows 11 images from Azure Marketplace supported by Azure Arc VMs are supported. See [Create Azure Local VM image using Azure Marketplace images](/azure-stack/hci/manage/virtual-machine-image-azure-marketplace?tabs=azurecli) for a list of all supported Windows 11 images.

> [!NOTE]
> VM guest images obtained outside of Azure Marketplace are not supported.

## Next steps

- [Deploy Trusted launch Arc VMs](trusted-launch-vm-deploy.md).
