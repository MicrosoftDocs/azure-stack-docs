---
title: Replace a failed NIC in an existing Network ATC intent on Azure Local
description: Learn how to replace a failed physical network adapter that's part of an existing Network ATC intent on an Azure Local instance.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: shisab
ms.date: 04/23/2026
ms.subservice: hyperconverged
---

# Replace a failed NIC in an existing Network ATC intent

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to replace a failed physical network adapter (NIC) that's a member of an existing Network ATC intent on an Azure Local instance, without rebuilding the node or recreating the intent.

For the related expansion workflow, see [Add NICs to an existing Network ATC intent](add-network-adapters-network-atc.md).

## Key principle

Network ATC must remain the single source of truth for all host networking configuration. All adapter changes are performed through the `Update-NetIntentAdapter` cmdlet. Don't manually modify vSwitch, VMSwitch, or team configurations outside of Network ATC.

## Critical warning: SDN-enabled environments and the virtual switch

> [!WARNING]
> **Don't remove or recreate the vSwitch when SDN is enabled.**
>
> If your Azure Local instance has Software Defined Networking (SDN) enabled, the Hyper-V Virtual Switch (vSwitch) has Virtual Filtering Platform (VFP) extensions attached to it. The vSwitch is identified by a unique vSwitch ID.
>
> If you remove and recreate the vSwitch (for example, by manually running `Remove-VMSwitch`), the new vSwitch receives a new vSwitch ID. This breaks your SDN implementation because:
>
> - The SDN Network Controller has recorded the original vSwitch ID.
> - VFP policies (load balancing rules, access control lists (ACLs), virtual network policies) are bound to the original vSwitch ID.
> - A new vSwitch ID means the Network Controller can no longer apply policies to the switch.
> - All SDN-managed workloads (virtual networks, load balancers, gateways) stop functioning correctly.
>
> Never run `Remove-VMSwitch`, or any operation that directly destroys the vSwitch, in an SDN-enabled environment.

> [!NOTE]
> `Remove-NetIntent` removes the intent definition but doesn't remove the vSwitch or change any existing switch settings. The procedure below modifies adapter membership within the existing intent, preserving the vSwitch and its ID.

## Check if SDN is enabled on your cluster

Before performing any NIC changes, determine whether SDN is enabled. If SDN is active, take extra care to preserve the vSwitch.

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
> If the VFP extension is enabled on the vSwitch, SDN is active and you must not remove or recreate the vSwitch (`Remove-VMSwitch`) under any circumstances.

## When to replace a NIC in an intent

Use this procedure when a physical network adapter that's part of an existing Network ATC intent has failed or is degraded, and you need to replace it without rebuilding the node or recreating the intent.

## Prerequisites

Complete all of the following before you begin:

| # | Prerequisite | How to verify |
|---|---|---|
| 1 | Identify the failed NIC and its adapter name. | `Get-NetAdapter` — the failed adapter may show `Status = Disconnected` or `Not Present`. |
| 2 | Know the intent name that contains the failed NIC. | `Get-NetIntent \| Select Name, NetAdapterName`. |
| 3 | Have the replacement NIC ready. It must be the **identical hardware model** as the original (same manufacturer, model number, speed, Remote Direct Memory Access (RDMA) type). Mixing different NIC models within an intent isn't supported. | `Get-NetAdapter \| Select InterfaceDescription` on a healthy node to confirm the exact model; match with the replacement. |
| 4 | Have out-of-band management access (baseboard management controller (BMC), such as Integrated Dell Remote Access Controller (iDRAC) or HPE Integrated Lights-Out (iLO)) in case connectivity is lost. | Verify BMC connectivity before starting. |
| 5 | A maintenance window is planned. Removing an adapter from the intent can be disruptive. | Coordinate with operations team. |
| 6 | SDN status has been checked. | See [Check if SDN is enabled on your cluster](#check-if-sdn-is-enabled-on-your-cluster). |
| 7 | Cluster health is confirmed before starting. | `Get-ClusterNode` (all nodes Up); `Get-ClusterGroup` (no failed critical resources). |

## Step-by-step procedure

### Step 1: Record current state

Document everything before making changes.

```powershell
# Record current intent configuration
Get-NetIntent | Format-List IntentName, NetAdapterNamesAsList, IntentType

# Record adapter details including the failed one
Get-NetAdapter | Format-Table Name, Status, LinkSpeed, InterfaceDescription -AutoSize

# Record the vSwitch ID (critical for SDN environments)
Get-VMSwitch | Format-List Name, Id
```

:::image type="content" source="media/replace-network-adapter-network-atc/replace-before-failed-adapter.png" alt-text="Diagram showing the cluster state before the replacement, with a failed NIC in the Management and Compute intent." lightbox="media/replace-network-adapter-network-atc/replace-before-failed-adapter.png":::

### Step 2: Suspend (drain) the cluster node

Before modifying the intent, suspend the node to gracefully move all clustered roles (virtual machines (VMs), cluster groups) to other nodes. This step protects workloads from any network disruption during the NIC replacement.

```powershell
# Replace Node01 with the actual node name
$nodeName = "Node01"

# Suspend the node - drains all roles to other cluster members
Suspend-ClusterNode -Name $nodeName -Drain -Wait

# Verify the node is Paused
Get-ClusterNode -Name $nodeName | Select-Object Name, State
# Expected: State = Paused
```

### Step 3: Stop Network ATC on non-paused nodes

Removing an adapter from the intent through `Update-NetIntentAdapter` is a cluster-wide operation. The Network ATC service (`NetworkATC`) on every node detects the intent change and attempts to converge, which could disrupt active traffic on healthy nodes. To prevent this disruption, stop the service on all nodes that aren't being drained.

```powershell
# The paused/drained node where we are working
$targetNode = "Node01"

# Get all OTHER cluster nodes (the ones that should NOT pick up the change yet)
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
> The service name on Azure Local is `NetworkATC`. Don't leave the service stopped indefinitely — it must be restarted after convergence (step 10). While the service is stopped, those nodes don't process any intent changes.

### Step 4: Remove the failed adapter from the intent

Update the intent to include only the healthy adapters. This change tells Network ATC to stop managing the failed NIC. Because you stopped Network ATC on the other nodes in step 3, only the paused node processes this change.

> [!WARNING]
> **Disruption warning.** This step may cause temporary loss of network connectivity on the paused node. If this is the only management NIC, the node may become unreachable over the network. Ensure you have out-of-band access (BMC, such as iDRAC or iLO) before proceeding.

```powershell
# Example: Intent 'MgmtCompute' currently has 'Ethernet1' (failed) and 'Ethernet2' (healthy)
# We remove the failed adapter by specifying only the healthy ones

$intentName  = "MgmtCompute"
$adapterList = @("Ethernet2")  # <-- ONLY the healthy adapters

# Apply the change - removes the failed NIC from the intent
Update-NetIntentAdapter -Name $intentName -AdapterName $adapterList

# Wait for ATC to converge
Get-NetIntentStatus | Format-List Host, IntentName, ConfigurationStatus, ProvisioningStatus
```

:::image type="content" source="media/replace-network-adapter-network-atc/replace-phase-1-suspend-and-remove.png" alt-text="Diagram showing Phase 1 of the replacement: the target node is suspended and the failed NIC is removed from the intent." lightbox="media/replace-network-adapter-network-atc/replace-phase-1-suspend-and-remove.png":::

### Step 5: Physically replace the failed NIC

Power down the node if required by your hardware vendor's replacement procedure, then replace the physical adapter.

### Step 6: Ensure the replacement adapter has the same name as the original

This step is critical. Network ATC identifies adapters by name. The replacement NIC must use the exact same name as the failed one.

```powershell
# After the replacement NIC is installed, check its name
Get-NetAdapter | Format-Table Name, Status, InterfaceDescription -AutoSize

# If the name differs from the original, rename it
# Example: The original was "Ethernet1" but the new NIC shows as "Ethernet 3"
Rename-NetAdapter -Name "Ethernet 3" -NewName "Ethernet1"

# Verify the rename
Get-NetAdapter | Format-Table Name, Status -AutoSize
```

### Step 7: Ensure drivers and firmware are up to date

Install the same driver and firmware version that the other nodes are running.

```powershell
# Compare driver version with other healthy nodes
Get-NetAdapter | Select-Object Name, DriverVersion, InterfaceDescription
```

:::image type="content" source="media/replace-network-adapter-network-atc/replace-phase-2-physical-swap.png" alt-text="Diagram showing Phase 2 of the replacement: the physical NIC is replaced, renamed, and drivers are updated." lightbox="media/replace-network-adapter-network-atc/replace-phase-2-physical-swap.png":::

### Step 8: Add the replacement adapter back into the intent

Now specify all adapters (the healthy ones plus the replacement) to restore the intent to its full configuration.

```powershell
# Example: Add 'Ethernet1' (replacement) back alongside 'Ethernet2' (was healthy)
$intentName  = "MgmtCompute"
$adapterList = @("Ethernet1", "Ethernet2")  # <-- ALL intended adapters

# Apply the change
Update-NetIntentAdapter -Name $intentName -AdapterName $adapterList
```

:::image type="content" source="media/replace-network-adapter-network-atc/replace-phase-3-add-replacement.png" alt-text="Diagram showing Phase 3 of the replacement: the replacement NIC is added back into the intent." lightbox="media/replace-network-adapter-network-atc/replace-phase-3-add-replacement.png":::

### Step 9: Wait for Network ATC convergence

```powershell
# Monitor until status is healthy/completed
Get-NetIntentStatus | Format-List Host, IntentName, ConfigurationStatus, ProvisioningStatus
```

### Step 10: Restart Network ATC on non-paused nodes and resume the cluster node

Now that the intent has converged on the target node, restart the Network ATC service on the other nodes, one by one, so they pick up the restored intent. Then resume the paused node where you replaced the failed NIC.

```powershell
# Start ATC on the next node
$nextNode = "Node02"
Invoke-Command -ComputerName $nextNode -ScriptBlock {
    Start-Service -Name NetworkATC
}

# Wait for convergence on that node
Invoke-Command -ComputerName $nextNode -ScriptBlock {
    Get-NetIntentStatus |
        Where-Object { $_.Host -eq "$($env:COMPUTERNAME)" } |
        Format-List IntentName, ConfigurationStatus, ProvisioningStatus
}

# Verify the Switch Embedded Teaming (SET) team now includes the new adapter on that node
Invoke-Command -ComputerName $nextNode -ScriptBlock {
    Get-VMSwitch | Get-VMSwitchTeam |
        Select-Object Name, @{N="Members";E={$_.NetAdapterInterfaceDescription -join ", "}}
}

# Repeat above for each remaining node until all nodes have converged

# Resume the paused node
$nodeName = "Node01"
Resume-ClusterNode -Name $nodeName -Failback Immediate

# Verify the node is back to Up
Get-ClusterNode -Name $nodeName | Select-Object Name, State
# Expected: State = Up

# Verify all cluster groups are healthy
Get-ClusterGroup | Format-Table Name, State, OwnerNode -AutoSize
```

:::image type="content" source="media/replace-network-adapter-network-atc/replace-after-complete.png" alt-text="Diagram showing the cluster after the replacement is complete, with the node resumed and all NICs healthy in the intent." lightbox="media/replace-network-adapter-network-atc/replace-after-complete.png":::

> [!IMPORTANT]
> **Don't forget to restart the service.** Ensure `NetworkATC` is running on all nodes before finishing.
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

### Step 11: Validate

See [Post-change validation checklist](#post-change-validation-checklist) for the full validation steps.

## Storage-only intents (no vSwitch)

Not all Network ATC intents use a Hyper-V Virtual Switch (vSwitch). Specifically, Storage intents typically use dedicated RDMA NICs that connect directly without a vSwitch or SET team.

:::image type="content" source="media/replace-network-adapter-network-atc/replace-storage-only-intent-reference.png" alt-text="Reference diagram showing a storage-only intent with dedicated RDMA NICs and no vSwitch." lightbox="media/replace-network-adapter-network-atc/replace-storage-only-intent-reference.png":::

When replacing a NIC in a storage-only intent (one that doesn't have a vSwitch):

- The SDN / vSwitch concerns described in [Critical warning](#critical-warning-sdn-enabled-environments-and-the-virtual-switch) don't apply to this intent. There's no vSwitch to protect, no vSwitch ID to preserve, and no VFP extension.
- You still use `Update-NetIntentAdapter` to remove and re-add adapters in the storage intent, exactly as described in the procedure above.
- You can skip the vSwitch ID and VFP extension validation steps in the post-change checklist for the storage intent specifically.
- All other prerequisites still apply: identical hardware model, matching drivers/firmware, and same adapter name for replacements.

> [!NOTE]
> **When does the SDN / vSwitch warning apply?** The SDN / vSwitch critical warning applies only to intents that create a Hyper-V Virtual Switch. Typically these are:
>
> - Management & Compute intents
> - Compute-only intents
> - Any intent that includes a Compute or Management role
>
> Storage-only intents don't create a vSwitch and aren't affected by the SDN warning. However, if your environment has a fully converged intent (for example, Management + Compute + Storage on the same adapters), then the vSwitch is involved and the SDN warning applies.

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

This procedure deliberately avoids the following actions to preserve the existing infrastructure:

| Action not taken | Why it's avoided |
|---|---|
| `Remove-VMSwitch` | Directly removing the VMSwitch destroys the vSwitch. In SDN environments the new vSwitch gets a new ID, breaking all SDN policies, VFP bindings, and virtual networking. Never do this manually. |
| `Remove-NetIntent` (unnecessarily) | While `Remove-NetIntent` doesn't remove the vSwitch or change switch settings, it does stop Network ATC from managing adapter configuration and reconciling drift. Prefer `Update-NetIntentAdapter` to modify adapter membership within the existing intent. |
| Full node repair / reinstall | Unnecessary for a simple NIC replacement. `Update-NetIntentAdapter` handles adapter membership changes gracefully. |
| Recreate the vSwitch | A new vSwitch gets a new ID. The SDN Network Controller, VFP policies, and all virtual network configurations are bound to the original ID. |

## Post-change validation checklist

After replacing the NIC, run through all of the following checks:

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

- [Add NICs to an existing Network ATC intent](add-network-adapters-network-atc.md)
- [Network ATC overview](../concepts/network-atc-overview.md?pivots=azure-local)
