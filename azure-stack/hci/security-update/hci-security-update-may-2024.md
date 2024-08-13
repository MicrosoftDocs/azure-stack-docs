---
title:  May 2024 security update (KB 5037781) for Azure Stack HCI, version 23H2
description: Read about the May 2024 security update (KB 5037781) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 05/14/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# May 2024 OS security update (KB 5037781) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on May 14, 2024 and applies to OS build 25398.887.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. When you install this KB:

- This update affects Windows Defender Application Control (WDAC). The update addresses an issue that might cause some applications to fail when you apply WDAC Application ID policies.

- This update addresses an issue that affects IE mode. A web page may stop working as expected when there's an open modal dialog.

- This update addresses an issue that affects IE mode. It stops responding. This occurs if you press the left arrow key when an empty text box has focus and caret browsing is on.

- This update addresses an issue that affects Wi-Fi Protected Access 3 (WPA3) in the Group Policy editor. HTML preview rendering fails.

- This update addresses an issue that affects Packet Monitor (pktmon). It's less reliable.

- This update addresses an issue that affects a server after you remove it from a domain. The `Get-LocalGroupMember` cmdlet returns an exception. This occurs if the local groups contain domain members.

- This update affects next secure record 3 (NSEC3) validation in a recursive resolver. Its limit is now 1,000 computations. One computation is equal to the validation of one label with one iteration. DNS Server Administrators can change the default number of computations. To do this, use the registry setting below:

    - Name: `\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DNS\Parameters\MaxComputationForNsec3Validation`
    - Type: DWORD
    - Default: 1000
    - Max: 9600
    - Min: 1

- This update addresses an issue that might affect the cursor when you type in Japanese. The cursor might move to an unexpected place.

- This update addresses an issue that affects the cursor. Its movement lags in some screen capture scenarios. This is especially true when you're using the remote desktop protocol (RDP).

- This update includes quarterly changes to the Windows Kernel Vulnerable Driver Blocklist file, `DriverSiPolicy.p7b`. It adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.

- This update addresses an issue that affects Trusted Platform Modules (TPM). On certain devices, they don't initialize correctly. Because of this, TPM-based scenarios stop working.

- This update addresses an issue that affects Active Directory. Bind requests to IPv6 addresses fail. This occurs when the requestor isn't joined to a domain.

- This update addresses an issue that might affect Virtual Secure Mode (VSM) scenarios. They might fail. These scenarios include VPN, Windows Hello, Credential Guard, and Key Guard.

- This update addresses an issue that might affect domain controllers. NTLM authentication traffic might increase.

- This update addresses a known issue that might cause your VPN connection to fail. This occurs after you install the update dated April 9, 2024 or later.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [May 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-May).


## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).


## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5037781](https://go.microsoft.com/fwlink/?linkid=2271901).


## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.
