---
title: Azure Stack Hub DC (Preview) OEM release notes
description: OEM Release Notes for Azure Stack Hub DC (Preview). Includes firmware and driver versions for all solution hardware.
author: sethmanheim
ms.topic: article
ms.date: 10/09/2023
ms.author: sethm
ms.reviewer: danlewi
ms.lastreviewed:

---

# Azure Stack Hub DC (Preview) 2309 OEM release notes

This article contains release and version information for Azure Stack Hub DC (Preview).

## Overview

This document describes the contents of Azure Stack Hub DC (Preview) first party updates for firmware and drivers. This update includes improvements and fixes for the latest release of Azure Stack Hub DC (Preview). Below are the download links:
    
* https://aka.ms/azshwpackage
* https://aka.ms/azshwmanifest

## Baseline and document history

| Release | Date       | Description of changes         |
|---------|------------|--------------------------------|
| 2008    | 10/13/2020 | 2.2.2010.5 OEM package updates |
| 2102    | 04/07/2021 | 2.2.2102.16 OEM package updates|
| 2108    | 09/28/2021 | 2.2.2108.8 OEM package updates |
| 2112    | 02/02/2022 | 2.2.2112.4 OEM package updates |
| 2206    | 06/21/2022 | 2.2.2206.10 OEM package updates|
| 2309    | 09/28/2023 | 2.3.2309.16 OEM package updates|
## Azs Hub Node

### Boot Drive Controller - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.5.13.3024  | Initial solution version  |

### Capacity Drive Controller - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 16.17.01.00  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.51.25.02  | Initial solution version  |

### Chipset - Azure Stack Hub

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics - Azure Stack Hub

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 4301A73  | Enhancements: Changes to support new hardware.  |

### GPU - AMD MI25 Plus - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 3.04/D0513400  | Initial solution version  |

### iDRAC - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 6.10.30.20  | Resolves issue with updating CPLD when iDRAC is at major version 5.  |

### Intel D3-S4510 boot - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | DL6R  | Initial solution version.<br/><br/>Fixes:<br/>-SMART attribute shift solution<br/>-MRR settings to mitigate BJ004 issue<br/>-Fix for drive stops responding after soft-reboot following windows install  |

### Micron 5100 M.2 480GB & 960GB - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | E013  | Fixes:<br/>- Remove monitoring of 12V power bus, to improve drive stability in noisy 12V power conditions.<br/>- Improve wear leveling algorithms, to recover cleanly from power cycles and manage high write workloads better.<br/>- Fix to R_ERR handling, to eliminate case where high frequency of CRC errors might cause the drive to enter bus hang state.  |

### Micron 5300 - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | D3MS402  | Initial solution version  |

### NIC - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 14.32.20.04  | Latest Dell recommended version for Azure Stack Hub as of April 2022.  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.80.25134.0  | Latest Dell recommended version for Azure Stack Hub as of April 2022.  |

### PowerEdge R840 BIOS - Azure Stack Hub

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.18.1  | Includes multiple security fixes since previous release.  |

### PowerEdge R840 CPLD - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 1.0.6  | Initial solution version  |

### Storage Backplane - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 4.35  | Initial solution version  |

### Storage Backplane Expander - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.52  | - Addressed an issue with select 3rd party utilities where the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/>- Addressed a firmware update issue when performed when no hard drives are present.  |

## HLH

### Boot Drive Controller - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.5.13.3024  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 1.2.0.1052  | Support for Windows Azure HCI Stack & Windows 2022 enabled  |

### Capacity Drive Controller - HLH

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.51.25.02  | Initial solution version  |

### Chipset - HLH

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics - HLH

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 4301A73  | Enhancements: Changes to support new hardware.  |

### iDRAC - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 6.10.30.20  | Resolves issue with updating CPLD when iDRAC is at major version 5.  |

### Intel D3-S4510 boot - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | DL6R  | Initial solution version.<br/><br/>Fixes:<br/>-SMART attribute shift solution<br/>-MRR settings to mitigate BJ004 issue<br/>-Fix for drive stops responding after soft-reboot following windows install  |
| 2309  | DL6R  | Initial solution version.<br/><br/>Fixes:<br/>-SMART attribute shift solution<br/>-MRR settings to mitigate BJ004 issue<br/>-Fix for drive stops responding after soft-reboot following windows install  |

### Intel D3-S4520 boot - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | DL70  | Initial solution version  |

### Intel S3520 boot - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | DL43  | Initial solution version<br/><br/>Fixes:<br/>-Numerous minor bug fixes<br/>-Fix for some M.2 drives not upgrading<br/><br/>Enhancements:<br/>-Added support for Instant Scramble Erase commands  |

### Micron 5100 M.2 480GB & 960GB - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | E013  | Fixes:<br/>- Remove monitoring of 12V power bus, to improve drive stability in noisy 12V power conditions.<br/>- Improve wear leveling algorithms, to recover cleanly from power cycles and manage high write workloads better.<br/>- Fix to R_ERR handling, to eliminate case where high frequency of CRC errors might cause the drive to enter bus hang state.  |

### Micron 5300 boot - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | J004  | Initial solution version  |

### NIC - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 20.5.13  | Fixes:<br/>  - Resolved a critical error observed while restoring default settings for the Intel(R) Ethernet<br/>     Converged Network Adapter X710 adapter.  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 1.16.62.0  | Fixes:<br/>- Resolved an issue on Windows 2019 where the driver wasn't being listed in "Uninstall<br/>Programs". When downgrading from 20.5.0 drivers to 20.0.0 drivers, first uninstall<br/>the 20.5.0 package via Add or Remove programs.<br/>- Resolved an issue so Intel(R) Ethernet Converged Network Adapter X710-T adapter no longer<br/>advertises the unsupported 100 Mbps speed in adapter settings.<br/>- Resolved an issue where device drivers couldn't be reinstalled after being uninstalled.  |

### PowerEdge R640 BIOS - HLH

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.18.1  | Includes multiple security fixes since previous release.  |

### PowerEdge R640 CPLD - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 1.0.6  | Fixes:<br/>-Addresses a possibility of IDRAC not responding during PSU firmware update.  |

### Storage Backplane - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 4.35  | Initial solution version  |

### Storage Backplane Expander - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.52  | - Addressed an issue with select 3rd party utilities where the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/>- Addressed a firmware update issue when performed when no hard drives are present.  |

## Switches

### CISCO BMC - Cisco NX-OS

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 10.2.5  | Upgrading to the latest recommend version of Cisco NX-OS.  |

### CISCO TOR - Cisco NX-OS

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 10.2.5  | Upgrading to the latest recommend version of Cisco NX-OS.  |

