---
title: "Azure Operator Nexus: Cluster runtime upgrade preflight checks"
description: Reference for the preflight validation checks that run before a Cluster runtime upgrade in Operator Nexus.
author: mbethi527
ms.author: mbethi
ms.service: azure-operator-nexus
ms.topic: reference
ms.date: 06/22/2026
---

# Cluster runtime upgrade preflight checks

Preflight checks are validation checks that run automatically before any runtime upgrade starts on cluster bare-metal machines. They run in two scenarios:
1. During the Cluster update-version (CUVA) action, which starts the upgrade.
1. During the Cluster continue-update-version (CCUVA) action, which resumes a paused upgrade.

These checks verify that the Cluster is ready for upgrade. They help prevent common failure scenarios, including concurrent upgrades, version downgrades, and unmet platform prerequisites.

If any check fails, the upgrade is blocked and a descriptive message is shown in the cluster `actionStates` field. Most failures require operator action before retrying CUVA or CCUVA.

Checks are grouped by whether they're affected by the CUVA `SafeguardMode` setting. All checks that can be evaluated are run together, so all failures are reported at once.

> [!IMPORTANT]
> `SafeguardMode=All` is the default for API version `2026-05-01` and later. Earlier API versions default to `SafeguardMode=None`.

## Validation checks

### Checks always enforced
The following checks always block the upgrade regardless of `SafeguardMode`.

#### 1. Cluster status
The cluster must meet the following conditions before the upgrade can start:
1. Cluster detailed status must be `Running`
1. Cluster-to-Cluster Manager connectivity must be `Connected`.

#### 2. Upgrade version checks
1. The target version must appear in the cluster's `status.availableUpgradeVersions` list. If it doesn't, the upgrade fails immediately.
1. The target version must be greater than the cluster's current version.

#### 3. Azure user-provided resource validations
The following customer-managed Azure resources are validated for existence and correct permissions. See [Cluster Managed Identity and User Provided Resources](howto-cluster-managed-identity-user-provided-resources.md) for details on configuring these resources.

### Checks enforced by `SafeguardMode=All`
The following checks only block the upgrade when `SafeguardMode=All` is set. With `SafeguardMode=None`, failures emit a warning and the upgrade proceeds.

#### 1. Platform prerequisites check
These checks validate that the cluster's control plane, management plane, and compute nodes meet the minimum health requirements before runtime upgrades begin.

Specifically, the following conditions must be met:
- **Control plane nodes**: All control plane nodes must be healthy (Power state `On`, Cordon status `Uncordoned`, Ready state `Yes`, Degraded `No`). If a spare control plane node exists, the spare node must be in the state: Power State `On`, Ready state `Yes`, Degraded `No`
>[!NOTE]
> If the spare control plane machine previously went through a provisioning process, it's expected to be in Cordon status `Cordoned`. If not, it should be in Cordon status `Uncordoned`.
- **Management plane nodes**: As the management plane machines are split into two groups, at least 50% + 1 nodes must be healthy. Across both groups, at least 75% machines must be healthy.
- **Compute nodes**: The cluster's configured upgrade strategy thresholds determine the minimum required number of healthy nodes in each rack. The number of healthy machines in a rack must be greater than the configured thresholds. To learn more about threshold behaviors or update strategy, see [cluster-update-strategy](./howto-cluster-runtime-upgrade-with-pauseafterrack-strategy.md)

For all nodes (except the spare), healthy means: Power state `On`, Cordon status `Uncordoned`, Ready state `Yes`, Degraded `No`.

The outcome of preflight checks is visible in the `stepStates` of the `Validate Cluster conditions and upgrade versions` step, accessible from the cluster resource's `JSON View` under `properties.actionStates`.

**Example: Upgrade blocked by a failed preflight check (`SafeguardMode=All`)**

```json
{
  "actionType": "Microsoft.NetworkCloud/clusters/updateVersion",
  "correlationId": "0f5776a8-7d83-4800-b0c8-332c536e3341",
  "endTime": "2026-05-28T20:34:54Z",
  "message": "Platform prerequisites not satisfied: Platform readiness checks failed: Cluster is not ready for upgrade. Fix the resources associated with capiCluster/nodepools rs1111",
  "startTime": "2026-05-28T20:34:22Z",
  "status": "Failed",
  "stepStates": [
    {
      "endTime": "2026-05-28T20:34:54Z",
      "message": "Preflight validation failed: Platform prerequisites not satisfied: Platform readiness checks failed: Cluster is not ready for upgrade. Fix the resources associated with capiCluster/nodepools rs1111",
      "startTime": "2026-05-28T20:34:23Z",
      "status": "Failed",
      "stepName": "Validate Cluster conditions and upgrade versions"
    }
  ]
}
```

**Example: Upgrade proceeds with a preflight warning (`SafeguardMode=None`)**

```json
{
  "actionType": "Microsoft.NetworkCloud/clusters/continueUpdateVersion",
  "correlationId": "14699a26-3e30-416a-a4d0-4188b2e91f1d",
  "message": "Target Cluster Version 4.11.0",
  "startTime": "2026-05-28T23:24:43Z",
  "status": "InProgress",
  "stepStates": [
    {
      "endTime": "2026-05-28T23:25:15Z",
      "message": "Cluster validation and version checks passed; Warning: Platform prerequisites not satisfied: Platform readiness checks failed: Cluster is not ready for upgrade. Fix the resources associated with capiCluster/nodepools rs1111. Proceeding with upgrade due to permissive safeguard mode.",
      "startTime": "2026-05-28T23:24:44Z",
      "status": "Completed",
      "stepName": "Validate Cluster conditions and upgrade versions"
    }
  ]
}
```
The message specifies whether the control plane capiCluster is unhealthy or whether the machines in a specific rack are unhealthy. Once you determine the rack or control plane machine that's unhealthy, use [Troubleshooting Bare Metal Machine Provisioning](./troubleshoot-bare-metal-machine-provisioning.md) to get the machines provisioned and healthy so that the prechecks pass the next time the CUVA action is triggered or is resumed.

## Related content

- [Upgrade Cluster runtime from Azure CLI](./howto-cluster-runtime-upgrade.md)
- [Upgrading Cluster runtime with PauseAfterRack strategy](./howto-cluster-runtime-upgrade-with-pauseafterrack-strategy.md)
- [Cluster Managed Identity and User Provided Resources](howto-cluster-managed-identity-user-provided-resources.md)
- [Troubleshoot Azure Operator Nexus server problems](troubleshoot-reboot-reimage-replace.md)
