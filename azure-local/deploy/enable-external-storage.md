---
title: Enable External Storage on Azure Local
description: Learn how to integrate external storage area network (SAN) storage from supported vendors with Azure Local using Fibre Channel (FC) or iSCSI.
author: troettinger
ms.author: thoroet
ms.reviewer: ronmiab
ms.topic: how-to
ms.date: 06/04/2026
ms.subservice: hyperconverged
---
# Connecting an external storage array to Azure Local

This article describes how to integrate external storage area network (SAN) storage from supported vendors with Azure Local using Fibre Channel (FC) or Internet Small Computer Systems Interface (iSCSI). It covers both Azure Local host-side configuration performed on cluster nodes and vendor array-side configuration tasks. Vendor-specific steps, such as creating Logical Unit Number (LUNs), registering hosts, and configuring zoning, are covered in [Vendor array-side configuration](#vendor-array-side-configuration).

Azure Local supports external SAN storage alongside Storage Spaces Direct storage, or as a standalone storage architecture. This support enables:

- Hybrid deployments (Storage Spaces Direct + SAN)
- Disaggregated deployments (SAN only)

These deployment models allow organizations to reuse existing SAN investments while running Azure Local workloads.

Supported protocols include:

- Fibre Channel (FC)
- iSCSI (TCP/IP)

## Prerequisites

### Fibre Channel

- Azure Local cluster deployed with version 2604 or later.
- Fibre Channel HBAs (Windows Server 2025 certified HBA and driver) installed on all cluster nodes and zoned on the FC fabric.
- The SAN array is accessible on the FC fabric with management access configured.

> [!IMPORTANT]
> Don't zone in FC HBA World Wide Names (WWNs) until after the Azure Local deployment to avoid deployment confusion for FC LUNs.

### iSCSI

- Azure Local cluster deployed with version 2604 or later.
- Network interface card (NIC) firmware and driver versions must match the Azure Local hardware catalog requirements.
- All nodes in the cluster must use identical NIC configurations.
- Hybrid storage configuration (Storage Spaces Direct + iSCSI) requires dedicated physical ports for iSCSI. vNICs aren't supported.

## Step 1: Enable Windows features and services

### 1a. Verify Multipath I/O (all deployments)

Azure Local 2604 and later versions enable Multipath I/O (MPIO) by default. Verify that MPIO is enabled on all nodes. If MPIO isn't enabled, which can happen in earlier versions, you need to reboot after enabling it.

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName MultipathIO

# Verify
Get-WindowsOptionalFeature -Online -FeatureName MultipathIO |
    Select-Object FeatureName, State, RestartNeeded
```

### 1b. Enable iSCSI Initiator service (iSCSI only)

For iSCSI deployments, enable and start the iSCSI Initiator service on all nodes. This step isn't required for FC-only deployments.

```powershell
Set-Service -Name MSiSCSI -StartupType Automatic
Start-Service -Name MSiSCSI
Get-Service -Name MSiSCSI | Select-Object Name, Status, StartType
```

### 1c. Reboot if required

If you enabled MPIO on pre-2604 builds or if `RestartNeeded` returns `True`, perform a rolling reboot of all nodes before proceeding.

### 1d. Collect initiator identifiers

After enabling the required services, collect the initiator identifiers from each node. You need these identifiers to configure LUN masking on the SAN array.

**FC — collect World Wide Port Names (WWPNs):**

```powershell
Get-InitiatorPort | Where-Object ConnectionType -eq 'Fibre Channel' |
    Select-Object NodeAddress, PortAddress, ConnectionType | Format-Table -AutoSize
```

**iSCSI — collect iSCSI Qualified Names (IQNs):**

```powershell
(Get-InitiatorPort | Where-Object ConnectionType -eq 'iSCSI').NodeAddress
```

## Step 2: Register vendor with MPIO and configure settings

Run all configurations on each Azure Local node. MPIO policy changes don't take effect until after a reboot.

### 2a. MPIO defaults

Azure Local 2604 and later versions include the following MPIO default settings:

| Setting | Default Value |
|--|--|
| PathVerificationState | Enabled |
| PathVerificationPeriod | 30 |
| PDORemovePeriod | 20 |
| RetryCount | 6 |
| RetryInterval | 3 |
| CustomPathRecovery | Disabled |
| CustomPathRecoveryTime | 20 |
| DiskTimeoutValue | 60 |
| Load Balance Policy | Round Robin (RR) |
| NewDiskPolicy | OfflineShared |

### 2b. Register vendor device with MSDSM

Register your storage vendor with Microsoft Device Specific Module (MSDSM) so MPIO can claim the array's LUNs. Use the command for your vendor:

| Vendor | VendorId | ProductId | Command |
|--------|----------|-----------|---------|
| Dell PowerStore | `DellEMC` | `PowerStore` | `New-MSDSMSupportedHW -VendorId "DellEMC" -ProductId "PowerStore"` |
| Everpure FlashArray | `PURE` | `FlashArray` | `New-MSDSMSupportedHW -VendorId "PURE" -ProductId "FlashArray"` |
| Hitachi VSP | *(use mpclaim)* | `OPEN-V` | `mpclaim -r -i -d "HITACHI OPEN-V"` |
| HPE Alletra / 3PAR | `3PARdata` | `VV` | `New-MSDSMSupportedHW -VendorId "3PARdata" -ProductId "VV"` |
| NetApp ONTAP | `NETAPP` | `LUN C-Mode` | `New-MSDSMSupportedHW -VendorId "NETAPP" -ProductId "LUN C-Mode"` |

> [!NOTE]
> - For NetApp:** ONTAP C-Mode reports `LUN C-Mode`, **not** `LUN`. Using `-ProductId "LUN"` doesn't match. Only register `LUN` if connecting to legacy 7-Mode systems.
>
> - For Everpure: Remove the generic vendor wildcard entry to prevent MSDSM from automatically claiming non-Pure devices:
>     ```powershell
>     Remove-MSDSMSupportedHW -VendorId 'Vendor*' -ProductId 'Product*'
>     ```

### 2c. Set the load balancing policy

```powershell
Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR
```

### 2d. Configure MPIO timers (vendor-specific)

Most supported vendors don't require extra MPIO tuning beyond the default settings. The following vendors recommend vendor-specific overrides.

#### Dell PowerStore

```powershell
Set-MPIOSetting -NewRetryCount 3 -CustomPathRecovery Enabled `
-NewPathRecoveryInterval 10 -NewDiskTimeout 30
```

#### Everpure FlashArray

```powershell
Set-MPIOSetting -NewPathRecoveryInterval 20 -CustomPathRecovery Enabled `
-NewPDORemovePeriod 20 -NewDiskTimeout 60 -NewPathVerificationState Enabled
```

#### HPE Alletra / 3PAR

No MPIO tuning required when you set the host persona to WINDOWS on the array.

#### Hitachi VSP

Default MSDSM settings with RR policy work well.

#### NetApp ONTAP

No extra MPIO tuning required beyond the default settings.

### 2e. Enable iSCSI auto-claim (iSCSI only)

```powershell
Enable-MSDSMAutomaticClaim -BusType iSCSI
```

This command registers MPIO to automatically claim all iSCSI devices. If you enable auto-claim after LUNs are already visible, restart the node so MSDSM can re-enumerate the devices.

### 2f. Verify the configuration and reboot

```powershell
mpclaim -s -d
Get-MSDSMSupportedHw
```

Restart each node in a rolling manner to apply MPIO changes before proceeding with SAN configuration.

## Step 3: Configure the iSCSI network (iSCSI only)

Skip this step for FC-only deployments.

### 3a. Exclude iSCSI NICs from Network ATC

Network ATC manages management, compute, and storage intents for Storage Spaces Direct and Remote Direct Memory Access (RDMA) traffic. Keep iSCSI NICs outside Network ATC and configure them manually.

```powershell
Add-NetIntent -Name "Mgmt-Compute" -Management -Compute -AdapterName "NIC1","NIC2"
Add-NetIntent -Name "Storage" -Storage -AdapterName "NIC3","NIC4"
```

If you add an iSCSI NIC to an Network ATC intent, remove it and reconfigure the adapter manually.

### 3b. Configure dedicated iSCSI NICs

Assign each iSCSI NIC a static IP address on its storage subnet without a default gateway.

```powershell
Rename-NetAdapter -Name "Ethernet 3" -NewName "iSCSI-NIC-A"
Rename-NetAdapter -Name "Ethernet 4" -NewName "iSCSI-NIC-B"

New-NetIPAddress -InterfaceAlias "iSCSI-NIC-A" -IPAddress 10.30.30.11 -PrefixLength 24
New-NetIPAddress -InterfaceAlias "iSCSI-NIC-B" -IPAddress 10.31.31.11 -PrefixLength 24
```

> [!NOTE]
> Don't configure a default gateway on iSCSI NICs.

### 3c. Configure MTU and VLANs (optional)

Use consistent maximum transmission unit (MTU) settings across the entire iSCSI network path. If switch ports are configured as access ports, the host sends untagged traffic.Configure VLAN tagging on the host only when switch ports are configured as trunk ports.

```powershell
Set-NetAdapterAdvancedProperty -Name "iSCSI-NIC-A" -RegistryKeyword "*JumboPacket" -RegistryValue 9014
Set-NetAdapterAdvancedProperty -Name "iSCSI-NIC-B" -RegistryKeyword "*JumboPacket" -RegistryValue 9014

Set-NetAdapter -Name "iSCSI-NIC-A" -VlanID 500
Set-NetAdapter -Name "iSCSI-NIC-B" -VlanID 600
```

### 3d. Configure static routes

Add persistent /32 routes for each target portal on both iSCSI NICs.

```powershell
New-NetRoute -DestinationPrefix <TargetPortalIP>/32 -InterfaceAlias "iSCSI-NIC-A" -NextHop <GatewayIP> -PolicyStore PersistentStore
New-NetRoute -DestinationPrefix <TargetPortalIP>/32 -InterfaceAlias "iSCSI-NIC-B" -NextHop <GatewayIP> -PolicyStore PersistentStore
```

### 3e. Configure quality of service (QoS) settings (optional)

If iSCSI traffic shares Ethernet infrastructure with other traffic, tag iSCSI with priority 4 and use Enhanced Transmission Selection (ETS) to reserve bandwidth.

```powershell
New-NetQosPolicy -Name "iSCSI" -IPDstPortStart 3260 -IPDstPortEnd 3260 -IPProtocol TCP -PriorityValue8021Action 4
New-NetQosPolicy -Name "CSV-LiveMigration" -Cluster -PriorityValue8021Action 3
New-NetQosPolicy -Name "ClusterHeartbeat" -IPProtocol UDP -IPDstPortStart 3343 -IPDstPortEnd 3343 -PriorityValue8021Action 7
```

## Step 4: Configure Storage Array and Present LUNs

Perform this step on the storage array, not on the Azure Local nodes. The procedures are vendor-specific. For vendor documentation links, see [Vendor array-side configuration](#vendor-array-side-configuration).

> [!IMPORTANT]
> Before proceeding to Step 5, confirm the following items with your storage administrator:

| Item | FC | iSCSI |
|--|--|--|
| LUNs created and mapped to all cluster nodes | ✓ | ✓ |
| Host entries created using initiator IDs from Step 1d | ✓ | ✓ |
| FC zoning configured between HBAs and array target ports | ✓ | — |
| iSCSI target portal IPs and target IQN available | — | ✓ |
| Each node can reach every target portal on port 3260 | — | ✓ |
| Consistent LUN IDs presented to all nodes | ✓ | ✓ |

## Step 5: Connect to iSCSI targets (iSCSI only)

Skip this step for FC-only deployments. FC LUNs appear automatically after zoning and LUN masking.

> [!IMPORTANT]
> Run the commands in this section on every Azure Local node.

Discover each target portal from both iSCSI NICs, and then connect to each target with persistence and multipath enabled.

```powershell
# Discover target portals
New-IscsiTargetPortal -TargetPortalAddress <TargetPortalIP-A> -InitiatorPortalAddress <InitiatorPortalIP-A>
New-IscsiTargetPortal -TargetPortalAddress <TargetPortalIP-A> -InitiatorPortalAddress <InitiatorPortalIP-B>

# Connect with multipath and persistence
Connect-IscsiTarget -NodeAddress "iqn.yyyy-mm.com.vendor:target-name" `-TargetPortalAddress <TargetPortalIP-A> -InitiatorPortalAddress <InitiatorPortalIP-A> `-IsPersistent $true -IsMultipathEnabled $true
Connect-IscsiTarget -NodeAddress "iqn.yyyy-mm.com.vendor:target-name" `-TargetPortalAddress <TargetPortalIP-A> -InitiatorPortalAddress <InitiatorPortalIP-B> `
-IsPersistent $true -IsMultipathEnabled $true
```

For each target portal IP that the array provides, run `New-IscsiTargetPortal` and `Connect-IscsiTarget`.

## Step 6: Verify SAN Disks

> [!IMPORTANT]
> Run the commands in this section on every Azure Local node.

Compare the `UniqueId` values. All nodes must see the same set of LUNs. Disk numbers might vary between nodes. Use UniqueId as the authoritative identifier.

```powershell
# Rescan storage
Update-HostStorageCache

# List SAN LUNs — appear with BusType 'Fibre Channel' or 'iSCSI'
Get-Disk | Where-Object { $_.BusType -in 'Fibre Channel','iSCSI' } | Select-Object Number, FriendlyName, Size, OperationalStatus, PartitionStyle, BusType | Format-Table -AutoSize

# Verify MPIO path count per disk
mpclaim -s -d

# Verify disk UniqueId matches across all nodes
Get-Disk | Where-Object { $_.BusType -in 'Fibre Channel','iSCSI' } | Select-Object Number, SerialNumber, UniqueId | Format-Table -AutoSize
```

## Step 7: Initialize and Format Disks

> [!IMPORTANT]
> Run this section on one Azure Local node only.

Initialize SAN volumes as GUID Partition Table (GPT) and format them with NTFS (use a 64K allocation unit for CSV). The cluster manages multi-node access after you add the disks as Cluster Shared Volumes (CSVs).

```powershell
$sanDisks = Get-Disk | Where-Object {
    $_.BusType -in 'Fibre Channel','iSCSI' -and $_.PartitionStyle -eq 'RAW'
}

foreach ($disk in $sanDisks) {
    # Bring disk online — SAN LUNs are Offline by default (OfflineShared policy)
    Set-Disk -Number $disk.Number -IsOffline $false
    Set-Disk -Number $disk.Number -IsReadOnly $false

    Initialize-Disk -Number $disk.Number -PartitionStyle GPT
    New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "SAN-LUN-$($disk.Number)" -Confirm:$false
}
```

## Step 8: Add disks to the cluster and create CSVs

> [!IMPORTANT]
> Run this section after all SAN disks are visible and validated on every cluster node.

Add the SAN disks to the failover cluster, and then convert the disks to CSVs.

```powershell
# Add SAN disks to cluster
Get-ClusterAvailableDisk | Add-ClusterDisk

# Convert to Cluster Shared Volumes
Get-ClusterResource | Where-Object {
    $_.ResourceType -eq 'Physical Disk' -and $_.OwnerGroup -eq 'Available Storage'
} | Add-ClusterSharedVolume

# Verify CSVs
Get-ClusterSharedVolume | Select-Object Name, State, OwnerNode | Format-Table -AutoSize

# Verify CSV paths
Get-ClusterSharedVolume | Select-Object -ExpandProperty SharedVolumeInfo | Select-Object FriendlyVolumeName
```

## Step 9: Add storage path in the Azure portal

Register each SAN CSV path in the Azure portal to enable virtual machine (VM) placement on SAN volumes. Only register SAN CSV paths. Azure Local automatically manages Storage Spaces Direct volumes, such as `Infrastructure` and `UserStorage`.

1. Sign in to the Azure portal and navigate to your Azure Local cluster resource.
1. Go to **Settings** > **Storage path**.
1. Select **+ Add storage path**.
1. Enter the CSV path, for example, `C:\ClusterStorage\Volume1`.
1. Confirm and save.
1. Repeat for each SAN CSV.

## Vendor array-side configuration

Azure Local supports external SAN integration with the following vendors and storage platforms. The corresponding sections of this article include vendor-specific array-side configuration guidance.

| Vendor | Supported Models | FC | iSCSI |
|--|--|--|--|
| Dell | PowerStore T/Q (OS 3.0+) | ✓ | ✓ |
| Everpure | FlashArray X, C, XL, E, RC20 | ✓ | ✓ |
| Hitachi | VSP One Block, VSP 5x00, VSP Exx90, VSP Fxx0, VSP Gxx0 | ✓ | ✓ |  |
| HPE | Alletra MP 10000 | ✓ | ✓ |  |
| NetApp | AFF, ASA, ONTAP platforms | ✓ | ✓ |
| Lenovo | ThinkSystem DS/DM/DG Series | ✓ | ✓ |

> [!NOTE]
> For a complete list of supported models and firmware requirements, see [Supported SAN solutions on Azure Local](../concepts/san-requirements).

### What to request from your storage administrator

Before starting the host-side configuration, provide your storage administrator with the following information:

1. The initiator identifiers collected in [Step 1d: Collect initiator identifiers](#1d-collect-initiator-identifiers) (WWPNs for FC, IQNs for iSCSI).
1. The required number and size of LUNs.
1. Cluster node names for host registration on the array.

Your storage administrator should provide the following information:

1. For FC: Target WWPNs for zoning configuration.
1. For iSCSI: Target portal IP addresses and target IQN.
1. Confirmation that LUNs are mapped to all cluster nodes with consistent LUN IDs.

## Troubleshooting

Use the following guidance to identify and resolve common issues when integrating SAN storage with Azure Local.

### Disks aren't visible on cluster nodes

If SAN disks don't appear on one or more cluster nodes, verify that the storage array maps the LUNs to all cluster node initiators:

- WWPNs for FC
- IQNs for iSCSI

Rescan storage on each node.

```powershell
Update-HostStorageCache
```

Also verify the following configuration settings:

- Check FC zoning or iSCSI target portal connectivity.
- Verify MPIO is enabled and the correct vendor and product IDs are registered.

```powershell
Get-MSDSMSupportedHw
```

### MPIO doesn't claim disks correctly

Verify that the registered vendor and product IDs match the storage array configuration.

```powershell
Get-MSDSMSupportedHw
```

For iSCSI deployments, verify that automatic MPIO claiming is enabled.

```powershell
Get-MSDSMAutomaticClaimSettings
```

If you add hardware IDs after the LUNs are already visible, restart the node so MPIO can re-enumerate the disks.

```powershell
mpclaim -s -d
```

### Cluster validation fails during Test-Cluster

Run cluster validation tests, including storage validation, and review the generated report.

```powershell
Test-Cluster -Include Storage
```

Verify the following requirements:

- All cluster nodes detect the same set of shared disks.
- LUN IDs are consistent across all nodes.
- The storage array supports SCSI-3 Persistent Reservations (PR).

### Can't add disks as CSVs

Before you can convert a disk to a CSV, add the disk to the failover cluster as a cluster resource.

Make sure the disks are online and formatted with the NTFS file system.

```powershell
Get-Disk | Select-Object Number, OperationalStatus, PartitionStyle
Get-Volume
```

Make sure the disk is available as a cluster resource.

```powershell
Get-ClusterResource | Where-Object ResourceType -eq 'Physical Disk'
```

### Storage path creation fails in the Azure portal

If storage path creation fails in the Azure portal, check the following conditions:

- CSV is online and accessible from all cluster nodes
- The CSV path uses the correct format, such as `C:\ClusterStorage\Volume1`
- The Azure Local cluster is registered and healthy in the Azure portal

## Next steps

- [Create a VM on Azure Local](../manage/create-arc-virtual-machines.md)
- [Using External Storage in AKS clusters on Azure Local](../manage/use-external-storage-for-containerized-workloads.md)
- [Deploying AVD on Azure Local](/azure/virtual-desktop/azure-local-overview) 
