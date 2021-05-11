---
title: Azure Stack Hub Ruggedized OEM Release Notes
description: OEM Release Notes for Azure Stack Hub Ruggedized. Includes firmware and driver versions for all solution hardware.
author: sethmanheim
ms.topic: article
ms.date: 05/11/2021
ms.author: sethm
ms.reviewer: danlewi
ms.lastreviewed: 05/11/2021

---

# Azure Stack Hub Ruggedized 2102 OEM release notes

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

## Azs Hub Node

### Boot Drive Controller

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.5.13.3024  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.2.0.1051  | Initial solution version  |

### Capacity Drive Controller

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 16.17.01.00  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.51.25.02  | Initial solution version  |

### Chipset

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 4301A38  | Initial solution version  |

### iDRAC

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 4.40.00.00  | - Fixed issues that caused RAC0182 iDRAC watchdog reboots<br/><br/>- In Compliance with STIG requirement: "network device must authenticate NTP"<br/><br/>- Fixed an issue that was not allowing iDRAC to display the Network Devices<br/><br/>- NVIDIA A100 250W PCIe GPU support<br/><br/>- Removal of Telnet and TLS 1.0 from web server<br/><br/>- Added support for new job states in Redfish API<br/><br/>- Next-gen iDRAC virtual console and virtual media (eHTML5)  |
| 2008  | 4.22.00.00  | Initial solution version  |

### Micron 5300

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | D3MS402  | Initial solution version  |

### NIC

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 14.27.60.08  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.40.22511.0  | Initial solution version  |

### PowerEdge R640 BIOS

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.10.0  | - Increased the 64bit Memory Mapped I/O allocation size, used for PCIe resource management, from 64GB to 256GB per root port to support Nvidia A100 GPU and other PCIe cards that request > 64GB of 64bit PCIe memory.<br/><br/>- Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2020.2.<br/><br/>- Removed the Logical Processor requirement for Monitor/MWait.  |
| 2008  | 2.8.2  | Initial solution version  |

### PowerEdge R640 CPLD

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 9.0.6  | Initial solution version  |

### Storage Backplane

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 4.35  | Initial solution version  |

### Storage Backplane Expander

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.52  | - Addressed an issue with select 3rd party utilities where the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/><br/>- Addressed a firmware update issue when performed when no hard drives are present.  |
| 2008  | 2.46  | Initial solution version  |

## HLH

### Boot Drive Controller

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.5.13.3024  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.2.0.1051  | Initial solution version  |

### Capacity Drive Controller

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 25.5.8.0001  | - Enhanced Background Initialization (BGI) and Consistency Check (CC) progress to reduce performance impact when progress is saved (checkpointed).  |
| 2008  | 25.5.7.0005  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.51.25.02  | Initial solution version  |

### Chipset

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 4301A38  | Initial solution version  |

### iDRAC

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 4.40.00.00  | - Fixed issues that caused RAC0182 iDRAC watchdog reboots<br/><br/>- In Compliance with STIG requirement: "network device must authenticate NTP"<br/><br/>- Fixed an issue that was not allowing iDRAC to display the Network Devices<br/><br/>- NVIDIA A100 250W PCIe GPU support<br/><br/>- Removal of Telnet and TLS 1.0 from web server<br/><br/>- Added support for new job states in Redfish API<br/><br/>- Next-gen iDRAC virtual console and virtual media (eHTML5)  |
| 2008  | 4.22.00.00  | Initial solution version  |

### NIC

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 19.5.12  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.11.101.0  | Initial solution version  |

### PowerEdge R640 BIOS

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.10.0  | - Increased the 64bit Memory Mapped I/O allocation size, used for PCIe resource management, from 64GB to 256GB per root port to support Nvidia A100 GPU and other PCIe cards that request > 64GB of 64bit PCIe memory.<br/><br/>- Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2020.2.<br/><br/>- Removed the Logical Processor requirement for Monitor/MWait.  |
| 2008  | 2.8.2  | Initial solution version  |

### PowerEdge R640 CPLD

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 9.0.6  | Initial solution version  |

### Storage Backplane

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 4.35  | Initial solution version  |

### Storage Backplane Expander

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.52  | - Addressed an issue with select 3rd party utilities where the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/><br/>- Addressed a firmware update issue when performed when no hard drives are present.  |
| 2008  | 2.46  | Initial solution version  |

## Switches

### DELL BMC - Dell S3048 Switch

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.14.2.9  | - Updated to Dell recommended version<br/><br/>- Sev 3 issue fix - avoid potential software exception at bootup<br/><br/>- Sev 2 issue fix - PSU serial not showing in inventory.  |
| 2008  | 9.14.2.4  | Initial solution version  |

### DELL TOR - Dell S5048F Switch

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.14.2.9  | - Updated to Dell recommended version<br/><br/>- Sev 3 issue fix - avoid potential software exception at bootup<br/><br/>- Sev 2 issue fix - PSU serial not showing in inventory.  |
| 2008  | 9.14.2.4  | Initial solution version  |
