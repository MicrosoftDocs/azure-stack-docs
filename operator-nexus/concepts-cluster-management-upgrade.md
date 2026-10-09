---
title: Azure Operator Nexus Cluster management upgrade overview
description: Get an overview of Cluster management upgrade for Azure Operator Nexus.
author: gregoberfield
ms.author: goberfield
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 10/09/2026
ms.custom: template-concept
---

# Operator Nexus Cluster Management Bundle Upgrades

Operator Nexus releases various functionality and bug fixes throughout the product lifecycle to update the Azure resources and on-premises extensions, critical in communications back to Azure.

> [!NOTE]
> This article describes **Management Bundle Upgrades (MBU)**, which Microsoft automatically applies. While a CMBU is in progress, existing workloads aren't impacted, but creating new workloads might be slightly delayed. These upgrades are separate from **Cluster Runtime Upgrades**, which are customer-managed and disruptive. For more information, see [Related content](#related-content).

## Scope
The releases update components on the Cluster to enable new functionality, while maintaining backwards compatibility for the customer. Additionally, new runtime releases are made available and accessed via [Cluster Runtime Upgrades](./howto-cluster-runtime-upgrade.md).

## Delivery

Microsoft applies Management Bundle Release Updates (MBU) when a release is available in the Azure region. Ring-based assignment groups Cluster Managers into ordered rollout waves within a region, allowing customers to organize which Cluster Managers receive updates earlier or later in the rollout.

Using the update wave functionality is opt-in for customers.

Each Cluster Manager has a `rolloutRing` value between `1` and `15`. Lower values identify earlier rollout waves, and higher values identify later waves. The default value is `4`. The value assigned is applicable only for the Azure region for which the Cluster Manager resides in.

Existing Cluster Managers are assigned ring `4` if no value is set. New Cluster Managers also default to ring `4` when a value isn't provided.

Ring assignment applies to Cluster Managers rather than individual clusters. Assign Cluster Managers to the same ring when you want them grouped in the same rollout wave.

> [!NOTE]
> Ring assignment controls rollout grouping and sequencing. It doesn't initiate a MBU or specify an exact upgrade time. Microsoft continues to apply MBUs. Ring assignment doesn't change the customer-managed Cluster Runtime Upgrade process.

## Assign a rollout ring

Use Azure CLI to view or change a ring assignment. Sign in to Azure CLI with an account that has permission to update the Cluster Manager.

> [!NOTE]
> The `rolloutRing` parameter requires API version `2026-08-01-preview`. When using the Azure CLI commands in this section, use a version of the `networkcloud` extension that supports this API version and the `--rollout-ring` parameter.

1. Identify the subscription, resource group, and name of the Cluster Manager you want to assign.

2. Choose an integer between `1` and `15` based on the Cluster Manager's intended rollout wave. For example, assign a lower-risk Cluster Manager to ring `1` and leave other Cluster Managers in ring `4` for the standard rollout.

3. Run the following command to update the assignment. Replace `<resource-group>` and `<cluster-manager-name>` with your resource details. This example assigns ring `3`; replace `3` with your chosen integer.

   ```azurecli
   az networkcloud clustermanager update --name "<cluster-manager-name>" --resource-group "<resource-group>" --rollout-ring 3
   ```

4. Retrieve the Cluster Manager and verify that the returned `rolloutRing` value matches your assignment. Replace the resource placeholders with the same values used in the update command.

   ```azurecli
   az networkcloud clustermanager show --name "<cluster-manager-name>" --resource-group "<resource-group>"
   ```

Repeat these steps for each Cluster Manager you want to assign. To return a Cluster Manager to the default rollout ring, set `rolloutRing` to `4`.

## Impact to customer workloads
Existing workload readiness and general node health remain unaffected throughout a MBU. Any baremetalMachines `readyState` transitioning to `false` briefly during the upgrade doesn't affect existing or new workloads. However, new workload creation might be slightly delayed during the upgrade window.


## Duration of on-premises updates
Updates take up to one hour to complete per Cluster.

## Related content

Azure Operator Nexus includes multiple upgrade types that serve different purposes.

### Network Fabric Management upgrades (non-disruptive)
- [Network Fabric Management upgrade overview](concepts-fabric-management-upgrade.md) - Non-disruptive updates to Fabric Azure resources and extensions

### Runtime upgrades (customer-managed, disruptive)
- [Cluster runtime upgrade overview](concepts-cluster-upgrade-overview.md) - Disruptive updates to underlying platform software
- [Cluster runtime upgrade](howto-cluster-runtime-upgrade.md)
- [Network Fabric runtime upgrade](howto-upgrade-nexus-fabric.md)
