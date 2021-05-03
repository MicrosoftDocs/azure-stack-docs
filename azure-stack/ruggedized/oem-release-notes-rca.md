---
title: Azure Stack Hub Ruggedized OEM Release Notes
description: Azure Stack Hub Ruggedized OEM Release Notes
author: sethmanheim
ms.topic: article
ms.date: 04/29/2021
ms.author: sethm
ms.reviewer: danlewi
ms.lastreviewed: 04/29/2021

---

# Azure Stack Hub ruggedized 2102 OEM release notes

This article contains release and version information for Azure Stack Hub Ruggedized.

## Overview

This document describes the contents of Azure Stack Hub Ruggedized first party updates for firmware and drivers. This update includes improvements and fixes for the latest release of Azure Stack Hub Ruggedized. Below are the download links:

* https://aka.ms/azshwpackage
* https://aka.ms/azshwmanifest

## Baseline and document history

| Release | Date       | Description of changes         |
|---------|------------|--------------------------------|
| 2008    | 10/13/2020 | 2.2.2010.5 OEM package updates |
| 2102    | 04/07/2021 | 2.2.2102.16 OEM package updates|

## Azure Stack Nodes

### Storage Backplane

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
| 2102, 2008            | 4.35            | Added support for additional PowerEdge platforms and configurations.|

### Storage Backplane Expander

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
| 2102            | 2.52            | - Addressed an issue with select 3rd party utilities in which the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/> - Addressed a firmware update issue when performed when no hard drives are present.|
| 2008            | 2.46 | - Updated device status reporting following drive removal specifically for PowerEdge R740XD2 24x3.5" configuration.<br/> Enhancements:<br/> - Added support for additional PowerEdge platforms. |

### PowerEdge R640 CPLD

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
| 2102, 2008            | 9.0.6            | Unchanged from prior release.|

### NIC

| Release version    | Firmware version    | Changes                                                                                                          |
|--------------------|---------------------|------------------------------------------------------------------------------------------------------------------|
|     2102, 2008           |     14.27.60.08     | Unchanged from prior release. |
|     2005           |     14.26.60.00     |                                                                                                                  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008            | 2.40.22511.0    | Unchanged from prior release. |

### HBA capacity drives

| Release version    | Firmware version    | Changes    |
|--------------------|---------------------|------------|
|     2102, 2008           |     16.17.01.00     | Fixed a firmware initialization problem that caused T10 Protection Information (PI) Logical Block and Guard Tag errors under Linux operating systems. This can result in an inability to read from T10 PI capable drives.           |

| Release version | Driver version | Changes |
|-----------------|------------------|---------|
|  2102, 2008   |  2.51.25.02  | Unchanged from prior release.        |

### HBA boot drives

| Release version | Firmware version | Changes                                                                                   |
|-----------------|------------------|-------------------------------------------------------------------------------------------|
| 2102, 2008      | 2.5.13.3024      | - Fixed PPID Discrepancy for M.2 drives of BOSS controller in iDRAC Hardware inventory page.<br/> - Fixed a behavior in firmware to handle creating and deleting VD command execution in a loop. |

| Release version | Driver version | Changes |
|-----------------|------------------|---------|
|  2102, 2008   |  1.2.0.1051 | Unchanged from prior release.        |

### iDRAC

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
| 2102            | 4.40.00.00       | - Fixed issues that caused RAC0182 iDRAC watchdog reboots.<br/> - In compliance with STIG requirement: "network device must authenticate NTP."<br/> - Fixed an issue that was not allowing iDRAC to display the network devices.<br/> - NVIDIA A100 250W PCIe GPU support.<br/> - Removed Telnet and TLS 1.0 from web server.<br/> - Added support for new job states in Redfish API.<br/> - Added support for next-generation iDRAC virtual console and virtual media (eHTML5).  |
| 2008            | 4.22.0.0         | 167411: Fixed an issue that caused force system restart while updating firmware through Redfish API.<br><br> Fixed an issue that caused iDRAC to reboot while collecting SupportAssist logs.<br><br> Fixed a low memory condition on iDRAC due to virtual console service. |

### Dell UEFI diagnostics

| Release version | Version | Changes |
|-----------------|------------------|---------|
|  2102, 2008   | 4301A38 | Unchanged from prior release.  |

## HLH (Management Node)

### Storage Backplane Expander - HLH

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
| 2102            | 2.52            | - Addressed an issue with select 3rd party utilities in which the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/> - Addressed a firmware update issue when performed when no hard drives are present.|
| 2008            | 2.46 | - Updated device status reporting following drive removal specifically for PowerEdge R740XD2 24x3.5" configuration.<br/> Enhancements:<br/> - Added support for additional PowerEdge platforms. |

### Storage Backplane - HLH

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
| 2102, 2008            | 4.35            | Unchanged from prior release.|

### PowerEdge R640 BIOS - HLH

| Release version | Version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102            | 2.10.0             | - Increased the 64bit Memory Mapped I/O allocation size, used for PCIe resource management, from 64GB to 256GB per root port to support Nvidia A100 GPU and other PCIe cards that request > 64GB of 64bit PCIe memory.<br/> - Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2020.2.<br/> - Removed the Logical Processor requirement for Monitor/MWait.<br/> - Fixed other miscellaneous issues. |
| 2008            | 2.8.2             | - Fixed an industry-issue seen on BIOS versions 2.6.4 through 2.8.1, in which the system can reset during power-on at the time "Configuring Memory" is displayed on the boot screen. The issue is applicable to DDR4 and NVDIMM-N memory configurations. <br/> -Enhancement to address security vulnerabilities (Common Vulnerabilities and Exposures-CVE) such as CVE-2020-0545, CVE-2020-0548, and CVE-2020-0549. |

### PowerEdge R640 CPLD - HLH

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
| 2102, 2008            | 9.0.6            | Unchanged from prior release.|

### NIC - HLH

| Release version    | Firmware version    | Changes                                                                                                                                                                   |
|--------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     2008           |     19.5.12         | Resolved an issue on Intel(R) Ethernet X710 10Gb adapters in which the device's LED stays on after blinking when device LED is set to blink mode from F2 Device Settings. |
|     2005           |     19.0.12         |                                                                                                                                                                           |

| Release version    | Driver version    | Changes        |
|--------------------|---------------------|---------------------|
|  2102, 2008        | 1.11.101.0          | Unchanged from prior release.                    |

### Intel chipset - HLH

| Release version | Driver Version | Changes |
|-----------------|------------------|---------|
|  2102, 2008   | 10.1.9.2 | Unchanged from prior release.        |

### iDRAC - HLH

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
| 2102            | 4.40.00.00       | - Fixed issues that caused RAC0182 iDRAC watchdog reboots.<br/> - In compliance with STIG requirement: "network device must authenticate NTP."<br/> - Fixed an issue that was not allowing iDRAC to display the network devices.<br/> - NVIDIA A100 250W PCIe GPU support.<br/> - Removed Telnet and TLS 1.0 from web server.<br/> - Added support for new job states in Redfish API.<br/> - Added support for next-generation iDRAC virtual console and virtual media (eHTML5).  |
| 2008            | 4.22.0.0         | 167411: Fixed an issue that caused force system restart while updating firmware through Redfish API.<br><br> Fixed an issue that caused iDRAC to reboot while collecting SupportAssist logs.<br><br> Fixed a low memory condition on iDRAC due to virtual console service. |

### HBA capacity drives - HLH

|     Release version |     Firmware version |     Changes                                                                                           |
|---------------------|----------------------|-------------------------------------------------------------------------------------------------------|
| 2005, 2008          | 25.5.7.0005          | Fixed an issue where a controller could stop responding at boot due to an incomplete non-volatile memory config. |

| Release version    | Driver version    | Changes        |
|--------------------|---------------------|---------------------|
| 2102, 2008         | 2.51.25.02          | Unchanged from prior release.  |

### HBA boot drives - HLH

| Release version    | Firmware version    | Changes        |
|--------------------|---------------------|---------------------|
| 2102, 2008         | 2.5.13.3024         | - Fixed PPID discrepancy for M.2 drives of BOSS controller in iDRAC hardware inventory page.<br/> - Fixed a behavior in firmware to handle when create and delete VD command execute in loop.                     |

| Release version | Driver version | Changes |
|-----------------|------------------|---------|
|  2102, 2008   |  1.2.0.1051 | Unchanged from prior release.        |

### Dell UEFI diagnostics - HLH

| Release version | Version | Changes |
|-----------------|------------------|---------|
|  2102, 2008   | 4301A38 | Unchanged from prior release.  |

## Drive Firmware

### Micron 5300

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008      | D3MS402          | Enables future online firmware updates |
| 2005            | S401             |                                        |

## Switches

### Dell TOR - Dell S5048F Switch

| Release version    | Firmware version    | Changes        |
|--------------------|---------------------|---------------------|
| 2102               | 9.14.2.9            | - Updated to Dell recommended version. <br/> - Sev 3 issue fix - avoid potential software exception at bootup. <br/> - Sev 2 issue fix - PSU serial not showing in inventory.                    |
| 2008               | 9.14.2.4            | Initial solution version. |

### Dell BMC - Dell S3048 Switch
 
| Release version    | Firmware version    | Changes        |
|--------------------|---------------------|---------------------|
| 2102               | 9.14.2.9            | - Updated to Dell recommended version. <br/> - Sev 3 issue fix - avoid potential software exception at bootup. <br/> - Sev 2 issue fix - PSU serial not showing in inventory.                    |
| 2008               | 9.14.2.4            | Initial solution version. |
