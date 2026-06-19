---
title: How to Configure Quality of Service (QoS) in Azure Operator Nexus 
description: How to Configure Quality of Service (QoS) in Azure Operator Nexus 
author: dougbristow
ms.author: dbristow
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 12/04/2025
ms.custom: template-concept
---

# How to Configure Quality of Service (QoS) in Azure Operator Nexus 

Users can enable or disable QoS via Azure CLI.  

## Prerequisites 

- Use supported API and Fabric version.  
- Fabric must be in a state that allows updates (not in an immutable provisioning phase).
- States that allow fabric update:

    #### Network Fabric Update (PATCH) — Allowed & Blocked States
    
    ##### Configuration State
    
    | Allowed ✅ | Blocked ❌ |
    |-----------|-----------|
    | Succeeded | Provisioning |
    | Provisioned | Deprovisioning |
    | Deprovisioned | Rejected |
    | ErrorProvisioning | DeferredControl |
    | ErrorDeprovisioning | PendingCommit |
    | Accepted | PendingAdministrativeUpdate |
    | Failed | CommitStaged |
    | | CommitStageFailed |
    | | CommitRollbackFailed |
    | | Initializing |
    
    ##### Lock States
    
    | Lock Type | Allowed ✅ | Blocked ❌ |
    |-----------|-----------|-----------|
    | Administrative Lock | Disabled | Enabled |
    | Configuration Lock (Commit Lock) | Disabled | Enabled |
    
    ##### Under Maintenance — Exempted Reasons (PATCH still allowed)
    
    | Reason |
    |--------|
    | NniUpdateInProgress |
    | ControlPlaneAclsUpdated |
    | TrustedIpPrefixesUpdated |
    
    Any other `UnderMaintenance` reason → ❌ PATCH blocked

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
az networkfabric fabric lock-fabric \
  --subscription XXX_SUBSCRIPTION_ID \
  --resource-group XXX_RESOURCE_GROUP \
  --network-fabric-name XXX_FABRIC_NAME \
  --lock-type Configuration \
  --action Lock
```
### Commit configuration: 
```Azure CLI
az networkfabric fabric commit-configuration \
  --subscription XXX_SUBSCRIPTION_ID \
  --resource-group XXX_RESOURCE_GROUP \
  --resource-name XXX_FABRIC_NAME 
```

Note: The commit-configuration will remove the Configuration lock on Fabric

## Feature behavior & traffic classification 

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








