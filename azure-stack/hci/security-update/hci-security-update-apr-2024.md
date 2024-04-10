---
title:  April 2024 security update (KB 5036910) for Azure Stack HCI, version 23H2
description: Read about the April 2024 security update (KB 5036910) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 04/10/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# April 2024 OS security update (KB 5036910) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on April 16, 2024 and applies to OS build 25398.830.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. When you install this KB:

- This update addresses an issue that affects Windows Defender Application Control (WDAC). It prevents a stop error that occurs when you apply more than 32 policies.

- This update addresses an issue that makes the troubleshooting process fail. This occurs when you use the **Get Help** app.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [March 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Mar).


## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).


## File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5035856](https://go.microsoft.com/fwlink/?linkid=2263215).



## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.