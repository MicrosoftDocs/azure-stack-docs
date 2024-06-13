---
title: Overview for Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2
description: Learn about Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2.
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 06/13/2024
---

# Introduction to Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article introduces Trusted launch for Azure Arc virtual machines (VMs) on Azure Stack HCI, version 23H2. You can create a Trusted launch Arc VM using Azure portal or by using Azure Command-Line Interface (CLI).


## Introduction

Trusted launch for Azure Arc VMs supports secure boot, virtual Trusted Platform Module (vTPM), and vTPM state transfer when a VM migrates or fails over within a cluster.

Trusted launch is a security type that can be specified when creating Arc VMs on Azure Stack HCI. For more information, see [Trusted launch for Azure Arc VMs on Azure Stack HCI](https://techcommunity.microsoft.com/t5/security-compliance-and-identity/trusted-launch-for-azure-arc-vms-on-azure-stack-hci-version-23h2/ba-p/3978051).

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

- IgvmAgent is a component that is installed on all nodes in the Azure Stack HCI cluster. It enables support for isolated VMs such as Trusted launch Arc VMs for example.

- As part of Trusted launch Arc VM creation, Hyper-V creates VM files on disk to store the VM state. By default, access to those VM files is restricted to host server administrators. Host administrators must ensure that the location where those VM files are stored always remains appropriately access-restricted.

- VM live migration network traffic is not encrypted. We strongly recommend that you enable a network layer encryption technology such as IPsec to protect live migration network traffic.

<!--- VM live migration network traffic is not encrypted. We strongly recommend that you enable IPsec to protect live migration network traffic. For more information, see [Network Recommendations for a Hyper-V Cluster](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn550728(v=ws.11)#How_to_isolate_the_network_traffic_on_a_Hyper-V_cluster).-->

## Guest operating system images

The following VM guest OS images from Azure Marketplace are supported. The VM image can be created using Azure portal or Azure CLI.

For more information, see [Create Azure Stack HCI VM image using Azure Marketplace](/azure-stack/hci/manage/virtual-machine-image-azure-marketplace?tabs=azurecli).

| Name | Publisher | Offer | SKU | Version number |
|---|---|---|---|---|
| Windows 11 Enterprise multi-session, version 22H2 - Gen2 | microsoftwindowsdesktop | windows-11  | win11-22h2-avd | 22621.2428.231001 |
| Windows 11 Enterprise multi-session, version 22H2 + Microsoft 365 Apps (preview) - Gen2 | microsoftwindowsdesktop | windows11preview | win11-22h2-avd-m365 | 22621.382.220810 |
| Windows 11 Enterprise multi-session, version 21H2 - Gen2 | microsoftwindowsdesktop  | windows-11  | win11-21h2-avd | 22000.2538.231001 |
| Windows 11 Enterprise multi-session, version 21H2 + Microsoft 365 Apps - Gen2 | microsoftwindowsdesktop | office-365 | win10-21h2-avd-m365-g2 | 19044.3570.231010 |

> [!NOTE]
> VM guest images obtained outside of Azure Marketplace are not supported.

## Next steps

- [Deploy Trusted launch Arc VMs](trusted-launch-vm-deploy.md).