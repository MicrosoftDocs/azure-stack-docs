---
title: Azure Modular Data Center OEM Release Notes
description: OEM Release Notes for Azure Modular Data Center. Includes firmware and driver versions for all solution hardware.
author: sethmanheim
ms.topic: article
ms.date: 09/28/2021
ms.author: sethm
ms.reviewer: danlewi
ms.lastreviewed: 09/28/2021

---

# Azure Modular Data Center 2108 OEM release notes

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
| 2108    | 09/28/2021 | 2.2.2108.8 OEM package updates |

## Azure Stack Hub node

### Boot Drive Controller - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 2.5.13.3024  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 1.2.0.1051  | Initial solution version  |

### Capacity Drive Controller - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 16.17.01.00  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 2.51.25.02  | Initial solution version  |

### Chipset - Azure Stack Hub

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics - Azure Stack Hub

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 4301A38  | Initial solution version  |

### GPU - AMD MI25 Plus - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 3.04/D0513400  | Initial solution version  |

### iDRAC - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108  | 4.40.10.00  | Fixes:<br/>- Fixed drive re-inventory problem when upgrading PERC firmware following warm boot (152057)<br/>- Fixed an iDRAC unresponsive issue when webserver is disabled (187318)<br/>- Fixed a PSU mismatch reporting issue on C6525 (185201)<br/>- Fixed an issue using custom webserver ports (185650)<br/>- Fixed redfish connection issue (186497)<br/><br/>Enhancements:<br/>- Support side band management for A100 GPU card  |

### Micron 5100 M.2 480GB & 960GB - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108  | E013  | Fixes:<br/>- Remove monitoring of 12V power bus, to improve drive stability in noisy 12V power conditions.<br/>- Improve wear leveling algorithms, to recover cleanly from power cycles and manage high write workloads better.<br/>- Fix to R_ERR handling, to eliminate case where high frequency of CRC errors may cause the drive to enter bus hang state.  |

### Micron 5300 - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | D3MS402  | Initial solution version  |

### NIC - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 14.27.60.08  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 2.40.22511.0  | Initial solution version  |

### PowerEdge R840 BIOS - Azure Stack Hub

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.9.4  | - Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2020.2.<br/><br/>- Removed the Logical Processor requirement for Monitor/MWait.  |
| 2008  | 2.8.2  | Initial solution version  |
| 2108  | 2.10.2  | Fixes:<br/>- Fixed an Intel errata reported on IPU 2020.1 and 2020.2 where the system could potentially not respond or reboot during POST when "Configuring Memory..." is displayed on the screen. This scenario may be encountered during system boot, where self-heal is attempted. The root cause is a race condition where during the self-heal process, a refresh cycle may not have completed when the CPU issues self-heal related commands to the DRAM.<br/>The Issue is described in Intel Xeon Processor Scalable Family Specification Update, SKX120 and second-generation Intel Xeon Scalable Processors Specification Update, CLX51.<br/><br/>- Fixed an issue where an invalid location was specified for a self-heal request. This results in self-heal not being performed, which could potentially not respond or reboot the system during POST when "Configuring Memory..." is displayed on the screen.<br/><br/>Note: The Dell PowerEdge BIOS will automatically schedule DIMM self-healing during POST, based on DIMM health monitoring of correctable and uncorrectable errors from previous system boots.<br/><br/>- Updated Intel processor microcode to address the following issues:<br/>* High Levels of Posted Interrupt Traffic on The PCIe Port May Result in a Machine Check with a TOR Timeout. The Issue is described in the Intel Xeon Processor Scalable Family Specification Update, SKX123 and Second-generation Intel Xeon Scalable Processors Specification Update, CLX52.<br/>* Some Short Loops of Instructions May Cause a 3-Strike Machine Check without a TOR Timeout. The Issue is described in the Second-generation Intel Xeon Scalable Processors Specification Update, CLX53.<br/><br/>Enhancements:<br/>- Updated the Processor Microcode to version 0x3005 for the second-generation Intel Xeon Processor Scalable Family.<br/>- Updated the Processor Microcode to version 0x6A09 for the Intel Xeon Processor Scalable Family.  |

### PowerEdge R840 CPLD - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 1.0.6  | Initial solution version  |

### Storage Backplane - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 4.35  | Initial solution version  |

### Storage Backplane Expander - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | 2.46  | Initial solution version  |
| 2108, 2102  | 2.52  | - Addressed an issue with select 3rd party utilities where the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/><br/>- Addressed a firmware update issue when performed when no hard drives are present.  |

## HLH

### Boot Drive Controller - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 2.5.13.3024  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 1.2.0.1051  | Initial solution version  |

### Capacity Drive Controller - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | 25.5.7.0005  | Initial solution version  |
| 2108, 2102  | 25.5.8.0001  | - Enhanced Background Initialization (BGI) and Consistency Check (CC) progress to reduce performance impact when progress is saved (checkpointed).  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 2.51.25.02  | Initial solution version  |

### Chipset - HLH

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics - HLH

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 4301A38  | Initial solution version  |

### iDRAC - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108  | 4.40.10.00  | Fixes:<br/>- Fixed drive re-inventory problem when upgrading PERC firmware following warm boot (152057)<br/>- Fixed an iDRAC unresponsive issue when webserver is disabled (187318)<br/>- Fixed a PSU mismatch reporting issue on C6525 (185201)<br/>- Fixed an issue using custom webserver ports (185650)<br/>- Fixed redfish connection issue (186497)<br/><br/>Enhancements:<br/>- Support side band management for A100 GPU card  |

### Micron 5100 M.2 480GB & 960GB - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108  | E013  | Fixes:<br/>- Remove monitoring of 12V power bus, to improve drive stability in noisy 12V power conditions.<br/>- Improve wear leveling algorithms, to recover cleanly from power cycles and manage high write workloads better.<br/>- Fix to R_ERR handling, to eliminate case where high frequency of CRC errors may cause the drive to enter bus hang state.  |

### NIC - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 19.5.12  | Initial solution version  |
| 2108  | 20.0.17  | - Intel(R) Ethernet 700 Series based adapters are subject to the content of Intel Technical Advisory TA_00380. Please review INTEL_TA_00380 for more detail.<br/><br/>- Resolved an issue where port link status in iDRAC for Intel(R) Ethernet 10G 2P X710 OCP adapter or Intel(R) Ethernet 10G 4P X710 OCP adapter may still appear as up after cable is disconnected.<br/><br/>- Resolved an issue where some X710 based adapters may display the Dell Family Firmware Version (FFV) instead of the OS driver version when viewing the device driver version in iDRAC.  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 1.11.101.0  | Initial solution version  |
| 2108  | 1.13.104.0  | - Resolved an issue on Windows OSs where using "Identify Adapter" under X710 based adapters' Adapter Properties in Device Manager does not blink the adapter LEDs.  |

### PowerEdge R640 BIOS - HLH

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 2.10.0  | - Increased the 64bit Memory Mapped I/O allocation size, used for PCIe resource management, from 64GB to 256GB per root port to support Nvidia A100 GPU and other PCIe cards that request > 64GB of 64bit PCIe memory.<br/><br/>- Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2020.2.<br/><br/>- Removed the Logical Processor requirement for Monitor/MWait.  |
| 2008  | 2.8.2  | Initial solution version  |
| 2108  | 2.10.2  | Fixes:<br/>- Fixed an Intel errata reported on IPU 2020.1 and 2020.2 where the system could potentially not respond or reboot during POST when "Configuring Memory..." is displayed on the screen. This scenario may be encountered during system boot, where self-heal is attempted. The root cause is a race condition where during the self-heal process, a refresh cycle may not have completed when the CPU issues self-heal related commands to the DRAM.<br/>The Issue is described in Intel Xeon Processor Scalable Family Specification Update, SKX120 and second-generation Intel Xeon Scalable Processors Specification Update, CLX51.<br/><br/>- Fixed an issue where an invalid location was specified for a self-heal request. This results in self-heal not being performed, which could potentially not respond or reboot the system during POST when "Configuring Memory..." is displayed on the screen.<br/><br/>Note: The Dell PowerEdge BIOS will automatically schedule DIMM self-healing during POST, based on DIMM health monitoring of correctable and uncorrectable errors from previous system boots.<br/><br/>- Updated Intel processor microcode to address the following issues:<br/>* High Levels of Posted Interrupt Traffic on The PCIe Port May Result in a Machine Check with a TOR Timeout. The Issue is described in the Intel Xeon Processor Scalable Family Specification Update, SKX123 and Second-generation Intel Xeon Scalable Processors Specification Update, CLX52.<br/>* Some Short Loops of Instructions May Cause a 3-Strike Machine Check without a TOR Timeout. The Issue is described in the Second-generation Intel Xeon Scalable Processors Specification Update, CLX53.<br/><br/>Enhancements:<br/>- Updated the Processor Microcode to version 0x3005 for the second-generation Intel Xeon Processor Scalable Family.<br/>- Updated the Processor Microcode to version 0x6A09 for the Intel Xeon Processor Scalable Family.  |

### PowerEdge R640 CPLD - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102, 2008  | 9.0.6  | Initial solution version  |
| 2108  | 1.0.6  | Fixes:<br/>-Addresses a possibility of IDRAC not responding during PSU firmware update.  |

### Storage Backplane - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 4.35  | Initial solution version  |

### Storage Backplane Expander - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | 2.46  | Initial solution version  |
| 2108, 2102  | 2.52  | - Addressed an issue with select 3rd party utilities where the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/><br/>- Addressed a firmware update issue when performed when no hard drives are present.  |

## Infrastructure

### Avocent MPU4032DAC KVM

| Release version | KVM FW version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | 2.6.0.25542  | Initial solution version  |
| 2108, 2102  | 2.8.3.25691  | - Improved product security  |

### Geist N30030L PDU

| Release version | PDU FW version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | i03-5_6_1-07092020  | Initial solution version  |
| 2108, 2102  | i03-5_7_0-11112020  | - Several new features via ssh and API including ability to manage TLS certs.<br/><br/>- Fixes related to incorrect uptime, SNMP values freezing, and phase balance sum.  |

## Storage

### Isilon Drive

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 1.33  | Initial solution version  |

### Isilon IA2000-E-10T-400G

| Release version | OS Patch version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | 8.2.2_GA-RUP_2020-07_PSP-40  | Initial solution version  |
| 2108, 2102  | 9.1.0.3_GA-RUP_2021-01_PSP-664  | - Most recent rollup package to go with 9.1 (January 2021). This patch addresses multiple Userspace and Kernel issues.  |

| Release version | OS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | 8.2.2.0  | Initial solution version  |
| 2108, 2102  | 9.1.0.0  | Initial solution version  |

### Isilon Node

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 10.3.3  | Initial solution version  |

## Switches

### CISCO BMC - Cisco NX-OS

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | 9.3.3  | Initial solution version  |
| 2108, 2102  | 9.3.6  | Latest recommended Cisco security and bug fixes as of November 2020.  |

### CISCO TOR - Cisco NX-OS

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008  | 9.3.3  | Initial solution version  |
| 2108, 2102  | 9.3.6  | Latest recommended Cisco security and bug fixes as of November 2020.  |

### Firewall - Cisco Firepower 4115 ASA

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.12.4.10  | Latest recommended Cisco security and bug fixes as of December 2020.  |
| 2008  | 9.12.2.9  | Initial solution version  |
| 2108  | 9.12.4.18  | Latest recommended Cisco security and bug fixes as of April 2021.  |

### Firewall - Cisco Firepower 4115 FX-OS

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2102  | 9.2.6.1.214  | Updated to match recommended ASA SW version (9.12.4.10)  |
| 2008  | 9.2.6.1.187  | Initial solution version  |
| 2108  | 9.2.6.1.224  | Latest recommended Cisco security and bug fixes as of April 2021.  |

### Storage Backend - Dell S4148F Switch

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2108, 2102, 2008  | 10.5.0.6.685  | Initial solution version  |
