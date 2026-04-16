---
title: Enable a SAMI for the Network Fabric Resource in Azure Operator Nexus
description: This article describes how to enable a SAMI for the Network Fabric resource in Azure Operator Nexus. You can enable a SAMI for new and existing resource paths.
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 03/30/2026
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to
---

# Enable a SAMI for the Network Fabric resource in Azure Operator Nexus

This article explains how to enable a system-assigned managed identity (SAMI) for the Network Fabric resource. You can enable a SAMI for both new and existing resource paths. The article also covers identity transition rules, lock and commit considerations, and role requirements.

The Network Fabric resource supports the following identity modes: `SystemAssigned`, `UserAssigned`, and `SystemAssigned,UserAssigned`. `None` isn't supported.

Be aware of the following constraints:

- After a SAMI is associated for trusted access scenarios, you can't remove a SAMI.

- If a SAMI is accidentally disassociated (for example, because of an incorrect `None` patch), reassociate the SAMI as soon as possible.

- For updates where a user-assigned managed identity (UAMI) already exists and you must add a SAMI, provide both identities (`SystemAssigned,UserAssigned`) in effective payload terms.

> [!IMPORTANT]
> Preserving a SAMI is required to prevent token acquisition failures in Network Fabric operational flows. If a SAMI is removed or the identity is set to `None`, reassociate the SAMI immediately.

## Prerequisites

- The Azure CLI is signed in to the correct subscription and tenant.
- The `managednetworkfabric` extension is installed and current.
- The Network Fabric resource lifecycle checks show the following conditions before the identity updates:
  - `provisioningState = Succeeded`
  - The resource isn't locked for the intended operation.
- Commit Workflow capabilities require Network Fabric resource version and API support. For example, you need `2024-06-15-preview` or newer APIs for lock and commit flows.
- For the latest identity visibility in your environment, use `2025-07-15` when available.

## Create a new resource

The following sections show you various ways to create a new resource.

### Create a Network Fabric resource with a SAMI only

```bash
az networkfabric fabric create \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --location <region> \
  --mi-system-assigned
```

For the full create command argument set, see [Create a Network Fabric](/azure/operator-nexus/howto-configure-network-fabric#create-a-network-fabric).

This article shows only the minimum arguments relevant to a SAMI enablement, not the complete set of arguments for resource creation.

| Argument               | Purpose                                              | Example       |
|------------------------|------------------------------------------------------|---------------|
| `--resource-group`     | Resource group for the Network Fabric resource.      | `my-nf-rg`    |
| `--resource-name`      | Network Fabric resource Azure Resource Manager name. | `my-nf`       |
| `--location`           | Deployment region.                                   | `eastus2euap` |
| `--mi-system-assigned` | Enables a SAMI.                                        | flag only     |

### Create Network Fabric resource with a UAMI only

```bash
az networkfabric fabric create \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --location <region> \
  --mi-user-assigned <uami-resource-id>
```

| Argument             | Purpose                       | Example                                           |
|----------------------|-------------------------------|---------------------------------------------------|
| `--mi-user-assigned` | Attach a UAMI resource ID(s). | `/subscriptions/.../userAssignedIdentities/uami1` |

When you use a UAMI for storage access, also include `--storage-account-config` to link the UAMI to the storage account identity:

```bash
--storage-account-config "{storageAccountId:'<storage-account-resource-id>',storageAccountIdentity:{identityType:'UserAssignedIdentity',userAssignedIdentityResourceId:'<uami-resource-id>'}}"
```

For more information, see [Bring your own storage for Network Fabric](/azure/operator-nexus/howto-configure-bring-your-own-storage-network-fabric).

### Create Network Fabric resource with a SAMI and a UAMI

```bash
az networkfabric fabric create \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --location <region> \
  --mi-system-assigned \
  --mi-user-assigned <uami-resource-id>
```

| Argument               | Purpose                             | Example                    |
|------------------------|-------------------------------------|----------------------------|
| `--mi-system-assigned` | Enable a SAMI.                      | flag only                  |
| `--mi-user-assigned`   | Attach a UAMI with a SAMI retained. | `/subscriptions/.../uami1` |

When you configure a UAMI for storage access in a SAMI and a UAMI topology, include `--storage-account-config` to link the UAMI to the storage account identity. See the preceding section for details.

## Use an existing resource

The following sections show you various ways to work with an existing resource.

### Add a SAMI when the Network Fabric resource has no identity

```bash
az networkfabric fabric update \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --mi-system-assigned
```

Here's what the identity payload transformation looks like.

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

### Add a SAMI when the Network Fabric resource already has a UAMI

```bash
az networkfabric fabric update \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --mi-system-assigned \
  --mi-user-assigned <uami-resource-id>
```

Here's what the identity payload transformation looks like.

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

### Add a UAMI when the Network Fabric resource already has a SAMI

```bash
az networkfabric fabric update \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --mi-system-assigned \
  --mi-user-assigned <uami-resource-id>
```

Here's what the identity payload transformation looks like.

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

| Argument               | Purpose                                 | Example                    |
|------------------------|-----------------------------------------|----------------------------|
| `--resource-group`     | Existing Network Fabric resource group. | `my-nf-rg`                 |
| `--resource-name`      | Existing Network Fabric resource name.  | `my-nf`                    |
| `--mi-system-assigned` | Ensures a SAMI exists post-update.      | flag only                  |
| `--mi-user-assigned`   | Keeps or adds a UAMI as required.       | `/subscriptions/.../uami1` |

## Support option for existing resources

If the direct Azure CLI update isn't possible in your context, reach out to support personnel to perform the SAMI patch on the Network Fabric resource.

Provide the following details to support personnel:

- Subscription ID

- Network Fabric resource ID

> [!NOTE]
> The Managed Identity Operator role assignment might be required during this operation. When the identity assignment requires `Microsoft.ManagedIdentity/userAssignedIdentities/assign/action` on attached user-assigned managed identities, you might need this role assignment.

## Managed Identity Operator permission matrix

This requirement is actor-based.

| Path                                                  | Who performs identity assign or action     | Who needs Managed Identity Operator role on a UAMI |
|-------------------------------------------------------|--------------------------------------------|----------------------------------------------------|
| Support-assisted patch path                           | Support personnel                          | Network Fabric resource provider                   |
| Manual path (the Azure CLI or Azure Resource Manager) | Human user or service principal runs patch | Acting caller identity                             |

When a Network Fabric identity operation attaches or preserves user-assigned managed identities, Azure authorization checks the `Microsoft.ManagedIdentity/userAssignedIdentities/assign/action` permission on each referenced user-assigned managed identity. The actor issuing the patch must have that permission. This is why either support personnel (support-assisted path) or the direct caller (manual path) needs the Managed Identity Operator role.

Grant `Managed Identity Operator` on each configured user-assigned managed identity to the actor that issues the patch (support personnel for the support-assisted path, or the caller principal for the manual path).

## Lock and commit notes

To safely apply pending configuration changes, you need lock and commit in Commit Workflow version 2.

After a successful Network Fabric identity patch, the Network Fabric resource moves to the `PendingCommit` state. At that point, the required flow is to lock the fabric and then commit the fabric.

- Why lock is needed: Lock prevents conflicting updates while the configuration is being committed.
- Why commit is needed: Commit applies pending changes and transitions the configuration toward a stable `Provisioned` state.
- Required order:
  1. Perform the identity patch and confirm the Network Fabric resource is in `PendingCommit`.
  1. Acquire a lock.
  1. Trigger a commit.
  1. Verify a commit completion and the resulting state.
  1. Unlock if the lock remains set after a failed or interrupted flow.

## Verify identity and operational state

```bash
az networkfabric fabric show \
  --resource-group <resource-group> \
  --resource-name <nf-name> \
  --query "{identity:identity, provisioningState:provisioningState, configurationState:configurationState, administrativeState:administrativeState, fabricLocks:fabricLocks}" \
  -o json
```

Check for the following conditions:

- `identity.type` matches the intended mode.

- `principalId` exists when a SAMI is enabled.

- Lifecycle states are healthy for your operation path.

- The lock state is understood before commit operations.

## Identity transition table

The following table shows the various identity transitions possible.

| Current         | Requested outcome | CLI shape                                      |
|-----------------|-------------------|------------------------------------------------|
| no identity     | a SAMI            | `--mi-system-assigned`                         |
| a UAMI          | a SAMI + a UAMI   | `--mi-system-assigned --mi-user-assigned <id>` |
| a SAMI          | a SAMI + a UAMI   | `--mi-system-assigned --mi-user-assigned <id>` |
| a SAMI + a UAMI | retain both       | include both flags as needed                   |
| any             | None              | invalid                                        |

## Common errors and fixes

You might encounter these errors. Here's how to fix them.

- Linked authorization failed.
  - Symptom: The identity assignment fails during patch.
  - Cause: The actor is missing the UAMI assign permission.
  - Fix: Assign `Managed Identity Operator` on the UAMI to the acting principal.

- Lock-related operation failure.
  - Symptom: The operation is blocked or the commit path fails due to a mismatch between lock and state.
  - Fix: Confirm the lock state and Network Fabric resource configuration state. Then rerun the sequence with the proper order.

- Invalid identity combination.
  - Symptom: The request is rejected or the operation fails validation.
  - Fix: Use a valid transition payload shape. Avoid `None`. Preserve a SAMI when required.

## Post-change checklist

After you change the identity, confirm the following points:

- The Network Fabric resource identity reflects the expected type.

- A SAMI `principalId` is present when a SAMI is enabled.

- If support personnel performed the existing-resource patch for you, verify the commit outcome and the resulting configuration state.

- Confirm that there's no residual lock if the operation failed mid-flow.

- For UAMI-linked paths, validate the Managed Identity Operator role assignments for the actor.

## Frequently asked questions

*What identity types are supported for the Network Fabric resource?*  

`SystemAssigned`, `UserAssigned`, and `SystemAssigned,UserAssigned`. Identity type `None` isn't supported.

*Can I remove a SAMI from the Network Fabric resource after it's associated?*  

No. Removing a SAMI isn't permitted. If a SAMI is accidentally removed (for example, with a `None` patch), reassociate the SAMI immediately. Use a manual Azure CLI update or support-assisted patch.

*What happens if I specify identity type `None`?*  

The managed identity resource provider might remove the SAMI context, leading to token acquisition failures. Recover by reassociating the SAMI immediately.

*How do I add a SAMI to a Network Fabric resource that already has a UAMI?*  

Use `--mi-system-assigned --mi-user-assigned <uami-id>`. The resulting identity type is `SystemAssigned,UserAssigned`.

*How do I add a UAMI to a Network Fabric resource that already has a SAMI?*  

Use `--mi-system-assigned --mi-user-assigned <uami-id>`. A SAMI is preserved and a UAMI is added.

*What identity should I use for bring your own storage scenarios?*  

Use a UAMI. If a SAMI is already present, specify both identities as `SystemAssigned,UserAssigned`. Include `--storage-account-config` to link the UAMI to the storage account.

*What happens to the identity if I perform a non-identity patch on the Network Fabric resource?*  

The existing identity configuration isn't altered unless identity fields are explicitly included in the payload.

*Can I use the same UAMI across multiple Network Fabric resources?*  

Yes. A UAMI is reusable, but ensure that the correct role assignments are configured for each resource the UAMI is attached to.
