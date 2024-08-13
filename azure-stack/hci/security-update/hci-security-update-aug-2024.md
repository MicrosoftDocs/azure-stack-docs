---
title:  August 2024 security update (KB 5041573) for Azure Stack HCI, version 23H2
description: Read about the August 2024 security update (KB 5041573) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 08/13/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# August 2024 OS security update (KB 5041573) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on August 13, 2024 and applies to OS build 25398.1085.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. The following key issues and features are present in this update:

- **Stability of clusters on Windows Server 2022**. Servers in the same cluster shutdown when you don't expect them to. This leads to high latency and network availability issues.  

- **Bootloader**. A race condition might stop a computer from starting. This occurs when you configure the bootloader to start many operating systems.  

- **Autopilot**. Using Autopilot to provision a Surface Laptop SE device fails.  

- **Windows Defender Application Control (WDAC)**. A memory leak occurs that might exhaust system memory as time goes by. This issue occurs when you provision a device.  

- **Protected Process Light (PPL) protections**. You can bypass them.  

- **Windows Kernel Vulnerable Driver Blocklist file (DriverSiPolicy.p7b)**. This update adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.  

- **NetJoinLegacyAccountReuse**. This update removes this registry key. For more information, see [KB 5020276 Net join: Domain join hardening changes](https://support.microsoft.com/topic/kb5020276-netjoin-domain-join-hardening-changes-2b65a0f3-1f4c-42ef-ac0f-1caaf421baf8).

- **BitLocker (known issue)**. A [BitLocker recovery screen](/windows/security/operating-system-security/data-protection/bitlocker/recovery-overview) shows when you start up your device. This occurs after you install the July 9, 2024, update. This issue is more likely to occur if [device encryption](https://support.microsoft.com/windows/turn-on-device-encryption-0c453637-bc88-5f74-5105-741561aae838) is on. Go to **Settings > Privacy & Security > Device encryption**. To unlock your drive, Windows might ask you to enter the recovery key from your Microsoft account.

- **Lock screen**. This update addresses CVE-2024-38143. As a result, the **Use my windows user account** check box isn't available on the lock screen to connect to Wi-Fi.

- **Secure Boot Advanced Targeting (SBAT) and Linux Extensible Firmware Interface (EFI)**. This update applies SBAT to systems that run Windows and stops vulnerable Linux EFI (shim bootloaders) from running. This update doesn't apply to systems that dual-boot Windows and Linux. After the update is applied, older Linux ISO images might not boot. If this occurs, work with your Linux vendor to get an updated ISO image.

- **Domain Name System (DNS)**. This update hardens DNS server security to address CVE-2024-37968. If the configurations of your domains aren't up to date, you might get the SERVFAIL error or a time-out.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [August 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Aug).

## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5041573](https://go.microsoft.com/fwlink/?linkid=2282056).

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.
