---
title: Monitor Azure Stack hardware health | Microsoft Docs
description: Learn how to monitor the health of Azure Stack hardware components.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.topic: conceptual
ms.date: 11/21/2019
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 11/21/2019

---

# Monitor Azure Stack hardware components

The health and monitoring system of Azure Stack already monitors the status of the storage subsystem and raises alerts as needed. With the 1910 release of Azure Stack, the health and monitoring system can now also raise alerts for the following hardware components:

- System fans
- System temperature
- Power supply
- CPUs
- Memory
- Boot drives

> [!NOTE]
> Prior to enabling this feature, you must validate with your hardware partner that they are ready. Your hardware partner will also provide the detailed steps for enabling this feature in the BMC.

## SNMP listener scenario

An SNMP v3 listener is running on all three ERCS instances on TCP port 162. The baseboard management controller (BMC) must be configured to send SNMP traps to the Azure Stack listener. You can get the three PEP IPs from the admin portal by opening the region properties view.

Sending traps to the listener requires authentication and must use the same credential as accessing base BMC itself.

When an SNMP trap is received on any of the three ERCS instances on TCP port 162, the OID is matched internally and an alert is raised. The Azure Stack health and monitoring system only accepts OIDs defined by the hardware partner. If an OID is unknown to Azure Stack, it will not match it to an alert.

Once a faulty component is replaced, an event is sent from the BMC to the SNMP listener that indicates the state change, and the alert will close automatically in Azure Stack.

> [!NOTE]
> Existing alerts will not close automatically when the entire node or motherboard is replaced. The same applies when the BMC loses its configuration; for example, due to a factory reset.

## Next steps

[Firewall integration](azure-stack-firewall.md)
