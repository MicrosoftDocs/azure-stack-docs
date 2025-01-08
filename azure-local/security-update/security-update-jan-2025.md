---
title:  January 2025 security update (KB5049984) for Azure Local, version 23H2
description: Read about the January 2025 security update (KB5049984) for Azure Local, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 01/08/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# January OS security update (KB5049984) for Azure Local, version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Local, version 23H2 that was released on January 14, 2025 and applies to OS build 25398.1362.

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Virtual machine (VM) Fixed]**: A Windows guest machine fails to start up. This occurs when you turn on nested virtualization on a host that supports Advanced Vector Extensions 10 (AVX10).  

- **[Windows Kernel Vulnerable Driver Blocklist file (DriverSiPolicy.p7b)]** This update adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [January 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Jan).

## Known issues

Microsoft is not currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5049984](security-update-jan-2025.md).


## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Local, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Local, version 23H2.