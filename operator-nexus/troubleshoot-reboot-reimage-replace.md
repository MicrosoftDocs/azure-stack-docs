---
title: Troubleshoot Azure Operator Nexus server problems
description: Troubleshoot cluster bare metal machines with Restart, Reimage, Replace for Azure Operator Nexus.
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 02/11/2026
author: gregoberfield
ms.author: goberfield
---

# Troubleshoot Azure Operator Nexus Bare Metal Machine server problems

This article describes how to troubleshoot server problems by using Restart, Reimage, and Replace actions on Azure Operator Nexus Bare Metal Machines (BMMs). You might need to take these actions on your server for maintenance reasons, which might cause a brief disruption to specific BMMs.

The time required to complete each of these actions is similar. Restarting is the fastest, whereas replacing takes slightly longer. All three actions are simple and efficient methods for troubleshooting.

[!INCLUDE [caution-affect-cluster-integrity](./includes/baremetal-machines/caution-affect-cluster-integrity.md)]

## Prerequisites

- **Familiarize yourself with BMM capabilities**: Review [Bare Metal Machine Platform Commands](howto-baremetal-functions.md) for comprehensive details on each action, command parameters, and platform behavior. This troubleshooting guide focuses on workflows and scenarios; refer to the platform commands article for complete command reference.
- Gather the following information (necessary for all actions):
  - Name of the managed resource group for the BMM
  - Name of the BMM that requires a lifecycle management operation
  - Subscription ID
- Cluster Detailed status must be `Running`
- Cluster to Cluster Manager connectivity must be `Connected`

[!INCLUDE [important-donot-disrupt-kcpnodes](./includes/baremetal-machines/important-donot-disrupt-kcpnodes.md)]

> [!TIP]
> In version 2509.1 and above, you can monitor recent or in-progress BMM actions in the Azure portal. For more information, see [Monitor status in Bare Metal Machine JSON properties](./howto-bare-metal-best-practices.md#monitor-status-in-bare-metal-machine-json-properties).

## Identify the corrective action

When troubleshooting a BMM for failures and determining the most appropriate corrective action, it's essential to understand the available options. This article provides a systematic approach to troubleshoot Azure Operator Nexus server problems using these three methods:

- **Restart** - Least invasive method, best for temporary glitches or unresponsive Virtual Machines (VMs). Preserves OS and data.
- **Reimage** - Intermediate solution, restores OS to known-good state without hardware changes. Wipes OS disk but tenant data preserved.
- **Replace** - Most comprehensive action, required after hardware component repairs (RAM, disk, NIC, etc.). Includes hardware validation before provisioning. Use `--storage-policy="Preserve"` to retain tenant data.

> [!TIP]
> **Quick guidance**: If you're unsure which action to use, start with the **Troubleshooting decision tree** below, then refer to the **Workflow sections** for detailed pre-checks and execution steps.

### Troubleshooting decision tree

Follow this escalation path when troubleshooting BMM issues. Always start with the least disruptive action and escalate only if the problem persists:

| Problem                      | First action | If problem persists | If still unresolved |
| ---------------------------- | ------------ | ------------------- | ------------------- |
| Unresponsive VMs or services | [Restart](#troubleshoot-with-a-restart-action)      | [Reimage](#troubleshoot-with-a-reimage-action)             | [Replace](#troubleshoot-with-a-replace-action)             |
| Software/OS corruption       | [Reimage](#troubleshoot-with-a-reimage-action)      | [Replace](#troubleshoot-with-a-replace-action)             | Contact support     |
| Known hardware failure       | [Replace](#troubleshoot-with-a-replace-action)      | N/A                 | Contact support     |
| Security compromise          | [Reimage](#troubleshoot-with-a-reimage-action)      | [Replace](#troubleshoot-with-a-replace-action)             | Contact support     |
| BMM stuck in provisioning    | [Restart](#troubleshoot-with-a-restart-action)      | [Reimage](#troubleshoot-with-a-reimage-action)             | Contact support     |
| Physical hardware replaced   | [Replace](#troubleshoot-with-a-replace-action)      | N/A                 | Contact support     |

**Key principles:**
- Always validate that the issue is resolved after each corrective action
- Use pre-checks to identify VMs and NAKS nodes on the BMM before starting
- Use post-checks to verify BMM, VM, and NAKS node status after completion
- Consult [Hardware Component Replacement Guide](#hardware-component-replacement-guide) to determine if replace is required

## Troubleshoot with a restart action

Restarting a BMM is a process of restarting the server through a simple API call. This action can be useful for troubleshooting problems when Tenant VMs on the host aren't responsive or are otherwise stuck.

The restart typically is the starting point for mitigating a problem.

> [!TIP]
> For complete details on restart behavior, timeout values, and system coordination steps, see [Restart a Bare Metal Machine](howto-baremetal-functions.md#restart-a-bare-metal-machine).

### Restart workflow

Follow these steps to safely restart a BMM:

1. **Assess impact** - Determine if restarting the BMM impacts critical virtual machines or NAKS nodes
2. **Choose restart method**:
   - If BMM is running: Use `restart` command (coordinates shutdown and startup as single operation)
   - If BMM is powered off: Use `start` command
   - If you need manual control: Use `power-off` followed by `start`
3. **Execute restart** - Run the appropriate command
4. **Verify status** - Check BMM is back online and functioning properly using post-check commands

> [!NOTE]
> The restart operation is the fastest recovery method but might not resolve issues related to OS corruption or hardware failures. If the issue persists after restart, proceed to [Reimage](#troubleshoot-with-a-reimage-action).

**Example commands** (see [BMM Platform Commands](howto-baremetal-functions.md) for complete parameter details):

```azurecli
# Power off (if needed)
az networkcloud baremetalmachine power-off --name <bareMetalMachineName> --resource-group "<resourceGroup>" --subscription <subscriptionID>

# Start a powered-off BMM
az networkcloud baremetalmachine start --name <bareMetalMachineName> --resource-group "<resourceGroup>" --subscription <subscriptionID>

# Restart a running BMM
az networkcloud baremetalmachine restart --name <bareMetalMachineName> --resource-group "<resourceGroup>" --subscription <subscriptionID>
```
#### Infrastructure Post Check

**To verify the BMM status after restart:**

```azurecli
az networkcloud baremetalmachine show \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID> \
  --query "{name:name, provisioningState:provisioningState, powerState:powerState, readyState:readyState}" -o table
```

Expected result:
- `provisioningState`: `Succeeded`
- `powerState`: `On`
- `readyState`: `True`

If the BMM doesn't reach this state within the expected timeout (40 minutes), investigate using status and activity log information.

## Troubleshoot with a reimage action

Reimaging a BMM is a process that you use to redeploy the image on the OS disk, without affecting the tenant data. This action executes the steps to rejoin the cluster with the same identifiers.

The reimage action can be useful for troubleshooting problems by restoring the OS to a known-good working state. Common causes that can be resolved through reimaging include recovery due to doubt of host integrity, suspected or confirmed security compromise, or "break glass" write activity.

A reimage action is the best practice for lowest operational risk to ensure the integrity of the BMM.

> [!TIP]
> For complete details on reimage phases (deprovisioning, provisioning, cloud init) and timeout values, see [Reimage a Bare Metal Machine](howto-baremetal-functions.md#reimage-a-bare-metal-machine).

### Reimage workflow

Follow these steps to safely reimage a BMM:

1. **Verify running virtual machines and NAKS Nodes** - Identify what workloads are on the BMM using [pre-check commands](#infrastructure-pre-check)
2. **Assess impact** - Determine if VMs/NAKS nodes can tolerate downtime (running VMs will auto-restart after reimage)
3. **Cordon and evacuate** - Run `cordon --evacuate "True"` to gracefully drain workloads
4. **Perform reimage** - Execute the reimage operation (wipes OS disk, preserves tenant data)
5. **Monitor progress** - Reimage includes deprovisioning, provisioning, and cloud init phases (up to 3 hours)
6. **Uncordon** - Make the BMM schedulable again after reimage completes
7. **Verify status** - Use [post-check commands](#infrastructure-post-check) to confirm BMM, VMs, and NAKS nodes are healthy

> [!IMPORTANT]
> Running VMs will experience downtime during reimage but will automatically restart after completion. Stopped VMs remain stopped.

#### Infrastructure Pre Check

##### Step 1: Identify VMs and NAKS clusters on the BMM

```azurecli
az networkcloud baremetalmachine show -n <nodeName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionId> \
  --query "associatedResourceIds" -o json
```

Example output:

```json
[
  "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.NetworkCloud/virtualMachines/firewallvnf",
  "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.NetworkCloud/kubernetesClusters/naks-01"
]
```

Understanding the output:

- An empty array `[]` means no VMs or NAKS clusters are running on this BMM. You can proceed to the cordon step.
- If the array contains VM ARM resource IDs (`.../virtualMachines/...`), check the status of each VM before proceeding.
- If the array contains NAKS ARM resource IDs (`.../kubernetesClusters/...`), check the status of each NAKS cluster before proceeding.

Record the ARM IDs returned here so you can use the same IDs during the post-check.

> [!NOTE]
> How the system handles VMs during cordon/evacuate:
> - Running VMs are gracefully shut down and will be automatically restarted after reimage
> - Stopped VMs remain stopped after reimage (no automatic restart)
> - Provisioning/Error VMs - if stuck due to BMM issues, reimage should resolve the underlying problem

##### Step 2a: Review VMs on the BMM

Use the ARM ID from the previous output (for resources containing `/virtualMachines/`):

```azurecli
az networkcloud virtualmachine show \
  --ids "<VM_ARM_ID>" \
  --query "{name:name, detailedStatus:detailedStatus, powerState:powerState}" -o table
```

Example output (your VM may show `Running`, `Stopped`, `Provisioning`, or `Error`):

```
Name         DetailedStatus    PowerState
-----------  ----------------  ------------
firewallvnf  Running           On
```

| detailedStatus | What This Means |
|----------------|-----------------|
| `Running` | VM is active. Will be shut down and automatically restarted after reimage. |
| `Stopped` | VM is already stopped. Will remain stopped after reimage. |
| `Provisioning` | VM may be stuck due to BMM issues. Reimage should resolve this. |
| `Error` | VM is in a failed state. Reimage may resolve the underlying BMM issue. |

##### Step 2b: Review NAKS nodes on the BMM

Use the ARM ID from the previous output (for resources containing `/kubernetesClusters/`) to capture basic cluster context:

```azurecli
az networkcloud kubernetescluster show \
  --ids "<NAKS_ARM_ID>" \
  --query "{name:name, detailedStatus:detailedStatus}" -o table
```

To see which NAKS nodes are running on each BMM, run the following command against your NAKS cluster:

```bash
kubectl get nodes -o custom-columns="NODE:.metadata.name,BMM:.metadata.labels.topology\.kubernetes\.io/baremetalmachine"
```

Example output:

```
NODE                                    BMM
naks-01-agentpool1-md-tjr8k-4qqx4        rack1-compute01
naks-01-agentpool2-md-zzrw8-gg8rx        rack1-compute01
naks-01-agentpool2-md-zzrw8-lqrmt        rack1-compute02
naks-01-control-plane-rmwqr              rack1-compute02
```

Review the output and identify nodes where the `BMM` column matches the BMM you plan to reimage. In this example, if you're reimaging `rack1-compute01`, two nodes will be affected: `naks-01-agentpool1-md-tjr8k-4qqx4` and `naks-01-agentpool2-md-zzrw8-gg8rx`.

> [!NOTE]
> The cordon/evacuate operation does not check the NAKS cluster health status before attempting to drain:
> - If NAKS nodes exist on the BMM, the system will attempt to drain them regardless of cluster status
> - If nodes are unreachable (e.g., due to BMM failure), the drain operation will timeout after 5 minutes and proceed
> - Use the `kubectl` output above to identify which specific NAKS nodes are on this BMM

> [!IMPORTANT]
> Running VMs will experience downtime during the reimage process.

#### Reimage

**The following Azure CLI command will `cordon` the specified bareMetalMachineName.**

```azurecli
az networkcloud baremetalmachine cordon \
  --evacuate "True" \
  --name <bareMetalMachineName> \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID>
```

> [!NOTE]
> When you run `cordon --evacuate "True"`, the system automatically:
> - Cordons NAKS nodes running on this BMM (marks them unschedulable)
> - Drains NAKS nodes (evicts pods to other nodes)
> - Gracefully shuts down VMs
>
> This process may take up to 30 minutes.

**The following Azure CLI command will `reimage` the specified bareMetalMachineName.**

```azurecli
az networkcloud baremetalmachine reimage \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID>
```

**The following Azure CLI command will `uncordon` the specified bareMetalMachineName.**

```azurecli
az networkcloud baremetalmachine uncordon \
  --name <bareMetalMachineName> \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID>
```

#### Infrastructure Post Check

##### Step 1: Verify BMM status after `reimage`:

```azurecli

az networkcloud baremetalmachine show \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID> \
  --query "{name:name, provisioningState:provisioningState, powerState:powerState, readyState:readyState}" -o table
```

A `provisioningState` of `Succeeded` and `readyState` of `True` indicates the BMM has been provisioned and rejoined the cluster.

##### Step 2: Verify VM status

> [!NOTE]
> Only VMs that were `Running` before the reimage will be automatically restarted. VMs that were `Stopped` will remain stopped - start them manually if needed using `az networkcloud virtualmachine start`.

Check that VMs previously running on this BMM have restarted successfully:

```azurecli
az networkcloud virtualmachine show \
  --ids "<VM_ARM_ID>" \
  --query "{name:name, detailedStatus:detailedStatus, powerState:powerState}" -o table
```

| Expected Status | Description |
|-----------------|-------------|
| `detailedStatus: Running`, `powerState: On` | VM has successfully restarted. |
| `detailedStatus: Stopped`, `powerState: Off` | VM was stopped before reimage and remains stopped. Start it manually if needed. |
| `detailedStatus: Provisioning` | VM is still starting up. Wait and check again. |
| `detailedStatus: Error` | VM failed to restart. Investigate the error. |

##### Step 3: Verify NAKS node status

Validate node-level recovery (for example, that nodes are `Ready` and running on the expected BMMs) by running the following command against your NAKS cluster:

```bash
kubectl get nodes -o custom-columns="NODE:.metadata.name,READY:.status.conditions[?(@.type=='Ready')].status,BMM:.metadata.labels.topology\.kubernetes\.io/baremetalmachine"
```

## Troubleshoot with a Replace action

Servers contain many physical components that can fail over time. It's important to understand which physical repairs require BMM replacement and when BMM replacement is recommended. The Tenant data isn't modified during replacement as long as `storage-policy="Preserve"` flag is used.

A hardware validation process is invoked to ensure the integrity of the physical host in advance of deploying the OS image.

> [!TIP]
> For complete details on replace phases (hardware validation, deprovisioning, provisioning, cloud init), safeguard-mode parameter, and hardware validation examples, see [Replace a Bare Metal Machine](howto-baremetal-functions.md#replace-a-bare-metal-machine).

**Related articles:**
- [Hardware Validation Overview](concepts-hardware-validation-overview.md) - Overview of the hardware validation process
- [Troubleshoot Hardware Validation](troubleshoot-hardware-validation-failure.md) - Check and troubleshoot hardware validation results

> [!IMPORTANT]
> When run with default options, the RAID controller is reset during BMM replace, wiping all data from the server's virtual disks. Baseboard Management Controller (BMC) virtual disk alerts triggered during BMM replace can be ignored unless there are other physical disk and/or RAID controllers alerts. Starting with the `2025-07-01-preview` version of the NetworkCloud API, and generally available with the `2025-09-01` GA version, use `replace` with `storage-policy="Preserve"` to retain virtual disk data.

### Replace workflow

Follow these steps to safely replace a BMM after hardware repairs:

1. **Identify hardware replaced** - Determine which components were repaired (see [Hardware Component Replacement Guide](#hardware-component-replacement-guide))
2. **Assess data impact** - If storage components were replaced (SSD/PERC/System board/Backplane), VM data may be lost; migrate VMs before replace
3. **Check BMM health** - Determine if BMM is healthy or unresponsive using [pre-check commands](#infrastructure-pre-check-1)
4. **Cordon and evacuate** - If BMM is healthy, run `cordon --evacuate "True"`; if failed, skip to replace command
5. **Verify firmware** - Ensure all replaced components meet minimum firmware requirements
6. **Execute replace** - Run replace command with required parameters (includes hardware validation phase)
7. **Monitor progress** - Replace includes hardware validation, deprovisioning, provisioning, and cloud init phases (up to 4 hours)
8. **Uncordon** - Make the BMM schedulable again after replacement completes
9. **Verify status** - Use [post-check commands](#infrastructure-post-check-1) to confirm BMM, VMs, and NAKS nodes are healthy

> [!IMPORTANT]
> Hardware validation runs before provisioning to verify BMC connectivity, credentials, network links, and component health. If validation fails, the replace action is rejected with detailed error messages. See [Troubleshoot Hardware Validation](troubleshoot-hardware-validation-failure.md).

**Example cordon command** (see [Cordon](howto-baremetal-functions.md#make-a-bare-metal-machine-unschedulable-cordon) for complete details):

```azurecli
az networkcloud baremetalmachine cordon --evacuate "True" --name <bareMetalMachineName> --resource-group "<resourceGroup>" --subscription <subscriptionID>
```

> [!NOTE]
> If the BMM has already failed and is unresponsive, the `cordon --evacuate "True"` command may not complete successfully. In this case:
> - VMs on the failed BMM are already impacted
> - Stateless pods can typically reschedule to healthy nodes, but StatefulSet pods can remain stuck on `NotReady` nodes
> - Proceed directly to physical repair and the replace command

#### Infrastructure Pre Check

> [!NOTE]
> Replace is typically used when the BMM has failed or is unhealthy. If the machine is already unresponsive, the pre-check commands may not return accurate information, and VMs/NAKS nodes on that machine may already be impacted.

##### Step 1: Check BMM health status

```azurecli
az networkcloud baremetalmachine show -n <nodeName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionId> \
  --query "{name:name, powerState:powerState, readyState:readyState, detailedStatus:detailedStatus}" -o table
```

| BMM State | Pre-Check Action |
|-----------|------------------|
| BMM is healthy/running | Follow the same VM/NAKS pre-check steps as Reimage to understand what is running on the BMM. Run the replace action with `--safeguard-mode None`. No manual `cordon --evacuate "True"` is required. |
| BMM is unhealthy/unresponsive | Pre-check may not be possible. Proceed to assess VM/NAKS impact below. |

> [!NOTE]
> For a healthy BMM, when you run the replace action with `--safeguard-mode None`, the system automatically:
> - Cordons and drains NAKS nodes on the BMM
> - Gracefully shuts down VMs
> - Proceeds with the replace operation once evacuation completes

> [!IMPORTANT]
> If the BMM is unresponsive or unhealthy, evacuation may not be possible. VMs and NAKS nodes on that BMM may already be impacted.


##### Step 2: Identify VMs and NAKS clusters on the BMM

```azurecli
az networkcloud baremetalmachine show -n <nodeName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionId> \
  --query "associatedResourceIds" -o json
```

##### Step 3: Assess VM and NAKS impact based on hardware replaced

| Hardware Replaced | VM Impact | Recommendation |
|-------------------|-----------|----------------|
| SSD / PERC / System board / Backplane | VM data may be permanently lost. | Delete VMs and recreate them on a healthy BMM before running replace. |
| NIC | VM data is not affected. | Verify network configuration after replace. |
| CPU / DIMM / Fan | VM data is not affected. | No special action required. |

> [!NOTE]
> NAKS impact:
> - If BMM was healthy: System will gracefully drain NAKS nodes before the replace operation proceeds.
> - If BMM was unresponsive/unhealthy: NAKS nodes on that BMM are already impacted. The NAKS cluster will automatically reprovision nodes on healthy BMMs.

> [!WARNING]
> Replacing a single SSD is safe and does not impact VM OS disks because the RAID set tolerates single‑disk failures. However, if more than one SSD in the RAID group is replaced or fails before the array rebuilds, VM OS disks stored on those drives may be permanently lost.

##### Step 4: Optional verification (healthy BMM only)

> [!NOTE]
> Replace with `--safeguard-mode None` automatically evacuates workloads (VMs are shut down and NAKS nodes are drained) before deprovisioning. Expect downtime even when there is no permanent data loss.

Use the checks below to record a baseline of what is running on the BMM so you can compare results after replace.

If replacing storage components (SSD / PERC / System board / Backplane): VM data may be permanently lost. Delete affected VMs and recreate them on a healthy BMM before running replace. You can skip the VM status check for VMs you plan to recreate.

For VMs:

```azurecli
az networkcloud virtualmachine show \
  --ids "<VM_ARM_ID>" \
  --query "{name:name, detailedStatus:detailedStatus, powerState:powerState}" -o table
```

For NAKS clusters:

```azurecli
az networkcloud kubernetescluster show \
  --ids "<NAKS_ARM_ID>" \
  --query "{name:name, detailedStatus:detailedStatus}" -o table
```

Refer to the [Reimage Pre Check](#infrastructure-pre-check) section for detailed guidance on interpreting VM and NAKS status values.

### Hardware component replacement guide

When you're performing a physical hot swappable power supply repair, a replace action isn't required because the BMM host will continue to function normally after the repair.

When you're performing the following physical repairs, we recommend a replace action, though it isn't necessary to bring the BMM back into service:

- CPU
- Dual In-Line Memory Module (DIMM)
- Fan
- Expansion board riser
- Transceiver
- Ethernet or fiber cable replacement

When you're performing the following physical repairs, a replace action **_is required_** to bring the BMM back into service:

- Backplane
- System board
- SSD disk
- PERC/RAID adapter
- Mellanox Network Interface Card (NIC)
- Broadcom embedded NIC

After physical repairs are completed, verify that all firmware versions align with the versions supported for the corresponding runtime. Apply the same best-practice checks used during deployment to ensure the components meet the [minimum firmware requirements](/azure/operator-nexus/howto-platform-prerequisites#minimum-recommended-bios-and-firmware-versions-for-nexus-cluster-runtime).

Once the firmware checks are complete, proceed with the replace action.

**Example replace command** (see [Replace a Bare Metal Machine](howto-baremetal-functions.md#replace-a-bare-metal-machine) for all parameters and safeguard-mode details):

```azurecli
az networkcloud baremetalmachine replace \
  --name <bareMetalMachineName> \
  --resource-group "<resourceGroup>" \
  --bmc-credentials password=<IDRAC_PASSWORD> username=<IDRAC_USER> \
  --bmc-mac-address <IDRAC_MAC> \
  --boot-mac-address <PXE_MAC> \
  --machine-name <OS_HOSTNAME> \
  --serial-number <SERIAL_NUM> \
  --subscription <subscriptionID> \
  --storage-policy <STORAGE_POLICY>

# Uncordon to allow scheduling
az networkcloud baremetalmachine uncordon --name <bareMetalMachineName> --resource-group "<resourceGroup>" --subscription <subscriptionID>
```

#### Infrastructure Post Check

##### Step 1: Verify BMM status after `replace`:

```azurecli
az networkcloud baremetalmachine show \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID> \
  --query "{name:name, provisioningState:provisioningState, powerState:powerState, readyState:readyState}" -o table
```

A `provisioningState` of `Succeeded` and `readyState` of `True` indicates the BMM has been provisioned and rejoined the cluster.

##### Step 2: Verify VM status:

> [!NOTE]
> If SSD was replaced, the affected VM must be recreated on another healthy BMM before starting the replace action. Skip this step if you deleted the VM before BMM replace action and recreated it elsewhere.

Check that VMs previously running on this BMM have restarted successfully:

```azurecli
az networkcloud virtualmachine show \
  --ids "<VM_ARM_ID>" \
  --query "{name:name, detailedStatus:detailedStatus, powerState:powerState}" -o table
```

| Expected Status | Description |
|-----------------|-------------|
| `detailedStatus: Running`, `powerState: On` | VM has successfully restarted. |
| `detailedStatus: Provisioning` | VM is still starting up. Wait and check again. |
| `detailedStatus: Error` | VM failed to restart. Investigate the error. |

##### Step 3: Verify NAKS node status

Validate node-level recovery (for example, that nodes are `Ready` and running on the expected BMMs) by running the following command against your NAKS cluster:

```bash
kubectl get nodes -o custom-columns="NODE:.metadata.name,READY:.status.conditions[?(@.type=='Ready')].status,BMM:.metadata.labels.topology\.kubernetes\.io/baremetalmachine"
```


## Summary

Restarting, reimaging, and replacing are effective troubleshooting methods for addressing Azure Operator Nexus server problems. Here's a quick reference guide:

| Action      | When to use                          | Impact                           | Requirements                                               |
| ----------- | ------------------------------------ | -------------------------------- | ---------------------------------------------------------- |
| **Restart** | Temporary glitches, unresponsive VMs | Brief downtime                   | None, fastest option                                       |
| **Reimage** | OS corruption, security concerns     | Longer downtime, preserves tenant data  | Workload evacuation recommended                            |
| **Replace** | Hardware component failures          | Longest downtime, preserves tenant data with `--storage-policy="Preserve"` | Hardware component replacement, specific parameters needed |

### Best practices

- **Always follow the escalation path**: Start with restart, then reimage, then replace unless the issue clearly indicates otherwise.
- **Verify virtual machines and NAKS nodes before action**: Use the provided commands to identify running virtual machines and NAKS nodes before any disruptive action.
- **Cordon with evacuation**: When performing reimage or replace actions, always use `cordon` with `evacuate="True"`.
- **Never run multiple operations simultaneously**: Ensure one operation completes before starting another to prevent server issues.
- **Verify resolution**: After performing any action, verify the BMM status and that the original issue is resolved.

For comprehensive details on all BMM actions, including command parameters, timeout values, and platform behavior, see [Bare Metal Machine Platform Commands](howto-baremetal-functions.md).

If you still have questions, [contact support](https://portal.azure.com/?#blade/Microsoft_Azure_Support/HelpAndSupportBlade).
For more information about Support plans, see [Azure Support plans](https://azure.microsoft.com/support/plans/response/).
