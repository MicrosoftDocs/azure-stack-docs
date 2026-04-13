---
title: Enable SAMI for the Network Fabric Controller in Azure Operator Nexus
description: This article describes how to enable and validate SAMI for the Network Fabric Controller in Azure Operator Nexus.
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 03/30/2026
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to
---

# Enable SAMI for the Network Fabric Controller in Azure Operator Nexus

This article describes how to enable and validate System Assigned Managed Identity (SAMI) for the Network Fabric Controller resource for both new resources and existing resources.

## Scope and identity rules

On the Network Fabric Controller resource, you can use `SystemAssigned` for your identity. You can't use `UserAssigned` or `None`. These identities aren't supported.

Network Fabric Controller resource managed flows access platform resources (for example, storage and key vault in managed resource groups). SAMI is the required baseline identity for trusted service access patterns in these workflows.

## Prerequisites

- Azure CLI is signed in to the target subscription.
- The `managednetworkfabric` CLI extension is installed and up to date.
- The Network Fabric Controller resource is in a healthy state before update operations:
  - `provisioningState = Succeeded`
- The API version is `2025-07-15` or newer when you need latest identity visibility and action payload compatibility.

## Create a Network Fabric Controller resource with SAMI

This section pertains to new resources.

### Command

```bash
az networkfabric controller create \
  --resource-group <resource-group> \
  --resource-name <nfc-name> \
  --location <region> \
  --mi-system-assigned
```

For the full create command argument set, see [Create a Network Fabric Controller](../../azure-stack-docs-pr/operator-nexus/howto-configure-network-fabric-controller#create-a-network-fabric-controller).

This article shows only the minimum arguments relevant to SAMI enablement, not the complete set of arguments for resource creation.

### Argument-by-argument explanation

| Argument               | Purpose                                                           | Example       |
|------------------------|-------------------------------------------------------------------|---------------|
| `--resource-group`     | Resource group containing the Network Fabric Controller resource. | `my-nfc-rg`   |
| `--resource-name`      | Network Fabric Controller resource Azure Resource Manager name.   | `my-nfc`      |
| `--location`           | Azure region for the Network Fabric Controller resource.          | `eastus2euap` |
| `--mi-system-assigned` | Enables SAMI on create. No value required.                        | flag only     |

### Expected result

- `identity.type` is `SystemAssigned`.

- Provisioning status is `Succeeded`.

Here's the expected identity in response.

```json
{
  "identity": {
    "type": "SystemAssigned",
    "principalId": "<assigned-principal-id>",
    "tenantId": "<tenant-id>"
  }
}
```

## Add SAMI to an existing Network Fabric Controller resource

This section pertains to existing resources.

### Option A: Direct Azure CLI update

```bash
az networkfabric controller update \
  --resource-group <resource-group> \
  --resource-name <nfc-name> \
  --mi-system-assigned
```

### Argument-by-argument explanation

| Argument               | Purpose                                                                    | Example     |
|------------------------|----------------------------------------------------------------------------|-------------|
| `--resource-group`     | Resource group containing the existing Network Fabric Controller resource. | `my-nfc-rg` |
| `--resource-name`      | Existing Network Fabric Controller resource name.                          | `my-nfc`    |
| `--mi-system-assigned` | Adds or retains SAMI on the resource identity.                             | flag only   |

This option transforms the identity payload.

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

### Option B: SAMI association via support personnel

If you're unable to use the direct Azure CLI update, or you require an automated support channel to perform SAMI association, contact support personnel. Provide the following details:

- Network Fabric Controller resource subscription ID

- Network Fabric Controller resource ID (Azure Resource Manager resource ID)

Support personnel can perform the SAMI association operation on your behalf.

## Verification

Here's how to verify the identity and state of your SAMI.

```bash
az networkfabric controller show \
  --resource-group <resource-group> \
  --resource-name <nfc-name> \
  --query "{identity:identity, provisioningState:provisioningState}" \
  -o json
```

Here's what to check:

- `identity.type == "SystemAssigned"`

- `identity.principalId` is populated.

- `provisioningState == "Succeeded"`

## Decision table

For your quick reference, this table shows the various identities and operations possible, and the outcomes to expect.

| Current identity | Requested operation | Valid | Result           |
|------------------|---------------------|-------|------------------|
| no identity      | add SAMI            | Yes   | `SystemAssigned` |
| SystemAssigned   | add SAMI            | Yes   | retained         |
| SystemAssigned   | add UAMI            | No    | rejected         |
| any              | set `None`          | No    | rejected         |

## Common errors and fixes

You might encounter these errors. Here's how to fix them.

- Identity type is invalid.
  - Symptom: The update fails when `UserAssigned` or `None` semantics are attempted for the Network Fabric Controller resource.
  - Fix: Rerun with `--mi-system-assigned` only.

    > [!IMPORTANT]
    > If identity type `None` is submitted, the Managed Service Identity Resource Provider might remove the SAMI context before the Nexus Network Fabric Resource Provider can block the request. This condition leads to token acquisition failures in Network Fabric Controller resource managed platform flows. Reassociate SAMI as soon as possible if this condition occurs.

- Resource not in a safe state.
  - Symptom: The update fails due to lifecycle state checks.
  - Fix: Ensure the Network Fabric Controller resource is fully provisioned (`Succeeded`) before identity association.

## Supplementary operational notes

- When you run existing resources at scale, capture existing external connectivity details before taking actions. Specifically, record all Azure ExpressRoute circuit details, and the ExpressRoute circuit-to-connection map. Ensure that the ExpressRoute circuit auth key hashes are populated before triggering the identity operation. This precaution helps you avoid unintended ExpressRoute circuit re-creation.

- If your internal runbook includes precheck actions (such as metadata stabilization in ExpressRoute), complete those actions first.

- Use the latest API versions to reduce payload and visibility mismatches.

After the SAMI change, check the following points:

- GET confirms `identity.type = SystemAssigned`.

- `principalId` exists.

- The Network Fabric Controller resource remains `Succeeded`.

- Downstream flows that require trusted identity access continue to function.

## Frequently asked questions

*Why is UAMI not supported for the Network Fabric Controller resource?*

The Network Fabric Controller resource uses SAMI as the required identity bound to its resource lifecycle. UAMI isn't in scope for these managed flows.

*Can I remove SAMI from the Network Fabric Controller resource?*

No. SAMI must persist to maintain trusted service access to Network Fabric Controller resources (such as Azure Key Vault and Azure Storage in its managed resource group).

*What happens if I specify identity type `None` for the Network Fabric Controller resource?*

The Managed Service Identity Resource Provider might remove the SAMI context, leading to token acquisition failures. Recover by reassociating SAMI immediately.

*How do I verify that SAMI is properly active on the Network Fabric Controller resource?*

Get the Network Fabric Controller resource, and confirm that `identity.type == "SystemAssigned"`. Also confirm that `identity.principalId` is populated.

*What identity does the Network Fabric Controller resource use for Key Vault and Storage account access?*

The Network Fabric Controller resource uses SAMI for secure access to Key Vault and Storage account in its managed resource group. This use is part of the trusted services configuration.

*What happens to Network Fabric Controller resource identity if a non-identity patch is performed?*

Existing SAMI configuration is unchanged unless identity fields are explicitly included in the payload.
