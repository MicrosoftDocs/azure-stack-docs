---
title: "Storage Appliance Component Repair"
description: How to document describing storage appliance components replacement in an Operator Nexus instance.
author: matternst7258 
ms.author: matthewernst
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 12/12/2025
ms.custom: template-how-to
---

# Storage Appliance Component Remediation

The Operator Nexus platform architecture incorporates a storage component replacement process that enables storage Original Equipment Manufacturers (OEMs) to perform hardware remediation autonomously. When storage appliances experience operational failures or degradation, the platform's design allows OEM personnel to execute component-level replacements—including drives, controllers, and other field-replaceable units—without necessitating intervention on the platform or requiring system-level reconfiguration.

Throughout the process of replacing these components, the status of the Storage Appliance can be viewed either through the Azure portal or using [Command Line](./howto-storage-run-read.md).

## Pure Storage
### Prerequisites
Before performing a component repair on a Pure Storage FlashArray, confirm Pure Storage Support has determined there is a hardware fault as outlined in [Pure Support documentation](https://support.purestorage.com/bundle/m_technical_services_information/page/Pure_Storage_Technical_Services/Technical_Services_Information/topics/task/t_pure_storage_parts_replacement_procedure.html). Additionally, review the open Purity//FA alerts in the Purity GUI, or the Azure portal using the steps in the [Troubleshooting an Unhealthy or Degraded Storage Appliance](https://learn.microsoft.com/en-us/azure/operator-nexus/troubleshoot-unhealthy-degraded-storage-appliance#active-alerts) guide (Active Alerts section).

### Component Replacement
Pure Storage FlashArray appliances support nondisruptive component replacement through [Pure's standard repair procedure](https://support.purestorage.com/bundle/m_technical_services_information/page/Pure_Storage_Technical_Services/Technical_Services_Information/topics/task/t_pure_storage_parts_replacement_procedure.html) (sign-in required). All major hardware components—including controllers, drives, power supplies, and fans—are [hot-swappable](https://support.purestorage.com/bundle/50-0035-12/resource/50-0035-12.pdf) (sign-in required), allowing technicians to replace failed parts without taking the system offline. The FlashArray automatically retains its configuration across hardware replacements, eliminating the need for manual reconfiguration.

For chassis replacements, update the serial number using Azure CLI for asset tracking purposes. This does not impact Operator Nexus functionality.

```azurecli

az networkcloud storageappliance update --name <storageAppliance> -g <HostedResourceGroup> --serial-number "<serial_number>"

```
 ### Post-Replacement
After the component is replaced, confirm that the related Purity//FA alert has cleared in the Purity GUI or Azure portal, and verify that the new component replacement reports a healthy state in the Purity GUI or CLI. 

You can also validate the hardware status through Operator Nexus by running a [read-only diagnostic command](https://learn.microsoft.com/en-us/azure/operator-nexus/howto-storage-run-read). This command surfaces the hardware state directly from the Pure FlashArray, allowing you to confirm that the replacement part is detected and reporting a healthy status.

```azurecli
az networkcloud storageappliance run-read-command \
  --resource-group <resourceGroup> \
  --storage-appliance-name <storageApplianceName> \
  --command "purehw list"
```
