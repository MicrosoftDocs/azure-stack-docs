---
title: Prerequisites to deploy Azure Stack HCI, version 23H2 (preview)
description: Learn about the prerequisites to deploy Azure Stack HCI, version 23h2 (preview).
author: alkohli
ms.topic: conceptual
ms.date: 10/13/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Review deployment prerequisites for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article discusses the security, software, hardware, and networking prerequisites in order to deploy Azure Stack HCI.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Security considerations

Review the [security considerations](../manage/preview-channel.md) for Azure Stack HCI and [assess environment readiness](../manage/use-environment-checker.md) by using the Environment Checker. If you plan to use the standalone version of the Environment Checker on an Azure Stack HCI cluster node, make sure to uninstall it before starting deployment. This will help you avoid any potential conflicts that could arise during the deployment process.

## Server and storage requirements

Before you begin, make sure that the physical server and storage hardware used to deploy the solution meets the following requirements:

- A standard Azure Stack HCI cluster requires a minimum of one server and a maximum of 16 servers. All servers be the same manufacturer and model, using the same types of drives and the same number of each type.

- Each server in the cluster should have dedicated volumes for logs, with log storage at least as fast as data storage. Stretched clusters require at least two volumes: one for replicated data and one for log data.

- Direct-attached SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each.

|Component|Minimum|
|--|--|
|CPU|A 64-bit Intel Nehalem grade or AMD EPYC or later compatible processor with second-level address translation (SLAT).|
|Memory|A minimum of 32 GB RAM per node.|
|Host network adapters|At least two network adapters listed in the Windows Server Catalog. Or dedicated network adapters per intent, which does require two separate adapters for storage intent. For more information, see [Windows Server Catalog](https://www.windowsservercatalog.com/).|
|BIOS|Intel VT or AMD-V must be turned on.|
|Boot drive|A minimum size of 200 GB size.|
|Data drives|At least 2 disks with a minimum capacity of 500 GB (SSD or HDD).|
|TPM|TPM 2.0 hardware must be present and turned on.|
|Secure boot|Secure Boot must be present and turned on.|

> [!IMPORTANT]
> **NOT SUPPORTED**: RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple servers, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths. Host-bus adapter (HBA) cards must implement simple pass-through mode for any storage devices used for Storage Spaces Direct.

## Network requirements

Before you begin, make sure that the physical network and the host network where the solution is deployed meet the requirements described in:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)

## Firewall requirements

Before you begin, make sure that the firewall where the solution is deployed meets the requirements described in:

- [Firewall requirements](../concepts/firewall-requirements.md)

## Next steps

- Review the [deployment checklist](deployment-checklist.md).