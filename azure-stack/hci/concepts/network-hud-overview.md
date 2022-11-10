---
title: Network HUD overview 
description: This topic introduces Network HUD for Azure Stack HCI.
author: sethmanheim
ms.topic: how-to
ms.date: 11/09/2022
ms.author: sethm 
ms.reviewer: dacuo
---

# Network HUD overview

[!INCLUDE [applies-to]( ../../includes/hci-applies-to-22h2-21h2.md)]

Network HUD ("heads up display") enables visibility across the network, simplifying operational network diagnostics. It performs real-time analysis of network issues and provides prescriptive alerts or auto-remediation of the issue when possible. These capabilities can increase stability and optimize network performance for workloads running on Azure Stack HCI.

## About Network HUD

Diagnosing network issues poses a significant challenge as administrators do not have visibility across the complete solution. The solution can be divided into several areas:

- Physical Network Switch (ToR), cabling, and NIC
- Cluster hosts: The HCI OS is installed here.
- Guest workloads (VMs or containers)

Network HUD can help:

- Identify misconfiguration on the physical network.
- Identify operational issues with physical hardware (NICs, cabling, physical switch).
- Identify and optimize your configuration for increased performance.
- Auto-remediate some host issues to increase stability and performance.

Network HUD integrates with existing technologies you’re already using, like:

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
   Install-Module -Name Az.Network.HUD  
   ```

## Next steps

- Review Network ATC defaults and example deployment options. See [Deploy host networking with Network ATC](..\deploy\network-atc.md).