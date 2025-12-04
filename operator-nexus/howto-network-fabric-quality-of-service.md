---
title: How to Configure Quality of Service (QoS) in Azure Operator Nexus 
description: How to Configure Quality of Service (QoS) in Azure Operator Nexus 
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: article
ms.date: 12/04/2025
ms.custom: template-concept
---

# How to Configure Quality of Service (QoS) in Azure Operator Nexus 

Users can enable or disable QoS via Azure CLI.  

## Prerequisites 

- Use supported API and Fabric version.  
- Fabric must be in a state that allows updates (not in an immutable provisioning phase). 
 

## Option 1—Azure CLI 

### Enable (or disable) QoS on a fabric: 
```Azure CLI
az networkfabric fabric update \ 
  --subscription XXX_SUBSCRIPTION_ID \ 
  --resource-group XXX_RESOURCE_GROUP \ 
  --resource-name XXX_FABRIC_NAME \ 
  --qos-configuration "{qosConfigurationState:'Enabled'}" 
 ```
Use 'Disabled' to turn QoS off 

### Enable configuration lock: 
```Azure CLI
az networkfabric fabric configuration-lock enable \ 
  --subscription XXX_SUBSCRIPTION_ID \ 
  --resource-group XXX_RESOURCE_GROUP \ 
  --resource-name XXX_FABRIC_NAME 
```
### Commit configuration: 
```Azure CLI
az networkfabric fabric commit \ 
  --subscription XXX_SUBSCRIPTION_ID \ 
  --resource-group XXX_RESOURCE_GROUP \ 
  --resource-name XXX_FABRIC_NAME 
```

## Feature Behavior & Traffic Classification 

- Each packet is classified into a Traffic Class (TC); egress queues prevent low‑priority traffic from blocking high‑priority traffic. 
- DSCP (IP) and EXP (MPLS) determine classification. 
- Precedence is copied or rewritten into outer headers during encapsulation. 
 
Testing tips (IP traffic): If you need to generate traffic for a specific TC, set DSCP accordingly. For example, to hit TC4 use DSCP 24 → TOS 96: 
ping -Q 96 XXX.XXX.XXX.XXX 

## Troubleshooting 

### Verify prerequisites whenever expected QoS is missing on devices: 
QoS Enabled, Supported Fabric version, CE/ToR device on Arista 7280 (for main QoS config) and recent commit completed successfully 
### Read‑only CLI checks (Arista devices): 
```Azure CLI
show run section qos 
show qos interfaces 
show interface counters queue 
show interface counters queue ingress 
show interface counters queue drops 
show interface counters queue rates 
```








