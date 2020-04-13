---
title: Monitor Azure Stack Hub hardware health 
description: Learn how to monitor the health of Azure Stack Hub hardware components.
author: sethmanheim

ms.topic: conceptual
ms.date: 02/24/2020
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 11/21/2019

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Monitor Azure Stack Hub hardware components

The Azure Stack Hub health and monitoring system monitors the status of the storage subsystem and raises alerts as needed. The health and monitoring system can also raise alerts for the following hardware components:

- System fans
- System temperature
- Power supply
- CPUs
- Memory
- Boot drives

> [!NOTE]
> Prior to enabling this feature, you must validate with your hardware partner that they are ready. Your hardware partner will also provide the detailed steps for enabling this feature in the BMC.

## SNMP listener scenario

An SNMP v3 listener is running on all three ERCS instances on TCP port 162. The baseboard management controller (BMC) must be configured to send SNMP traps to the Azure Stack Hub listener. You can get the three PEP IPs from the admin portal by opening the region properties view.

Sending traps to the listener requires authentication and must use the same credential as accessing base BMC itself.

When an SNMP trap is received on any of the three ERCS instances on TCP port 162, the OID is matched internally and an alert is raised. The Azure Stack Hub health and monitoring system only accepts OIDs defined by the hardware partner. If an OID is unknown to Azure Stack Hub, it will not match it to an alert.

Once a faulty component is replaced, an event is sent from the BMC to the SNMP listener that indicates the state change, and the alert will close automatically in Azure Stack Hub.

> [!NOTE]
> Existing alerts will not close automatically when the entire node or motherboard is replaced. The same applies when the BMC loses its configuration; for example, due to a factory reset.

## Next steps

[Firewall integration](azure-stack-firewall.md)
