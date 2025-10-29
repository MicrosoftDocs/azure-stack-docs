---
title: "Storage Appliance Component Repair"
description: How to document describing replacing storage appliance components in an Operator Nexus instance.
author: matternst7258 
ms.author: matthewernst
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 10/28/2025
ms.custom: template-how-to
---

# Storage Appliance Component Remediation

The Operator Nexus platform architecture incorporates a storage component replacement process that enables storage Original Equipment Manufacturers (OEMs) to perform hardware remediation autonomously. When storage appliances experience operational failures or degradation, the platform's design allows OEM personnel to execute component-level replacements—including drives, controllers, and other field-replaceable units—without necessitating intervention on the platform or requiring system-level reconfiguration.

Throughout the process of replacing these components, the status of the Storage Appliance can be viewed either through the Azure portal or using [Command Line](./howto-storage-run-read.md)

## Pure Storage

Pure Storage FlashArray appliances support nondisruptive component replacement through [Pure's standard repair procedure](https://support.purestorage.com/bundle/m_technical_services_information/page/Pure_Storage_Technical_Services/Technical_Services_Information/topics/task/t_pure_storage_parts_replacement_procedure.html) (sign-in required). All major hardware components—including controllers, drives, power supplies, and fans—are [hot-swappable](https://support.purestorage.com/bundle/50-0035-12/resource/50-0035-12.pdf) (sign-in required), allowing technicians to replace failed parts without taking the system offline. The FlashArray automatically retains its configuration across hardware replacements, eliminating the need for manual reconfiguration.

For chassis replacement, there is a need to update the serial number for customer tracking purposes.

```azurecli

az networkcloud storageappliance update --name <storageAppliance> -g <HostedResourceGroup> --serial-number "<serial_number>"

```
