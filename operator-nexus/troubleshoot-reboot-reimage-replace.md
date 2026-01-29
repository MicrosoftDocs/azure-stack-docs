---
title: Troubleshoot Azure Operator Nexus server problems
description: Troubleshoot cluster bare metal machines with Restart, Reimage, Replace for Azure Operator Nexus.
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 01/23/2026
author: gregoberfield
ms.author: goberfield
---

# Troubleshoot Azure Operator Nexus Bare Metal Machine server problems

This article describes how to troubleshoot server problems by using Restart, Reimage, and Replace actions on Azure Operator Nexus Bare Metal Machines (BMMs). You might need to take these actions on your server for maintenance reasons, which might cause a brief disruption to specific BMMs.

The time required to complete each of these actions is similar. Restarting is the fastest, whereas replacing takes slightly longer. All three actions are simple and efficient methods for troubleshooting.

> [!CAUTION]
> Don't perform any action against management servers without first consulting with Microsoft support personnel. Doing so could affect the integrity of the Operator Nexus Cluster.

## Prerequisites

- Familiarize yourself with the capabilities referenced in this article by reviewing the [BMM actions](howto-baremetal-functions.md).
- Gather the following information (necessary for all actions):
  - Name of the managed resource group for the BMM
  - Name of the BMM that requires a lifecycle management operation
  - Subscription ID
- Cluster Detailed status must be `Running`
- Cluster to Cluster Manager connectivity must be `Connected`

> [!IMPORTANT]
> Disruptive commands to a Kubernetes Control Plane (KCP) node are rejected if another disruptive action is already in progress on any KCP node or if the full KCP is unavailable.
>
> Restart, reimage and replace are all considered disruptive actions.
>
> This check is done to maintain the integrity of the Nexus instance and ensure multiple KCP nodes don't go down at once due to simultaneous disruptive actions. If multiple nodes go down, it breaks the healthy quorum threshold of the Kubernetes Control Plane.

> [!TIP]
> In version 2509.1 and above, you can monitor recent or in-progress BMM actions in the Azure portal. For more information, see [Monitor status in Bare Metal Machine JSON properties](./howto-bare-metal-best-practices.md#monitor-status-in-bare-metal-machine-json-properties).

## Identify the corrective action

When troubleshooting a BMM for failures and determining the most appropriate corrective action, it's essential to understand the available options. This article provides a systematic approach to troubleshoot Azure Operator Nexus server problems using these three methods:

- **Restart** - Least invasive method, best for temporary glitches, or unresponsive Virtual Machines (VM)s
- **Reimage** - Intermediate solution, restores OS to known-good state without affecting data
- **Replace** - Most significant action, required for hardware component failures such as RAM, hard disk, etc.  Replace action should be used after the BMM components have been replaced.

### Troubleshooting decision tree

Follow this escalation path when troubleshooting BMM issues:

| Problem                      | First action | If problem persists | If still unresolved |
| ---------------------------- | ------------ | ------------------- | ------------------- |
| Unresponsive VMs or services | [Restart](#troubleshoot-with-a-restart-action)      | [Reimage](#troubleshoot-with-a-reimage-action)             | [Replace](#troubleshoot-with-a-replace-action)             |
| Software/OS corruption       | [Reimage](#troubleshoot-with-a-reimage-action)      | [Replace](#troubleshoot-with-a-replace-action)             | Contact support     |
| Known hardware failure       | [Replace](#troubleshoot-with-a-replace-action)      | N/A                 | Contact support     |
| Security compromise          | [Reimage](#troubleshoot-with-a-reimage-action)      | [Replace](#troubleshoot-with-a-replace-action)             | Contact support     |

The recommended approach is to start with the least invasive solution (restart) and escalate to more complex measures only if necessary. Always validate that the issue is resolved after each corrective action.

## Troubleshoot with a restart action

Restarting a BMM is a process of restarting the server through a simple API call. This action can be useful for troubleshooting problems when Tenant VMs on the host aren't responsive or are otherwise stuck.

The restart typically is the starting point for mitigating a problem.

### Restart workflow

1. **Assess impact** - Determine if restarting the BMM impacts critical virtual machines or NAKS nodes.
2. **Power off** - If needed, power off the BMM (optional).
3. **Start or restart** - Either start a powered-off BMM or restart a running BMM.
4. **Verify status** - Check if the BMM is back online and functioning properly.

> [!NOTE]
> The restart operation is the fastest recovery method but might not resolve issues related to OS corruption or hardware failures.

**The following Azure CLI command will `power-off` the specified bareMetalMachineName:**

```azurecli
az networkcloud baremetalmachine power-off \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID>
```

**The following Azure CLI command will `start` the specified bareMetalMachineName:**

```azurecli
az networkcloud baremetalmachine start \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID>
```

**The following Azure CLI command will `restart` the specified bareMetalMachineName:**

```azurecli
az networkcloud baremetalmachine restart \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID>
```
#### Infrastructure Post Check

**To verify the BMM status after restart:**

```azurecli
az networkcloud baremetalmachine show \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID> \
  --query "provisioningState"
```

A result of `Succeeded` will show the command has completed.

## Troubleshoot with a reimage action

Reimaging a BMM is a process that you use to redeploy the image on the OS disk, without affecting the tenant data. This action executes the steps to rejoin the cluster with the same identifiers.

The reimage action can be useful for troubleshooting problems by restoring the OS to a known-good working state. Common causes that can be resolved through reimaging include recovery due to doubt of host integrity, suspected or confirmed security compromise, or "break glass" write activity.

A reimage action is the best practice for lowest operational risk to ensure the integrity of the BMM.

### Reimage workflow

1. **Verify running virtual machines and NAKS Nodes** - Before reimaging, check what VMs and NAKS nodes are running on the BMM.
2. **Perform reimage** - Execute the reimage operation.
3. **Uncordon** - Make the BMM schedulable again after reimage completes.

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
| `Error` | VM is in a failed state. Reimage should resolve the underlying BMM issue. |

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
> - Unenrolls the BMM from Azure Arc
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

This article provides an overview of the hardware validation process [Hardware Validation Overview](concepts-hardware-validation-overview.md)

This article provides instructions on how to check and troubleshoot hardware validation results [Troubleshoot Hardware Validation](troubleshoot-hardware-validation-failure.md)

> [!IMPORTANT]
> When run with default options, the RAID controller is reset during BMM replace, wiping all data from the server's virtual disks. Baseboard Management Controller (BMC) virtual disk alerts triggered during BMM replace can be ignored unless there are other physical disk and/or RAID controllers alerts. Starting with the `2025-07-01-preview` version of the NetworkCloud API, and generally available with the `2025-09-01` GA version, use `replace` with `storage-policy="Preserve"` to retain virtual disk data.

### Replace workflow

1. **Cordon and evacuate** - Remove virtual machines and NAKS nodes from the BMM before physical repair.
2. **Perform physical repairs** - Replace hardware components as needed.
3. **Execute replace command** - Run the replace command with required parameters.
4. **Uncordon** - Make the BMM schedulable again after replacement completes.
5. **Verify status** - Check that the BMM is properly functioning.[MM1.1][DR1.2]

**The following Azure CLI command will `cordon` the specified bareMetalMachineName.**

```azurecli
az networkcloud baremetalmachine cordon \
  --evacuate "True" \
  --name <bareMetalMachineName> \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID>
```

> [!NOTE]
> If the BMM has already failed and is unresponsive, the `cordon --evacuate "True"` command may not complete successfully. In this case:

> - VMs on the failed BMM are already impacted
> - Stateless pods can typically reschedule to healthy nodes, but StatefulSet pods can remain stuck on `NotReady` nodes[NA2.1][DR2.2][DR2.3]
> - Proceed directly to physical repair and the replace command

#### Infrastructure Pre Check

> [!NOTE]
> Replace is typically used when the BMM has failed or is unhealthy. If the machine is already dead, the pre-check commands may not return accurate information, and VMs/NAKS nodes on that machine may already be impacted.

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
| BMM is unhealthy/dead | Pre-check may not be possible. Proceed to assess VM/NAKS impact below. |

> [!NOTE]
> For a healthy BMM, when you run the replace action with `--safeguard-mode None`, the system automatically:

> - Cordons and drains NAKS nodes on the BMM
> - Gracefully shuts down VMs
> - Proceeds with the replace operation once evacuation completes

> [!IMPORTANT]
> If the BMM is dead or unhealthy, evacuation may not be possible. VMs and NAKS nodes on that BMM may already be impacted.


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
> - If BMM was dead/unhealthy: NAKS nodes on that BMM are already impacted. The NAKS cluster will automatically reprovision nodes on healthy BMMs.[DR3.1][AB3.2][DR3.3]

> [!WARNING]
> If SSD was replaced: All VM OS disks stored on that SSD are permanently lost. Delete the affected VM and recreate it on another healthy BMM (if you have capacity) before starting the replace action. Ensure you have VM configurations backed up or documented.

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

**The following Azure CLI command will `replace` the specified bareMetalMachineName.**

```azurecli
az networkcloud baremetalmachine replace \
  --name <bareMetalMachineName>  \
  --resource-group "<resourceGroup>" \
  --bmc-credentials password=<IDRAC_PASSWORD> username=<IDRAC_USER> \
  --bmc-mac-address <IDRAC_MAC> \
  --boot-mac-address <PXE_MAC> \
  --machine-name <OS_HOSTNAME> \
  --serial-number <SERIAL_NUM> \
  --subscription <subscriptionID> \
  --storage-policy <STORAGE_POLICY>
```

**The following Azure CLI command will uncordon the specified bareMetalMachineName.**

```azurecli
az networkcloud baremetalmachine uncordon \
  --name <bareMetalMachineName> \
  --resource-group "<resourceGroup>" \
  --subscription <subscriptionID>
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
| **Reimage** | OS corruption, security concerns     | Longer downtime, preserves data  | Workload evacuation recommended                            |
| **Replace** | Hardware component failures          | Longest downtime, data in virtual disks is not preserved and VM may be unable to boot | Hardware component replacement, specific parameters needed |

### Best practices

- **Always follow the escalation path**: Start with restart, then reimage, then replace unless the issue clearly indicates otherwise.
- **Verify virtual machines and NAKS nodes before action**: Use the provided commands to identify running virtual machines and NAKS nodes before any disruptive action.
- **Cordon with evacuation**: When performing reimage or replace actions, always use `cordon` with `evacuate="True"`.
- **Never run multiple operations simultaneously**: Ensure one operation completes before starting another to prevent server issues.
- **Verify resolution**: After performing any action, verify the BMM status and that the original issue is resolved.

More details about the BMM actions can be found in the [BMM actions](howto-baremetal-functions.md) article.

If you still have questions, [contact support](https://portal.azure.com/?#blade/Microsoft_Azure_Support/HelpAndSupportBlade).
For more information about Support plans, see [Azure Support plans](https://azure.microsoft.com/support/plans/response/).
