---
title: Azure Stack Hub Ruggedized OEM Release Notes
description: OEM Release Notes for Azure Stack Hub Ruggedized. Includes firmware and driver versions for all solution hardware.
author: sethmanheim
ms.topic: article
ms.date: 10/09/2023
ms.author: sethm
ms.reviewer: danlewi
ms.lastreviewed:

---

# Azure Stack Hub Ruggedized 2309 OEM release notes

This article contains release and version information for Azure Stack Hub Ruggedized.

## Overview

This document describes the contents of Azure Stack Hub Ruggedized first party updates for firmware and drivers. This update includes improvements and fixes for the latest release of Azure Stack Hub Ruggedized. Below are the download links:

* https://aka.ms/azsruggedhwpackage
* https://aka.ms/azsruggedhwmanifest

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
| 2309, 2008, 2102, 2108, 2112  | 2.5.13.3024  | Initial solution version  |

### Capacity Drive Controller - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | 16.17.01.00  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | 2.51.25.02  | Initial solution version  |

### Chipset - Azure Stack Hub

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics - Azure Stack Hub

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 4301A73  | Enhancements: Changes to support new hardware.  |
| 2008, 2102, 2108, 2112  | 4301A38  | Initial solution version  |

### iDRAC - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 6.10.30.20  | Resolves issue with updating CPLD when iDRAC is at major version 5.  |
| 2112  | 5.00.10.20  | Enhancements:<br/>General<br/>-Option to clear the system critical status to healthy state when unconfigured internal drive is removed<br/>-Support Firmware update of TPM<br/>GUI Enhancements<br/>-Prevent Browser Refresh from Logging Out iDRAC User<br/>-Show PCIe slot inventory in a simplified view<br/>-Storage page - added new filters<br/>-Show the last used domain name by default in the login page (AD users)<br/>Redfish Updates<br/>-Redfish: Add ComputerSystem.GraceFulRestart<br/>-Redfish: support OperationApplyTime option for updates<br/>-Redfish: support ConvergedInfra.1#AppRawData attribute<br/>-Redfish: Support Redfish lifecycle events.<br/>-Redfish: Add HTTP/2 support to iDRAC9<br/>Support/Diagnostics<br/>-CPU & Memory Utilization logging in Support Assist Collection<br/>-Add PCIe tree of the system in the Support Assist Collection<br/>-SupportAssist Logs to include historical thermal inlet and outlet temperature<br/><br/>Fixes:<br/>-Fixed an issue that failed the local RACADM to update the error code value while the update job was running.<br/>-Fixed an issue that generated FAN0000/FAN0001 events for auxiliary Fan5 while system was in powered off state.<br/>-Fixed an issue that caused a failure in firmware rollback using DellUpdateService in Redfish interface.<br/>-System fan running at a higher speed than expected, on systems with actively cooled third-party GPUs.<br/>-Firmware update through local RACADM fails when the firmware image is uploaded from a local drive.<br/>-iDRAC resets to default settings, enforcing restoration of all settings including licenses.<br/>-Fixed Share HTTP IPV6 with FQDN was not working.<br/>-Fixed Observed connecting viewer --> unable to connect the viewer.<br/>-Fixed Observed vConsole is in connecting viewer state only when vConsole launched after 30 min idle state<br/>-Fixed 15G_iDRAC_Redfish_Halo_B ContainedBy attribute is shown as json empty for Modular Enclosure<br/>-Fixed Not able to clear the Provisioning Server details from Remote Enablement from IDRAC Hii<br/>-Fixed Multiple iDRAC monitor observed after perform creating VD<br/>-Fixed Incorrect Job name created in Job Queue when DC PSU FW updated on top of Linux or Win OS<br/>-Fixed Repository Update JID fails from custom repository  |
| 2108  | 4.40.10.00  | Fixes:<br/>- Fixed drive re-inventory problem when upgrading PERC firmware following warm boot (152057)<br/>- Fixed an iDRAC unresponsive issue when webserver is disabled (187318)<br/>- Fixed a PSU mismatch reporting issue on C6525 (185201)<br/>- Fixed an issue using custom webserver ports (185650)<br/>- Fixed redfish connection issue (186497)<br/><br/>Enhancements:<br/>- Support side band management for A100 GPU card  |
| 2102  | 4.40.00.00  | - Fixed issues that caused RAC0182 iDRAC watchdog reboots<br/>- In Compliance with STIG requirement: "network device must authenticate NTP"<br/>- Fixed an issue that was not allowing iDRAC to display the Network Devices<br/>- NVIDIA A100 250W PCIe GPU support<br/>- Removal of Telnet and TLS 1.0 from web server<br/>- Added support for new job states in Redfish API<br/>- Next-gen iDRAC virtual console and virtual media (eHTML5)  |
| 2008  | 4.22.00.00  | Initial solution version  |

### Intel D3-S4510 boot - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | DL6R  | Initial solution version.<br/><br/>Fixes:<br/>-SMART attribute shift solution<br/>-MRR settings to mitigate BJ004 issue<br/>-Fix for drive stops responding after soft-reboot following windows install  |
| 2309, 2112  | DL6R  | Initial solution version.<br/><br/>Fixes:<br/>-SMART attribute shift solution<br/>-MRR settings to mitigate BJ004 issue<br/>-Fix for drive stops responding after soft-reboot following windows install  |

### Intel D3-S4520 boot - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | DL70  | Initial solution version  |

### Intel S3520 boot - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | DL43  | Initial solution version<br/><br/>Fixes:<br/>-Numerous minor bug fixes<br/>-Fix for some M.2 drives not upgrading<br/><br/>Enhancements:<br/>-Added support for Instant Scramble Erase commands  |

### Micron 5100 M.2 480GB & 960GB - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2108, 2112  | E013  | Fixes:<br/>- Remove monitoring of 12V power bus, to improve drive stability in noisy 12V power conditions.<br/>- Improve wear leveling algorithms, to recover cleanly from power cycles and manage high write workloads better.<br/>- Fix to R_ERR handling, to eliminate case where high frequency of CRC errors may cause the drive to enter bus hang state.  |

### Micron 5300 - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | D3MS402  | Initial solution version  |

### Micron 5300 boot - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | J004  | Initial solution version  |

### NIC - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 14.32.20.04  | Latest Dell recommended version for Azure Stack Hub as of April 2022.  |
| 2112  | 14.31.10.14  | Latest available Dell recommended versions for Azure Stack Hub as of October 2011.<br/><br/>See release notes at https://www.dell.com/support/home/us/en/19/Drivers/DriversDetails?driverId=900N0 for details  |
| 2008, 2102, 2108  | 14.27.60.08  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.80.25134.0  | Latest Dell recommended version for Azure Stack Hub as of April 2022.  |
| 2112  | 2.70.24708.0  | Latest Dell recommended version for Azure Stack Hub as of October 2021.  |
| 2008, 2102, 2108  | 2.40.22511.0  | Initial solution version  |

### PowerEdge R640 BIOS - Azure Stack Hub

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.18.1  | Includes multiple security fixes since previous release.  |
| 2112  | 2.12.2  | Fixes:<br/>- Incorrect critical error pop-up message that was seen while exiting iDRAC Settings menu.<br/>- Fixed BIOS only report partial data in iDRAC/LC for system/setup password after set by SCP from iDRAC.<br/>- Fix HTTP boot failure with single DNS entry in static IPv4 address mode.<br/><br/>Enhancements:<br/>- Support for Microsoft Windows Server 2022 Operating System.<br/>- Updated the S140 Software RAID firmware to version 5.6.0-0002.<br/>- Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2021.1.<br/>- Updated the Processor Microcode to version 0x3102 for the second-generation Intel Xeon Processor Scalable Family.<br/>- Updated the Processor Microcode to version 0x6B06 for the Intel Xeon Processor Scalable Family.<br/>- Updated the Purley Refresh PV Candidate Reference Code Version 612D02.<br/>- Updated the AEP Release 1.0.0.3515 files to Purley Refresh UEFI Source.<br/>- Updated SPS to SPS_E5_04.01.04.505.0 (IPU 2021.1) for Purley Refresh.<br/>- Enhancement to address the security vulnerabilities (Common Vulnerabilities and Exposures - CVE) such as CVE-2021-21555, CVE-2021-21556, CVE-2021-21557, CVE-2020-24511, CVE-2020-12358, CVE-2020-12360, CVE-2020-24486, CVE-2019-14553, CVE-2021-21571.  |
| 2108  | 2.10.2  | Fixes:<br/>- Fixed an Intel errata reported on IPU 2020.1 and 2020.2 where the system could potentially not respond or reboot during POST when "Configuring Memory..." is displayed on the screen. This scenario may be encountered during system boot, where self-heal is attempted. The root cause is a race condition where during the self-heal process, a refresh cycle may not have completed when the CPU issues self-heal related commands to the DRAM.<br/>The Issue is described in Intel Xeon Processor Scalable Family Specification Update, SKX120 and second-generation Intel Xeon Scalable Processors Specification Update, CLX51.<br/>- Fixed an issue where an invalid location was specified for a self-heal request. This results in self-heal not being performed, which could potentially not respond or reboot the system during POST when "Configuring Memory..." is displayed on the screen. Note: The Dell PowerEdge BIOS will automatically schedule DIMM self-healing during POST, based on DIMM health monitoring of correctable and uncorrectable errors from previous system boots.<br/>- Updated Intel processor microcode to address the following issues:<br/>1. High Levels of Posted Interrupt Traffic on The PCIe Port May Result in a Machine Check with a TOR Timeout. The Issue is described in the Intel Xeon Processor Scalable Family Specification Update, SKX123 and Second-generation Intel Xeon Scalable Processors Specification Update, CLX52.<br/>2. Some Short Loops of Instructions May Cause a 3-Strike Machine Check without a TOR Timeout. The Issue is described in the Second-generation Intel Xeon Scalable Processors Specification Update, CLX53.<br/><br/>Enhancements:<br/>- Updated the Processor Microcode to version 0x3005 for the second-generation Intel Xeon Processor Scalable Family.<br/>- Updated the Processor Microcode to version 0x6A09 for the Intel Xeon Processor Scalable Family.  |
| 2102  | 2.10.0  | - Increased the 64bit Memory Mapped I/O allocation size, used for PCIe resource management, from 64GB to 256GB per root port to support Nvidia A100 GPU and other PCIe cards that request > 64GB of 64bit PCIe memory.<br/>- Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2020.2.<br/>- Removed the Logical Processor requirement for Monitor/MWait.  |
| 2008  | 2.8.2  | Initial solution version  |

### PowerEdge R640 CPLD - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2108, 2112  | 1.0.6  | Fixes:<br/>-Addresses a possibility of IDRAC not responding during PSU firmware update.  |
| 2008, 2102  | 9.0.6  | Initial solution version  |

### Storage Backplane - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | 4.35  | Initial solution version  |

### Storage Backplane Expander - Azure Stack Hub

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2102, 2108, 2112  | 2.52  | - Addressed an issue with select 3rd party utilities where the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/>- Addressed a firmware update issue when performed when no hard drives are present.  |
| 2008  | 2.46  | Initial solution version  |

## HLH

### Boot Drive Controller - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | 2.5.13.3024  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 1.2.0.1052  | Support for Windows Azure HCI Stack & Windows 2022 enabled  |
| 2008, 2102, 2108, 2112  | 1.2.0.1051  | Initial solution version  |

### Capacity Drive Controller - HLH

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | 2.51.25.02  | Initial solution version  |

### Chipset - HLH

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | 10.1.9.2  | Initial solution version  |

### Dell uEFI Diagnostics - HLH

| Release version | Application version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 4301A73  | Enhancements: Changes to support new hardware.  |
| 2008, 2102, 2108, 2112  | 4301A38  | Initial solution version  |

### iDRAC - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 6.10.30.20  | Resolves issue with updating CPLD when iDRAC is at major version 5.  |
| 2112  | 5.00.10.20  | Enhancements:<br/>General<br/>-Option to clear the system critical status to healthy state when unconfigured internal drive is removed<br/>-Support Firmware update of TPM<br/>GUI Enhancements<br/>-Prevent Browser Refresh from Logging Out iDRAC User<br/>-Show PCIe slot inventory in a simplified view<br/>-Storage page - added new filters<br/>-Show the last used domain name by default in the login page (AD users)<br/>Redfish Updates<br/>-Redfish: Add ComputerSystem.GraceFulRestart<br/>-Redfish: support OperationApplyTime option for updates<br/>-Redfish: support ConvergedInfra.1#AppRawData attribute<br/>-Redfish: Support Redfish lifecycle events.<br/>-Redfish: Add HTTP/2 support to iDRAC9<br/>Support/Diagnostics<br/>-CPU & Memory Utilization logging in Support Assist Collection<br/>-Add PCIe tree of the system in the Support Assist Collection<br/>-SupportAssist Logs to include historical thermal inlet and outlet temperature<br/><br/>Fixes:<br/>-Fixed an issue that failed the local RACADM to update the error code value while the update job was running.<br/>-Fixed an issue that generated FAN0000/FAN0001 events for auxiliary Fan5 while system was in powered off state.<br/>-Fixed an issue that caused a failure in firmware rollback using DellUpdateService in Redfish interface.<br/>-System fan running at a higher speed than expected, on systems with actively cooled third-party GPUs.<br/>-Firmware update through local RACADM fails when the firmware image is uploaded from a local drive.<br/>-iDRAC resets to default settings, enforcing restoration of all settings including licenses.<br/>-Fixed Share HTTP IPV6 with FQDN was not working.<br/>-Fixed Observed connecting viewer --> unable to connect the viewer.<br/>-Fixed Observed vConsole is in connecting viewer state only when vConsole launched after 30 min idle state<br/>-Fixed 15G_iDRAC_Redfish_Halo_B ContainedBy attribute is shown as json empty for Modular Enclosure<br/>-Fixed Not able to clear the Provisioning Server details from Remote Enablement from IDRAC Hii<br/>-Fixed Multiple iDRAC monitor observed after perform creating VD<br/>-Fixed Incorrect Job name created in Job Queue when DC PSU FW updated on top of Linux or Win OS<br/>-Fixed Repository Update JID fails from custom repository  |
| 2108  | 4.40.10.00  | Fixes:<br/>- Fixed drive re-inventory problem when upgrading PERC firmware following warm boot (152057)<br/>- Fixed an iDRAC unresponsive issue when webserver is disabled (187318)<br/>- Fixed a PSU mismatch reporting issue on C6525 (185201)<br/>- Fixed an issue using custom webserver ports (185650)<br/>- Fixed redfish connection issue (186497)<br/><br/>Enhancements:<br/>- Support side band management for A100 GPU card  |
| 2102  | 4.40.00.00  | - Fixed issues that caused RAC0182 iDRAC watchdog reboots<br/>- In Compliance with STIG requirement: "network device must authenticate NTP"<br/>- Fixed an issue that was not allowing iDRAC to display the Network Devices<br/>- NVIDIA A100 250W PCIe GPU support<br/>- Removal of Telnet and TLS 1.0 from web server<br/>- Added support for new job states in Redfish API<br/>- Next-gen iDRAC virtual console and virtual media (eHTML5)  |
| 2008  | 4.22.00.00  | Initial solution version  |

### Intel D3-S4510 boot - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | DL6R  | Initial solution version.<br/><br/>Fixes:<br/>-SMART attribute shift solution<br/>-MRR settings to mitigate BJ004 issue<br/>-Fix for drive stops responding after soft-reboot following windows install  |
| 2309, 2112  | DL6R  | Initial solution version.<br/><br/>Fixes:<br/>-SMART attribute shift solution<br/>-MRR settings to mitigate BJ004 issue<br/>-Fix for drive stops responding after soft-reboot following windows install  |

### Intel D3-S4520 boot - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | DL70  | Initial solution version  |

### Intel S3520 boot - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | DL43  | Initial solution version<br/><br/>Fixes:<br/>-Numerous minor bug fixes<br/>-Fix for some M.2 drives not upgrading<br/><br/>Enhancements:<br/>-Added support for Instant Scramble Erase commands  |

### Micron 5100 M.2 480GB & 960GB - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2108, 2112  | E013  | Fixes:<br/>- Remove monitoring of 12V power bus, to improve drive stability in noisy 12V power conditions.<br/>- Improve wear leveling algorithms, to recover cleanly from power cycles and manage high write workloads better.<br/>- Fix to R_ERR handling, to eliminate case where high frequency of CRC errors may cause the drive to enter bus hang state.  |

### Micron 5300 boot - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | J004  | Initial solution version  |

### NIC - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | 20.5.13  | Fixes:<br/>  - Resolved a critical error observed while restoring default settings for the Intel(R) Ethernet<br/>     Converged Network Adapter X710 adapter.  |
| 2108  | 20.0.17  | Note: Intel(R) Ethernet 700 Series based adapters are subject to the content of Intel Technical Advisory TA_00380. Please review INTEL_TA_00380 for more detail.<br/><br/>- Resolved an issue where port link status in iDRAC for Intel(R) Ethernet 10G 2P X710 OCP adapter or Intel(R) Ethernet 10G 4P X710 OCP adapter may still appear as up after cable is disconnected.<br/>- Resolved an issue where some X710 based adapters may display the Dell Family Firmware Version (FFV) instead of the OS driver version when viewing the device driver version in iDRAC.  |
| 2008, 2102  | 19.5.12  | Initial solution version  |

| Release version | Driver version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2112  | 1.16.62.0  | Fixes:<br/>- Resolved an issue on Windows 2019 where the driver was not being listed in "Uninstall<br/>Programs". When downgrading from 20.5.0 drivers to 20.0.0 drivers, please first uninstall<br/>the 20.5.0 package via Add or Remove programs.<br/>- Resolved an issue so Intel(R) Ethernet Converged Network Adapter X710-T adapter no longer<br/>advertises the unsupported 100 Mbps speed in adapter settings.<br/>- Resolved an issue where device drivers could not be reinstalled after being uninstalled.  |
| 2108  | 1.13.104.0  | - Resolved an issue on Windows OSs where using "Identify Adapter" under X710 based adapters' Adapter Properties in Device Manager does not blink the adapter LEDs.  |
| 2008, 2102  | 1.11.101.0  | Initial solution version  |

### PowerEdge R640 BIOS - HLH

| Release version | BIOS version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 2.18.1  | Includes multiple security fixes since previous release.  |
| 2112  | 2.12.2  | Fixes:<br/>- Incorrect critical error pop-up message that was seen while exiting iDRAC Settings menu.<br/>- Fixed BIOS only report partial data in iDRAC/LC for system/setup password after set by SCP from iDRAC.<br/>- Fix HTTP boot failure with single DNS entry in static IPv4 address mode.<br/><br/>Enhancements:<br/>- Support for Microsoft Windows Server 2022 Operating System.<br/>- Updated the S140 Software RAID firmware to version 5.6.0-0002.<br/>- Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2021.1.<br/>- Updated the Processor Microcode to version 0x3102 for the second-generation Intel Xeon Processor Scalable Family.<br/>- Updated the Processor Microcode to version 0x6B06 for the Intel Xeon Processor Scalable Family.<br/>- Updated the Purley Refresh PV Candidate Reference Code Version 612D02.<br/>- Updated the AEP Release 1.0.0.3515 files to Purley Refresh UEFI Source.<br/>- Updated SPS to SPS_E5_04.01.04.505.0 (IPU 2021.1) for Purley Refresh.<br/>- Enhancement to address the security vulnerabilities (Common Vulnerabilities and Exposures - CVE) such as CVE-2021-21555, CVE-2021-21556, CVE-2021-21557, CVE-2020-24511, CVE-2020-12358, CVE-2020-12360, CVE-2020-24486, CVE-2019-14553, CVE-2021-21571.  |
| 2108  | 2.10.2  | Fixes:<br/>- Fixed an Intel errata reported on IPU 2020.1 and 2020.2 where the system could potentially not respond or reboot during POST when "Configuring Memory..." is displayed on the screen. This scenario may be encountered during system boot, where self-heal is attempted. The root cause is a race condition where during the self-heal process, a refresh cycle may not have completed when the CPU issues self-heal related commands to the DRAM.<br/>The Issue is described in Intel Xeon Processor Scalable Family Specification Update, SKX120 and second-generation Intel Xeon Scalable Processors Specification Update, CLX51.<br/>- Fixed an issue where an invalid location was specified for a self-heal request. This results in self-heal not being performed, which could potentially not respond or reboot the system during POST when "Configuring Memory..." is displayed on the screen. Note: The Dell PowerEdge BIOS will automatically schedule DIMM self-healing during POST, based on DIMM health monitoring of correctable and uncorrectable errors from previous system boots.<br/>- Updated Intel processor microcode to address the following issues:<br/>1. High Levels of Posted Interrupt Traffic on The PCIe Port May Result in a Machine Check with a TOR Timeout. The Issue is described in the Intel Xeon Processor Scalable Family Specification Update, SKX123 and Second-generation Intel Xeon Scalable Processors Specification Update, CLX52.<br/>2. Some Short Loops of Instructions May Cause a 3-Strike Machine Check without a TOR Timeout. The Issue is described in the Second-generation Intel Xeon Scalable Processors Specification Update, CLX53.<br/><br/>Enhancements:<br/>- Updated the Processor Microcode to version 0x3005 for the second-generation Intel Xeon Processor Scalable Family.<br/>- Updated the Processor Microcode to version 0x6A09 for the Intel Xeon Processor Scalable Family.  |
| 2102  | 2.10.0  | - Increased the 64bit Memory Mapped I/O allocation size, used for PCIe resource management, from 64GB to 256GB per root port to support Nvidia A100 GPU and other PCIe cards that request > 64GB of 64bit PCIe memory.<br/>- Updated the "Processor and Memory Reference Code" for the second-generation Intel Xeon Processor Scalable Family to IPU 2020.2.<br/>- Removed the Logical Processor requirement for Monitor/MWait.  |
| 2008  | 2.8.2  | Initial solution version  |

### PowerEdge R640 CPLD - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2108, 2112  | 1.0.6  | Fixes:<br/>-Addresses a possibility of IDRAC not responding during PSU firmware update.  |
| 2008, 2102  | 9.0.6  | Initial solution version  |

### Storage Backplane - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2008, 2102, 2108, 2112  | 4.35  | Initial solution version  |

### Storage Backplane Expander - HLH

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309, 2102, 2108, 2112  | 2.52  | - Addressed an issue with select 3rd party utilities where the LED Identify operation continues to blink after a planned drive replacement operation as completed.<br/>- Addressed a firmware update issue when performed when no hard drives are present.  |
| 2008  | 2.46  | Initial solution version  |

## Switches

### DELL BMC - Dell S3048 Switch

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 9.14.2.11  | Latest Dell recommended version for OS9 switches with Azure Stack Hub as of April 2023.  |
| 2102, 2108, 2112  | 9.14.2.9  | - Updated to Dell recommended version<br/>- Sev 3 issue fix - avoid potential software exception at bootup<br/>- Sev 2 issue fix - PSU serial not showing in inventory.  |
| 2008  | 9.14.2.4  | Initial solution version  |

### DELL TOR - Dell S5048F Switch

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 9.14.2.11  | Latest Dell recommended version for OS9 switches with Azure Stack Hub as of April 2023.  |
| 2102, 2108, 2112  | 9.14.2.9  | - Updated to Dell recommended version<br/>- Sev 3 issue fix - avoid potential software exception at bootup<br/>- Sev 2 issue fix - PSU serial not showing in inventory.  |
| 2008  | 9.14.2.4  | Initial solution version  |

### DELL BMC - Dell N3248TE-ON Switch

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 10.5.3.2.89  | Latest Dell recommended version for OS10 switches with Azure Stack Hub as of April 2023.  |
| 2112  | 10.5.2.7.374  | Initial solution version  |

### DELL TOR - Dell S5248-ON Switch

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2309  | 10.5.3.2.89  | Latest Dell recommended version for OS10 switches with Azure Stack Hub as of April 2023.  |
| 2112  | 10.5.2.7.374  | Initial solution version  |
