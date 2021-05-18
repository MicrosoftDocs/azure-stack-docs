---
title: Azure Modular Data Center OEM Release Notes
description: OEM Release Notes for Azure Modular Data Center. Includes firmware and driver versions for all solution hardware.
author: sethmanheim
ms.topic: article
ms.date: 05/18/2021
ms.author: sethm
ms.reviewer: danlewi
ms.lastreviewed: 05/18/2021

---

# Azure Modular Data Center 2102 OEM release notes

This article contains release and version information for Azure Modular Data Center.

## Overview

This document describes the contents of Azure Modular Data Center first party updates for firmware and drivers. This update includes improvements and fixes for the latest release of Azure Modular Data Center. Below are the download links:

* https://aka.ms/azshwpackage
* https://aka.ms/azshwmanifest

## Baseline and document history

| Release | Date       | Description of changes         |
|---------|------------|--------------------------------|
| 2008    | 10/13/2020 | 2.2.2010.5 OEM package updates |
| 2102    | 04/07/2021 | 2.2.2102.16 OEM package updates|

## Azure Stack Hub node

### Boot Drive Controller - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.5.13.3024  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.2.0.1051  | Initial solution version  |

### Capacity Drive Controller - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 16.17.01.00  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.51.25.02  | Initial solution version  |

### Chipset - Azure Stack Hub

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics - Azure Stack Hub

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 4301A38  | Initial solution version  |

### GPU - AMD MI25 Plus - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 3.04/D0513400  | Initial solution version  |

### iDRAC - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 4.40.00.00  | - Fixed issues that caused RAC0182 iDRAC watchdog reboots.<br/><br/>- In compliance with STIG requirement: "network device must authenticate NTP."<br/><br/>- Fixed an issue that was not allowing iDRAC to display the network devices.<br/><br/>- NVIDIA A100 250W PCIe GPU support.<br/><br/>- Removal of Telnet and TLS 1.0 from web server.<br/><br/>- Added support for new job states in Redfish API.<br/><br/>- Next-gen iDRAC virtual console and virtual media (eHTML5).  |
| 2008  | 4.22.00.00  | Initial solution version  |

### Micron 5300 - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | D3MS402  | Initial solution version  |

### NIC - Azure Stack Hub - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 14.27.60.08  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.40.22511.0  | Initial solution version  |

### PowerEdge R840 BIOS - Azure Stack Hub

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.9.4  | - Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon processor scalable family to IPU 2020.2.<br/><br/>- Removed the logical processor requirement for Monitor/MWait.  |
| 2008  | 2.8.2  | Initial solution version  |

### PowerEdge R840 CPLD - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.0.6  | Initial solution version  |

### Storage Backplane - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 4.35  | Initial solution version  |

### Storage Backplane Expander - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.52  | - Addressed an issue with select third-party utilities in which the LED Identify operation continued to blink after a planned drive replacement operation was completed.<br/><br/>- Addressed a firmware update issue that occurred when no hard drives were present.  |
| 2008  | 2.46  | Initial solution version  |

## HLH

### Boot Drive Controller - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.5.13.3024  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.2.0.1051  | Initial solution version  |

### Capacity Drive Controller - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 25.5.8.0001  | - Enhanced background initialization (BGI) and consistency check (CC) progress to reduce performance impact when progress is saved (checkpointed).  |
| 2008  | 25.5.7.0005  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 2.51.25.02  | Initial solution version  |

### Chipset - HLH

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics - HLH

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 4301A38  | Initial solution version  |

### iDRAC - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 4.40.00.00  | - Fixed issues that caused RAC0182 iDRAC watchdog reboots.<br/><br/>- In compliance with STIG requirement: "network device must authenticate NTP."<br/><br/>- Fixed an issue that was not allowing iDRAC to display the network devices.<br/><br/>- NVIDIA A100 250W PCIe GPU support.<br/><br/>- Removal of Telnet and TLS 1.0 from web server.<br/><br/>- Added support for new job states in Redfish API<br/><br/>- Next-gen iDRAC virtual console and virtual media (eHTML5)  |
| 2008  | 4.22.00.00  | Initial solution version  |

### NIC - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 19.5.12  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.11.101.0  | Initial solution version  |

### PowerEdge R640 BIOS - HLH

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.10.0  | - Increased the 64-bit memory mapped I/O allocation size, used for PCIe resource management, from 64 GB to 256 GB per root port, to support Nvidia A100 GPU and other PCIe cards that request more than 64 GB of 64-bit PCIe memory.<br/><br/>- Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon processor scalable family to IPU 2020.2.<br/><br/>- Removed the logical processor requirement for Monitor/MWait.  |
| 2008  | 2.8.2  | Initial solution version  |

### PowerEdge R640 CPLD - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 9.0.6  | Initial solution version  |

### Storage Backplane - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 4.35  | Initial solution version  |

### Storage Backplane Expander - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.52  | - Addressed an issue with select 3rd party utilities in which the LED Identify operation continued to blink after a planned drive replacement operation was completed.<br/><br/>- Addressed a firmware update issue that occurred when no hard drives were present.  |
| 2008  | 2.46  | Initial solution version  |

## Infrastructure

### Avocent MPU4032DAC KVM

| Release version | KVM FW version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.8.3.25691  | - Improved product security  |
| 2008  | 2.6.0.25542  | Initial solution version  |

### Geist N30030L PDU

| Release version | PDU FW version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | i03-5_7_0-11112020  | - Several new features via SSH and API, including ability to manage TLS certs.<br/><br/>- Fixes related to incorrect uptime, SNMP values freezing, and phase balance sum.  |
| 2008  | i03-5_6_1-07092020  | Initial solution version  |

## Storage

### Isilon Drive

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.33  | Initial solution version  |

### Isilon IA2000-E-10T-400G

| Release version | OS Patch version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.1.0.3_GA-RUP_2021-01_PSP-664  | - Most recent rollup package to go with 9.1 (January 2021). This patch addresses multiple userspace and kernel issues.  |
| 2008  | 8.2.2_GA-RUP_2020-07_PSP-40  | Initial solution version  |

| Release version | OS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.1.0.0  | Initial solution version  |
| 2008  | 8.2.2.0  | Initial solution version  |

### Isilon Node

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 10.3.3  | Initial solution version  |

## Switches

### CISCO BMC - Cisco NX-OS

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.3.6  | Latest recommended Cisco security and bug fixes as of November 2020.  |
| 2008  | 9.3.3  | Initial solution version  |

### CISCO TOR - Cisco NX-OS

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.3.6  | Latest recommended Cisco security and bug fixes as of November 2020.  |
| 2008  | 9.3.3  | Initial solution version  |

### Firewall - Cisco Firepower 4115 ASA

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.12.4.10  | Latest recommended Cisco security and bug fixes as of December 2020.  |
| 2008  | 9.12.2.9  | Initial solution version  |

### Firewall - Cisco Firepower 4115 FX-OS

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.2.6.1.214  | Updated to match recommended ASA SW version (9.12.4.10)  |
| 2008  | 9.2.6.1.187  | Initial solution version  |

### Storage Backend - Dell S4148F Switch

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 10.5.0.6.685  | Initial solution version  |

