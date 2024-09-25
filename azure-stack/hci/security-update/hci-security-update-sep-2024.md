---
title:  September 2024 security update (KB 5043055) for Azure Stack HCI, version 23H2
description: Read about the September 2024 security update (KB 5043055) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 09/25/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# September OS security update (KB 5043055) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on September 10, 2024 and applies to OS build 25398.1128.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. The following key issues and new features are present in this update:

- **Windows Installer** When repairing an application, the User Account Control (UAC) doesn't prompt for your credentials. After you install this update, the UAC will then prompt for them. Because of this, you must update your automation scripts. Application owners must add the Shield icon. It indicates that the process requires full administrator access. To turn off the UAC prompt, set the `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer\DisableLUAInRepair` registry value to `1`.

    The changes in this update might affect automatic Windows Installer repairs - see [Application Resiliency: Unlock the Hidden Features of Windows Installer](/previous-versions/dotnet/articles/aa302344(v=msdn.10)).  

- **BitLocker** You might not be able to decrypt a BitLocker data drive. This occurs when you move that drive from a newer version of Windows to an older version.  

- **Unified Write Filter (UWF) Windows Management Instrumentation (WMI)** API calls to shut down or restart a system results in an `access denied` exception.  

- **Azure Virtual Desktop** A deadlock stops you from signing in to sessions.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [September 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-sep).

## Known issues

Microsoft is not currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5043055](https://go.microsoft.com/fwlink/?linkid=2278952).

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.