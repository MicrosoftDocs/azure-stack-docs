---
title:  March 2024 security update (KB 5035856) for Azure Stack HCI, version 23H2
description: Read about the March 2024 security update (KB 5035856) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 03/20/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# March 2024 OS security update (KB 5035856) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on March 20, 2024 and applies to OS build 25398.763.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. When you install this KB:

- This update addresses an issue that affects Windows Defender Application Control (WDAC). It prevents a stop error that occurs when you apply more than 32 policies.

- This update addresses an issue that makes the troubleshooting process fail. This occurs when you use the **Get Help** app.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [March 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Mar).

<!--## Servicing stack update - 25398.760

This update makes quality improvements to the servicing stack, which is the component that installs Windows updates. Servicing stack updates (SSU) ensure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.-->

## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).

<!--| Release Channel | Available | Next Step |
|--| -- |--|
| Windows Update and Microsoft Update | Yes | None. This update is downloaded automatically from Windows Update. |
| Windows Update for Business | Yes | None. This update is downloaded automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the Microsoft Update Catalog website. |
| Windows Server Update Services (WSUS) | Yes | This update automatically syncs with WSUS if you configure Products and Classifications as follows:<br>Product: Azure Stack HCI<br>Classification: Security Updates |-->


## File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5035856](https://go.microsoft.com/fwlink/?linkid=2263215).



## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.