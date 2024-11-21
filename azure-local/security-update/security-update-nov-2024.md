---
title:  November 2024 security update (KB 5046618) for Azure Local, version 23H2
description: Read about the November 2024 security update (KB 5046618) for Azure Local, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 11/15/2024
ms.author: alkohli
ms.reviewer: alkohli
---

# November OS security update (KB) for Azure Local, version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Local, version 23H2 that was released on November 12, 2024 and applies to OS build 25398.1251.

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[FrameShutdownDelay]** Fixed: The browser ignores its value in the *HKLM\SOFTWARE\Microsoft\Internet Explorer\Main* registry key.  

- **[vmswitch]** Fixed: A VMswitch triggers a stop error. This occurs when you use Load Balancing and Failover (LBFO) teaming with two virtual switches on a virtual machine (VM). In this case, one virtual switch uses single root Input/Output Virtualization (SR-IOV).  

- **[Collector sets]** Fixed: They don't close properly when an exception occurs during startup or while the set is active. Because of this, the command to stop a collector set stops responding.  

- **[Windows Kernel Vulnerable Driver Blocklist file (DriverSiPolicy.p7b)]** This update adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.  

- **[Windows Backup]** Fixed: Backup sometimes fails. This occurs when a device has an Extensible Firmware Interface (EFI) system partition (ESP).

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [November 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Nov).

## Known issues

Microsoft is not currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB 5046618](https://go.microsoft.com/fwlink/?linkid=2296832).

For a list of the files that are provided just in the servicing stack update, download the [file information for the SSU (KB 5046717) - version 25398.1241](https://go.microsoft.com/fwlink/?linkid=2297213).

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Local, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Local, version 23H2.