---
title: Azure Operator Nexus Cluster management upgrade overview
description: Get an overview of Cluster management upgrade for Azure Operator Nexus.
author: gregoberfield
ms.author: goberfield
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 01/16/2026
ms.custom: template-concept
---

# Operator Nexus Cluster Management Bundle Upgrades

Operator Nexus releases various functionality and bug fixes throughout the product lifecycle to update the Azure resources and on-premises extensions, critical in communications back to Azure.

> [!NOTE]
> This article describes **Cluster Management Bundle Upgrades (CMBU)**, which Microsoft automatically applies. While a CMBU is in progress, existing workloads aren't impacted, but creating new workloads might be slightly delayed. These upgrades are separate from **Cluster Runtime Upgrades**, which are customer-managed and disruptive. For more information, see [Related content](#related-content).

## Scope
The releases update components on the Cluster to enable new functionality, while maintaining backwards compatibility for the customer. Additionally, new runtime releases are made available and accessed via [Cluster Runtime Upgrades](./howto-cluster-runtime-upgrade.md).

## Delivery
CMBU is triggered independently when the release is available in the Azure region.

## Impact to customer workloads
Existing workload readiness and general node health remain unaffected throughout a CMBU. Any baremetalMachines `readyState` transitioning to `false` briefly during the upgrade doesn't affect existing or new workloads. However, new workload creation might be slightly delayed during the upgrade window. 


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
