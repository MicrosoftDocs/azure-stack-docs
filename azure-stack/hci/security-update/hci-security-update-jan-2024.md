---
title:  January 2024 OS security update (KB 5034130) for Azure Stack HCI, version 23H2
description: Read about the January 2024 OS security update (KB 5034130) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 03/20/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# January 2024 OS security update (KB 5034130) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the security update for Azure Stack HCI, version 23H2 that was released on January 9, 2024 and applies to OS build 25398.643.

<!--For an overview of Azure Stack HCI version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->


## Improvements

This security update includes quality improvements. When you install this KB:

- This update addresses an issue that affects the Trusted Sites Zone sign in policy. You can't manage it using mobile device management (MDM).

- This update addresses an issue that affects the ActiveX scroll bar. It doesn't work in IE mode.

- This update addresses an issue that causes your device to shut down after 60 seconds. This occurs when you use a smart card to authenticate on a remote system.

- This update addresses an issue that affects the display of a smart card icon. The icon doesn't appear when you sign in. This occurs when there are multiple certificates on the smart card.

- This update addresses an issue that affects the Key Distribution Service (KDS). It doesn't start in the time required if LDAP referrals are needed.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [January 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Jan).

<!--## Servicing stack update - 25398.640

This update makes quality improvements to the servicing stack, which is the component that installs Windows updates. Servicing stack updates (SSU) ensure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.-->

## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/en-us/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI via PowerShell](../update/update-via-powershell-23h2.md).

<!--| Release Channel | Available | Next Step |
|--| -- |--|
| Windows Update and Microsoft Update | Yes | None. This update is downloaded automatically from Windows Update. |
| Windows Update for Business | Yes | None. This update is downloaded automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the Microsoft Update Catalog website. |
| Windows Server Update Services (WSUS) | Yes | This update will automatically sync with WSUS if you configure **Products and Classifications** as follows:<br>**Product**: Azure Stack HCI<br>**Classification**: Security Updates |-->

<!--## To remove the LCU

To remove the LCU after installing the combined SSU and LCU package, use the DISM [Remove-WindowsPackage](/powershell/module/dism/remove-windowspackage) command line option with the LCU package name as the argument. You can find the package name by using this command: `DISM /online /get-packages`.

Running [Windows Update Standalone Installer](https://support.microsoft.com/topic/description-of-the-windows-update-standalone-installer-in-windows-799ba3df-ec7e-b05e-ee13-1cdae8f23b19) (wusa.exe) with the /uninstall switch on the combined package won't work because the combined package contains the SSU. You can't remove the SSU from the system after installation.-->

## File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5034130](https://go.microsoft.com/fwlink/?linkid=2257353).

<!--For a list of the files that are provided in the servicing stack update, download the file information for the [SSU - version 25398.640](https://go.microsoft.com/fwlink/?linkid=2257446).-->


## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.