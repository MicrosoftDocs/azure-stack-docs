---
title: A / B staged commit configuration update commit workflow v3 in Azure Operator Nexus
description: Learn about A / B staged commit configuration update commit workflow in Azure Operator Nexus
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 05/16/2025
ms.custom: template-concept
---

# A / B staged commit configuration update commit workflow in Azure Operator Nexus - Network Fabric

**A/B Staged Config Update** introduces a safe rollout model for Network Fabric configuration. Operators stage configuration on one Customer Edge device(A or B), validate behavior, optionally cancel to revert, or complete rolling out to the remaining devices—leveraging **Commit Workflow** semantics (lock → validate → commit). Current scope targets **Customer Edge-only staging**; broader policies might be added later.

## Key Highlights

- **Reduced Risk:** Prevents simultaneous configuration errors that could affect all devices, ensuring network stability.
- **Staged Rollout**: Enables updates to be applied to one Customer Edge device at a time, allowing for targeted testing and validation.
- **Rollback Capability:** Provides a straightforward rollback mechanism to revert to the previous configuration if issues are detected during staging.
- **Operational Flexibility:** Supports both staged and traditional (nonstaged) configuration workflows, giving operators control over the update process. Both workflows are mutually exclusive and can't be triggered while one is in progress.

## Supported Use Cases

- Customer Edge configuration changes that can be fully validated during staging; other devices update only after **Complete**.
- Nonstaged Commit V2 remains available (lock → diff/validate → commit) for all supported resources.

## Architecture & Workflow

A/B Update extends Commit V2 with policy‑driven staged steps:<br>
1. **Lock (Configuration)** – freeze fabric configuration to batch the intended updates.<br>
2. **Prepare (Start)** – build candidate configs based on policy (for example, Stage‑CE‑config).<br>
3. **Staged Apply (Continue to CE1/CE2)** – apply to the selected Customer Edge device only; no other devices change.<br>
4. **Validate & Test** – run traffic/telemetry checks, device config views.<br>
5. **Cancel (Rollback)** – revert all devices to previous golden configuration if results aren’t acceptable.<br>
6. **Complete** – roll out to remaining devices, then release the lock.<br>

## Prerequisites & Versioning

- **Runtime**: Network Fabric runtime **≥ 7.0.0**.
- **NNF Release**: Feature ships with **NNF 10.0**.
- **API**: GA API dated **2025‑07‑15** (or later).
- **Commit V2** foundation: Runtime **≥ 5.0.1** (for nonstaged operations and device previews/diffs).

## Behavior & Constraints

- Fabric administrative **lock is mandatory** before staged or full commits.
- During **Customer Edge staging**, only the specified Customer Edge device is updated; all other devices remain unchanged until **Complete**.
- **Commit Discard** restores last known good configuration across all ARM resource and can be used to prior to staging the devices.
- Commit cancel rollback restores last known good configuration to all devices and ARM resources. This operation can be used post staging the configuration on one device
- Commit cancel operation isn't supported post the final commit is executed.
- User can retry to commit the changes across all devices via the commit operation in case of failures
- A/B Update currently **does not** support staging for ToRs, Network Packet Brokers, or management switches; some L3 isolation domain operations can't be fully validated during customer edge staging.
- A/B update and commit v2 workflows (patch and update) are mutually exclusive and can't be performed in parallel.
- Once A/B update workflow gets initiated, the service doesn't support switching over to commit v2 workflow

## State Transitions (high level)

- **Fabric**: Provisioned → Locked (Configuration) → Prepared (Staged) → Committed/Completed → Provisioned.
- **Customer Edge device**: Config(previous) → Candidate(staged) → Applied → (if cancel) Reverted(previous).

## Failure Handling & Observability

- Use device configuration views to identify misconfigurations **before** commit.
- Failed commit batches surface descriptive errors; use activity logs and Commit V2 diagnostics.


## Next steps

[How to use A / B staged commit configuration update commit workflow in Azure Operator Nexus](./howto-use-ab-staged-commit-configuration-update-commit-workflow-v3.md)
