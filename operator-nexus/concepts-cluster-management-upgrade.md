---
title: Azure Operator Nexus Cluster management upgrade overview
description: Get an overview of Cluster management upgrade for Azure Operator Nexus.
author: bartpinto
ms.author: bpinto
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 01/16/2026
ms.custom: template-concept
---

# Operator Nexus Cluster Management Bundle Upgrades

Operator Nexus releases various functionality and bug fixes throughout the product lifecycle to update the Azure resources and on-premises extensions, critical in communications back to Azure.

> [!NOTE]
> This article describes **Cluster Management Bundle Upgrades (CMBU)**, which are non-disruptive and automatically applied by Microsoft. These upgrades are separate from **Cluster Runtime Upgrades**, which are customer-managed and disruptive. For more information, see [Related content](#related-content).

## Scope
The releases update components on the Cluster to enable new functionality, while maintaining backwards compatibility for the customer. Additionally, new runtime releases are made available and accessed via [Cluster Runtime Upgrades](./howto-cluster-runtime-upgrade.md).

## Delivery
CMBU is triggered independently when the release is available in the Azure region.

## Impact to customer workloads
There's no disruption to running workloads or instantiating new workloads, and on-premises resources retain availability throughout the upgrade. Therefore, the customer sees no impact. 

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
