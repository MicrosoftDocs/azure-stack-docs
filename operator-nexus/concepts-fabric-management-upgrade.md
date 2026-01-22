---
title: Azure Operator Nexus Network Fabric management upgrade overview
description: Get an overview of Network Fabric management upgrade for Azure Operator Nexus.
author: bartpinto
ms.author: bpinto
ms.service: azure-operator-nexus
ms.topic: feature-availability
ms.date: 01/16/2026
ms.custom: template-concept
---

# Operator Nexus Network Fabric Management Bundle Upgrades

Operator Nexus releases various functionality and bug fixes throughout the product lifecycle to update the Azure resources and on-premises extensions, critical in communications back to Azure.

> [!NOTE]
> This article describes **Fabric Management Bundle Upgrades**, which are non-disruptive and automatically applied by Microsoft. Fabric Management Bundle Upgrades are separate from **Fabric Device Runtime Upgrades**, which update the software on network devices. For more information, see [Related content](#related-content).

## Scope
The releases update components on the Network Fabric Controller to enable new functionality, while maintaining backwards compatibility for the customer. Additionally, new runtime releases are made available and accessed via [Network Fabric Upgrades](./howto-upgrade-nexus-fabric.md).

For Fabric Device management, Microsoft delivers new software to the extensions and agents that exist on the platform to provide new functionality and maintain security and communication back to Azure.

## Delivery
Network Fabric Controller update is triggered independently when the release is available in the region.

## Impact to customer workloads
There's no disruption to running workloads or instantiating new workloads, and on-premises resources retain availability throughout the upgrade. Therefore, the customer sees no impact. 

## Duration of on-premises updates
Updates take approximately 45 minutes to complete per Network Fabric.

## Related content

Azure Operator Nexus includes multiple upgrade types that serve different purposes. Fabric management upgrades are separate from fabric device upgrades, which update the software running on network devices.

### Management upgrades (non-disruptive)
- [Cluster management bundle upgrade overview](concepts-cluster-management-upgrade.md) - Non-disruptive updates to cluster Azure resources and extensions

### Runtime and device upgrades (customer-managed)
- [Network Fabric runtime upgrade](howto-upgrade-nexus-fabric.md) - Updates to network device software
- [Cluster runtime upgrade overview](concepts-cluster-upgrade-overview.md) - Disruptive updates to underlying platform software
- [Cluster runtime upgrade](howto-cluster-runtime-upgrade.md)
