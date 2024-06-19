---
title:  June 2024 security update (KB 5039236) for Azure Stack HCI, version 23H2
description: Read about the June 2024 security update (KB 5039236) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 06/19/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# June 2024 OS security update (KB 5039236) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on June 19, 2024 and applies to OS build 25398.950.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. When you install this KB:

- This update affects Server Message Block (SMB) over Quick UDP Internet Connections (QUIC). It turns on the SMB over QUIC client certificate authentication feature. Administrators can use it to restrict which clients can access SMB over QUIC servers. For more information, see [Configure SMB over QUIC client access control in Windows Server](/windows-server/storage/file-server/configure-smb-over-quic-client-access-control).

- This update affects the version of **curl.exe** that is in Windows. The version number is now 8.7.1.  

- This update addresses an issue that affects **lsass.exe**. It stops responding. This occurs after you install the April 2024 security updates on Windows servers.

- This update addresses an issue that affects Microsoft Edge. The UI is wrong for the **Internet Options Data Settings**.  

- This update affects the Antimalware Scan Interface (AMSI) **AmsiUtil** class. It helps to detect the bypass of the AMSI scan. This update also addresses some long-term issues that expose your device to threats.  

- This update addresses an issue that affects Storage Spaces Direct (S2D) and Remote Direct Memory Access (RDMA). When you use them with SMBdirect in your networks, the networks fail. You also lose the ability to manage clusters.  

- This update addresses an issue that affects **dsamain.exe**. It stops responding. This occurs when the Knowledge Consistency Checker (KCC) runs evaluations.  

- This update addresses an issue that affects **lsass.exe**. It leaks memory. This occurs during a Local Security Authority (Domain Policy) Remote Protocol (LSARPC) call.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [June 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-June).

## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5039236](https://go.microsoft.com/fwlink/?linkid=2275128).

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.
