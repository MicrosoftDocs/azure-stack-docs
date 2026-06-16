---
title: Update a Network-to-Network Interconnect (NNI) in Azure Operator Nexus
description: Learn how to update a Network-to-Network Interconnect (NNI) resource in Azure Operator Nexus Managed Network Fabric, including prerequisites, updatable properties, and commit workflow.
author: stalluri
ms.author: stalluri
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 06/04/2026
ms.custom: template-how-to, devx-track-azurecli
---

# Update a Network-to-Network Interconnect (NNI) in Azure Operator Nexus

This article describes how to update a Network-to-Network Interconnect (NNI) resource in Azure Operator Nexus Managed Network Fabric. The NNI is a critical resource that provides connectivity between Azure infrastructure and the operator's underlay Customer Edge (CE) network. Incorrect updates to the NNI can disrupt this connectivity and cause service outages.

## Prerequisites

Before you update an NNI resource, ensure the following conditions are met.

- An Azure account with an active subscription.
- Install the latest version of the CLI commands (see [Install Azure CLI extensions](howto-install-cli-extensions.md)).
- A provisioned Network Fabric in `Succeeded` state.

### Verify the fabric state

The parent Network Fabric must be in a stable state before you update any NNI resource:

- **Provisioning State**: `Succeeded`
- **Configuration State**: `Succeeded`
- **Administrative State**: `Enabled`

The fabric must not be locked. If a fabric lock (full or configuration lock) is active, the NNI update request is rejected.

```azurecli
az networkfabric fabric show \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NFName>" \
  --query "{provisioningState: provisioningState, configurationState: configurationState, administrativeState: administrativeState}"
```

### Verify the NNI resource state

The NNI resource must be in a stable state:

- **Provisioning State**: `Succeeded`
- **Administrative State**: `Enabled`

```azurecli
az networkfabric nni show \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NNIName>" \
  --fabric "<NFName>" \
  --query "{provisioningState: provisioningState, administrativeState: administrativeState, configurationState: configurationState}"
```

### Verify NNI Layer 2 interface administrative states

> [!IMPORTANT]
> Before you perform any NNI update operation, verify that all Layer 2 (L2) interfaces listed in the NNI's `layer2Configuration.interfaces` are in `Enabled` administrative state. If any interface shows `Disabled`, you must enable it before you proceed with the update. If you don't, the commit operation shuts down interfaces on the device, causing loss of connectivity between Azure and the CE network.

List the NNI interfaces:

```azurecli
az networkfabric nni show \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NNIName>" \
  --fabric "<NFName>" \
  --query "layer2Configuration.interfaces"
```

Check each interface's administrative state:

```azurecli
az networkfabric interface show \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<InterfaceName>" \
  --device "<DeviceName>" \
  --query "{name: name, administrativeState: administrativeState}"
```

If any interface shows `administrativeState: Disabled`, enable it before you update the NNI:

```azurecli
az networkfabric interface update-admin-state \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<InterfaceName>" \
  --device "<DeviceName>" \
  --state Enable
```

Repeat this step for **all** interfaces in the NNI's `layer2Configuration.interfaces` list on **both CE devices** (CE1 and CE2).

### Ensure no concurrent operations

Ensure no other operations are running on the fabric or its child resources:

- No ongoing `commitConfiguration` operation.
- No ongoing provision, deprovision, or upgrade operation.
- No other NNI update in progress.

## Updatable properties

The following table lists NNI properties that you can update. All changes require a `commitConfiguration` operation on the parent fabric to take effect on the network devices.

| Parameter | Description |
| --- | --- |
| `layer2Configuration` | L2 interface configuration including MTU and interface list |
| `optionBLayer3Configuration.prefixLimits` | BGP maximum route prefix limits |
| `optionBLayer3Configuration.bmpConfiguration` | BMP (BGP Monitoring Protocol) configuration |
| `importRoutePolicy` | Route policy for import routes |
| `exportRoutePolicy` | Route policy for export routes |
| `ingressAclId` | Ingress Access Control List reference |
| `egressAclId` | Egress Access Control List reference |

> [!NOTE]
> Set the following properties when you create the NNI. You can't change them through an update: `nniType`, `isManagementType`, `useOptionB`, `optionBLayer3Configuration.primaryIpv4Prefix`, `optionBLayer3Configuration.secondaryIpv4Prefix`, `optionBLayer3Configuration.fabricASN`, `optionBLayer3Configuration.peerASN`, `optionBLayer3Configuration.vlanId`.

## Update BGP maximum route prefix limits

To configure or update the maximum number of BGP route prefixes accepted from the peer:

```azurecli
az networkfabric nni update \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NNIName>" \
  --fabric "<NFName>" \
  --option-b-layer3-configuration "{prefixLimits: [{maximumRoutes: 500000}]}"
```

Expected output:

```output
{
  "administrativeState": "Enabled",
  "configurationState": "Accepted",
  "id": "/subscriptions/<subscription-id>/resourceGroups/<NFResourceGroup>/providers/Microsoft.ManagedNetworkFabric/networkFabrics/<NFName>/networkToNetworkInterconnects/<NNIName>",
  "name": "<NNIName>",
  "provisioningState": "Succeeded",
  "optionBLayer3Configuration": {
    "prefixLimits": [
      {
        "maximumRoutes": 500000
      }
    ]
  }
}
```

> [!NOTE]
> When the `maximumRoutes` value is reached, the BGP session enters a **warning-only** mode. Routes continue to be accepted, but a warning is logged. The BGP session isn't torn down.

## Update Layer 2 interface configuration

To update the L2 interface list or MTU:

```azurecli
az networkfabric nni update \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NNIName>" \
  --fabric "<NFName>" \
  --layer2-configuration "{mtu: 9146, interfaces: ['/subscriptions/<subscription-id>/resourceGroups/<NFResourceGroup>/providers/Microsoft.ManagedNetworkFabric/networkDevices/<DeviceName>/networkInterfaces/Ethernet1-1']}"
```

> [!CAUTION]
> **Reducing the number of interfaces in the L2 configuration can cause loss of connectivity.** When you remove an interface from the NNI's L2 interface list, the interface is removed from the port-channel (LAG) on the device during the next commit operation. Ensure that the remaining interfaces provide sufficient bandwidth and redundancy for your traffic requirements.
>
> If you configure the NNI's `portCount` (the minimum number of active links in the LAG), ensure that the number of interfaces you provide is **greater than or equal to** the `portCount` value. If you supply fewer interfaces than the `portCount`, the LAG goes down entirely because the minimum link threshold isn't met, resulting in **complete loss of connectivity** between Azure and the CE network.

## Update ACL references

To attach or change an ingress or egress ACL:

```azurecli
az networkfabric nni update \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NNIName>" \
  --fabric "<NFName>" \
  --ingress-acl-id "/subscriptions/<subscription-id>/resourceGroups/<NFResourceGroup>/providers/Microsoft.ManagedNetworkFabric/accessControlLists/<ACLName>"
```

## Update route policies

To attach or change import and export route policies:

```azurecli
az networkfabric nni update \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NNIName>" \
  --fabric "<NFName>" \
  --import-route-policy "{importIpv4RoutePolicyId: '/subscriptions/<subscription-id>/resourceGroups/<NFResourceGroup>/providers/Microsoft.ManagedNetworkFabric/routePolicies/<PolicyName>'}"
```

## Commit the configuration

After you update an NNI, you **must** commit the configuration to push the changes to the network devices. The commit operation isn't triggered automatically. You must manually run it on the parent fabric after every NNI update.

> [!IMPORTANT]
> An NNI update only updates the Azure Resource Manager (ARM) resource. The changes aren't applied to the network devices until you run `commitConfiguration` on the parent fabric. Without a commit, the NNI resource shows `configurationState: Accepted`, indicating pending changes that aren't pushed to the devices.

### Step 1: Lock the fabric

Before you commit, lock the fabric to prevent concurrent modifications:

```azurecli
az networkfabric fabric lock-fabric \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NFName>"
```

### Step 2: Commit the configuration

```azurecli
az networkfabric fabric commit-configuration \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NFName>"
```

### Step 3: Monitor the commit operation

```azurecli
az networkfabric fabric show \
  --resource-group "<NFResourceGroup>" \
  --resource-name "<NFName>" \
  --query "{provisioningState: provisioningState, configurationState: configurationState}"
```

Wait until both states return to `Succeeded` before you proceed with any other operations.

> [!WARNING]
> For management NNIs (`isManagementType: True`), the commit operation applies base configuration changes. The fabric might enter `UnderMaintenance` state during this process. Don't perform any other operations on the fabric until the commit completes and the fabric returns to a stable state.

## Troubleshooting

### NNI update fails with "fabric is locked"

The fabric has an active lock. Wait for any ongoing operation to complete or contact support to release the lock.

### Interfaces go down after NNI update

If CE interfaces go admin-down after an NNI update and commit:

> [!WARNING]
> For management NNIs with a single uplink interface, if that interface goes down, **all ARM management connectivity to the fabric is lost**. You can't run Azure CLI commands (including `update-admin-state`) to recover because the management path flows through the NNI. In this scenario, you must use out-of-band access (terminal server or break-glass access) to restore the interface on the device. See [How to set up break-glass access](howto-set-up-break-glass-access.md).

**If ARM connectivity is still available** (multiple interfaces and at least one is still up):

1. Check the interface administrative states in ARM as described in [Verify NNI Layer 2 interface administrative states](#verify-nni-layer-2-interface-administrative-states).
2. If interfaces show `Disabled`, enable them:

    ```azurecli
    az networkfabric interface update-admin-state \
      --resource-group "<NFResourceGroup>" \
      --resource-name "<InterfaceName>" \
      --device "<DeviceName>" \
      --state Enable
    ```

3. Verify connectivity is restored.
4. Re-run the NNI update and commit operations.

**If ARM connectivity is lost** (management NNI with all interfaces down):

1. Use break-glass or terminal server access to connect to the CE devices directly.
2. Re-enable the interfaces on the device using device CLI commands.
3. Once management connectivity is restored, enable the interfaces in ARM using `az networkfabric interface update-admin-state`.
4. Contact Microsoft support if you need assistance restoring connectivity.

### Configuration state shows "Rejected"

If the NNI or fabric `configurationState` shows `Rejected` after an update:

1. Review the error details in the operation status.
2. Fix the underlying issue (for example, invalid ACL or route policy reference).
3. Re-run the update with corrected parameters.
4. If the fabric is stuck in `Accepted` state, run `commitConfiguration` to apply pending changes, or run `commit-cancel` to revert.

## Best practices

- **Always verify interface states** before you perform NNI update operations, especially on fabrics that you recently provisioned.
- **Avoid concurrent operations** on the same fabric. Wait for any ongoing operation to complete before you start a new one.
- **Test in non-production first.** If possible, validate NNI updates in a test or staging environment before you apply them to production fabrics.
- **Plan maintenance windows** for NNI updates on management NNIs. The commit operation temporarily puts the fabric in maintenance mode.
- **Monitor commit completion.** After an NNI update, wait for the commit operation to fully complete (`configurationState: Succeeded`) before you perform any other operations.
- **Keep a record of the current NNI configuration** before you make changes, so you can revert if needed.

## Next steps

- [Network-to-Network Interconnect (NNI) overview](concepts-network-to-network-interconnect.md)
- [Configure the Network Fabric](howto-configure-network-fabric.md)
- [Commit Workflow v2](howto-use-commit-workflow-v2.md)
- [Network Fabric resource update and commit](concepts-network-fabric-resource-update-commit.md)
