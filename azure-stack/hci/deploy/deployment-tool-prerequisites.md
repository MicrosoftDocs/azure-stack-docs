---
title: Prerequisites to deploy Azure Stack HCI (preview)
description: Learn about the prerequisites to deploy Azure Stack HCI (preview).
author: alkohli
ms.topic: conceptual
ms.date: 05/30/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Review deployment prerequisites for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article discusses the security, software, hardware, and networking prerequisites in order to deploy Azure Stack HCI.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Security considerations

Review the [security considerations](../manage/preview-channel.md) for Azure Stack HCI and [assess environment readiness](../manage/use-environment-checker.md) by using the Environment Checker. If you plan to use the standalone version of the Environment Checker on an Azure Stack HCI cluster node, make sure to uninstall it before running the Deployment Tool. This will help you avoid any potential conflicts that could arise during the deployment process.

## Software requirements

The Supplemental Package supports only the English version of the Azure Stack HCI operating system. Therefore, you must install Azure Stack HCI, version 22H2 operating system in English using the instructions in [Deploy Azure Stack HCI, version 22H2 OS](./deployment-tool-install-os.md).

## Hardware requirements

Before you begin, make sure that the physical hardware used to deploy the solution meets the following requirements:

|Component|Minimum|
|--|--|
|CPU|A 64-bit Intel Nehalem grade or AMD EPYC or later compatible processor with second-level address translation (SLAT).|
|Memory|A minimum of 32 GB RAM.|
|Host network adapters|At least two network adapters listed in the Windows Server Catalog. Or dedicated network adapters per intent, which does require two separate adapters for storage intent. For more information, see [Windows Server Catalog](https://www.windowsservercatalog.com/).|
|BIOS|Intel VT or AMD-V must be turned on.|
|Boot drive|A minimum size of 200 GB size.|
|Data drives|At least 3 disks with a minimum capacity of 500 GB (SSD or HDD).|
|TPM|TPM 2.0 hardware must be present and turned on.|
|Secure boot|Secure Boot must be present and turned on.|

## Network requirements

Before you begin, make sure that the physical network and the host network where the solution is deployed meet the requirements described in:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)

## Next steps

- Review the [deployment checklist](deployment-tool-checklist.md).