---
title:  July 2024 security update (KB 5040438) for Azure Stack HCI, version 23H2
description: Read about the July 2024 security update (KB 5040438) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 07/09/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# July 2024 OS security update (KB 5040438) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on July 9, 2024 and applies to OS build 25398.1005.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well.

- **Absent apps and features**. Some apps and features are absent after you upgrade to Windows 11.

- **[BCryptSignHash](/windows/win32/api/bcrypt/nf-bcrypt-bcryptsignhash) API known issue**. Because of this issue, the API returns `STATUS_INVALID_PARAMETER`. This occurs when callers use NULL padding input parameters for RSA signatures. This issue is more likely to occur when Customer-Managed Keys (CMKs) are in use, like on an Azure Synapse dedicated SQL pool.

- **Input Method Editor (IME)**. The candidate list fails to show or shows it in the wrong position.

- **Windows Presentation Foundation (WPF)**. A malformed Human Interface Device (HID) descriptor causes WPF to stop responding.

- **Handwriting panels and touch keyboards**. They do not appear when you use the tablet pen.

- ***HKLM\Software\Microsoft\Windows\DWM ForceDisableModeChangeAnimation (REG_DWORD)***. This is a new registry key. When you set its value to `1` (or a non-zero number), it turns off the display mode change animation. If the value is `0` or the key does not exist, the animation is set to on.

- **Remote Desktop MultiPoint Server**. A race condition causes the service to stop responding.

- **Windows Local Administrator Password Solution (LAPS)**. Post Authentication Actions (PAA) do not occur at the end of the grace period. Instead, they occur at restart.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [July 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Jul).

## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

The SSU for this update is KB 5040560, version 25398.1000.

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5040438](https://go.microsoft.com/fwlink/?linkid=).

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.
