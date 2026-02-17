---
title: Troubleshoot High CPU and Memory Utilization for Azure Operator Nexus
description: Troubleshoot High CPU and Memory Utilization for Azure Operator Nexus
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 02/16/2026
author: RaghvendraMandawale
ms.author: rmandawale
---

# Troubleshoot high CPU and memory utilization for Azure Operator Nexus

This guide helps you identify, assess, and remediate CPU and memory utilization conditions that may affect device performance and health in Azure Operator Nexus.

## High CPU or Memory Utilization  

### What to check  

- Verify whether the device is handling unusually high traffic levels. This may be expected under certain workloads.
- Check if the device is in maintenance mode, which can temporarily cause CPU or memory spikes.  
- Look for signs of abnormal traffic patterns such as broadcast or control plane storms.  
    

### Recommended actions  

- If high utilization is sustained, consider applying a CPU traffic policy to protect the control plane from excessive traffic.
- If the issue persists and impacts device manageability, contact Microsoft Customer Support.  
- For Arista devices with multiple hardware SKUs, if traffic levels or memory consumption remain consistently high, consider upgrading to a higher capacity SKU, where supported.  
    

## Unhealthy (Critically High) CPU or Memory Utilization  

### What to check  
- Same checks as listed under High CPU / Memory Utilization.  
    

### Recommended actions  
- Follow the same remediation steps as above.  
- Engage Microsoft Customer Support if the device remains in an unhealthy state.  
    

## Low CPU or Memory Utilization  

### What to check  
- Verify whether the device has been in maintenance mode for an extended period, which can result in very low utilization readings.  
    

### Recommended actions  

- If maintenance activities are complete, remove the device from maintenance mode, where applicable.  
- If low utilization persists unexpectedly, contact Microsoft Customer Support for further investigation.
