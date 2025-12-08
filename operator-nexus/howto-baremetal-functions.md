---
title: "Azure Operator Nexus: Bare Metal Machine platform commands"
description: Learn how to manage bare metal machines (BMM).
author: matternst7258
ms.author: matthewernst
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 12/04/2025
ms.custom: template-how-to, devx-track-azurecli
---

# Bare Metal Machine Platform Commands

This article describes how to perform lifecycle management operations on Bare Metal Machines (BMM).
These steps should be used for troubleshooting purposes to recover from failures or when taking maintenance actions.

First, read the advice in the article [Best Practices for Bare Metal Machine Operations](./howto-bare-metal-best-practices.md) before proceeding with operations.

The bolded actions listed are considered disruptive (Power off, Restart, Reimage, Replace).
The Cordon action without the `evacuate` parameter isn't considered disruptive while Cordon with the `evacuate` parameter is considered disruptive.

- **Power off a Bare Metal Machine**
- Start a Bare Metal Machine
- **Restart a Bare Metal Machine**
- Make a Bare Metal Machine unschedulable (cordon without evacuate, doesn't drain the node)
- **Make a Bare Metal Machine unschedulable (cordon with evacuate, drains the node)**
- Make a Bare Metal Machine schedulable (uncordon)
- **Reimage a Bare Metal Machine**
- **Replace a Bare Metal Machine**

## Action comparison

The following table summarizes each action to help you select the appropriate operation for your scenario:

| Action    | Purpose                                         | Data Loss | Downtime | Hardware Change | Timeout     |
|-----------|-------------------------------------------------|-----------|----------|-----------------|-------------|
| Cordon    | Mark node unschedulable                         | None      | None     | No              | 10 minutes  |
| Uncordon  | Remove scheduling restriction                   | None      | None     | No              | 10 minutes  |
| Power off | Gracefully power down the machine               | None      | Yes      | No              | 40 minutes  |
| Start     | Power on a machine                              | None      | Recovery | No              | 30 minutes  |
| Restart   | Reboot the machine while preserving OS and data | None      | Minutes  | No              | 40 minutes  |
| Reimage   | Reinstall the OS image on existing hardware     | Full      | Hours    | No              | 3 hours     |
| Replace   | Swap physical hardware with new machine         | Full      | Hours    | Yes             | 4 hours     |

## Choose the right action

Use the following guidance to determine which action best fits your situation:

| Symptom                                              | Recommended Action |
|------------------------------------------------------|--------------------|
| Preparing node for maintenance                       | Cordon             |
| Resume scheduling after maintenance                  | Uncordon           |
| Machine needs to be offline for maintenance          | Power off          |
| Bring offline machine back online                    | Start              |
| Machine needs reboot                                 | Restart            |
| OS corrupted or software issues                      | Reimage            |
| Hardware failure detected and repaired               | Replace            |
| Need fresh OS installation                           | Reimage            |
| Replacing physical server                            | Replace            |
| System unresponsive due to temporary software issues | Restart            |
| Rolling maintenance across nodes                     | Cordon             |
| BMC credentials need manual rotation                 | Replace            |
| Firmware reconciliation needed                       | Replace            |

## Control plane node considerations

Control plane nodes require extra caution when performing lifecycle actions. The platform implements special handling for control plane nodes to maintain cluster quorum and availability:

- **One at a time**: The platform prevents multiple concurrent disruptive actions (restart, reimage, replace) on control plane nodes. If another control plane node is already undergoing a disruptive action, new requests are blocked until that action completes and the node rejoins the cluster.
- **Quorum safety**: The platform verifies that sufficient healthy control plane nodes remain before allowing disruptive operations. Actions may be rejected if proceeding would break cluster quorum.
- **Extended coordination**: Restart, reimage, and replace actions on control plane nodes include extra steps to safely remove and rejoin the node to the control plane.

## Action locking

Only one lifecycle action can run on a BMM at a time. If you attempt to start a new action while another is in progress, the request is rejected. Before starting a new action:

- Verify any previous action has completed by checking the BMM's `actionStates` in the Azure portal or via the API
- If an action appears stuck, investigate the root cause before attempting another action

[!INCLUDE [caution-affect-cluster-integrity](./includes/baremetal-machines/caution-affect-cluster-integrity.md)]

[!INCLUDE [important-donot-disrupt-kcpnodes](./includes/baremetal-machines/important-donot-disrupt-kcpnodes.md)]

> [!TIP]
> In version 2509.1 and above, you can monitor recent or in-progress BMM actions in the Azure portal. For more information, see [Monitor status in Bare Metal Machine JSON properties](./howto-bare-metal-best-practices.md#monitor-status-in-bare-metal-machine-json-properties).

[!INCLUDE [prerequisites-azure-cli-bare-metal-machine-actions](./includes/baremetal-machines/prerequisites-azure-cli-bare-metal-machine-actions.md)]

## Power off a Bare Metal Machine

The power-off action gracefully shuts down a bare metal machine, making it unavailable to the cluster while preserving its data. The machine remains in a powered-off state until explicitly started again. This action is useful for maintenance scenarios where the hardware needs to be offline but no reprovisioning is required.

> [!IMPORTANT]
> There are rare cases where running Nexus VMs fail to relaunch after BMM shutdown or restart. To prevent these cases, power off any virtual machines on the BMM before powering off or restarting the BMM. See the [`cordon`](#make-a-bare-metal-machine-unschedulable-cordon) command for instructions on finding the workloads running on a BMM.

Use the `power-off` command when the machine needs to be taken completely offline, such as for physical maintenance that requires the machine to be powered down or to reduce power consumption for unused capacity.

This command will `power-off` the specified `bareMetalMachineName`.

```azurecli
az networkcloud baremetalmachine power-off \
  --name <BareMetalMachineName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionID>
```

## Start a Bare Metal Machine

The start action powers on a bare metal machine that was previously powered off, bringing it back online and making it available to the cluster. This action is the inverse of the power-off action and restores the machine to an operational state without reinstalling the operating system or losing any data.

Use the `start` command when a powered-off machine needs to be brought back online, such as recovering from a power-off action or restoring capacity after maintenance.

> [!NOTE]
> After a start operation, if the machine was cordoned before being powered off, you may need to execute an [`uncordon`](#make-a-bare-metal-machine-schedulable-uncordon) command to allow workloads to be scheduled on the node.

This command will `start` the specified `bareMetalMachineName`.

```azurecli
az networkcloud baremetalmachine start \
  --name <BareMetalMachineName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionID>
```

## Restart a Bare Metal Machine

The restart action performs a controlled reboot of the bare metal machine. Unlike power-off followed by start, the restart action coordinates the shutdown and startup as a single operation, ensuring workloads are gracefully terminated and the machine rejoins the cluster after rebooting. The operating system and all data on the machine are preserved.

> [!IMPORTANT]
> There are rare cases where running Nexus VMs fail to relaunch after BMM shutdown or restart. To prevent these cases, power off any virtual machines on the BMM before powering off or restarting the BMM. See the [`cordon`](#make-a-bare-metal-machine-unschedulable-cordon) command for instructions on finding the workloads running on a BMM.

Use the `restart` command when the machine is unresponsive but hardware is healthy, a reboot is needed to apply configuration changes, or temporary software issues need to be cleared. The restart action is the least disruptive operation among those that cause downtime.

During a restart, the system:

1. Cordons the node to prevent new workload scheduling
1. Waits for workloads to gracefully terminate
1. Powers off the hardware
1. Powers on and waits for the node to rejoin the cluster

This command will `restart` the specified `bareMetalMachineName`.

```azurecli
az networkcloud baremetalmachine restart \
  --name <BareMetalMachineName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionID>
```

## Make a Bare Metal Machine unschedulable (cordon)

The cordon action marks a bare metal machine as unschedulable, preventing new workloads from being placed on the node. Unlike power-off or restart, the machine remains powered on and existing workloads continue running. This action is commonly used as a preparatory step before maintenance operations or to isolate a node for troubleshooting.

On the execution of the `cordon` command, Operator Nexus workloads aren't scheduled on the Bare Metal Machine when `cordon` is set.
Any attempt to create a workload on a `cordoned` Bare Metal Machine results in the workload being set to `pending` state.
Existing workloads continue to run on the Bare Metal Machine unless the workloads are drained.

Use cordon when:

- You need to prevent new workloads from scheduling on a node
- Performing rolling maintenance across multiple nodes
- Troubleshooting a node while keeping existing workloads running

> [!NOTE]
> The platform may automatically cordon nodes due to detected hardware issues such as port flapping, NIC failures, or LACP issues. When you execute an uncordon command, it clears both your cordon and any platform-applied cordons. However, if the node is still degraded due to an unresolved hardware issue, the uncordon is rejected.

### Drain Bare Metal Machine workloads

The cordon command supports the `evacuate` parameter, for which its default value `False` means that the `cordon` command prevents scheduling new workloads.
To drain workloads with the `cordon` command, the `evacuate` parameter must be set to `True`.
The workloads running on the Bare Metal Machine are `stopped` and the Bare Metal Machine is set to `pending` state.

> [!NOTE]
> Nexus Management Workloads continue to run on the Bare Metal Machine even when the server is cordoned and evacuated.

It's a best practice to set the `evacuate` value to `True` when attempting to do any maintenance operations on the Bare Metal server.
For more best practices to follow, read through [Best Practices for Bare Metal Machine Operations](./howto-bare-metal-best-practices.md).

```azurecli
az networkcloud baremetalmachine cordon \
  --evacuate "True" \
  --name <BareMetalMachineName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionID>
```

### To identify if any workloads are currently running on a Bare Metal Machine, run the following command

For Virtual Machines:

```azurecli
az networkcloud baremetalmachine show -n <nodeName> /
  --resource-group <resourceGroup> /
  --subscription <subscriptionID> | jq '.virtualMachinesAssociatedIds'
```

For Nexus Kubernetes cluster nodes: (Requires logging into the Nexus Kubernetes cluster)

```shell
kubectl get nodes <resourceName> -ojson |jq '.metadata.labels."topology.kubernetes.io/baremetalmachine"'
```

## Make a Bare Metal Machine schedulable (uncordon)

The uncordon action removes the scheduling restriction from a bare metal machine, allowing new workloads to be placed on the node. This action is the inverse of the cordon action and is typically performed after maintenance is complete. The uncordon action also clears any automatic cordons that the platform may have applied due to detected hardware issues.

All workloads in a `pending` state on the Bare Metal Machine are `restarted` when the Bare Metal Machine is `uncordoned`.

Use uncordon when:

- Maintenance is complete and the node should resume normal scheduling
- A hardware issue has been resolved and the auto-cordon should be cleared
- The node is ready to accept new workloads again

> [!NOTE]
> For compute nodes, if the node is degraded due to a hardware issue and was automatically cordoned by the platform, the uncordon action is rejected until the underlying hardware issue is resolved. The error message indicates the node is degraded and which condition is preventing uncordon. This protection prevents accidentally scheduling workloads on nodes with known hardware issues.

```azurecli
az networkcloud baremetalmachine uncordon \
  --name <BareMetalMachineName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionID>
```

## Reimage a Bare Metal Machine

The reimage action completely reinstalls the operating system on the bare metal machine, returning it to a clean state. The existing machine is deprovisioned, the disk is wiped, and a fresh OS image is deployed. After reimaging, the machine rejoins the cluster with the same identity (hostname, IP addresses) but with a freshly installed operating system. Use this action when software issues can't be resolved through a restart.

This process **redeploys** the runtime image on the target Bare Metal Machine and executes the steps to rejoin the cluster with the same identifiers.

Use reimage when:

- The OS has become corrupted or unstable
- A clean slate is needed without changing hardware
- Software configuration has drifted beyond recovery

During a reimage, the system progresses through the following phases:

1. **Deprovisioning**: Deletes the existing machine, triggering disk wipe and power-off
1. **Provisioning**: Creates a new machine with fresh OS image
1. **Cloud Init**: Waits for the reimaged machine to complete initialization and rejoin the cluster

> [!NOTE]
> Both reimage and replace result in a freshly provisioned machine, but they differ in key ways. Reimage reinstalls the OS on the same hardware, while replace swaps the physical hardware entirely. Use reimage for software-related issues and replace for hardware failures.

As a best practice, ensure the Bare Metal Machine's workloads are drained using the [`cordon`](#make-a-bare-metal-machine-unschedulable-cordon) command, with `evacuate` set to `True`, before executing the `reimage` command.
For more best practices to follow, read through [Best Practices for Bare Metal Machine Operations](./howto-bare-metal-best-practices.md).

> [!IMPORTANT]
> Avoid write or edit actions performed on the node via Bare Metal Machine access.
> The `reimage` action is required to restore Microsoft support and any changes done to the Bare Metal Machine are lost while restoring the node to it's expected state.

[!INCLUDE [warning-do-not-run-multiple-actions](./includes/baremetal-machines/warning-do-not-run-multiple-actions.md)]

```azurecli
az networkcloud baremetalmachine reimage \
  --name <BareMetalMachineName> \
  --resource-group <resourceGroup> \
  --subscription <subscriptionID>
```

## Replace a Bare Metal Machine

The replace action integrates new or repaired physical hardware into the cluster. Before provisioning the new hardware, the system validates that the replacement hardware meets requirements by testing BMC connectivity, verifying credentials, and checking network links. After validation passes, the old machine is deprovisioned and the replacement hardware is provisioned with a fresh OS image. The machine then rejoins the cluster with the same logical identity.

After replacing components such as motherboard or Network Interface Card (NIC), the MAC address of Bare Metal Machine changes; however, the iDRAC IP address and hostname remain the same.
A `replace` **must** be executed after each hardware maintenance operation, read through [Best practices for a Bare Metal Machine replace](./howto-bare-metal-best-practices.md#best-practices-for-a-bare-metal-machine-replace) for more details.

Use replace when:

- Hardware has failed (disk, memory, CPU, NIC)
- Physical maintenance requires swapping the chassis
- BMC credentials need to be updated along with hardware
- Hardware components replaced and need firmware reconciled with platform

During a replace operation, the system progresses through the following phases:

1. **Hardware Validation**: Validates replacement hardware meets requirements (BMC credentials, serial number, MAC addresses)
1. **Deprovisioning**: Removes the old machine from cluster control and deletes associated resources
1. **Provisioning**: Registers, inspects, and provisions the replacement hardware
1. **Cloud Init**: Waits for the replacement machine to join the cluster and become ready

As of the 2506.2 release, the password value for iDRAC can be provided as a Key Vault Uniform Resource Identifier (URI) or password value. See [Key Vault Credential Reference](reference-key-vault-credential.md). Using a URI instead of a plaintext password provides extra security.

[!INCLUDE [warning-do-not-run-multiple-actions](./includes/baremetal-machines/warning-do-not-run-multiple-actions.md)]

```azurecli
az networkcloud baremetalmachine replace \
  --name <BareMetalMachineName> \
  --resource-group <resourceGroup> \
  --bmc-credentials password=<PASSWORD_URI or IDRAC_PASSWORD> username=<IDRAC_USER> \
  --bmc-mac-address <IDRAC_MAC> \
  --boot-mac-address <PXE_MAC> \
  --machine-name <OS_HOSTNAME> \
  --serial-number <SERIAL_NUMBER> \
  --subscription <subscriptionID> \
  --safeguard-mode <"All" or "None">
```

> [!IMPORTANT]
> For replace actions made using API version `2025-07-01-preview` and later: by default the replace action uses a safeguard that prevents replacing a healthy machine (powered on, ready, provisioned, joined to cluster) to avoid unnecessary disruptive operations. If a `replace` is attempted while the machine is healthy the action is rejected with the following response:
>
> ```
> (action rejected) cannot replace healthy machine (powered on, ready, provisioned, joined to cluster). Use --safeguard-mode None to override
> Code: action rejected
> Message: cannot replace healthy machine (powered on, ready, provisioned, joined to cluster). Use --safeguard-mode None to override
> ```
>
> To override the safeguard, specify `--safeguard-mode None`:

If the `replace` action fails due to a hardware validation failure, the specific error or test failure is shown in the `replace` response, as shown in the following examples.
This information can also be found in the Activity Log for the Bare Metal Machine (Operator Nexus).
The error code and error message are also included in the JSON properties of the corresponding `BareMetalMachines_Replace` operation.

### Example 1: Hardware validation fails due to invalid Key Vault URI for Baseboard Management Controller (BMC) credentials

```shell
$ az networkcloud baremetalmachine replace --name rack1compute02 --resource-group hostedRG --bmc-credentials password=$KEY_VAULT_URI username=root --bmc-mac-address 00-00-5E-00-01-00 --boot-mac-address 00-00-5E-00-02-00 --machine-name RACK1COMPUTE02 --serial-number SN123435
(failed to retrieve password from key vault) failed to get secret value from key vault: failed to get cluster key vault secret
Code: failed to retrieve password from key vault
Message: failed to retrieve password from key vault
Response: 400 Bad Request
```

### Example 2: Hardware validation fails due to invalid Baseboard Management Controller (BMC) credentials provided

```shell
$ az networkcloud baremetalmachine replace --name rack1compute02 --resource-group hostedRG --bmc-credentials password=REDACTED username=root --bmc-mac-address 00-00-5E-00-01-00 --boot-mac-address 00-00-5E-00-02-00 --machine-name RACK1COMPUTE02 --serial-number SN123435
(None) BMC login unsuccessful: Fail - Unauthorized; System health test(s) failed: [Additional logs: Server power down at end of test failed with: Unauthorized]
Code: None
Message: BMC login unsuccessful: Fail - Unauthorized; System health test(s) failed: [Additional logs: Server power down at end of test failed with: Unauthorized]
```

> [!NOTE]
> When hardware validation fails due to BMC credential authentication issues (Unauthorized), the action is rejected but the Bare Metal Machine isn't marked as failed or put into an error state. The Bare Metal Machine maintains its current operational status while the hardware validation reports the credential authentication failure.

### Example 3: Hardware validation fails due to networking failure

```shell
$ az networkcloud baremetalmachine replace --name rack1compute02 --resource-group hostedRG --bmc-credentials password=REDACTED username=root --bmc-mac-address 00-00-5E-00-01-00 --boot-mac-address 00-00-5E-00-02-00 --machine-name RACK1COMPUTE02 --serial-number SN123435
(None) Networking test(s) failed: [NIC.Slot.6-1-1_LinkStatus] expected: up; observed: Down; [Additional logs: Link failure detected on NIC.Slot.6-1-1; Unable to perform cabling check on PCI Slot 6]
Code: None
Message: Networking test(s) failed: [NIC.Slot.6-1-1_LinkStatus] expected: up; observed: Down; [Additional logs: Link failure detected on NIC.Slot.6-1-1; Unable to perform cabling check on PCI Slot 6]
```

For more information about troubleshooting hardware validation failures, see [Troubleshoot Hardware Validation Failure](./troubleshoot-hardware-validation-failure.md).
