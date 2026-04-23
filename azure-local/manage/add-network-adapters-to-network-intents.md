---
title: Add NICs to an existing Network ATC intent on Azure Local
description: Learn how to add new physical network adapters to an existing Network ATC intent on an Azure Local instance.
author: ronmiab
ms.author: cedward
ms.topic: how-to
ms.reviewer: shisab
ms.date: 04/23/2026
ms.subservice: hyperconverged
---

# Add NICs to an existing Network ATC intent

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article shows you how to add new physical network adapters (NICs) to an existing Network ATC intent on an Azure Local instance. Use this procedure to expand an intent for more bandwidth, better redundancy, or to match new hardware standards in your cluster.

For the related repair workflow, see [Replace a failed NIC in an existing Network ATC intent](replace-network-adapter-to-network-intents.md).

## Key principle

Network ATC owns all host networking configuration. Make all adapter changes with the `Update-NetIntentAdapter` cmdlet. Don't change vSwitch, VMSwitch, or team configurations outside Network ATC.

## Critical warning: SDN-enabled environments and the virtual switch

> [!WARNING]
> **Don't remove or recreate the vSwitch when SDN is enabled.**
>
> When your Azure Local instance has Software Defined Networking (SDN) enabled, Virtual Filtering Platform (VFP) extensions attach to the Hyper-V Virtual Switch (vSwitch). Each vSwitch has a unique vSwitch ID.
>
> If you remove and recreate the vSwitch (for example, by running `Remove-VMSwitch`), the new vSwitch gets a new ID. This breaks SDN because:
>
> - The SDN Network Controller still uses the original vSwitch ID.
> - VFP policies (load balancing rules, access control lists (ACLs), virtual network policies) bind to the original ID.
> - A new ID prevents the Network Controller from applying policies to the switch.
> - All SDN-managed workloads (virtual networks, load balancers, gateways) stop working.
>
> In an SDN-enabled environment, never run `Remove-VMSwitch` or any command that destroys the vSwitch.

> [!NOTE]
> `Remove-NetIntent` removes the intent definition but doesn't touch the vSwitch or its settings. However, without an intent, Network ATC no longer reconciles configuration drift. Use `Update-NetIntentAdapter` to change adapter membership inside the existing intent instead of removing and recreating it.

## Check if SDN is enabled on your cluster

Check SDN status before you change any NICs. If SDN is active, take extra care to preserve the vSwitch.

On Azure Local, SDN is active when the VFP extension is enabled on the Hyper-V Virtual Switch. The following command checks for this directly:

```powershell
# Check if SDN is enabled by querying for the VFP extension specifically
$vfp = Get-VMSwitch | Get-VMSwitchExtension -Name "Microsoft Azure VFP Switch Extension" -ErrorAction SilentlyContinue

if ($vfp -and $vfp.Enabled) {
    Write-Host "SDN IS ENABLED - VFP extension is active. The vSwitch MUST be preserved." -ForegroundColor Red
    Write-Host "vSwitch Name : $($vfp.SwitchName)" -ForegroundColor Yellow
    Write-Host "Extension ID : $($vfp.Id)" -ForegroundColor Yellow
} else {
    Write-Host "SDN is NOT enabled (VFP extension not found or not active)." -ForegroundColor Green
}
```

> [!IMPORTANT]
> When the VFP extension is enabled on the vSwitch, SDN is active. Don't remove or recreate the vSwitch (`Remove-VMSwitch`) for any reason.

## When to add NICs to an intent

Add more physical network adapters to an existing Network ATC intent when you need to:

- Increase bandwidth (for example, add a second 25 GbE port).
- Improve redundancy (for example, move from a single NIC to a teamed pair).
- Match updated hardware standards across the cluster.

## Prerequisites

Complete all of the following before you begin:

| # | Prerequisite | How to verify |
|---|---|---|
| 1 | Install the new NICs and confirm the operating system sees them on all cluster nodes. | Run `Get-NetAdapter` on each node and confirm the new adapter appears. |
| 2 | Install matching driver and firmware versions on every node. | `Get-NetAdapter \| Select Name, DriverVersion` on each node. |
| 3 | Use the **identical hardware model** as the existing adapters in the intent (same manufacturer, model, speed, and Remote Direct Memory Access (RDMA) type). An intent doesn't support mixed NIC models. | `Get-NetAdapter \| Select Name, InterfaceDescription, DriverVersion`; compare with existing adapters. |
| 4 | Know the exact adapter names on each node. Names must match across nodes for the same intent. | `Get-NetAdapter \| Select Name, InterfaceDescription`. |
| 5 | Know the intent name to modify. | `Get-NetIntent \| Select Name, NetAdapterName`. |
| 6 | Check SDN status. | See [Check if SDN is enabled on your cluster](#check-if-sdn-is-enabled-on-your-cluster). |
| 7 | Schedule a maintenance window and notify the operations team. | Coordinate the change window with stakeholders. |
| 8 | Confirm cluster health. | `Get-ClusterNode` (all nodes Up); `Get-ClusterGroup` (no failed critical resources). |

> [!IMPORTANT]
> **Hardware model requirement.** Every NIC in the same Network ATC intent must be the same hardware model (same manufacturer, model number, speed, and RDMA type). Network ATC expects every member of an intent to have the same capabilities. A mixed-model intent (for example, Intel X710 with Mellanox ConnectX-5) fails to converge or behaves unpredictably.

## Step-by-step procedure

This procedure has two phases:

- **Phase A** installs the physical NICs on each node, one node at a time.
- **Phase B** updates the Network ATC intent across the cluster after all nodes have the new hardware.

### Phase overview

**Phase A — Rolling hardware installation** (repeat for each node, one at a time):

1. Record current state.
1. Suspend (drain) the cluster node.
1. Install the new physical NICs.
1. Check NIC visibility, naming, and drivers.
1. Resume the cluster node.
1. Repeat steps 2–5 for the next node.

**Phase B — Intent update** (run once, after all nodes have the new hardware):

1. (Optional) Stop Network ATC on non-target nodes for a controlled rollout.
1. Update the Network ATC intent to include the new adapters.
1. Wait for convergence (and roll out to remaining nodes if controlled).
1. Validate.

### Phase A: Rolling hardware installation (per node)

Run the following steps on each cluster node, one at a time. Wait until the current node is fully resumed and healthy before you start the next node.

#### Step 1: Record current cluster and intent state

Document the current state for rollback reference before you make any changes. Run this step once, before you start the first node.

```powershell
# Record intent configuration
Get-NetIntent | Format-List IntentName, NetAdapterNamesAsList, IntentType

# Record current cluster node states
Get-ClusterNode | Format-Table Name, State -AutoSize

# Record current adapter list on each node (run on each node or by using Invoke-Command)
Get-NetAdapter | Format-Table Name, Status, LinkSpeed, InterfaceDescription -AutoSize
```

:::image type="content" source="media/add-network-adapters-to-network-intents/add-before-current-state.png" alt-text="Diagram showing the cluster state before adding new NICs, with the existing Management and Compute intent and Storage intent." lightbox="media/add-network-adapters-to-network-intents/add-before-current-state.png":::

#### Step 2: Suspend (drain) the cluster node

Suspend the target node to move all clustered roles (virtual machines (VMs), cluster groups) to other nodes before you do any hardware work.

```powershell
# Replace with the actual node name being modified
$nodeName = "Node01"

# Suspend the node - drains all roles to other cluster members
Suspend-ClusterNode -Name $nodeName -Drain -Wait

# Verify the node is now Paused
Get-ClusterNode -Name $nodeName | Select-Object Name, State
# Expected: State = Paused
```

> [!NOTE]
> **Why suspend before hardware installation?** NIC installation might require you to power down the server, depending on whether your hardware supports hot-plug Peripheral Component Interconnect Express (PCIe). Even with hot-plug support, suspending (draining) the node:
>
> - Live-migrates all VMs and cluster roles to other healthy nodes first.
> - Protects workloads if you power down or reboot the node.
> - Marks the node as in maintenance for Storage Spaces Direct (S2D).
>
> The `-Drain` flag moves all roles. The `-Wait` flag blocks until the drain finishes.

#### Step 3: Install the new physical NICs

With the node suspended (and powered down if your hardware vendor requires it), install the new network adapters.

- Seat the adapter in its PCIe slot and check the cabling.
- If you powered the server down, power it back up and wait for it to rejoin the cluster.

:::image type="content" source="media/add-network-adapters-to-network-intents/add-phase-a-rolling-install.png" alt-text="Diagram showing the per-node rolling install in Phase A, with one node paused for hardware installation while other nodes remain Up." lightbox="media/add-network-adapters-to-network-intents/add-phase-a-rolling-install.png":::

#### Step 4: Verify the new NIC is visible and properly configured

After the node comes back online, check the NIC before you resume it:

```powershell
# Confirm the new NIC is present and link is up
Get-NetAdapter | Format-Table Name, Status, LinkSpeed, InterfaceDescription -AutoSize

# Verify the adapter name matches what you will use in the intent
# Names MUST be consistent across all nodes for the same intent

# Confirm RDMA capability if the intent requires RDMA
Get-NetAdapterRdma | Format-Table Name, Enabled -AutoSize

# Confirm driver version matches other nodes
Get-NetAdapter | Select-Object Name, DriverVersion, InterfaceDescription
```

> [!IMPORTANT]
> **Adapter naming.** The new NIC name must match across all cluster nodes. If the operating system assigns a name like `Ethernet 5` but you need `Ethernet3`, rename it now:
>
> ```powershell
> Rename-NetAdapter -Name 'Ethernet 5' -NewName 'Ethernet3'
> ```
>
> Do this on each node as you go, so every node uses the same name for the same adapter.

#### Step 5: Resume the cluster node

After you verify the NIC, resume the node to bring it back into the active cluster.

```powershell
# Resume the node
$nodeName = "Node01"
Resume-ClusterNode -Name $nodeName -Failback Immediate

# Verify the node is back to Up state
Get-ClusterNode -Name $nodeName | Select-Object Name, State
# Expected: State = Up

# Verify all cluster nodes are healthy before moving to the next one
Get-ClusterNode | Format-Table Name, State -AutoSize
```

#### Step 6: Repeat for each remaining node

Go back to step 2 and repeat the **Suspend → Install → Verify → Resume** cycle for the next node. Continue until every node has the new NICs installed.

:::image type="content" source="media/add-network-adapters-to-network-intents/add-phase-a-complete.png" alt-text="Diagram showing all cluster nodes have completed the Phase A rolling installation and now have the new NIC hardware." lightbox="media/add-network-adapters-to-network-intents/add-phase-a-complete.png":::

> [!WARNING]
> **Don't skip nodes.** Network ATC expects the same set of adapters on every node in the intent. If any node is missing the new adapter, the intent update in Phase B fails or produces inconsistent results. Install and verify the new NIC on every node before you start Phase B.

### Phase B: Intent update (cluster-wide)

After every node has the new NICs installed, verified, and resumed, update the Network ATC intent. By default, Network ATC converges the intent on all nodes at the same time. To control the rollout and converge one node at a time, run step 7 first. Otherwise, skip to step 8.

> [!NOTE]
> **Why control the rollout?** When you run `Update-NetIntentAdapter`, the Network ATC service (`NetworkATC`) on every node detects the change and starts to converge at the same time. The Switch Embedded Teaming (SET) team on every node reconfigures at once, which can briefly disrupt all nodes.
>
> If you stop the Network ATC service on the other nodes first, only one node converges at a time. This limits the impact of any issues to a single node.
>
> If your environment can tolerate a brief cluster-wide disruption, skip step 7 and go straight to step 8 for a faster, but less controlled, rollout.

#### Step 7: (Optional) Stop Network ATC on non-target nodes for controlled rollout

To converge one node at a time, stop the Network ATC service on every node except the first one you want to converge. This stops those nodes from picking up the intent change until you're ready.

```powershell
# Choose which node will converge first
$targetNode = "Node01"

# Get all OTHER cluster nodes (the ones that should NOT converge yet)
$otherNodes = (Get-ClusterNode | Where-Object { $_.Name -ne $targetNode }).Name

# Stop the Network ATC service on each non-target node
foreach ($node in $otherNodes) {
    Write-Host "Stopping NetworkATC on $node ..."
    Invoke-Command -ComputerName $node -ScriptBlock {
        Stop-Service -Name NetworkATC -Force
    }
}

# Verify the service is stopped on those nodes
foreach ($node in $otherNodes) {
    Invoke-Command -ComputerName $node -ScriptBlock {
        Get-Service -Name NetworkATC | Select-Object Name, Status
    }
}
# Expected: Status = Stopped on all non-target nodes
```

> [!IMPORTANT]
> The service name on Azure Local is `NetworkATC`. Don't leave the service stopped — restart it after convergence (step 9). While the service is stopped, those nodes don't process any intent changes.

#### Step 8: Update the intent to include the new adapters

Use `Update-NetIntentAdapter` to add the new NICs. You must list every adapter that belongs in the intent (existing and new).

> [!WARNING]
> **Why list all adapters?** The `-AdapterName` parameter is the complete list of adapters for the intent, not just the new ones. If you list only the new adapter, Network ATC removes the existing adapters from the intent.

```powershell
# Example: Intent 'MgmtCompute' currently has 'Ethernet1'.
# We are adding 'Ethernet2' as a new adapter.

# Define ALL adapters that should be in the intent (existing + new)
$intentName  = "MgmtCompute"
$adapterList = @("Ethernet1", "Ethernet2")  # <-- existing + new

# Apply the change
Update-NetIntentAdapter -Name $intentName -AdapterName $adapterList
```

:::image type="content" source="media/add-network-adapters-to-network-intents/add-phase-b-intent-update.png" alt-text="Diagram showing the cluster-wide intent update in Phase B, with Update-NetIntentAdapter adding the new NIC to the intent." lightbox="media/add-network-adapters-to-network-intents/add-phase-b-intent-update.png":::

#### Step 9: Wait for Network ATC convergence

Network ATC applies the configuration (teaming, RDMA, Quality of Service (QoS), and so on) to the new adapter. If you stopped Network ATC on the other nodes in step 7, only the target node converges now.

```powershell
# Monitor intent status on the target node
Get-NetIntentStatus | Format-List Host, IntentName, ConfigurationStatus, ProvisioningStatus
# Wait until Status shows 'Completed' or 'Success'
# This may take several minutes
```

For a controlled rollout (step 7), restart the Network ATC service on the next node, wait for it to converge, and repeat until every node is done:

```powershell
# Start ATC on the next node
$nextNode = "Node02"
Invoke-Command -ComputerName $nextNode -ScriptBlock {
    Start-Service -Name NetworkATC
}

Start-Sleep -Seconds 5  # Allow time for the service to process the change

# Check status to see if the intent converged on that node
Get-NetIntentStatus | Format-Table IntentName, Host, ConfigurationStatus, ProvisioningStatus

# Verify the SET team now includes the new adapter on that node
Invoke-Command -ComputerName $nextNode -ScriptBlock {
    Get-VMSwitch | Get-VMSwitchTeam |
        Select-Object Name, @{N="Members";E={$_.NetAdapterInterfaceDescription -join ", "}}
}

# Repeat for each remaining node until all nodes have converged
```

> [!IMPORTANT]
> **Don't forget to restart the service.** If you stopped `NetworkATC` in step 7, restart it on every node before you finish.
>
> Verify with:
>
> ```powershell
> Get-ClusterNode | ForEach-Object {
>     Invoke-Command -ComputerName $_.Name -ScriptBlock { Get-Service NetworkATC }
> }
> ```
>
> All nodes must show `Status = Running`.

#### Step 10: Validate

See [Post-change validation checklist](#post-change-validation-checklist) for the full validation steps.

:::image type="content" source="media/add-network-adapters-to-network-intents/add-after-three-adapters-healthy.png" alt-text="Diagram showing the cluster after the add operation completes, with all three NICs healthy in the Management and Compute intent." lightbox="media/add-network-adapters-to-network-intents/add-after-three-adapters-healthy.png":::

> [!NOTE]
> **Expected impact.** A controlled rollout to add adapters to an intent rarely disrupts traffic. Network ATC reads the updated adapter list and applies configuration automatically. Always plan a maintenance window as a precaution.

## Storage-only intents (no vSwitch)

Not every Network ATC intent uses a Hyper-V Virtual Switch (vSwitch). Storage intents typically use dedicated RDMA NICs that connect directly without a vSwitch or SET team.

:::image type="content" source="media/add-network-adapters-to-network-intents/add-storage-only-intent-reference.png" alt-text="Reference diagram showing a storage-only intent with dedicated RDMA NICs and no vSwitch." lightbox="media/add-network-adapters-to-network-intents/add-storage-only-intent-reference.png":::

When you add NICs to a storage-only intent (one without a vSwitch):

- The SDN and vSwitch concerns in [Critical warning](#critical-warning-sdn-enabled-environments-and-the-virtual-switch) don't apply. There's no vSwitch to protect, no vSwitch ID to preserve, and no VFP extension.
- Use `Update-NetIntentAdapter` to add adapters to the storage intent, just as the procedure describes.
- For the storage intent, you can skip the vSwitch ID and VFP extension checks in the post-change checklist.
- All other prerequisites still apply: same hardware model, matching drivers and firmware, and matching adapter names across nodes.

> [!NOTE]
> **When does the SDN and vSwitch warning apply?** This warning applies only to intents that create a Hyper-V Virtual Switch. Those are typically:
>
> - Management and Compute intents
> - Compute-only intents
> - Any intent that includes a Compute or Management role
>
> Storage-only intents don't create a vSwitch, so the SDN warning doesn't apply. However, a fully converged intent (for example, Management + Compute + Storage on the same adapters) does include the vSwitch, so the SDN warning applies.

### How to determine if an intent has a vSwitch

```powershell
# List all intents and their types
Get-NetIntent | Format-List IntentName, IntentType, NetAdapterName
# If IntentType includes 'Compute' or 'Management', a vSwitch exists for that intent.
# If IntentType is 'Storage' only, there is no vSwitch.

# You can also verify by checking for a VMSwitch:
Get-VMSwitch | Format-List Name, Id
```

## What this procedure does NOT do

This procedure avoids the following actions to preserve the existing infrastructure:

| Action not taken | Why it's avoided |
|---|---|
| `Remove-VMSwitch` | Removing the VMSwitch destroys the vSwitch. In SDN environments, the new vSwitch gets a new ID, which breaks all SDN policies, VFP bindings, and virtual networking. Never do this manually. |
| `Remove-NetIntent` (when not needed) | `Remove-NetIntent` doesn't remove the vSwitch or change switch settings, but it does stop Network ATC from managing adapter configuration and reconciling drift. Use `Update-NetIntentAdapter` to change adapter membership inside the existing intent. |
| Full node repair or reinstall | Not needed for a simple NIC addition. `Update-NetIntentAdapter` handles adapter membership changes. |
| Recreate the vSwitch | A new vSwitch gets a new ID. The SDN Network Controller, VFP policies, and all virtual network configurations bind to the original ID. |

## Post-change validation checklist

After you add the NICs, run all the following checks:

| # | Check | Command / method | Expected result |
|---|---|---|---|
| 1 | Cluster node is resumed and Up. | `Get-ClusterNode \| Select Name, State` | `State = Up` for the modified node. |
| 2 | All cluster groups are Online. | `Get-ClusterGroup \| Format-Table Name, State, OwnerNode` | `State = Online` for all groups. |
| 3 | Intent status is healthy. | `Get-NetIntent \| Format-List Name, IntentStatus` | `IntentStatus = Completed / Success / Healthy`. |
| 4 | All expected adapters are listed in the intent. | `Get-NetIntent \| Select-Object -ExpandProperty NetAdapterName` | All intended adapter names are present. |
| 5 | vSwitch ID is unchanged (intents with vSwitch only). | `Get-VMSwitch \| Select-Object Name, Id` | ID matches the value recorded before the change. |
| 6 | VFP extension is still enabled (SDN environments). | `Get-VMSwitch \| Get-VMSwitchExtension` | `Microsoft Azure VFP Switch Extension = Enabled`. |
| 7 | Host network connectivity works. | `Test-Connection` to gateway, other nodes, and management network. | All pings succeed. |
| 8 | Cluster network health. | `Get-ClusterNetwork \| Format-Table Name, State` | `State = Up` for all cluster networks. |
| 9 | Storage Spaces Direct health. | `Get-StorageSubSystem *Cluster* \| Get-StorageHealthReport` | No critical warnings; repair jobs complete. |
| 10 | Live Migration works. | Test a virtual machine live migration between nodes. | Migration completes successfully. |
| 11 | RDMA is functional (if applicable). | `Get-NetAdapterRdma \| Format-Table Name, Enabled` | `Enabled = True` on all intended adapters. |
| 12 | No unexpected alerts in Windows Admin Center. | Check Windows Admin Center cluster dashboard. | No new warnings or errors. |

## Next steps

- [Replace a failed NIC in an existing Network ATC intent](replace-network-adapter-to-network-intents.md)
- [Network ATC overview](../concepts/network-atc-overview.md?pivots=azure-local)
