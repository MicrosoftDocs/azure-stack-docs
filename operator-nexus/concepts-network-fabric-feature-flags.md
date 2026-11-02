---
title: Azure Operator Nexus Network Fabric - Feature flags
description: Learn how feature flags work on Azure Operator Nexus - Network Fabric, including flag states, effectuation, and adoption.
author: rbhupatiraju-ms
ms.author: rbhupatiraju
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 09/22/2026
ms.custom: template-concept
---

# Feature flags in Azure Operator Nexus - Network Fabric

Feature flags control whether selected Network Fabric capabilities are active on your instance. Starting with release 12.0, supported feature flags are properties of the Network Fabric resource, so you can view them through the same API and CLI that you already use for other fabric configuration.

## Key concepts

Each feature flag returned by the Network Fabric resource has three properties:

- **`featureFlagName`**: The descriptive name of the flag.
- **`featureFlagValue`**: Your requested configuration, either `Enable` or `Disable`.
- **`featureFlagState`**: The operational state of the feature, managed by the platform.

The following example shows the `featureFlags` property on a Network Fabric resource:

```json
"featureFlags": [
  {
    "featureFlagName": "AggRouteV2RT",
    "featureFlagValue": "Enable",
    "featureFlagState": "Active"
  }
]
```

### Requested value compared to operational state

`featureFlagValue` and `featureFlagState` answer different questions. `featureFlagValue` records what you asked for. `featureFlagState` records what's actually running on the fabric.

You set the value. The platform manages the state. Because enabling a feature can require orchestration, a runtime upgrade, or both, the two properties can differ for as long as that work is outstanding. For example, you might see the following combination while a commit is still pending:

```json
"featureFlagValue": "Enable",
"featureFlagState": "PendingActivation"
```

A `featureFlagValue` of `Enable` doesn't confirm that the feature is active. To confirm activation, check `featureFlagState`.

## Feature flag states

The `featureFlagState` property is read-only and takes one of the following values:

| State | Description |
|-------|-------------|
| `Active` | The feature is active on the Network Fabric. |
| `Inactive` | The feature isn't active on the Network Fabric. |
| `PendingActivation` | You requested enablement, but a required action, such as a runtime upgrade, didn't finish successfully. |
| `PendingDeactivation` | You requested disablement, but a required action didn't finish successfully. |

> [!NOTE]
> A flag that's waiting for a runtime upgrade stays at `PendingActivation`. There's no separate state for this condition.

When you enable a flag, the state moves from `Inactive` to `PendingActivation`, and then to `Active` after the required effectuation action completes. Disabling a flag follows the same pattern in reverse, moving from `Active` to `PendingDeactivation`, and then to `Inactive`.

## Feature flags available

Not every visible flag is settable. The service returns read-only flags so that you can see their state, but it rejects requests to change them.

| Flag | Description | Default | Effectuation | Settable |
|------|-------------|---------|--------------|----------|
| `AggRouteV2RT` | De-preference aggregate routes on Azure Operator Nexus devices. | `Disable` | Commit, followed by a runtime upgrade | Yes |
| `UseMicroBfd` | Enable the Micro-BFD feature on the Network Fabric. | `Disable` | Commit | No |

## How feature flag changes are applied

Changing a feature flag can require updates across the resource provider, Azure Resource Manager, the orchestrator, and the network devices themselves. Depending on the flag, final effectuation can also depend on a runtime upgrade, a maintenance-based upgrade, or a feature-specific workflow.

Network Fabric applies these changes through the commit workflow v2, the same workflow used for other enabled fabric resources.

For more information, see [Commit workflow v2 in Azure Operator Nexus - Network Fabric](./concepts-commit-workflow-v2.md).

## Adoption

### New fabrics

On a Network Fabric that you create on release 12.0, supported flags become visible with their default values as part of the creation and provisioning lifecycle. You can change a settable flag from its default in the initial `PUT` request, or with a `PATCH` request before provisioning. The flag is effectuated as part of successful provisioning, and the state becomes `Active`.

> [!NOTE]
> Read-only flags are populated during the provisioning flow rather than during fabric creation, so not every flag is present immediately after the create call returns.

### Existing fabrics

On a Network Fabric that already exists, an upgrade to release 12.0 is required before supported flags become visible through a `GET` request.

Surfacing the flags doesn't change how your fabric behaves. Initial flag defaults are aligned with the current behavior of the instance, so behavior changes only after you explicitly change a flag. After the flags are visible, you request changes with a `PATCH` request and apply them through the commit workflow v2, along with any other effectuation action that the flag requires.

## Constraints

Consider the following constraints before you plan a feature flag change.

### Include the complete flag array

The `featureFlags` property follows Azure Resource Manager array replacement semantics. A `PATCH` request must include every persisted flag and its current value, not just the flag you're changing. The service rejects requests that omit flags with an error.

Retrieve the current array with a `GET` request, change the entry you want, and submit the complete array.

### Changes are blocked during other operations

The service rejects feature flag changes while the Network Fabric is running another mutually exclusive operation, including:

- Another commit
- An upgrade
- A reboot
- Provisioning or deprovisioning
- Certificate rotation
- An active administrative lock
- An active configuration lock

The API returns an error that identifies the blocking condition. This error appears in the Activity Log alongside other Network Fabric operations.

### Effectuation can require more than a commit

The commit workflow v2 is the unified configuration workflow, but it isn't always sufficient on its own to activate or deactivate a feature. Activation can stay pending until a runtime upgrade, a maintenance-based upgrade, or another feature-specific workflow completes.

## Related content

- [Configure feature flags on Azure Operator Nexus - Network Fabric](./howto-configure-network-fabric-feature-flags.md)
- [Commit workflow v2 in Azure Operator Nexus - Network Fabric](./concepts-commit-workflow-v2.md)
