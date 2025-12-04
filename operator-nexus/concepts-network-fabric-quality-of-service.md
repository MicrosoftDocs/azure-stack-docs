---
title: Network Fabric Quality of Service (QoS) in Azure Operator Nexus 
description: Overview of Network Fabric Quality of Service (QoS) in Azure Operator Nexus.
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: article
ms.date: 12/04/2025
ms.custom: template-concept
---

# Network Fabric Quality of Service (QoS) in Azure Operator Nexus 

Quality of Service (QoS) on Managed Network Fabric ensures that higher‑priority traffic is protected under congestion. When enabled, the fabric classifies packets into Traffic Classes—each backed by distinct egress queues—so that critical flows aren't queued behind lower‑priority traffic. Classification uses DSCP (for IP) and EXP (for MPLS) markings; precedence is preserved or rewritten appropriately when encapsulation adds an outer header. 
 
From the supported API version, the NetworkFabric resource includes a qosConfiguration properties with the single field:  
```Azure CLI
{ 
  "qosConfiguration": { 
    "qosConfigurationState": "Enabled" | "Disabled" 
  } 
} 
```

- Default: Disabled (for new deployments unless explicitly set). 
- Forward compatibility: If sent to earlier API versions, the property is ignored. 
- Idempotency: Re‑sending the same state is a no‑op. 
 
## When enabled, the service applies: 
- A fixed base QoS configuration (mappings, queue behavior) to CE/ToR devices (Arista 7280, Supported NF versions). 
- Light‑weight marking for management traffic (GNMI, SSH) across all devices.


## Next steps

[How to Configure Quality of Service (QoS) in Azure Operator Nexus ](./howto-network-fabric-quality-of-service.md)
