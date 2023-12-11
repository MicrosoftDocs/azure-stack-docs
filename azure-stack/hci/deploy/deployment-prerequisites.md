---
title: Prerequisites to deploy Azure Stack HCI, version 23H2 (preview)
description: Learn about the prerequisites to deploy Azure Stack HCI, version 23h2 (preview).
author: alkohli
ms.topic: conceptual
ms.date: 12/08/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Review deployment prerequisites for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article discusses the security, software, hardware, and networking prerequisites in order to deploy Azure Stack HCI, version 23H2.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Security considerations

Review the [security considerations](../manage/preview-channel.md) for Azure Stack HCI.

## Environment readiness

[Assess deployment readiness of your environment](../manage/use-environment-checker.md) by using the Environment Checker. If you plan to use the standalone version of the Environment Checker on an Azure Stack HCI server, make sure to uninstall it before starting deployment. This will help you avoid any potential conflicts that could arise during the deployment process.

## Server and storage requirements

Before you begin, make sure that the physical server and storage hardware used to deploy an Azure Stack HCI cluster meets the following requirements:

|Component|Minimum|
|--|--|
|Number of servers| 1 to 16 servers are supported. <br> Each server must be the same model, manufacturer, have the same network adapters, and have the same number and type of storage drives.|
|CPU|A 64-bit Intel Nehalem grade or AMD EPYC or later compatible processor with second-level address translation (SLAT).|
|Memory|A minimum of 32 GB RAM per node.|
|Host network adapters|At least two network adapters listed in the Windows Server Catalog. Or dedicated network adapters per intent, which does require two separate adapters for storage intent. For more information, see [Windows Server Catalog](https://www.windowsservercatalog.com/).|
|BIOS|Intel VT or AMD-V must be turned on.|
|Boot drive|A minimum size of 200 GB size.|
|Data drives|At least 2 disks with a minimum capacity of 500 GB (SSD or HDD).|
|Trusted Platform Module (TPM)|TPM version 2.0 hardware must be present and turned on.|
|Secure boot|Secure Boot must be present and turned on.|

The servers should also meet the following additional requirements: 

- Each server should have dedicated volumes for logs, with log storage at least as fast as data storage. 

- Have direct-attached drives that are physically attached to one server each. RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple servers, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths, are not supported.

    > [!NOTE]
    > Host-bus adapter (HBA) cards must implement simple pass-through mode for any storage devices used for Storage Spaces Direct.

## Network requirements

Before you begin, make sure that the physical network and the host network where the solution is deployed meet the requirements described in:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)

## Firewall requirements

Before you begin, make sure that the firewall where the solution is deployed meets the requirements described in:

- [Firewall requirements](../concepts/firewall-requirements.md)

## Next steps

- Review the [deployment checklist](deployment-checklist.md).
