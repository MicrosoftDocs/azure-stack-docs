---
title: How to Disable Internal/External Networks in an Enabled Layer 3 Isolation Domain 
description: Learn about how to disable Internal/External networks in an enabled layer 3 isolation domain
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 05/16/2025
ms.custom: template-concept
---

# How to Disable Internal/External Networks in an Enabled Layer 3 Isolation Domain 

## Prerequisites

- Fabric must support CommitV2.
- ISD must be in Enabled state.
- Fabric Runtime version ≥ 6.0.1.

## Steps

### Common parameters used across commands:
- --resource-group <rg>_ – Resource group containing the ISD and network resources
- --l3-isolation-domain-name <isd-name>_ – The L3 Isolation Domain where networks belong
- --name <resource-name>_ – Internal/External network resource name
- --fabric <fabric-name>_ – Fabric resource name for commit operations

### Step 1: Disable an External Network (Administrative State)
```Azure CLI
az managednetworkfabric external-network update-administrative-state \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --name <external-network-name> \
  --state Disable
```
**Verify state**
```Azure CLI
az managednetworkfabric external-network show \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --name <external-network-name> \
  --query "{name:name, adminState:administrativeState, provState:provisioningState}"
```

### Step 2: Disable an Internal Network (Administrative State)
```Azure CLI
az managednetworkfabric internal-network update-administrative-state \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --name <internal-network-name> \
  --state Disable
``` 
**Verify state**
```Azure CLI
az managednetworkfabric internal-network show \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --name <internal-network-name> \
  --query "{name:name, adminState:administrativeState, provState:provisioningState}"
```

### Step 3: CommitV2 Workflow (Fabric-wide)
**Lock configuration**
```Azure CLI
az managednetworkfabric fabric lock-configuration \
  --fabric <fabric-name>   
```
**(Optional) Inspect the configuration diff before applying**
```Azure CLI
# Device-level configuration view
az managednetworkfabric fabric view-device-configuration \
  --fabric <fabric-name> \
  --output table
```     
**Commit configuration**
```Azure CLI
az managednetworkfabric fabric commit-configuration \
  --fabric <fabric-name>  
```
**Check commit job status**
```Azure CLI
az managednetworkfabric fabric show \
  --fabric <fabric-name> \
  --query "{name:name, provState:provisioningState, commitStatus:commitStatus}"
```

### Step 4: Re-enable a Network (Rollback / Enable)
**External Network: Enable**
```Azure CLI
az managednetworkfabric external-network update-administrative-state \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --name <external-network-name> \
  --state Enable  
``` 
**Internal Network: Enable**
```Azure CLI
az managednetworkfabric internal-network update-administrative-state \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --name <internal-network-name> \
  --state Enable   
```
**Commit the change**
```Azure CLI
az managednetworkfabric fabric lock-configuration --fabric <fabric-name>
az managednetworkfabric fabric commit-configuration --fabric <fabric-name> 
```

### Step 5: Optional step - Delete a Network (after Disable + Commit)
**External Network: Delete**
```Azure CLI
az managednetworkfabric external-network delete \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --name <external-network-name> 
```
**Internal Network: Delete**
```Azure CLI
az managednetworkfabric internal-network delete \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --name <internal-network-name>
```
### Notes
- **Always** perform a **Lock** followed by a **Commit** after administrative state changes.
- Deletion is permitted **only after** disable + commit success.
- Keep at least one Internal Network enabled per ISD to avoid service disruption.

### Important Notes

- Disable and commit must be completed before delete.
- Associated resources will also be disabled unless shared globally.

### FAQ
---

- **Why not allow direct delete?** To maintain configuration integrity and avoid traffic disruption.
- **Can disabled networks be re-enabled?** Yes, via commit flow.