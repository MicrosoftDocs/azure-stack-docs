---
title:  October 2024 security update (KB 5044281) for Azure Stack HCI, version 23H2
description: Read about the October 2024 security update (KB 5044281) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 10/11/2024
ms.author: alkohli
ms.reviewer: alkohli
---

# October OS security update (KB 5044281) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on October 8, 2024 and applies to OS build 20349.2762.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. The following key issues and new features are present in this update:

- **Software Defined Networking (SDN)**: The new SDN API now performs better for large-scale deployments. Watch for load balancer connectivity issues after you install this update. If you have any, move the SDNAPI microservice to another node. An SDN admin can move the service. To do that, use the `Move-ServiceFabricPrimaryReplica` PowerShell cmdlet.

- **MSIX applications** Fixed: When you install them from an HTTPS URI, they fail to open. This issue occurs when the download of the app is not complete. This damages the package.

- **Task Manager** Fixed: It stops responding when you select the **Performance** tab.

- **Direct Composition batched presentations** Fixed: A brief flash of triangles or boxes show on the screen. This issue affects browsers, like Microsoft Edge, and other apps.

- **Input Method Editor (IME)** Fixed: When a combo box has input focus, a memory leak might occur when you close that window.

- **AppLocker** Fixed: The rule collection enforcement mode is not overwritten when rules merge with a collection that has no rules. This occurs when the enforcement mode is set to "Not Configured".

- **Remote Desktop Gateway Service** Fixed: The service stops responding. This occurs when a service uses remote procedure calls (RPC) over HTTP. Because of this, clients that are using the service disconnect.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [October 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Oct).

## Known issues

Microsoft is not currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5044281](https://go.microsoft.com/fwlink/?linkid=2290060).

For a list of the files that are provided in just the servicing stack update, download the file information for [SSU update KB5044414 - version 20349.2750. ](https://go.microsoft.com/fwlink/?linkid=2290061).

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.