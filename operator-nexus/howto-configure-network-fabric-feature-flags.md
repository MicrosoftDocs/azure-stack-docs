---
title: How to configure feature flags in Azure Operator Nexus - Network Fabric
description: Learn how to view and set feature flags on an Azure Operator Nexus - Network Fabric resource.
author: rbhupatiraju-ms
ms.author: rbhupatiraju
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 09/22/2026
ms.custom: template-how-to, devx-track-azurecli
---

# How to configure feature flags in Azure Operator Nexus - Network Fabric

This article explains how to view the feature flags on a Network Fabric resource and how to change the flags that support customer configuration.

For background on the flag properties, states, and effectuation model, see [Feature flags in Azure Operator Nexus - Network Fabric](./concepts-network-fabric-feature-flags.md).

## Prerequisites

- **Network Fabric API version**: `2026-07-15-preview`.
- **Resource provider version**: Release 12.0.
- **Azure CLI**: The version released with 12.0.
- Your **Network Fabric must be in the `Provisioned` state** and the configuration state must be `Succeeded`.
- The **fabric admin state must be `Enabled`**.
- On an existing Network Fabric, the MBU upgrade to release 12.0 must be complete before flags are visible.

## View feature flags

Retrieve the current feature flags with the `show` command:

```azurecli
az networkfabric fabric show \
    --resource-group "example-rg" \
    --resource-name "example-fabric" \
    --query "featureFlags"
```

The command returns every flag on the fabric with its requested value and current state:

```json
[
  {
    "featureFlagName": "UseMicroBfd",
    "featureFlagValue": "Disable",
    "featureFlagState": "Inactive"
  },
  {
    "featureFlagName": "AggRouteV2RT",
    "featureFlagValue": "Disable",
    "featureFlagState": "Inactive"
  }
]
```

Keep this output. You need the complete array in the next step.

## Set a feature flag

### Step 1: Update the flag value

Submit the complete feature flag array with the value you want to change. The array follows Azure Resource Manager replacement semantics, so a request that omits any persisted flag is rejected.

```azurecli
az networkfabric fabric update \
    --resource-group "example-rg" \
    --resource-name "example-fabric" \
    --feature-flags "[{featureFlagName:'UseMicroBfd',featureFlagValue:'Disable'},{featureFlagName:'AggRouteV2RT',featureFlagValue:'Enable'}]"
```

In this example, only `AggRouteV2RT` changes. You must include `UseMicroBfd` at its current value because the array must be complete.

| Parameter | Description |
|-----------|-------------|
| `--resource-group` | Name of the resource group that contains the Network Fabric. |
| `--resource-name` | Name of the Network Fabric. |
| `--feature-flags` | The complete feature flag array, with `featureFlagValue` set to `Enable` or `Disable` for each flag. |

> [!NOTE]
> `featureFlagState` is read-only. Don't include it in the request.

After the update succeeds, the fabric configuration state becomes `Accepted` and the flag state moves to `PendingActivation`. The change isn't applied to your devices yet.

### Step 2: Lock the fabric configuration

```azurecli
az networkfabric fabric lock-fabric \
    --action Lock \
    --lock-type Configuration \
    --network-fabric-name "example-fabric" \
    --resource-group "example-rg"
```

### Step 3: Commit the configuration

```azurecli
az networkfabric fabric commit-configuration \
    --resource-group "example-rg" \
    --resource-name "example-fabric"
```

For the full commit procedure, including the optional configuration diff review, see [How to use Commit Workflow v2 in Azure Operator Nexus](./howto-use-commit-workflow-v2.md).

### Step 4: Verify the flag state

Run the `show` command again and check `featureFlagState`:

```azurecli
az networkfabric fabric show \
    --resource-group "example-rg" \
    --resource-name "example-fabric" \
    --query "featureFlags"
```

A state of `Active` confirms that the feature is running on the fabric:

```json
[
  {
    "featureFlagName": "AggRouteV2RT",
    "featureFlagValue": "Enable",
    "featureFlagState": "Active"
  }
]
```

If the state is still `PendingActivation`, the flag requires an effectuation action that didn't finish. `AggRouteV2RT` requires a runtime upgrade after the commit, and stays at `PendingActivation` until that upgrade completes successfully.

## Disable a feature flag

To disable a flag, follow the same steps with `featureFlagValue` set to `Disable`. The state moves to `PendingDeactivation`, and then to `Inactive` after the required effectuation action completes.

## Troubleshoot

### The request is rejected because flags are missing

The `featureFlags` array must contain every flag persisted on the fabric. Run the `show` command, copy the full array, change only the entry you want, and resubmit.

### The request is rejected because the flag is read-only

Not every visible flag supports customer configuration. `UseMicroBfd` is returned for visibility only, and requests to change it are rejected. See the flag table in [Feature flags in Azure Operator Nexus - Network Fabric](./concepts-network-fabric-feature-flags.md#feature-flags-available).

### The request is rejected because another operation is running

Feature flag changes are blocked while the fabric is running another mutually exclusive operation, such as another commit, an upgrade, a reboot, provisioning or deprovisioning, or certificate rotation. Changes are also blocked while an administrative lock or configuration lock is active.

The API returns an error that identifies the blocking condition. This error appears in the Activity Log alongside other Network Fabric operations. Wait for the blocking operation to finish, then retry.

## Related content

- [Feature flags in Azure Operator Nexus - Network Fabric](./concepts-network-fabric-feature-flags.md)
- [How to use Commit Workflow v2 in Azure Operator Nexus](./howto-use-commit-workflow-v2.md)
