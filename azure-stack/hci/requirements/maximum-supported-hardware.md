---
title: Maximum supported hardware specifications for Azure Stack HCI
description: Use this topic to make sure you do not exceed the maximum supported hardware specifications for Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/15/2020
---

# Maximum supported hardware specifications for Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2

Use this topic to make sure you do not exceed the maximum supported hardware specifications for Azure Stack HCI.

## Review maximum supported hardware specifications

Azure Stack HCI deployments that exceed the following specifications are not supported:

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 16      |
| VMs per host                 | 1,024   |
| Disks per VM (SCSI)          | 256     |
| Storage per cluster          | 4 PB    |
| Storage per server           | 400 TB  |
| Logical processors per host  | 512     |
| RAM per host                 | 24 TB   |
| RAM per VM                   | 12 TB (generation 2 VM) or 1 TB (generation 1)|
| Virtual processors per host  | 2,048   |
| Virtual processors per VM    | 240 (generation 2 VM) or 64 (generation 1)|

## Next steps

For related information, see also:

- [Server requirements for Azure Stack HCI](server-requirements.md)
- [Networking requirements for Azure Stack HCI](networking-requirements.md)
- [Storage requirements for Azure Stack HCI](storage-requirements.md)
