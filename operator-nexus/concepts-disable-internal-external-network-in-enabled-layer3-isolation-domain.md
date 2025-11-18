---
title: Disable Internal/External Networks in an Enabled Layer 3 Isolation Domain 
description: Learn about Disable Internal/External Networks in an Enabled Layer 3 Isolation Domain 
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 05/16/2025
ms.custom: template-concept
---

# Disable Internal/External Networks in an Enabled Layer 3 Isolation Domain 

Disabling internal or external networks while an Isolation Domain (ISD) is enabled ensures controlled configuration changes without disrupting active traffic. This feature introduces administrative state updates for networks, integrated with Commit workflows for atomic operations.

### Key Capabilities

- Support enabling/disbaling of Internal and External Networks on an enabled Layer 3 ISD via updateAdministrativeState POST action.
- Integration with Commit workflow for consistent configuration changes.
- Enables safe disablement of internal/external networks before deletion by enforcing Disable → Commit → Delete (outside commit) to prevent accidental removal.

### Behavior & Constraints

- Internal/External Networks resoruces cannot be deleted directly when ISD is enabled; they must be disabled first.
- **Mutually exclusive pipelines:** PATCH-based config updates (**Accepted**) and admin POST actions (**PendingAdministrativeUpdate**) cannot be performed in a single commit session.
- At least one internal network must remain enabled in ISD.
- Disable operation is blocked if an ARM update and commit batch is in progress.
- Disabling will fail if associated resources are enabled
  - Internal Networks: RoutePolicy, NetworkTap, NetworkMonitor.
  - External Networks: RoutePolicy, NNIs, ACLs.
- Disabling Internal /external network is not supported via A/B update workflow.
- Modification of any Internal/External Network configuration might lead to temporary or may be permanent disruption of network if the dependent service/workloads are still using the old configuration.
- Unlocking during the batch will not restore the resource to enabled state, user must perform update Administrative State to enabled and commit if the user desires to change the state.
- Post delete operation there are no mechanisms to restore the deleted internal/external network. Users must recreate the resource via ARM API via commit workflow if the Layer3 Isolation Domain is in enabled state

### State Transitions

- Network **Fabric:** Provisioned → PendingAdministrativeUpdate → Provisione
- Internal/External **Network:** Enabled → PendingAdministrativeUpdate → Disabled

## Next steps

[How to disable Internal/External networks in enabled layer 3 isolation domain](./howto-disable-internal-external-networks-in-enabled-layer-3-isolation-domain.md)