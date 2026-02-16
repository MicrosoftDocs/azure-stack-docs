---
title: Troubleshoot Temperature Guide for Azure Operator Nexus
description: Troubleshoot Temperature Guide for Azure Operator Nexus
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 02/16/2026
author: RaghvendraMandawale
ms.author: rmandawale
---

# Troubleshoot Temperature Guide for Azure Operator Nexus

## High Temperature 

### What to check 

- Verify fans are operational and fan speed is within expected range 
- Check system cooling status (system environment / cooling indicators) 
- Inspect airflow conditions: device orientation, ventilation clearance, rack density 
- Verify ambient temperature in lab / datacenter is within supported limits 
    

### Recommended actions 

- Configure alert thresholds to get early warning when fan speed reaches warning levels 
- Improve airflow management (correct orientation, better ventilation, reduce rack density) 
- Adjust ambient temperature to supported operating range 
- If issue persists or hardware malfunction is suspected, open a support case with Arista TAC and provide show tech-support output 
    

## Unhealthy (Critically High) Temperature 

### What to check 

- Perform all checks listed under High Temperature 
- Confirm temperature has exceeded critical thresholds for sustained duration 
    

### Recommended actions 

- Treat as hardware-impacting condition 
- Escalate immediately to Arista TAC 
- Provide show tech-support output and environment diagnostics for investigation 
    

## Low Temperature 

### What to check 

- Verify fan operation and ensure fans are not overcooling the device 
- Check ambient temperature in lab / datacenter is not below supported operating limits 
    

### Recommended actions 

- Adjust environmental conditions to bring ambient temperature within supported range 
- If low temperature persists or device behavior is abnormal, contact Arista TAC 
- Provide show tech-support output for analysis 
    

## References  

- [Customer Support - Arista](https://www.arista.com/en/support/customer-support) 
- [EOS 4.34.2F - Environment Commands - Arista](https://www.arista.com/en/um-eos/eos-environment-commands)