---
title: Azure Stack Hub Ruggedized OEM Release Notes
description: Azure Stack Hub Ruggedized OEM Release Notes
author: sethmanheim
ms.topic: article
ms.date: 12/08/2020
ms.author: sethm
ms.reviewer: danlewi
ms.lastreviewed: 12/08/2020

---

# Azure Stack Hub Ruggedized 2008 OEM release notes

This article contains release and version information for the Ruggedized Cloud Appliance.

## Overview

This document describes the contents of Azure Stack Hub Ruggedized Cloud Appliance first party updates for firmware and drivers. This update includes improvements and fixes for the latest release of Azure Stack Hub. Below are the download links:

* https://aka.ms/azshwpackage
* https://aka.ms/azshwmanifest

## Baseline and document history

| Release | Date       | Description of changes         |
|---------|------------|--------------------------------|
| 2008    | 10/13/2020 | 2.2.2010.5 OEM package updates |

## Firmware

### Bios

| Release version | Firmware version | Changes                                                                                                                                                                                                                                                                                                                                                                                                       |   |   |
|-----------------|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---|---|
| 2008            | 2.8.2            | Fixed an industry-issue seen on BIOS versions 2.6.4 through 2.8.1 where the system may reset during power-on at the time "Configuring Memory" is displayed on the boot screen. The issue is applicable to DDR4 and NVDIMM-N memory configurations.<br><br>Enhancement to address the security vulnerabilities (Common Vulnerabilities and Exposures-CVE) such as CVE-2020-0545, CVE-2020-0548, and CVE-2020-0549. |   |   |
| 2005            | 2.7.7            |                                                                                                                                                                                                                                                                                                                                                                                                               |   |   |
|                 |                  |                                                                                                                                                                                                                                                                                                                                                                                                               |   |   |

### IDRAC

| Release version | Firmware version | Changes                                                                                                                                                                                                                                                                          |   |   |
|-----------------|------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---|---|
| 2008            | 4.22.0.0         | 167411: Fixed an issue that caused force system restart while updating firmware through Redfish API.<br><br>155376: Fixed an issue that caused iDRAC to reboot while collecting SupportAssist logs.<br><br>162778: Fixed a low memory condition on iDRAC due to virtual console service. |   |   |
| 2005            | 4.10.10.10       |                                                                                                                                                                                                                                                                                  |   |   |
|                 |                  |                                                                                                                                                                                                                                                                                  |   |   |

### NIC-Azure Stack nodes

| Release version    | Firmware version    | Changes                                                                                                          |
|--------------------|---------------------|------------------------------------------------------------------------------------------------------------------|
|     2008           |     14.27.60.08     | Fixed a firmware fatal assert that showed an IRISC HANG due to init_hca waiting on the timers flow lock release. |
|     2005           |     14.26.60.00     |                                                                                                                  |

### NIC-HLH

| Release version    | Firmware version    | Changes                                                                                                                                                                   |
|--------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     2008           |     19.5.12         | Resolved an issue on Intel(R) Ethernet X710 10Gb adapters in which the device's LED stays on after blinking when device LED is set to blink mode from F2 Device Settings. |
|     2005           |     19.0.12         |                                                                                                                                                                           |

### HBA-Azure Stack node capacity drives

| Release version    | Firmware version    | Changes    |
|--------------------|---------------------|------------|
|     2008           |     16.17.01.00     |            |
|     2005           |     16.17.00.05     |            |

### HBA-HLH capacity drives

|     Release version |     Firmware version |     Changes                                                                                           |
|---------------------|----------------------|-------------------------------------------------------------------------------------------------------|
| 2005, 2008          | 25.5.7.0005          | Fixed an issue where a controller could hang at boot due to an incomplete non-volatile memory config. |

### HBA - boot drives

| Release version | Firmware version | Changes                                                                                   |
|-----------------|------------------|-------------------------------------------------------------------------------------------|
| 2005, 2008      | 2.5.13.3024      | Fixed PPID Discrepancy for M.2 drives of BOSS controller in iDRAC Hardware inventory page |

### CPLD

| Release version | Firmware version | Changes                                                                                                                                                                                                |
|-----------------|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     2008        |     9.0.6        | Addresses possible IDRAC hang during firmware update.<br> Signal noise filtering added to prevent false errors reported.<br> Host memory map modified to prevent potential front USB port disablement. |
|     2005        |     1.0.6        |                                                                                                                                                                                                        |

### Drive FW

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008            | S402             | Enables future online firmware updates |
| 2005            | S401             |                                        |

## Drivers

### NIC

| Release version | Firmware version | Changes                                |
|-----------------|------------------|----------------------------------------|
| 2008            | 2.40.22511.0    |  |
| 2005            | 2.30.21713.0 |                                        |

### HBA - Capacity drives

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
|  2005, 2008   |  2.51.25.02  |         |

### HBA - Boot drives

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
|  2005, 2008   |  1.2.0.1051 |         |

### Intel chipset

| Release version | Firmware version | Changes |
|-----------------|------------------|---------|
|  2005, 2008   | 10.1.18243.8188 |         |
