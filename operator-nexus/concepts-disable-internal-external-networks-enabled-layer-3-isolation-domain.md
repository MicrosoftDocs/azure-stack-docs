---
title: Disable Internal/External Networks in an Enabled Layer 3 Isolation Domain in Azure Operator Nexus 
description: Learn about disabling internal/external networks in an enabled layer 3 isolation domain in Azure Operator Nexus.
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 05/16/2025
ms.custom: template-concept
---

# Disable internal/external networks in an enabled layer 3 isolation domain in Azure Operator Nexus

Disabling internal or external networks while an isolation domain (ISD) is enabled ensures controlled configuration changes without disrupting active traffic. This feature introduces administrative state updates for networks integrated with commit workflows for atomic operations.

## Key capabilities

- Supports enabling and disabling of internal/external networks on an enabled layer 3 ISD via update by using the `AdministrativeState` POST action.
- Integrates with commit workflows for consistent configuration changes.
- Enables safe disablement of internal/external networks before deletion by enforcing Disable → Commit → Delete (outside commit) to prevent accidental removal.

## Behavior and constraints

- The internal/external networks resources can't be deleted directly when an ISD is enabled. They must be disabled first.
- Pipelines are mutually exclusive. PATCH-based config updates (**Accepted**) and admin POST actions (`PendingAdministrativeUpdate`) can't be performed in a single commit session.
- At least one internal network must remain enabled in ISD.
- The disable operation is blocked if an Azure Resource Manager update and commit batch are in progress.
- Disabling fails if associated resources are enabled:

  - **Internal networks**: `RoutePolicy`, `NetworkTap`, and `NetworkMonitor`
  - **External networks**: `RoutePolicy`, network-to-network interconnect, and access control lists
- Disabling internal/external networks isn't supported via A/B update workflow.
- Modification of any internal/external network configuration might lead to temporary or permanent disruption of the network if the dependent service or workloads are still using the old configuration.
- Unlocking during the batch doesn't restore the resource to an enabled state. You must update the administrative state to enabled and commit if you want to change the state.
- After the delete operation, there are no mechanisms to restore the deleted internal/external network. You must re-create the resource via a Resource Manager API by using a commit workflow if the layer 3 ISD is in an enabled state.

## State transitions

- **Network Fabric**: Provisioned → `PendingAdministrativeUpdate` → Provisioned
- **Internal/external networks**: Enabled → `PendingAdministrativeUpdate` → Disabled

## Related content

- [Disable internal/external networks in an enabled layer 3 isolation domain](./howto-disable-internal-external-networks-enabled-layer-3-isolation-domain.md)
