---
title: How to enable system-assigned managed identity (SAMI) for the Network Fabric resource in Azure Operator Nexus
description: Learn about how to enable system-assigned managed identity (SAMI) for the Network Fabric resource in Azure Operator Nexus
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 03/30/2026
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to
---

# How to enable system-assigned managed identity (SAMI) for the Network Fabric resource in Azure Operator Nexus

This guide explains how to enable System Assigned Managed Identity (SAMI) for the Network Fabric resource, including new-resource and existing-resource paths, identity transition rules, lock/commit considerations, and role requirements.


## Identity model and constraints

### Supported identity modes on Network Fabric resource
- `SystemAssigned`
- `UserAssigned`
- `SystemAssigned,UserAssigned`

### Important constraints
- `None` is not supported.
- SAMI removal is not supported once associated for trusted-access scenarios.
- If SAMI is accidentally disassociated (for example via an incorrect `None` PATCH), re-associate SAMI as soon as possible.
- For updates where UAMI already exists and SAMI must be added, provide both identities (`SystemAssigned,UserAssigned`) in effective payload terms.

> [!IMPORTANT]
> Preserving SAMI is required to prevent token acquisition failures in Network Fabric operational flows. If SAMI is removed or identity is set to `None`, re-associate SAMI immediately.

## Prerequisites

- Azure CLI logged in to correct subscription/tenant.
- `managednetworkfabric` extension installed and current.
- Network Fabric resource lifecycle checks before identity updates:
  - `provisioningState = Succeeded`
  - resource is not locked for the intended operation
- Version guidance:
  - Commit v2 workflow capabilities require Network Fabric resource version and API support (for example `2024-06-15-preview` or newer APIs for lock and commit v2 flows).
- For latest identity visibility in your environment, use `2025-07-15` when available.

## For new resources

### 1. Create Network Fabric Resource with SAMI only

```bash
az networkfabric fabric create \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --location <region> \
  --mi-system-assigned
```

> [!NOTE]
> For the full create command argument set, refer to the public documentation: [Create a Network Fabric](https://learn.microsoft.com/azure/operator-nexus/howto-configure-network-fabric#create-a-network-fabric) 

This guide shows the minimum arguments relevant to SAMI enablement, not the complete set of arguments for resource creation.

| Argument | Purpose | Example |
|---|---|---|
| `--resource-group` | Resource group for the Network Fabric resource. | `my-nf-rg` |
| `--resource-name` | Network Fabric resource ARM name. | `my-nf` |
| `--location` | Deployment region. | `eastus2euap` |
| `--mi-system-assigned` | Enables SAMI. | flag only |

### 2. Create Network Fabric Resource with UAMI only

```bash
az networkfabric fabric create \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --location <region> \
  --mi-user-assigned <uami-resource-id>
```

| Argument | Purpose | Example |
|---|---|---|
| `--mi-user-assigned` | Attach UAMI resource ID(s). | `/subscriptions/.../userAssignedIdentities/uami1` |


> [!NOTE]
> When UAMI is used for storage access (Bring Your Own Storage), also include `--storage-account-config` to link the UAMI to the storage account identity:
> ```bash
> --storage-account-config "{storageAccountId:'<storage-account-resource-id>',storageAccountIdentity:{identityType:'UserAssignedIdentity',userAssignedIdentityResourceId:'<uami-resource-id>'}}"
> ```
> See [Bring Your Own Storage for Network Fabric](https://learn.microsoft.com/azure/operator-nexus/howto-configure-bring-your-own-storage-network-fabric) for full BYoS guidance.

### 3. Create Network Fabric Resource with SAMI + UAMI

```bash
az networkfabric fabric create \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --location <region> \
  --mi-system-assigned \
  --mi-user-assigned <uami-resource-id>
```

| Argument | Purpose | Example |
|---|---|---|
| `--mi-system-assigned` | Enable SAMI. | flag only |
| `--mi-user-assigned` | Attach UAMI with SAMI retained. | `/subscriptions/.../uami1` |


> [!NOTE]
> When UAMI is configured for storage access in a SAMI+UAMI topology, include `--storage-account-config` as described in the UAMI-only new-resource section above.

## For existing resources

### 1. Add SAMI when Network Fabric Resource has no identity

```bash
az networkfabric fabric update \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --mi-system-assigned
```


**Identity payload transformation:**

Before (resource has no identity):
```json
{
  // no identity present
}
```
After:
```json
{
  "identity": {
    "type": "SystemAssigned",
    "principalId": "<assigned-principal-id>",
    "tenantId": "<tenant-id>"
  }
}
```

### 2. Add SAMI when Network Fabric Resource already has UAMI

```bash
az networkfabric fabric update \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --mi-system-assigned \
  --mi-user-assigned <uami-resource-id>
```


**Identity payload transformation:**

Before (resource has `UserAssigned` identity):
```json
{
  "identity": {
    "type": "UserAssigned",
    "userAssignedIdentities": {
      "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami1": {}
    }
  }
}
```
After:
```json
{
  "identity": {
    "type": "SystemAssigned,UserAssigned",
    "principalId": "<assigned-principal-id>",
    "tenantId": "<tenant-id>",
    "userAssignedIdentities": {
      "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami1": {}
    }
  }
}
```

### 3. Add UAMI when Network Fabric Resource already has SAMI

```bash
az networkfabric fabric update \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --mi-system-assigned \
  --mi-user-assigned <uami-resource-id>
```


**Identity payload transformation:**

Before (resource has `SystemAssigned` identity):
```json
{
  "identity": {
    "type": "SystemAssigned",
    "principalId": "<existing-principal-id>",
    "tenantId": "<tenant-id>"
  }
}
```
After:
```json
{
  "identity": {
    "type": "SystemAssigned,UserAssigned",
    "principalId": "<existing-principal-id>",
    "tenantId": "<tenant-id>",
    "userAssignedIdentities": {
      "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami1": {}
    }
  }
}
```

### Shared argument explanations for update commands

| Argument | Purpose | Example |
|---|---|---|
| `--resource-group` | Existing Network Fabric resource group. | `my-nf-rg` |
| `--resource-name` | Existing Network Fabric resource name. | `my-nf` |
| `--mi-system-assigned` | Ensures SAMI exists post-update. | flag only |
| `--mi-user-assigned` | Keeps or adds UAMI as required. | `/subscriptions/.../uami1` |

## Existing-Resource Support-Assisted SAMI Association

If direct CLI update is not possible, reach out to support personnel to perform the SAMI PATCH on the Network Fabric resource.

Provide the following details to support personnel:
- Subscription ID
- Network Fabric resource ID

> [!NOTE]
> Managed Identity Operator role assignment might be required during this operation when identity assignment requires `Microsoft.ManagedIdentity/userAssignedIdentities/assign/action` on attached user-assigned managed identities.

## Managed Identity Operator (MIO) permission matrix

This requirement is actor-based.

| Path | Who performs identity assign/action | Who needs MIO role on UAMI |
|---|---|---|
| Support-assisted patch path | Support personnel | Nexus Network Fabric resource-provider |
| Manual CLI/ARM path | Human user or service principal executes PATCH | Acting caller identity |

### Why MIO role is required
When a Network Fabric identity operation attaches or preserves user-assigned managed identities, Azure authorization checks the `Microsoft.ManagedIdentity/userAssignedIdentities/assign/action` permission on each referenced user-assigned managed identity. The actor issuing the PATCH must have that permission. This is why either support personnel (support-assisted path) or the direct caller (manual CLI/ARM path) needs Managed Identity Operator.

### Typical remediation
Grant `Managed Identity Operator` on each configured user-assigned managed identity to the actor that issues the PATCH (support personnel for support-assisted path, caller principal for manual path).

## Lock and commit notes (Commit workflow v2 alignment)

Lock and commit version 2 are needed to safely apply pending configuration changes.

After a successful Network Fabric identity PATCH, the Network Fabric resource moves to `PendingCommit` state. At that point, the required flow is to lock the fabric and then commit the fabric.

- **Why lock is needed:** lock prevents conflicting updates while configuration is being committed.
- **Why commit is needed:** commit applies pending changes and transitions configuration toward a stable `Provisioned` state.
- **Required execution order:**
  - First, perform identity PATCH and confirm the Network Fabric resource is in `PendingCommit`.
  - Second, acquire lock.
  - Third, trigger commit.
  - Fourth, verify commit completion and resulting state.
  - Fifth, unlock if lock remains set after a failed or interrupted flow.

## Verification

### Verify identity and operational state

```bash
az networkfabric fabric show \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --query "{identity:identity, provisioningState:provisioningState, configurationState:configurationState, administrativeState:administrativeState, fabricLocks:fabricLocks}" \
  -o json
```

### What to check
- `identity.type` matches intended mode.
- `principalId` exists when SAMI is enabled.
- lifecycle states are healthy for your operation path.
- lock state is understood before commit operations.

## Identity transition quick table

| Current | Requested outcome | CLI shape |
|---|---|---|
| no identity | SAMI | `--mi-system-assigned` |
| UAMI | SAMI + UAMI | `--mi-system-assigned --mi-user-assigned <id>` |
| SAMI | SAMI + UAMI | `--mi-system-assigned --mi-user-assigned <id>` |
| SAMI + UAMI | retain both | include both flags as needed |
| any | None | invalid |

## Common errors and fixes

### Error: LinkedAuthorizationFailed
- Symptom: identity assignment fails during PATCH.
- Cause: actor missing UAMI assign permission.
- Fix: assign `Managed Identity Operator` on UAMI to the acting principal.

### Error: lock-related operation failure
- Symptom: operation blocked or commit path fails due to lock/state mismatch.
- Fix: confirm lock state and Network Fabric resource configuration state, then rerun sequence with proper order.

### Error: invalid identity combination
- Symptom: request rejected or operation fails validation.
- Fix: use valid transition payload shape; avoid `None`; preserve SAMI when required.

## Post-change checklist

- Network Fabric resource identity reflects expected type.
- SAMI `principalId` is present when SAMI is enabled.
- If support-assisted existing-resource PATCH was used, verify commit outcome and resulting config state.
- Confirm no residual lock if operation failed mid-flow.
- For UAMI-linked paths, validate MIO role assignments for the actor.

## Frequently asked questions

**Q: What identity types are supported for the Network Fabric resource?**  
A: `SystemAssigned`, `UserAssigned`, and `SystemAssigned,UserAssigned`. Identity type `None` is not supported.

**Q: Can I remove SAMI from the Network Fabric resource once it is associated?**  
A: No. Removing SAMI is not permitted. If SAMI is accidentally removed (for example via a `None` PATCH), re-associate SAMI immediately using manual CLI update or support-assisted patch.

**Q: What happens if I specify identity type `None`?**  
A: The Managed Service Identity Resource Provider may remove the SAMI context before the Nexus Network Fabric Resource Provider blocks the request, which can cause token acquisition failures. Recover by re-associating SAMI immediately.

**Q: How do I add SAMI to a Network Fabric resource that already has UAMI?**  
A: Use `--mi-system-assigned --mi-user-assigned <uami-id>`. The resulting identity type is `SystemAssigned,UserAssigned`.

**Q: How do I add UAMI to a Network Fabric resource that already has SAMI?**  
A: Use `--mi-system-assigned --mi-user-assigned <uami-id>`. SAMI is preserved and UAMI is added.

**Q: What identity should I use for BYoS scenarios?**  
A: Use UAMI. If SAMI is already present, specify both identities as `SystemAssigned,UserAssigned` and include `--storage-account-config` to link the UAMI to the storage account.

**Q: What happens to identity if I perform a non-identity PATCH on the Network Fabric resource?**  
A: Existing identity configuration is not altered unless identity fields are explicitly included in the payload.

**Q: Can I use the same UAMI across multiple Network Fabric resources?**  
A: Yes. UAMI is reusable, but ensure correct role assignments are configured for each resource it is attached to.
