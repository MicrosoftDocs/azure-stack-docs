---
title: Prerequisites for deploying Azure Stack HCI version 22H2 (preview)
description: Learn the prerequisites for deploying Azure Stack HCI version 22H2
author: dansisson
ms.topic: how-to
ms.date: 08/29/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Prerequisites for deploying Azure Stack HCI version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article discusses the security, software, hardware, and networking prerequisites in order to deploy Azure Stack HCI, version 22H2.

## Security considerations

Review the [security considerations](/manage/preview-channel.md) and [assess environment readiness](/manage/use-environment-checker.md) for version 22H2.

## Software requirements

You must set up the version 22H2 operating system to boot from a VHDX image file using the instructions in this article.

## Hardware requirements

Before you begin, make sure that the physical hardware used to deploy the solution meets the following requirements:

|Component|Minimum|
|--|--|
|CPU|A 64-bit Intel Nehalem grade or AMD EPYC or later compatible processor with second-level address translation (SLAT).|
|Memory|A minimum of 32 GB RAM.|
|Host network adapters|At least two network adapters listed in the Windows Server Catalog. Or dedicated network adapters per intent, which does require two separate adapters for storage intent.|
|BIOS|Intel VT or AMD-V must be turned on.|
|Boot drive|A minimum size of 200 GB size.|
|Data drives|At least 3 disks with a minimum capacity of 500 GB (SSD or HDD).|
|TPM|TPM 2.0 hardware must be present and turned on.|
|Secure boot|Secure boot must be present and turned on.|

## Network requirements

Before you begin, make sure that the physical network and the host network where the solution is deployed meet the requirements described in:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)

> [!NOTE]
> Advanced settings within the storage network configuration like iWarp or MTU changes are not supported in this release.

## Next steps

Review the [deployment checklist](deployment-tool-checklist.md).