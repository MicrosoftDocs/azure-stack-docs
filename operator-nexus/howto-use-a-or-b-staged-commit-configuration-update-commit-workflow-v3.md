---
title: How to perform A / B staged commit configuration update commit workflow v3 in Azure Operator Nexus
description: Learn about how to perform A / B staged commit configuration update commit workflow v3 in Azure Operator Nexus
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 05/26/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

# How to perform A / B staged commit configuration update commit workflow v3 in Azure Operator Nexus

## Prerequisites
-------------

- Network Fabric runtime ≥ 7.0.0, NNF 10.0, GA API 2025-07-15 or later.
- Contributor rights on the resource group and fabric.
- Fabric must be in Provisioned and Enabled state, with no active commit batch in progress.

### Step 1: Make ARM Resource Changes (Pre-commit)
----------------------------------------------
Apply your intended configuration changes to ARM resources. These changes form the candidate configuration for A/B staging. <br>
#### Example: Update L3 Isolation Domain (ISD) to enable a new QoS policy and associate a new route policy
```Azure CLI
az managednetworkfabric l3-isolation-domain update \ 
  --resource-group <rg> \ 
  --name <isd-name> \ 
  --annotation "AB-staged change: tighten routing, add aggregate prefixes" \ 
  --redistribute-connected-subnets True \ 
  --redistribute-static-routes False \ 
  --aggregate-route-configuration '{ 
    "ipv4Routes": [ 
      { "prefix": "10.10.0.0/16" }, 
      { "prefix": "10.20.0.0/16" } 
    ], 
    "ipv6Routes": [ 
      { "prefix": "2001:db8:100::/40" } 
    ] 
  }' \ 
  --connected-subnet-route-policy '{ 
    "exportRoutePolicyId": "/subscriptions/<subscriptionId>/resourceGroups/<rg>/providers/Microsoft.ManagedNetworkFabric/routePolicies/route-policy-v2", 
    "exportRoutePolicy": { 
      "exportIpv4RoutePolicyId": "/subscriptions/<subscriptionId>/resourceGroups/<rg>/providers/Microsoft.ManagedNetworkFabric/routePolicies/route-policy-v2", 
      "exportIpv6RoutePolicyId": "/subscriptions/<subscriptionId>/resourceGroups/<rg>/providers/Microsoft.ManagedNetworkFabric/routePolicies/route-policy-v2" 
 } 
 }' \ 
  --tags env=prod change=ab-staged
```

### Step 2: Lock the Fabric for Configuration

```Azure CLI
az managednetworkfabric fabric lock-configuration \ 
   --resource-group <rg> \ 
   --fabric-name <fabric-name> 
```
- This locks the fabric for configuration changes and is required before any commit workflow.

### Step 3: Validate Candidate Configuration
```Azure CLI
# View device-level configuration (candidate vs current) 
az managednetworkfabric fabric view-device-configuration \ 
  --resource-group <rg> \ 
  --fabric-name <fabric-name> \ 
  --output table 
```

### Step 4: Commit Configuration (A/B Staged Update)
```Azure CLI
az managednetworkfabric fabric commit-configuration \ 
  --resource-group <rg> \ 
  --fabric-name <fabric-name> 
```
- This applies the candidate configuration to the fabric according to the current commit policy (including staged/CE-first if set in the resource). 

### Step 5: Monitor Commit Status
```Azure CLI
# Get the full commit batch status object for a fabric 
az managednetworkfabric fabric commit-batch-status \ 
  --resource-group <rg> \ 
  --fabric-name <fabric-name> \ 
```

## Discard or Rollback incase of changes (Commit Batch Management) 

### Step 6: Unlock the Fabric
```Azure CLI
az managednetworkfabric fabric unlock-configuration \ 
  --resource-group <rg> \ 
  --fabric-name <fabric-name> 
```

### Step 7 (optional): Discard or Rollback
--------------------------------------

#### 7.1 Discard Commit Batch (Before Staging to Device)

If you have locked the fabric and created a commit batch but have **not yet staged the configuration to any device**, you can **discard the commit batch**. This will abandon the candidate configuration and unlock the fabric for new changes.
```Azure CLI
az managednetworkfabric fabric discard-commit-configuration \ 
    --resource-group <rg> \ 
    --fabric-name <fabric-name> 
```
##### Effect:
- The candidate configuration is dropped.
- No changes are pushed to any device.
- The fabric is unlocked and ready for a new commit workflow.

#### 7.2 Rollback (After Staging to Device, Before Final Commit)

If you have already staged the configuration to a device (e.g., CE1 or CE2) but **have not yet performed the final commit**, you can **rollback** the staged changes. This will revert the device(s) to the previous golden configuration and abandon the batch.
```Azure CLI
az managednetworkfabric fabric rollback-commit-configuration \ 
   --resource-group <rg> \ 
   --fabric-name <fabric-name> 
```
##### Effect:
- Only available after staging to device, before final commit.
- Device(s) are reverted to their pre-staging state.
- The batch is closed; the fabric remains locked until explicitly unlocked.

#### 7.3 No Rollback/Discard After Final Commit

- **After the final commit is performed, rollback or discard is NOT available.**
- To remediate, you must update the ARM resources to the desired state and repeat the lock/commit workflow as a new batch.

## Summary Table: Discard/Rollback Actions

| **Stage**<br> | **Supported Action**<br> | **Command Example**<br> |
| --- | --- | --- |
| **Before device staging**<br> | Discard commit batch<br> | az managednetworkfabric fabric discard-commit-configuration<br> |
| **After device staging**<br> | Rollback staged changes<br> | az managednetworkfabric fabric rollback-commit-configuration<br> |
| **After final commit**<br> | No rollback/discard; new batch<br> | Update ARM, lock, commit, unlock<br> |

## Troubleshooting

- **Check commit batch status:**
```Azure CLI
az managednetworkfabric fabric show --resource-group <rg> --fabric-name <fabric-name> --query "commitStatus" 
```
- **View operation logs and diagnostics** for errors or unexpected results.