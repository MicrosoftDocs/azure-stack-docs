---
title: Prerequisites to deploy Azure Stack HCI, version 23H2
description: Learn about the prerequisites to deploy Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 01/26/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Review deployment prerequisites for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article discusses the security, software, hardware, and networking prerequisites in order to deploy Azure Stack HCI, version 23H2.

## Security considerations

Review the [security features](../concepts/security-features.md) for Azure Stack HCI.

## Environment readiness

[Assess deployment readiness of your environment](../manage/use-environment-checker.md) by using the Environment Checker. If you plan to use the standalone version of the Environment Checker on an Azure Stack HCI server, make sure to uninstall it before starting deployment. This will help you avoid any potential conflicts that could arise during the deployment process.

## Server and storage requirements

Before you begin, make sure that the [server and storage requirements](../concepts/system-requirements-23h2.md#server-and-storage-requirements) are met by the server hardware used to deploy an Azure Stack HCI system.

## Network requirements

Before you begin, make sure that the physical network and the host network where the solution is deployed meet the requirements described in:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)

## Firewall requirements

Before you begin, make sure that the firewall where the solution is deployed meets the requirements described in:

- [Firewall requirements](../concepts/firewall-requirements.md)

## Next steps

- Review the [deployment checklist](deployment-checklist.md).
