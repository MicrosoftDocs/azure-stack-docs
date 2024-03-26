---
title:  February 2024 OS security update (KB 5034769) for Azure Stack HCI, version 23H2
description: Read about the February 2024 OS security update (KB 5034769) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 03/20/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# February 2024 OS security update (KB 5034769) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on February 13, 2024 and applies to OS build 25398.709.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. When you install this KB:

- This update affects software defined networking (SDN). You can now deploy SDN on Windows failover clustering. Service Fabric SDN deployment remains in support.

- This update addresses a handle leak in Windows Management Instrumentation (WMI) provider traces. Because of this, WMI commands fail at a random stage when you deploy a cluster.

- This update addresses an issue that affects remote direct memory access (RDMA) performance counters. They don't return networking data on VMs in the right way.

- This update addresses an issue that affects **fontdrvhost.exe**. It stops responding when you use Compact Font Format version 2 (CFF2) fonts.

- This update addresses an issue that affects clusters. It stops you from registering a cluster using Network ATC. This occurs after you set the proxy to use Network ATC. The issue also stops a preset proxy configuration from clearing.

- This update addresses a memory leak in **TextInputHost.exe**. The leak might cause text input to stop working on devices that haven't restarted for many days.

- This update addresses an issue that affects touchscreens. They don't work properly when you use more than one monitor.

- This update includes quarterly changes to the Windows Kernel Vulnerable Driver Blocklist file, **DriverSiPolicy.p7b**. It adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.

- This update affects Unified Extensible Firmware Interface (UEFI) Secure Boot systems. It adds a renewed signing certificate to the Secure Boot DB variable. You can now opt for this change. For more information, see [KB5036210](https://support.microsoft.com/topic/kb5036210-deploying-windows-uefi-ca-2023-certificate-to-secure-boot-allowed-signature-database-db-a68a3eae-292b-4224-9490-299e303b450b).

- This update addresses an issue that occurs after you run a [Push-button reset](/windows-hardware/manufacture/desktop/how-push-button-reset-features-work). You can't set up Windows Hello facial recognition. This affects devices that have Windows Enhanced Sign-in Security (ESS) turned on.

- This update addresses an issue that affects the download of device metadata. Downloads from the Windows Metadata and Internet Services (WMIS) over HTTPS are now more secure.

- This update addresses an issue that affects the Local Security Authority Subsystem Service (LSASS). It might stop working. This occurs when you access the Active Directory database.

- This update addresses an issue that affects the Certificate Authority snap-in. You can't select the "Delta CRL" option. This stops you from using the GUI to publish Delta CRLs.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [February 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Feb). 

To return to the Azure Stack HCI documentation site.

<!--## Servicing stack update - 25398.700

This update makes quality improvements to the servicing stack, which is the component that installs Windows updates. Servicing stack updates (SSU) ensure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.-->

## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI via PowerShell](../update/update-via-powershell-23h2.md).

<!--| Release Channel | Available | Next Step |
|----|----|----|
| Windows Update and Microsoft Update | Yes | None. This update is downloaded automatically from Windows Update. |
| Windows Update for Business | Yes | None. This update is downloaded automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the Microsoft Update Catalog website. |
| Windows Server Update Services (WSUS) | Yes | This update automatically syncs with WSUS if you configure Products and Classifications as follows:<br>Product: Azure Stack HCI<br>Classification: Security Updates |-->

<!--## To remove the LCU

To remove the LCU after installing the combined SSU and LCU package, use the DISM [Remove-WindowsPackage](/powershell/module/dism/remove-windowspackage) command line option with the LCU package name as the argument. You can find the package name by using this command: `DISM /online /get-packages`.

Running [Windows Update Standalone Installer](https://support.microsoft.com/topic/description-of-the-windows-update-standalone-installer-in-windows-799ba3df-ec7e-b05e-ee13-1cdae8f23b19) (wusa.exe) with the /uninstall switch on the combined package won't work because the combined package contains the SSU. You can't remove the SSU from the system after installation.-->

## File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5034769](https://go.microsoft.com/fwlink/?linkid=2260628).

<!--For a list of the files that are provided in the servicing stack update, download the file information for the [SSU - version 25398.700](https://go.microsoft.com/fwlink/?linkid=2260170).-->

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.