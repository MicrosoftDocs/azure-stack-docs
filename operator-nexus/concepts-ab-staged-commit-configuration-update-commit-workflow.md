---
title: 'A/B Staged Configuration Update: Commit Workflow in Azure Operator Nexus'
description: Learn about the A/B staged configuration update commit workflow in Azure Operator Nexus.
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: article
ms.date: 05/16/2025
ms.custom: template-concept
---

# A/B staged configuration update: Commit workflow in Azure Operator Nexus

The A/B staged configuration update introduces a safe rollout model for Network Fabric configuration. Operators stage configuration on one customer edge device (A or B), validate behavior, optionally cancel to revert, or complete rolling out to the remaining devices by using commit workflow semantics (lock-validate-commit cycle). The current scope targets customer edge-only staging. Broader policies might be added later.

## Key highlights

- **Reduced risk**: Prevents simultaneous configuration errors that could affect all devices to ensure network stability.
- **Staged rollout**: Enables updates to be applied to one customer edge device at a time, which allows for targeted testing and validation.
- **Rollback capability**: Provides a straightforward rollback mechanism to revert to the previous configuration if issues are detected during staging.
- **Operational flexibility**: Supports both staged and traditional (nonstaged) configuration workflows, which gives operators control over the update process. Both workflows are mutually exclusive and can't be triggered while one is in progress.

## Supported use cases

- Customer edge configuration changes that can be fully validated during staging. Other devices update only after **Complete**.
- Nonstaged commit workflow v2 remains available (lock → diff/validate → commit) for all supported resources.

## Architecture and workflow

A/B update extends commit workflow v2 with policy‑driven staged steps:

* **Lock (configuration)**: Freeze fabric configuration to batch the intended updates.
* **Prepare (start)**: Build candidate configurations based on policy (for example, stage‑customer edge‑configuration cycle).
* **Staged apply (continue to CE1/CE2)**: Apply to the selected customer edge device only. No other devices change.
* **Validate and test**: Run traffic/telemetry checks and device configuration views.
* **Cancel (rollback)**: Revert all devices to previous golden configuration if results aren't acceptable.
* **Complete**: Roll out to remaining devices, and then release the lock.

## Prerequisites and versioning

- **Runtime**: Network Fabric runtime ≥7.0.0.
- **Azure Operator Nexus - Network Fabric release**: Feature ships with Azure Operator Nexus - Network Fabric 10.0.
- **API**: GA API dated 2025‑07‑15 (or later).
- **Commit workflow v2 foundation**: Runtime ≥5.0.1 (for nonstaged operations and device previews/diffs).

## Behavior and constraints

- Fabric administrative lock is *mandatory* before staged or full commits.
- During customer edge staging, only the specified customer edge device is updated. All other devices remain unchanged until **Complete**.
- The commit discard operation restores the last known good configuration across all Azure Resource Manager resources. You can use it before you stage the devices.
- The commit cancel rollback operation restores the last known good configuration to all devices and Resource Manager resources. You can use this operation after you stage the configuration on one device.
- The commit cancel operation isn't supported until after the final commit is executed.
- You can retry to commit the changes across all devices via the commit operation if there are failures.
- An A/B update currently doesn't support staging for top-of-rack devices, network packet brokers, or management switches. Some layer 3 isolation domain operations can't be fully validated during customer edge staging.
- The A/B update and commit workflow v2 (patch and update) are mutually exclusive and can't be performed in parallel.
- After the A/B update workflow is initiated, the service doesn't support switching over to commit workflow v2.

## State transitions (high level)

- **Network Fabric**: Provisioned → Locked (configuration) → Prepared (staged) → Committed/Completed → Provisioned
- **Customer edge device**: Configuration (previous) → Candidate (staged) → Applied → (if canceled) Reverted (previous)

## Failure handling and observability

- Use device configuration views to identify misconfigurations before you commit.
- Failed commit batches surface descriptive errors. Use activity logs and commit workflow v2 diagnostics.

## Related content

- [Perform A/B staged configuration update: Commit workflow in Azure Operator Nexus](./howto-use-ab-staged-commit-configuration-update-commit-workflow.md)
