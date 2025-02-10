---
title:  October 2024 security update (KB 5044288) for Azure Local, version 23H2
description: Read about the October 2024 security update (KB 5044288) for Azure Local, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 01/28/2025
ms.author: alkohli
ms.reviewer: alkohli
monikerRange: "=azloc-24082"
---

# October OS security update (KB 5044288) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This article describes the OS security update for Azure Local that was released on October 8, 2024 and applies to OS build 25398.1189.

<!--For an overview of Azure Local, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. The following key issues and new features are present in this update:

- **Microsoft Defender for Endpoint**: Work Folders files fail to sync when Defender for Endpoint is on.

- **Input Method Editor (IME)** When a combo box has input focus, a memory leak might occur when you close that window.

- **AppLocker** The rule collection enforcement mode is not overwritten when rules merge with a collection that has no rules. This occurs when the enforcement mode is set to “Not Configured”.

- **Remote Desktop Gateway Service** The service stops responding. This occurs when a service uses remote procedure calls (RPC) over HTTP. Because of this, the clients that are using the service disconnect.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [October 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Oct).

## Known issues

Microsoft is not currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5044288](https://go.microsoft.com/fwlink/?linkid=2289974).

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Local.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Local.