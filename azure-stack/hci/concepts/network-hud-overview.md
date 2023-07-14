---
title: Network HUD overview 
description: This topic introduces Network HUD for Azure Stack HCI.
author: dcuomo
ms.topic: how-to
ms.date: 07/14/2023
ms.author: dacuo 
ms.reviewer: dacuo
---

# Network HUD overview

[!INCLUDE [applies-to]( ../../includes/hci-applies-to-22h2-21h2.md)]

Network HUD enables visibility across the network, simplifying operational network diagnostics. It performs real-time analysis of network issues and provides prescriptive alerts or auto-remediation of the issue when possible. These capabilities can increase stability and optimize network performance for workloads running on Azure Stack HCI.

## About Network HUD

Diagnosing network issues poses a significant challenge as administrators don't have visibility across the complete solution. The solution can be divided into several areas:

- Physical Network Switch (ToR), cabling, and NIC
- Cluster hosts: The HCI OS is installed here.
- Guest workloads (VMs or containers)

Network HUD can help:

- Identify misconfiguration on the physical network.
- Identify operational issues with physical hardware (NICs, cabling, physical switch).
- Identify and optimize your configuration for increased performance.
- Auto-remediate some host issues to increase stability and performance.

Network HUD integrates with existing technologies you're already using, like:

- Network ATC: Network HUD understands the intent of your adapters, ensuring the adapters are operating as expected.

- Cluster Health: Events from Network HUD are integrated with Cluster Health to ensure your existing tools continue to work. No other dashboards or alerting mechanisms are required.

## Definitions

**Network HUD:** An inbox feature that analyzes and remediates network issues.

**Network HUD Content:** Content that enables Network HUD to perform its analysis. This content is downloaded separately, can run in a disconnected state, and is easily updated. It's important that this content is updated regularly.

**Network HUD Content Detection:** Content detections watch for system and network behavior that indicates an issue is or will occur on your system. These detections are included in the Network HUD Content.

## Installation

Installation of Network HUD requires two steps:

1. Install Network HUD:

   ```PowerShell
   Install-WindowsFeature -Name NetworkHUD 
   ```

1. Install Network HUD Content:

   ```PowerShell
   Install-Module -Name Az.StackHCI.NetworkHUD -Force
   ```
   
1. Verify Network HUD is running: Network HUD will log an event indicating it has started in the Network HUD operational log once it verifies prerequisites have been met. If there are errors listed in this log, you must resolve the errors before Network HUD will start.

   ```PowerShell
   Get-WinEvent -LogName  Microsoft-Windows-Networking-NetworkHUD/Operational

   ProviderName: Microsoft-Windows-Networking-NetworkHUD

   TimeCreated                      Id LevelDisplayName Message
   -----------                      -- ---------------- -------
   11/18/2022 4:34:20 PM           105 Information      Network HUD has successfully started.
   ```

## View cluster health faults

If Network HUD detects a problem, it will throw a cluster health fault which you can view using

   ```PowerShell
   Get-HealthFault
   ```

## Network HUD capabilities

Network HUD can detect the following networking problems. For more information, see [Network HUD: November 2022 content update](https://techcommunity.microsoft.com/t5/networking-blog/network-hud-november-2022-content-update-has-arrived/ba-p/3676158).

### Network adapter

#### Disconnections or resets

**Fault Level: Critical**
Network HUD can detect if your adapter is disconnecting or resetting frequently. Adapters that disconnect or reset frequently can cause poor VM and container performance, or Storage Spaces Direct instability.

> [!VIDEO https://www.youtube.com/embed/g1TDW_GnhMQ]

#### PCIe bandwidth oversubscription

**Fault Level: Critical**

Network HUD can detect if adapters have enough PCIe bandwidth to satisfy the listed linkspeed of the adapters.

> [!VIDEO https://www.youtube.com/embed/GqOq3oBbRrM]

### Drivers

#### Inbox drivers

**Fault Level: Critical**

Inbox drivers are not supported for production use. Network HUD detects if inbox drivers are being used on your adapters.

#### Driver age

Network HUD will inform you if your drivers begin to age. Old network drivers should be updated for stability and performance benefits.

**Fault Level: Warning**

Network drivers between six (6) months and one (1) year old generate a warning.

**Fault Level: Critical**

Network drivers older than one (1) year generate a critical health fault.

## Next steps

- Review Network ATC defaults and example deployment options. See [Deploy host networking with Network ATC](..\deploy\network-atc.md).
