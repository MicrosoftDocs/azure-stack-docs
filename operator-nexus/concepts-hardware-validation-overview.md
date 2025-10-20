---
title: Azure Operator Nexus hardware validation overview
description: Get an overview of hardware validation for Azure Operator Nexus.
author: vnikolin
ms.author: vanjanikolin
ms.date: 10/03/2025
ms.service: azure-operator-nexus
ms.topic: conceptual
---

# Azure Operator Nexus hardware validation overview

Hardware Validation (HWV) assesses the state and health of hardware components for a Bare Metal Machine (BMM) by executing test cases against the baseboard management controller (BMC). At this time, the Azure Operator Nexus platform is deployed on Dell servers. Dell servers use the integrated Dell remote access controller (iDRAC), which is the equivalent of a BMC.

## Tooling overview

HWV uses Redfish APIs to communicate with a BMM's BMC. HWV firmware updates are performed using the Redfish firmware push method.

## Hardware validation categories

HWV results can be viewed in the cluster Log Analytics Workspace (LAW). They're grouped in to five distinct categories.

- **System information**: Details about the server hardware, such as model, serial number, CPU, license, firmware, and memory configuration.
- **Drive information**: Status and inventory of storage devices, including type, capacity, and health of each drive.
- **Network information**: Information about network interfaces, MAC addresses, link status, neighbor information, and configuration.
- **Health information**: Overall health status of hardware components, including sensors, power supplies, and fans. BMC critical/failure logs and disruptive action results are also displayed in the health information.
- **Boot information**: Current boot order, boot device configuration, and related BIOS settings.

## Hardware validation updates and disruptive actions

If any discrepancies are detected during HWV, tooling makes an attempt to bring the BMM back to a healthy/acceptable deployment state.

Disruptive actions against BMM are run as needed during HWV:

- BMC/iDRAC reset
- Virtual flea drain
- Server power up/down
- TLS certificate cleanup
- RAID reset

Update/Auto-Fix actions:

- BIOS boot configuration Auto-Fix
- Firmware component Auto-Fix

If disruptive or update actions aren't successful, user intervention is required.

## Firmware component update

HWV verifies that firmware on 15G (Ice Lake) and 16G (Sapphire Rapids) Dell servers meets the minimum recommended version (N-2). If any firmware is below this minimum, HWV automatically updates it to a supported, stable version. For 15G servers, HWV checks and updates the BIOS, iDRAC, NIC, and CPLD components. For 16G servers, it checks and updates the iDRAC and NIC. If HWV can't update a component automatically, manual intervention is required to bring the firmware up to the minimum recommended version.

Firmware component versions and successful/failed update attempts are logged in the System information results.

Up to date Azure Operator Nexus firmware specs, and N-1 and N-2 versions can be found here: [Operator Nexus platform prerequisites](howto-platform-prerequisites.md)

## BIOS boot configuration update

HWV verifies that the BIOS boot configuration meets the requirements for successful bootstrapping. If any settings are incorrect, HWV automatically updates them to match the required specifications.
