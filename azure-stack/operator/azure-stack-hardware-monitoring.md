---
title: Monitor hardware health in Azure Stack Hub
description: Learn how to monitor Azure Stack Hub hardware components, including system fans, temperature, and power supplies. Set up SNMP alerts to stay ahead of failures.
author: sethmanheim
ms.topic: concept-article
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 11/21/2019

# Intent: As an Azure Stack Hub operator, I want to monitor the status and health of my hardware components and set alerts when needed.
# Keyword: monitor hardware health azure stack hub

---

# Monitor Azure Stack Hub hardware components

The Azure Stack Hub health and monitoring system monitors the storage subsystem and raises alerts as needed. The health and monitoring system can also raise alerts for the following hardware components:

- System fans
- System temperature
- Power supply
- CPUs
- Memory
- Boot drives

> [!NOTE]
> Before you enable this feature, validate with your hardware partner that they're ready. Your hardware partner also provides the detailed steps for enabling this feature in the baseboard management controller (BMC). For build 2005 and later, the user encryption in the base board management controller must be set to AES.

## SNMP listener scenario

An SNMP v3 listener runs on all three ERCS instances on TCP port 162. You must configure the BMC to send SNMP traps to the Azure Stack Hub listener. Get the three PEP IPs from the administrator portal by opening the region properties view.

Sending traps to the listener requires authentication and must use the same credential as accessing base BMC itself.

When an SNMP trap is received on any of the three ERCS instances on TCP port 162, the OID is matched internally and an alert is raised. The Azure Stack Hub health and monitoring system only accepts OIDs defined by the hardware partner. If an OID is unknown to Azure Stack Hub, it doesn't match it to an alert.

When you replace a faulty component, the BMC sends an event to the SNMP listener that indicates the state change. The alert then closes automatically in Azure Stack Hub.

> [!NOTE]
> Existing alerts don't close automatically when you replace the entire node or motherboard. The same condition applies when the BMC loses its configuration, such as due to a factory reset.

## Next steps

[Firewall integration](azure-stack-firewall.md)
