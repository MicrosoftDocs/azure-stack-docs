---
title: Troubleshoot Packet Drops, Discards, and Errors for Azure Operator Nexus
description: Troubleshoot Packet Drops, Discards, and Errors for Azure Operator Nexus
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 02/16/2026
author: RaghvendraMandawale
ms.author: rmandawale
---

# Troubleshoot packet drops, discards, and errors for Azure Operator Nexus

## Dropped Packets 

This section provides guidance to identify, analyze, and remediate packet drops, discards, and interface‑level errors that may impact network reliability and performance.

### What to Check 

- Validate whether packet drops are expected due to normal forwarding behavior (for example, buffer exhaustion under load). 
- Review traffic policing and rate‑limiting configuration that may intentionally drop packets. 
- Correlate drops with traffic spikes or congestion events. 
    

### Recommended actions 

- Tune traffic policing or rate‑limit configuration if drops are unintended. 
- If drops persist and impact traffic, engage Arista Technical Assistance Center (TAC) for further analysis. 
    

## Interface In Discards 

### What to Check 

- Determine whether discards are caused by buffer overflows, congestion, or traffic policing. 
- Review interface queue health and identify queues experiencing drops. 
- Identify interfaces reporting non‑zero discard counters and isolate affected ports. 
- Verify whether Quality of Service (QoS) policies are enforcing drops. 
- Inspect hardware‑level discard reasons (for example VLAN or routing‑related drops). 
    

### Recommended actions 

- Adjust queue configuration or traffic patterns to reduce congestion. 
- Review and correct QoS or policing policies if misconfigured. 
- If discards can't be explained or resolved, engage Arista TAC and provide interface counters, queue statistics, and relevant logs. 
    

## Interface In Errors 

### What to Check 

- Identify physical‑layer issues such as cabling faults, optical issues, or transient link instability. 
- Validate whether malformed or corrupted packets are being received. 
- Review interface error counters to determine error patterns. 
    

### Recommended actions 

- Inspect and replace faulty cables, optics, or transceivers. 
- Verify link configuration consistency across both ends of the interface. 
- If errors persist, escalate to Arista TAC for deeper diagnostics. 
    

## Interface Out Discards 

### What to Check 

- Determine whether outbound congestion is causing packet drops. 
- Review egress queue utilization and buffer behavior. 
- Check for traffic policing or shaping on outbound interfaces. 
    

### Recommended actions 

- Adjust queue allocation or traffic shaping to reduce congestion. 
- Review QoS policies applied to outbound traffic. 
- Engage Arista TAC if drops persist or can't be correlated to expected traffic behavior. 
    

## Interface In or Out Errors 

### What to Check 

- Confirm Ethernet frame errors at the data‑link (L2) layer. 
- Validate speed, duplex, and autonegotiation settings on both ends of the link. 
- Review optical power levels and physical media health. 
    

### Recommended actions 

- Replace faulty cables or transceivers and clean fiber connectors. 
- Correct speed, duplex, or negotiation mismatches. 
- If error rates remain high, escalate to Arista TAC with interface diagnostics and optical readings. 
    

## LACP Errors 

### What to Check 

- Validate LACP configuration consistency (mode, timers, LAG identifiers). 
- Confirm all LAG member ports have identical attributes (speed, MTU, VLAN configuration). 
- Inspect physical link health for all LAG members. 
- Verify LACP control traffic isn't blocked by policies or control‑plane features. 
- Ensure no conflicting LACP controllers or bonding configurations exist. 
    

### Recommended actions 

- Correct configuration mismatches across LAG members. 
- Replace faulty cables, optics, or ports. 
- Resolve control‑plane or policy conditions blocking LACP PDUs. 
- Engage Arista TAC if LACP instability persists. 
    

## Ethernet CRC Errors 

### What to Check 

- Identify corrupted frames indicating physical‑layer issues. 
- Review interface counters on both ends of the link. 
- Validate optical power levels are within supported ranges. 
    

### Recommended actions 

- Replace damaged cables or faulty transceivers. 
- Clean fiber connectors and reseat optics. 
- Correct speed, duplex, or negotiation mismatches. 
- Escalate to Arista TAC if CRC errors continue after remediation.
