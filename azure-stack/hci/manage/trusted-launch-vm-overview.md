---
title: Introduction to Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2 (preview)
description: Learn about Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2 (preview).
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/09/2023
---

# Introduction to Trusted launch for Azure Arc VMs on Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article introduces Trusted launch for Azure Arc virtual machines (VMs) on Azure Stack HCI, version 23H2. You can create a Trusted launch Arc VM using Azure portal or by using Azure Command-Line Interface (CLI).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Introduction

Trusted launch for Azure Arc VMs supports secure boot, virtual Trusted Platform Module (TPM), and VM guest boot integrity monitoring.

Trusted launch is a security type that is specified when creating Arc VMs on Azure Stack HCI.

## Capabilities and benefits

A few of the capabilities and benefits of using Trusted launch for Arc VMs include:

| Capability | Benefit |
| -- | -- |
| Secure boot. | Helps reduce risk of malware (rootkits) during boot by verifying that boot components are signed by trusted publishers. |
| vTPM. | Virtualized version of a hardware TPM that serves as a dedicated vault for keys, certificates, and secrets.  |
| vTPM. | Preserves virtual TPM state when the VM migrates or fails over within a cluster. |
| Virtualization-based security (VBS). | Guest in the VM can create isolated regions of memory using VBS support. |

> [!NOTE]
> VM guest boot integrity verification is only supported in supported Azure regions.

## Guest operating system images

The following VM guest OS images from Azure Marketplace are supported. 

| Name | Publisher | Offer | SKU | Version number |
| -- | -- | -- | -- | -- |
| Windows 11 Enterprise multi-session, version 22H2 - Gen2 | microsoftwindowsdesktop | windows-11  | win11-22h2-avd | 22621.2428.231001 |
| Windows 11 Enterprise multi-session, version 22H2 + Microsoft 365 Apps (preview) - Gen2 | microsoftwindowsdesktop | windows11preview | win11-22h2-avd-m365 | 22621.382.220810 |
| Windows 11 Enterprise multi-session, version 21H2 - Gen2 | microsoftwindowsdesktop  | windows-11  | win11-21h2-avd | 22000.2538.231001 |
| Windows 11 Enterprise multi-session, version 21H2 + Microsoft 365 Apps - Gen2 | microsoftwindowsdesktop | office-365 | win10-21h2-avd-m365-g2 | 19044.3570.231010 |

Run the following example command to download a guest image:

```PowerShell
az stack-hci-vm image create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $Location --name "WS2022DataCenter-AE" --os-type $osType --offer "windowsserver" --publisher "microsoftwindowsserver" --sku "2022-datacenter-azure-edition" --version "20348.1970.230905"
```

> [!NOTE]
> VM guest images obtained outside of Azure Marketplace are not supported.

## Next steps

- [Deploy Trusted launch Arc VMs](trusted-launch-vm-deploy.md).