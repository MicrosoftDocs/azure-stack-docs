---
title: Re-create a storage-only Network ATC intent on Azure Local
description: Learn how to recover and re-create a storage-only Network ATC intent on Azure Local by restoring the verified original storage networking configuration.
author: ronmiab
ms.author: cedward
ms.topic: how-to
ms.date: 10/27/2026
ms.subservice: hyperconverged
---

# Re-create a storage-only Network ATC intent on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

Network ATC manages host networking on Azure Local through intents. A storage-only intent configures the physical storage adapters and related storage networking settings.

This article describes how to recover a storage-only intent after the intent was removed and can't be restored. Re-create the intent only with the configuration that you previously used. Don't use this procedure to change adapters, virtual local area networks (VLANs), Remote Direct Memory Access (RDMA) technology, quality of service (QoS), maximum transmission unit (MTU), or the storage addressing design.

> [!WARNING]
> Re-creating a storage intent changes storage networking across the Azure Local instance. Perform this procedure during a maintenance window. An incorrect adapter, VLAN, IP address, RDMA, MTU, or QoS configuration can disrupt storage connectivity.

The recovery process has four stages:

1. Confirm that this procedure applies.
1. Recover the previous storage configuration.
1. Prepare and re-create the intent.
1. Validate the recovered configuration.

:::image type="complex" source="media/recreate-storage-network-intent/storage-intent-recovery-process.svg" alt-text="Diagram of the four recovery stages and the configuration recovery gate." lightbox="media/recreate-storage-network-intent/storage-intent-recovery-process.svg":::
   Perform the whole procedure during a maintenance window. Stage 1 confirms that the procedure applies. Stage 2 recovers the previous storage configuration. At the recovery gate, continue only if the configuration is positively identified. Otherwise, stop and obtain missing information from deployment or network records; never guess values. Stage 3 prepares and re-creates the intent. Stage 4 validates the recovered configuration and, when automatic IP generation is enabled, reviews every previously recorded storage address, removes verified obsolete addresses, and documents any old addresses deliberately retained.
:::image-end:::

## Prerequisites

Before you begin:

- Schedule a maintenance window.
- Have access to every machine in the Azure Local instance and run the PowerShell commands in an elevated session.
- Gather the available deployment and network records. In [Stage 2](#stage-2-recover-the-previous-storage-configuration), use these records together with the remaining host configuration to establish the original configuration.

## Stage 1: Confirm that this procedure applies

Use this procedure only when:

- The missing intent was a storage-only intent.
- The physical storage adapters are still present.
- You intend to restore the previous storage networking configuration.

Don't use this procedure when:

- The intent combines storage with management or compute.
- You want to [add an adapter to an existing intent](add-network-adapters-to-network-intents.md).
- You want to [replace a failed adapter in an existing intent](replace-network-adapter-to-network-intents.md).
- You intend to change the storage networking design.

> [!IMPORTANT]
> This procedure is for recovery. Don't remove and re-create an intent to change which physical adapters belong to an existing intent.

### Check the current intent status

1. Confirm that the storage intent is missing and review the remaining intents:

   ```powershell
   Get-NetIntent
   Get-NetIntentStatus
   ```

1. Check whether Failover Clustering excludes any of the physical adapters that you expect to use for storage. Make sure the storage adapters aren't included in the list:

   ```powershell
   Get-ClusterExcludedAdapter -ExclusionType Description
   ```

1. Before you continue, verify that you're working with a missing storage-only intent.

:::image type="complex" source="media/recreate-storage-network-intent/storage-intent-recovery-scope.svg" alt-text="Flowchart for deciding whether the storage-only intent recovery procedure applies." lightbox="media/recreate-storage-network-intent/storage-intent-recovery-scope.svg":::
   Start with a missing storage intent that can't be restored. Confirm that it was storage-only and its physical adapters are still present. An intent that combines storage with management or compute is outside the scope of this procedure. Next, confirm that the goal is to restore the previous configuration unchanged. Adding or replacing an adapter, or changing VLANs, RDMA, QoS, MTU, or IP addressing is outside the scope. If both conditions are met, proceed to stage 2.
:::image-end:::

The next stage is the recovery gate. Don't run `Add-NetIntent` until you can establish the required configuration of the deleted intent.

## Stage 2: Recover the previous storage configuration

Removing a Network ATC intent doesn't remove the networking configuration previously provisioned on the hosts. Therefore, some of the previous storage configuration might still be visible on the physical adapters and in the cluster.

Use this remaining configuration as evidence. Don't assume that it represents a complete copy of the deleted intent.

### Find the best available record of the configuration

Try to recover the previous configuration from the following sources, in order:

1. Previously captured `Get-NetIntent` output or other saved Network ATC configuration.
1. The deployment script, implementation record, or documentation used to create the original intent.
1. Configuration that remains on the Azure Local machines.
1. The physical switch configuration or, for a switchless deployment, the cabling and IP addressing design.

If you need to use the existing host configuration, collect the configuration from every machine in the Azure Local instance.

:::image type="complex" source="media/recreate-storage-network-intent/storage-configuration-recovery-gate.svg" alt-text="Diagram of the evidence sources and configuration checklist for the recovery gate." lightbox="media/recreate-storage-network-intent/storage-configuration-recovery-gate.svg":::
   Consult evidence in this order: saved Network ATC configuration; deployment scripts or records; remaining configuration on every Azure Local machine; and physical switch configuration or switchless cabling and IP design. Identify seven items: the original intent name, dedicated storage adapters, storage topology, original VLAN mapping, EnableAutomaticIPGeneration value, static IP address and prefix per adapter and machine if automatic IP generation was disabled, and nondefault settings to restore as overrides.
:::image-end:::

### Identify the physical adapters

Run the following command:

```powershell
Get-NetAdapter |
    Format-Table Name, InterfaceDescription, InterfaceIndex,
                 Status, MacAddress
```

Identify the dedicated physical adapters that you used for storage. Compare adapter names and interface descriptions across every machine.

### Check RDMA

Run the following command and record the RDMA configuration for the identified storage adapters:

```powershell
Get-NetAdapterRdma |
    Format-Table Name, Enabled, OperationalState
```

### Check adapter properties

Run the following command:

```powershell
Get-NetAdapterAdvancedProperty |
    Format-Table Name, DisplayName, DisplayValue,
                 RegistryKeyword, RegistryValue
```

Use the output to identify adapter settings that you might need to compare with the previous deployment configuration. Don't assume that the current adapter properties tell you which values the deleted Network ATC intent explicitly overridden.

### Check existing storage IP addresses

Run the following command and record the current IPv4 configuration:

```powershell
Get-NetIPAddress -AddressFamily IPv4 |
    Format-Table InterfaceAlias, InterfaceIndex, IPAddress,
                 PrefixLength, PrefixOrigin, SuffixOrigin
```

If IP addresses remain on the dedicated storage adapters, use them together with the deployment and network records to determine the previous storage addressing configuration.

### Check cluster networks

Run the following command:

```powershell
Get-ClusterNetwork |
    Format-Table Name, Address, AddressMask, Role, State
```

Use the cluster network information to help validate the storage subnets that you previously configured.

> [!IMPORTANT]
> These commands inventory the configuration that remains on the machines. They don't reconstruct the deleted Network ATC intent and they don't prove which settings were explicitly overridden.

### Determine whether you have enough information to continue

Before you recreate the intent, identify:

- The original intent name.
- The dedicated physical storage adapters.
- The storage topology: switched, two-machine switchless, or three-machine or four-machine switchless.
- The original storage VLAN mapping.
- Whether `EnableAutomaticIPGeneration` was `$true` or `$false`.
- If automatic IP generation was disabled, the original IP address and prefix for every storage adapter on every machine.
- Any settings that differed from the Network ATC defaults and therefore must be restored as overrides.

### Validate the VLAN configuration

For switched storage, validate the recovered VLAN mapping against the physical switch configuration.

For switchless storage:

- A three-machine or four-machine switchless deployment requires one shared storage VLAN ID across the storage links.
- A two-machine switchless deployment can use different VLAN IDs on the storage links.
- Preserve the original VLAN mapping.

:::image type="complex" source="media/recreate-storage-network-intent/storage-vlan-rules.svg" alt-text="Diagram comparing storage VLAN rules for switched and switchless deployments." lightbox="media/recreate-storage-network-intent/storage-vlan-rules.svg":::
   Switched storage uses the VLAN mapping from the physical switch configuration. Two-machine switchless storage can use different VLAN IDs on its storage links. Three-machine or four-machine switchless storage requires one shared VLAN ID across all storage links. In every case, preserve the original VLAN mapping.
:::image-end:::

> [!CAUTION]
> Don't continue if you can't positively identify the required storage adapters, VLAN configuration, automatic IP generation configuration, or required static IP addresses.
>
> Obtain the missing information from the deployment or network records. If you can't establish the original configuration with confidence, stop the recovery instead of guessing values.

## Stage 3: Prepare and re-create the storage intent

Record the existing storage IP configuration according to the original `EnableAutomaticIPGeneration` value before you run `Add-NetIntent`. Keep the existing addresses in place while Network ATC provisions the intent.

Both modes require you to record the existing addresses and leave them unchanged during provisioning unless you identify an IP address conflict. The difference is the intended configuration after recovery: with automatic IP generation enabled, review every previously recorded address after validation, remove verified obsolete addresses, and document any old addresses deliberately retained; with automatic IP generation disabled, the verified original static addresses remain the intended configuration.

Additional addresses aren't the same as duplicate-address conflicts. Different old and new addresses can coexist if they don't cause a conflict. The same IP address assigned to different machines on the same network is a conflict that you must resolve before recovery is complete. If you identify a conflict at any stage, stop the routine recovery or cleanup sequence and [resolve the conflicting assignment](#a-duplicate-ip-address-conflict-is-detected) using the verified network design.

:::image type="complex" source="media/recreate-storage-network-intent/storage-ip-preparation.svg" alt-text="Flowchart showing storage IP recovery, required review of old automatic addresses, and removal of verified obsolete IPs." lightbox="media/recreate-storage-network-intent/storage-ip-preparation.svg":::
   Branch on the original EnableAutomaticIPGeneration value. If true, record existing IPv4 addresses on dedicated physical storage adapters and leave nonconflicting addresses unchanged during provisioning and validation to protect connectivity. After validation, review every previously recorded address. Remove verified obsolete addresses, preserve required addresses, and document any old addresses deliberately retained and why. If false, record the original static address and prefix per adapter and machine and preserve those addresses as the intended configuration. Resolve IP address conflicts against the verified IP mapping before completing recovery; don't choose an address to remove solely because it is older. Build the intent and run Add-NetIntent once as a cluster-wide operation. Wait for successful provisioning, then validate intent, IP, network, and storage health. Resolve any conflicts before routine cleanup, working on one node at a time. If automatic IP generation is disabled, restore only a verified original static address if it is missing; don't copy or invent addresses or add a default gateway. Revalidate health and connectivity after any address changes.
:::image-end:::

### If automatic IP generation was enabled

If `EnableAutomaticIPGeneration` was `$true`, run the following command on every machine and record the existing IPv4 addresses and prefixes on the dedicated physical storage adapters:

```powershell
Get-NetIPAddress -AddressFamily IPv4 |
    Format-Table InterfaceAlias, InterfaceIndex, IPAddress,
                 PrefixLength, PrefixOrigin
```

Keep a per-machine, per-adapter record so that you can distinguish the old addresses from any new addresses that Network ATC provisions.

> [!WARNING]
> Don't remove nonconflicting existing storage IP addresses as a cleanup step before re-creating the intent. Removing them at this point can interrupt storage connections and take workloads offline.
>
> If you identify a duplicate-address conflict, stop routine recovery and resolve the conflicting assignment against the verified network design. Don't remove an address solely because it is older.

Leave nonconflicting addresses in place while you re-create and validate the intent to protect existing storage connections. After successful provisioning and validation, you must review every previously recorded address. Remove verified obsolete addresses and document any old addresses deliberately retained and why. Resolving an IP address conflict is also required. See [Review and clean up old automatic storage IP addresses](#review-and-clean-up-old-automatic-storage-ip-addresses).

### If automatic IP generation was disabled

If `EnableAutomaticIPGeneration` was `$false`, preserve the verified original static storage IP addresses as the intended configuration after recovery. Don't remove a valid original static address that remains on a dedicated storage adapter.

Before you re-create the intent, record the verified original IP address and prefix for every storage adapter on every machine.

If an original address is missing after Network ATC provisions the intent, restore only the verified original address.

> [!WARNING]
> Don't copy a storage address from another machine, assign an arbitrary address, or add a default gateway to a dedicated storage adapter.

### Build the storage intent

1. Use the recovered configuration to prepare the new intent. Replace every placeholder before you run the commands, and set `$autoIP` to the verified original value (`$true` or `$false`):

   ```powershell
   $name     = "<original-intent-name>"
   $adapters = @("<storage-adapter-1>", "<storage-adapter-2>")
   $vlans    = @(<original-vlan-1>, <original-vlan-2>)
   $autoIP   = $true # Replace with the verified original value
   ```

1. Create the storage override and set the verified automatic IP generation value:

   ```powershell
   $storageOverride = New-NetIntentStorageOverrides
   $storageOverride.EnableAutomaticIPGeneration = $autoIP
   ```

1. Create the parameter set:

   ```powershell
   $parameters = @{
       Name             = $name
       Storage          = $true
       AdapterName      = $adapters
       StorageVlans     = $vlans
       StorageOverrides = $storageOverride
       ErrorAction      = "Stop"
   }
   ```

1. Add any other verified original overrides that you need to restore.

   > [!IMPORTANT]
   > Don't add an override just because a value appears on an adapter. Restore an override only when you confirm that the previous intent required that value.

1. Review the parameters:

   ```powershell
   $parameters | Format-List
   ```

   Before you continue, confirm:

   - The intent name.
   - The physical storage adapter names.
   - The VLAN mapping.
   - The `EnableAutomaticIPGeneration` value.
   - Any additional override values.

### Re-create the intent

Submit the intent once as a cluster-wide operation:

```powershell
Add-NetIntent @parameters
```

Don't run `Add-NetIntent` separately on every machine. Allow Network ATC to finish provisioning before you continue to validation.

## Stage 4: Validate the recovered configuration

Don't consider the recovery complete only because `Add-NetIntent` returned successfully. Validate the configuration that Network ATC applied.

### Check the intent status

Run the following commands:

```powershell
Get-NetIntent -Name $name

Get-NetIntentStatus -Name $name |
    Format-Table IntentName, Host,
                 ProvisioningStatus, ConfigurationStatus
```

Confirm that the storage intent is present and healthy across the Azure Local instance.

### Validate the storage IP configuration

Run the following command on every machine:

```powershell
Get-NetIPAddress -AddressFamily IPv4 |
    Format-Table InterfaceAlias, IPAddress,
                 PrefixLength, PrefixOrigin, SuffixOrigin, AddressState
```

- If automatic IP generation is enabled, verify the storage IP addresses provisioned by Network ATC.
- Compare the addresses with the per-machine, per-adapter record captured before recovery. Don't perform routine cleanup of unused old automatic addresses during this validation step.
- Confirm that addresses don't conflict across machines on the same network. An `AddressState` value of `Duplicate` indicates an address conflict. Resolve any identified conflicts against the verified IP mapping before continuing.
- If automatic IP generation is disabled, verify that every dedicated storage adapter has its original static IP address and prefix.
- If a verified original static address is missing, restore that address before you consider recovery complete.

### Validate storage networking

Run the following commands on every machine:

```powershell
Get-ClusterNetwork |
    Format-Table Name, Address, AddressMask, Role, State

Get-NetAdapterRdma

Get-ClusterExcludedAdapter -ExclusionType Description
```

Confirm that:

- You're using the intended physical storage adapters.
- The VLAN configuration matches the recovered storage design.
- Failover Clustering doesn't exclude any required storage adapter.
- RDMA and other required adapter configurations match the validated previous configuration.
- The expected storage networks are available.

### Validate storage health

Run the following commands:

```powershell
Get-ClusterSharedVolume

Get-VirtualDisk |
    Format-Table FriendlyName, HealthStatus, OperationalStatus

Get-StorageJob
```

Before you close the maintenance window, verify that:

- The storage intent is healthy on every machine.
- Storage IP addressing matches the recovered design.
- No unresolved duplicate-address conflicts remain.
- If automatic IP generation is enabled, every previously recorded storage IP address is accounted for in the [address review](#review-and-clean-up-old-automatic-storage-ip-addresses), and you document any deliberately retained old addresses and the reasons for retaining them.
- The expected cluster storage networks are available.
- Cluster Shared Volumes are online.
- Virtual disks report the expected health and operational state.
- No unexpected storage repair job remains active.
- Application and storage connectivity are working as expected.

### Review and clean up old automatic storage IP addresses

Review old automatic storage IP addresses when `EnableAutomaticIPGeneration` is `$true`. Account for every storage IP address recorded before recovery. Remove verified obsolete addresses, preserve addresses required by the recovered intent, and document any old addresses you deliberately retain and why. If no addresses require removal, record that outcome and still complete the final validation.

Old and new automatic storage IP addresses can coexist only if they are distinct and don't cause address conflicts. This condition doesn't remove the requirement to review and account for the old addresses.

You must resolve duplicate-address conflicts before recovery is complete. Resolve a conflict based on the verified intended address assignment, not on which address is older.

Perform the review and routine cleanup after the preceding intent, IP configuration, storage networking, and storage health checks succeed on every machine.

> [!WARNING]
> For routine cleanup of unused old addresses, wait until Network ATC successfully provisions the intent and you verify that the new storage IP addresses are present and storage connectivity is healthy.
>
> If you identify a duplicate-address conflict, stop routine cleanup and resolve the conflicting assignment against the verified network design before continuing. Don't remove an address solely because it is older.
>
> Remove addresses only from dedicated physical storage adapters that belonged to the deleted storage-only intent. Don't remove addresses from management, compute, converged, virtual, or other host interfaces. Never remove an address that the recovered intent currently uses.

For extra protection, consider putting the node into storage maintenance mode during cleanup to pause storage traffic to that node. Work on one node at a time, and resume the node after cleanup so that storage connections are reestablished using the new addresses. Don't put multiple nodes into maintenance mode at the same time.

1. Compare the current addresses with the record captured before recovery. For every previously recorded address on every dedicated storage adapter and machine, record whether it is required by the recovered intent, verified obsolete and to be removed, or deliberately retained with a documented reason. If you can't determine an address's role, don't remove it; obtain the missing information before completing the review.

1. For each verified obsolete storage address, confirm that it isn't one of the addresses used by the recovered intent. Replace the placeholders in the following command with both the interface and the exact address:

   ```powershell
   Remove-NetIPAddress `
       -InterfaceAlias "<storage-adapter>" `
       -IPAddress "<verified-old-storage-IP>" `
       -Confirm
   ```

   Don't use an interface-only or `PrefixOrigin`-only removal command. A broad filter can match more addresses than the old storage address that you intend to remove.

1. Verify that you removed only the intended old address and that the addresses provisioned by Network ATC remain:

   ```powershell
   Get-NetIPAddress `
       -InterfaceAlias "<storage-adapter>" `
       -AddressFamily IPv4
   ```

1. If you put the node into maintenance mode, resume it. Repeat the storage IP, networking, health, and connectivity checks before proceeding to another node. Stop cleanup if any check fails.

1. Complete the review for every previously recorded address, even when no removal is needed. Before you close the maintenance window, confirm that the address review and retention decisions are documented, repeat the [storage health checks](#validate-storage-health), and confirm that all nodes are out of maintenance mode.

## Troubleshooting

### A storage intent or intent with the same name already exists

Don't create a second storage intent. Run the following command and investigate the existing intent before you continue:

```powershell
Get-NetIntent
```

### Network ATC provisioning fails

Check the status on every machine:

```powershell
Get-NetIntentStatus
```

Compare the adapter names, VLANs, and verified override values with the recovered configuration.

### A storage network is missing or unavailable

Run the following commands:

```powershell
Get-ClusterNetwork
Get-ClusterExcludedAdapter -ExclusionType Description
```

Verify the physical adapter, VLAN configuration, and physical network or switchless topology against the recovered design.

### The IP configuration isn't what you expected

First determine whether the recovered intent uses automatic IP generation.

- If automatic IP generation is enabled, don't manually replace Network ATC-generated addresses with arbitrary static addresses.
- If automatic IP generation is disabled, compare the adapter configuration with the verified original per-machine, per-adapter IP mapping.

### A duplicate IP address conflict is detected

Different old and new IP addresses on an adapter aren't, by themselves, a duplicate-address conflict. A conflict occurs when the same IP address is assigned to different machines on the same network.

Stop routine recovery or cleanup and identify the conflicting assignments. Use the verified deployment and network records to establish the intended owner of the address and correct the unintended assignment. Don't automatically remove the older address or an address used by the recovered intent.

If you can't establish the intended assignment with confidence, stop recovery and obtain the missing information instead of guessing. After resolving the conflict, repeat the storage IP, networking, health, and connectivity checks before continuing or declaring recovery complete.

## Recovery principle

A deleted intent doesn't mean that all evidence of the previous networking configuration is lost. However, the configuration that remains on the hosts isn't a complete reconstruction of the deleted intent.

Use the remaining configuration together with deployment and network records to establish the previous design. If you can't establish the required configuration with confidence, stop rather than re-create the intent with assumed values.

## Related content

- [Network ATC overview](../concepts/network-atc-overview.md?pivots=azure-local)
- [Add NICs to an existing Network ATC intent](add-network-adapters-to-network-intents.md)
- [Replace a failed NIC in an existing Network ATC intent](replace-network-adapter-to-network-intents.md)
