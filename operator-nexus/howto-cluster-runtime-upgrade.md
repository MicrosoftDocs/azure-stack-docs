---
title: "Azure Operator Nexus: Runtime upgrade"
description: Learn to execute a Cluster runtime upgrade for Operator Nexus
author: mbethi527
ms.author: mbethi
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus, devx-track-azurecli
ms.topic: how-to
ms.date: 06/22/2026
# ms.custom: template-include
---

# Upgrade Cluster runtime from Azure CLI

This article explains how to perform runtime upgrade for an Operator Nexus Cluster.

## Prerequisites

1. Install the latest version of the [appropriate CLI extensions](howto-install-cli-extensions.md).
1. Subscription access to run the Azure Operator Nexus network fabric (NF) and network cloud (NC) CLI extension commands.
1. Collect the following information:
   - Subscription ID (`SUBSCRIPTION`)
   - Cluster name (`CLUSTER`)
   - Resource group (`CLUSTER_RG`)
1. Cluster detailed status must be `Running`.
1. Cluster-to-Cluster Manager connectivity must be `Connected`.
1. Azure prerequisites (Log Analytics Workspace, Storage Account, Key Vault) must be validated. These resources are checked before upgrade begins. See [Cluster Managed Identity and User Provided Resources](howto-cluster-managed-identity-user-provided-resources.md).
1. Under Cluster > Workload > Compute Servers
    - Control plane node health requirements before upgrade are:
      - If no spare control plane node exists, all control plane nodes must be healthy: Power state `On`, Cordon status `Uncordoned`, Ready state `Yes`, and Degraded `No`.
      - If a spare control plane node exists, only the spare node can be in Power state `Off`, Ready state `No`, and Degraded `No`. Every other control plane node must be healthy: Power state `On`, Cordon status `Uncordoned`, Ready state `Yes`, and Degraded `No`.
      >[!NOTE]
      > If the spare control plane machine previously went through a provisioning process, it is expected to be in Cordon status `Cordoned`. If not, it should be in Cordon status `Uncordoned`.
    - The management plane servers are broken into two groups on odd and even numbered racks. In each group, at least more than 50% of the servers must be healthy: Power State `On`, Cordon status `Uncordoned`, Ready state `Yes`, and Degraded `No`.
        - Across both management plane groups, at least 75% of the management machines must be healthy.
    - Compute plane server numbers vary based on individual cluster runtime threshold settings. Customers need to determine their minimum number based on their settings, looking for Power state `On`, Cordon status `Uncordoned`, Ready state `Yes`, and Degraded `No`.
1. Under Cluster > Managed Resource Group select the group name to go to the resource group page.
    - In the resource group, search for ``Kubernetes - Azure Arc`` to identify the Azure Arc information and select it. Status should be ``Connected``.
        - Within Azure Arc page, select Settings > Extensions.
            - `nc-platform-extension` should be in status `Succeeded`.
            - `nc-platform-runtime-extension` should be in status `Succeeded`.

> [!NOTE]
> These same checks should also be performed following the upgrade to ensure the Cluster is healthy.

## Checking current runtime version

Verify the current cluster runtime version before upgrade: See [How to check current Cluster runtime version](./howto-check-runtime-version.md#check-current-cluster-runtime-version).

## Finding available runtime versions

### Via the Azure portal

To find available upgradeable runtime versions, navigate to the target Cluster in the Azure portal. In the Cluster's overview pane, navigate to the **_Available upgrade versions_** tab.

:::image type="content" source="./media/runtime-upgrade-upgradeable-runtime-versions.png" alt-text="Screenshot of Azure portal showing correct tab to identify available Cluster upgrades." lightbox="./media/runtime-upgrade-upgradeable-runtime-versions.png":::

From the **available upgrade versions** tab, you can see the different cluster versions available to upgrade. Select the target runtime version from the list, and then proceed with upgrading the cluster.

:::image type="content" source="./media/runtime-upgrade-runtime-version.png" lightbox="./media/runtime-upgrade-runtime-version.png" alt-text="Screenshot of Azure portal showing available Cluster upgrades.":::

### Via Azure CLI

Available upgrades are retrievable via the Azure CLI:

```azurecli
az networkcloud cluster show --name "<CLUSTER>" \
--resource-group "<CLUSTER_RG>" \
--subscription "<SUBSCRIPTION>" | grep -A8 availableUpgradeVersions
```

In the output, you can find the `availableUpgradeVersions` property and look at the `targetClusterVersion` field:

```
  "availableUpgradeVersions": [
    {
      "controlImpact": "True",
      "expectedDuration": "Upgrades may take up to 4 hours + 2 hours per rack",
      "impactDescription": "Workloads will be disrupted during rack-by-rack upgrade",
      "supportExpiryDate": "2023-07-31",
      "targetClusterVersion": "3.3.0",
      "workloadImpact": "True"
    }
  ],
```

If there are no available Cluster upgrades, the list is empty.

## Configure Compute threshold parameters for Runtime upgrade using Cluster `updateStrategy`

The following Azure CLI command is used to configure the compute threshold parameters for a runtime upgrade:

```azurecli
az networkcloud cluster update \
--name "<CLUSTER>" \
--resource-group "<CLUSTER_RG>" \
--subscription "<SUBSCRIPTION>" \
--update-strategy strategy-type="<strategyType>" threshold-type="<thresholdType>" \
threshold-value="<thresholdValue>" max-unavailable="<maxNodesOffline>" \
wait-time-minutes="<waitTimeBetweenRacks>"
```

Required parameters:

- strategy-type: Defines the update strategy. Settings used are `Rack` (Rack-by-Rack) OR `PauseAfterRack` (Pause for user before each Rack starts). The default value is `Rack`. To perform a Cluster runtime upgrade using the `PauseAfterRack` strategy, follow the steps outlined in [Upgrade Cluster Runtime with PauseAfterRack Strategy](howto-cluster-runtime-upgrade-with-pauseafterrack-strategy.md).
- threshold-type: Determines how the threshold should be evaluated, applied in the units defined by the strategy. Settings used are `PercentSuccess` OR `CountSuccess`. The default value is `PercentSuccess`.
- threshold-value: The numeric threshold value used to evaluate an update. The default value is `80`.

Optional parameters:

- max-unavailable: The maximum number of worker nodes that can be offline, that is, upgraded rack at a time. The default value is `32767`.
- wait-time-minutes: The delay or waiting period before updating a rack. The default value is `15`.

### Upgrade Behavior based on PercentSuccess threshold type

The following example is for a customer using Rack-by-Rack strategy with a Percent Success of 60% and a 1-minute pause.

```azurecli
az networkcloud cluster update --name "<CLUSTER>" \
--resource-group "<CLUSTER_RG>" \
--update-strategy strategy-type="Rack" threshold-type="PercentSuccess" \
threshold-value=60 wait-time-minutes=1 \
--subscription "<SUBSCRIPTION>"
```

Verify update:

```
az networkcloud cluster show --name "<CLUSTER>" \
--resource-group "<CLUSTER_RG>" \
--subscription "<SUBSCRIPTION>" | grep -A5 updateStrategy

  "updateStrategy": {
    "maxUnavailable": 32767,
      "strategyType": "Rack",
      "thresholdType": "PercentSuccess",
      "thresholdValue": 60,
      "waitTimeMinutes": 1
```

In this example, once 60% of the machines in a rack are successfully upgraded, the system considers the threshold met and proceeds to upgrade the next rack, while continuing to provision any remaining machines in the current rack. If the threshold isn't met - meaning fewer than 60% of the machines in the rack were able to upgrade and instead failed, then the cluster upgrade is paused. When an upgrade is paused, the system provides a detailed status message on the cluster explaining the reason. At that point, the problematic machines in the rack must be repaired, and a cluster continue-update-version operation must be triggered to resume and complete the upgrade. 

To view the upgrade status through the Azure portal, navigate to the targeted Cluster resource. In the Cluster's *Overview* screen, the detailed status is provided along with a detailed status message.

The Cluster upgrade is in-progress when detailedStatus is set to `Updating` and detailedStatusMessage shows the progress of upgrade. Some examples of upgrade progress shown in detailedStatusMessage are `Waiting for control plane upgrade to complete...`, `Waiting for nodepool "<rack-id>" to finish upgrading...`, etc.

The Cluster upgrade is complete when detailedStatus is set to `Running` and detailedStatusMessage shows message `Cluster is up and running`

If the Detailed Status Message shows upgrade is paused, the message looks like below:
`Cluster is deployed but the upgrade has been paused. Machines in rack "<rack-id>" are unhealthy. Fix the machines and perform cluster continue-update-version action to finish the upgrade`

:::image type="content" source="./media/runtime-upgrade-cluster-detail-status-message-paused.png" lightbox="./media/runtime-upgrade-cluster-detail-status-message-paused.png" alt-text="Screenshot of Azure portal showing Cluster upgrade paused.":::

To resume the runtime upgrade, execute the following az networkcloud cli command.
```azurecli
az networkcloud cluster continue-update-version --cluster-name "<CLUSTER>" \
--resource-group="<CLUSTER_RG>" \
--subscription="<SUBSCRIPTION>" \
--safeguard-mode <SAFEGUARD_MODE>
```

Optional parameters:
- `--safeguard-mode`: Specifies how safeguards are applied during the continue-update-version operation. Use `All` to run all preoperation validation checks. Use `None` to bypass safeguards that block the upgrade when they detect problems. The default value is `All`.

>[!IMPORTANT]
> The default safeguard mode `All` blocks the upgrade from resuming if validations determine that the upgrade can't be completed without fixing the detected problems. To learn more, see [Cluster Runtime Upgrade preflight validations](howto-cluster-runtime-upgrade-preflight-checks.md).

### Upgrade Behavior based on CountSuccess threshold Type

The following example is for a customer using Rack-by-Rack strategy with a threshold type `CountSuccess` of 10 nodes per rack and a 1-minute pause.

```azurecli
az networkcloud cluster update --name "<CLUSTER>" \
--resource-group "<CLUSTER_RG>" \
--update-strategy strategy-type="Rack" threshold-type="CountSuccess" \
threshold-value=10 wait-time-minutes=1 \
--subscription "<SUBSCRIPTION>"
```

Verify update:

```
az networkcloud cluster show --name "<CLUSTER>" \
--resource-group "<CLUSTER_RG>" \
--subscription "<SUBSCRIPTION>" | grep -A5 updateStrategy

  "updateStrategy": {
    "maxUnavailable": 32767,
      "strategyType": "Rack",
      "thresholdType": "CountSuccess",
      "thresholdValue": 10,
      "waitTimeMinutes": 1
```

In this example, if at least 10 nodes are successfully upgraded, the upgrade moves on to the next rack while continuing to provision any remaining machines in the current rack. If at least 10 machines in the rack fail to upgrade, the cluster upgrade pauses. When this happens, the required hardware must be repaired before running the continue‑update‑version action to resume and complete the upgrade. 

For troubleshooting issues with bare metal machines, refer to [Troubleshoot Azure Operator Nexus server problems](troubleshoot-reboot-reimage-replace.md)

> [!NOTE]
> **You can't change _`update-strategy` after the Cluster runtime upgrade starts._**

## Validations that can block the cluster runtime upgrade
When you trigger a cluster runtime upgrade, the process runs a series of preupgrade validations before the runtime upgrade on the cluster bare metal machines starts. These validations confirm that the runtime upgrade can succeed given the current state of the cluster. For more information, see [Cluster Runtime Upgrade preflight validations](howto-cluster-runtime-upgrade-preflight-checks.md).


## Upgrade Cluster runtime using CLI

To upgrade the cluster runtime version, use the following Azure CLI command:

```azurecli
az networkcloud cluster update-version\
--cluster-name "<CLUSTER>" \
--resource-group "<CLUSTER_RG>" \
--subscription "<SUBSCRIPTION>" \
--target-cluster-version "<versionNumber>" \
--safeguard-mode "<SAFEGUARD_MODE>"
```

Required parameters:
- `--target-cluster-version`: The version to apply to the cluster during the update.

Optional parameters:
- `--safeguard-mode`: Specifies how safeguards are applied during the update version operation. Use `All` to run all preoperation validation checks. Use `None` to bypass safeguards that block the upgrade when they detect problems. The default value is `All`.

>[!IMPORTANT]
> The default safeguard mode `All` blocks the OS and extensions upgrade from starting if validations determine that the upgrade can't be completed without fixing the detected problems. To learn more, see [Cluster Runtime Upgrade preflight validations](howto-cluster-runtime-upgrade-preflight-checks.md).

This command initiates the runtime upgrade process for the specified cluster. The command itself typically finishes within about five minutes, but it only starts the upgrade process once the validations succeed. The actual runtime upgrade continues to execute in the background and can take several hours to complete, as it upgrades nodes rack by rack and installs the new OS version.

Detailed status and diagnostic information for the initiation step is available in Azure portal in the `JSON View` of the Cluster (Operator Nexus) resource. The following information is included in the `updateVersion` entry of the `properties.actionStates` field, when using API Version `2025-07-01-preview` or higher.

- Start and end time of the action.
- Current status (`Succeeded`, `Failed`, or `InProgress`).
- Any extra context or error message associated with the current status.
- The Correlation ID for the original `cluster update-version` operation, as also shown in the Azure Activity log.
- An ordered list of individual steps and their status - for example `Validate Cluster conditions and upgrade versions`, and `Initiate Platform Runtime Extension update`.

> [!IMPORTANT]
> The `properties.actionStates` entry for `updateVersion` reflects only the short initiation phase (validation and request initiation that typically completes in ~5 minutes).
> It doesn't track the rack-by-rack progress of the main upgrade.
> To monitor the full upgrade, use the Cluster’s detailed status and detailed status message in the resource Overview, or query via `az networkcloud cluster show`.

Example `JSON View` output for the Cluster (Operator Nexus) resource:

```json
{
  "properties": {
    "actionStates": [
      {
        "correlationId": "aaaa0000-bb11-2222-33cc-444444dddddd",
        "status": "Completed",
        "actionType": "Microsoft.NetworkCloud/clusters/updateVersion",
        "endTime": "2025-08-01T03:46:13Z",
        "message": "Cluster upgrade to 4.6.0 successfully initiated - monitor progress via cluster detailed status",
        "startTime": "2025-08-01T03:42:08Z",
        "stepStates": [
          {
            "status": "Completed",
            "endTime": "2025-08-01T03:42:08Z",
            "message": "Cluster validation and version checks passed",
            "startTime": "2025-08-01T03:42:08Z",
            "stepName": "Validate Cluster conditions and upgrade versions"
          },
          {
            "status": "Completed",
            "endTime": "2025-08-01T03:46:11Z",
            "message": "Platform Runtime Extension deployment initiated",
            "startTime": "2025-08-01T03:42:39Z",
            "stepName": "Initiate Platform Runtime Extension update"
          },
          {
            "status": "Completed",
            "endTime": "2025-08-01T03:46:11Z",
            "message": "Platform Runtime Extension installation completed",
            "startTime": "2025-08-01T03:46:11Z",
            "stepName": "Monitor Platform Runtime Extension readiness"
          },
          {
            "status": "Completed",
            "endTime": "2025-08-01T03:46:13Z",
            "message": "Platform Cluster version updated successfully",
            "startTime": "2025-08-01T03:46:13Z",
            "stepName": "Update Platform Cluster version specification"
          }
        ]
      }
    ]
  }
}
```

When this command finishes, the full runtime upgrade process begins. This process can take several hours to complete, depending on the number of racks in the Cluster and the number of worker nodes in each rack.

- The upgrade first upgrades the control plane nodes, then management nodes and then sequentially rack by rack for the worker nodes.
- The management servers are segregated into two groups, which are upgraded separately. This approach allows for components running on the management servers to ensure resiliency during the runtime upgrade by applying affinity rules.
- The cloud service networks (CSNs) also use this functionality by placing one instance in each management group.
- There's no customer interaction with this functionality. However, there might be other labels seen on management nodes to identify the groups.

The upgrade is considered finished when the thresholds configured by the cluster's `updateStrategy` for worker node racks are met and at least 50% of management nodes in each group are successfully upgraded.
Workloads might be impacted while the worker nodes in a rack are being upgraded, but workloads in all other racks aren't impacted. Consideration of workload placement in light of this implementation design is encouraged.

Monitor progress by using the cluster's detailed status, available via the Azure portal or Azure CLI.

To view the upgrade status through the Azure CLI, use `az networkcloud cluster show`.

```azurecli
az networkcloud cluster show --cluster-name "<CLUSTER>" \
--resource-group "<CLUSTER_RG>" \
--subscription "<SUBSCRIPTION>"
```
The output includes the target Cluster's information along with its detailed status and detailed status message. For more detailed insights on upgrade progress, the individual nodes in each rack can be checked for status. An example is provided in the reference section under [BareMetal Machine roles](./reference-near-edge-baremetal-machine-roles.md).

To view the upgrade status through the Azure portal, go to the targeted cluster resource. In the cluster's _Overview_ screen, you can view the detailed status along with a detailed status message.

The cluster upgrade is in progress when `detailedStatus` is set to `Updating` and `detailedStatusMessage` shows the progress of the upgrade. Some examples of upgrade progress shown in `detailedStatusMessage` are `Waiting for control plane upgrade to complete...` and `Waiting for nodepool "<rack-id>" to finish upgrading...`.

The cluster upgrade is complete when `detailedStatus` is set to `Running` and `detailedStatusMessage` shows `Cluster is up and running`.

:::image type="content" source="./media/runtime-upgrade-cluster-detail-status.png" lightbox="./media/runtime-upgrade-cluster-detail-status.png" alt-text="Screenshot of Azure portal showing in progress Cluster upgrade.":::

The Cluster upgrade is paused when `detailedStatus` is set to `Updating` and `detailedStatusMessage` shows the reason or component that caused the upgrade to pause.

### Paused Cluster runtime upgrade

The upgrade pauses when any of the following happens:

1. All control plane machines can't be successfully upgraded and aren't provisioned and ready.
2. More than 50% of the machines in a management plane group can't be upgraded and aren't provisioned and ready. The management plane servers are broken into two groups on odd and even numbered racks.
3. Compute or worker node machines configured per threshold can't be upgraded and aren't provisioned and ready.

> [!NOTE]
> If a spare control plane exists, it is normal for the spare control plane to be in Power state `off`, Ready state `No`, Degraded `No`, Detailed status `Available` state. The cluster upgrade pauses only when the upgrade process determines that the conditions above can't be satisfied. A spare control plane being in an **Available** (not Ready) state doesn't itself cause the upgrade to pause.

Review the cluster's detailed status message to identify which component caused the upgrade to enter a paused state. The examples below show detailed status messages for each component.

**Control plane (KCP) failure detailed status message**

- "Cluster is deployed but the upgrade has been paused. Control plane upgrade failed as capiCluster \<clusterName\> is unhealthy. MachineHealthCheck may be swapping unhealthy KCP machines with Management Plane machines to restore quorum. Wait for remediation to complete, then run continue-update-version action to complete the upgrade."

**Compute or management plane group failure detailed status message**

- "Cluster is deployed but the upgrade has been paused. Machines in rack "\<rack-id\>" are unhealthy. Fix the machines and perform cluster continue-update-version action to finish the upgrade."

>[!NOTE]
> When a Control Plane machine fails to provision and the upgrade pauses, the machines might be autoremediated in the background. Check the `actionStates` of the affected control plane bare metal machines to see if autoremediation resolved the issue and brought the machines into a provisioned state. 

Once the affected component (control plane, management, or compute) is identified, do the following:

**Step 1: Check the status of individual bare metal machines for the affected component.**

An example is provided in the reference section under [BareMetal Machine roles](./reference-near-edge-baremetal-machine-roles.md).

After you identify the bare metal machines for the affected component, check the status of each machine and take the following actions based on its state.

| Bare metal machine detailed status | Node Ready | Details and mitigation                                                                                              |
|----------------------------------- |----------- | ------------------------------------------------------------------------------------------------------------------- |
| `Deprovisioning`                   | `No`       | [Review TSR logs]. And, follow the next steps to check action logs for the BMM                                      |
| `Available`                        | `No`       | If the BMM is a spare control plane machine, `Available` is the expected state. Otherwise, check action state logs. |
| `Provisioning`                     | `No`       | [Review TSR logs]. And, follow the next steps to check action logs for the BMM                                      |
| `Provisioned`                      | `No`       | Check cloud-init logs in Shoebox.                                                                                   |
| `Provisioned`                      | `Yes`      | This is the expected healthy state. Proceed to resuming the upgrade using cluster continue-update-version action    |

**Step 2: Check action state logs for the BMM.**

To check action state logs for a BMM, navigate to the BMM resource > **Operations** > **Action Log**.

| Action log details                                 | Mitigation                                                                                                      |
|--------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| No action log exists                               | Fix issues using [Bare Metal Machine Troubleshooting guide] guide.                                              |
| `machineHealthCheckRemediation` action in progress | Wait for the remediation to complete. If it fails, fix issues using [Bare Metal Machine Troubleshooting guide]. |
| `machineHealthCheckRemediation` action completed   | If the node is not ready, check cloud-init logs in Shoebox.                                                     |

Once the problem is resolved and the Baremetal machine is provisioned and ready, run the cluster `continue-update-version` action to resume and complete the upgrade.
```azurecli
az networkcloud cluster continue-update-version \
-g <CLUSTER_RG> \
-n <CLUSTER_NAME> \
--subscription <CUSTOMER_SUB_ID> \
--safeguard-mode <SAFEGUARD_MODE>
```

Optional parameters:
- `--safeguard-mode`: Specifies how safeguards are applied during the continue-update-version operation. Use `All` to run all preoperation validation checks. Use `None` to bypass safeguards that block the upgrade when they detect problems. The default value is `All`.

>[!IMPORTANT]
> The default safeguard mode `All` blocks the upgrade from resuming if validations determine that the upgrade can't be completed without fixing the detected problems. To learn more, see [Cluster Runtime Upgrade preflight validations](howto-cluster-runtime-upgrade-preflight-checks.md).

> [!IMPORTANT]
> Running `continue-update-version` before the worker node threshold is met (as configured in the cluster `updateStrategy`) returns the upgrade to a paused state. Always fix the affected machines first, and then run the `continue-update-version` action.

## Frequently Asked Questions

### Identifying Cluster Upgrade Stalled/Stuck

During a runtime upgrade, the cluster enters a paused state once the upgrade process determines that the upgrade can't proceed without manual intervention. However, the upgrade process might sometimes fail to move forward while the detailed status still reflects the upgrade as ongoing. **Because the runtime upgrade can take a very long time to successfully finish, there's no set timeout length currently specified.** Check your cluster's detailed status and logs periodically to determine if your upgrade is indefinitely attempting to upgrade.

You can identify an indefinitely stuck upgrade by looking at the cluster's logs, detailed message, and detailed status message. If this condition occurs, you observe the cluster continuously reconciling the same state without progressing. Check the cluster logs or configured Log Analytics Workspace (LAW) to see if there's a failure or a specific step causing the lack of progress.

### Identifying Bare Metal Machine Upgrade Stalled/Stuck

A guide for identifying issues with provisioning worker nodes is provided at [Troubleshooting Bare Metal Machine Provisioning](./troubleshoot-bare-metal-machine-provisioning.md).

### Hardware Failure doesn't require Upgrade re-execution

If a hardware failure during an upgrade occurs, the runtime upgrade continues as long as the set thresholds are met for the compute and management/control nodes. Once the machine is fixed or replaced, it gets provisioned with the current platform runtime's OS, which contains the targeted version of the runtime. If a rack was updated before a failure, then the upgraded runtime version would be used when the nodes are reprovisioned. If the rack's spec wasn't updated to the upgraded runtime version before the hardware failure, the machine provisions with the previous runtime version when the hardware is repaired. The machine is upgraded along with the rack when the rack starts its upgrade.

### After a runtime upgrade, the Cluster shows "Failed" Provisioning State

During a runtime upgrade, the Cluster enters a state of `Upgrading`. If the runtime upgrade fails, the Cluster goes into a `Failed` provisioning state. Infrastructure components (for example, the Storage Appliance) might cause failures during the upgrade. In some scenarios, it might be necessary to diagnose the failure with Microsoft support.

### Bare Metal Machine shows Degraded after Runtime Update

Certain situations can result in a node returning in a `Degraded` state. This state happens if any of the conditions found in [Troubleshoot Degraded Status Errors](./troubleshoot-bare-metal-machine-degraded.md) are met. Degraded status means the node is automatically cordoned to prevent new workloads from being scheduled on the node until the underlying problem is resolved.

[Review TSR logs]: ./troubleshoot-reboot-reimage-replace.md#collect-a-troubleshooting-report-tsr
[Bare Metal Machine Troubleshooting guide]: ./troubleshoot-bare-metal-machine-provisioning.md