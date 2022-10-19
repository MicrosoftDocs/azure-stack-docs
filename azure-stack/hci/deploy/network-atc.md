---
title: Deploy host networking with Network ATC
description: This topic covers how to deploy host networking for Azure Stack HCI.
author: dcuomo
ms.topic: how-to
ms.date: 04/20/2022 
ms.author: dacuo
ms.reviewer: jgerend
---

# Deploy host networking with Network ATC 

> Applies to: Azure Stack HCI, version after (and including) 21H2. 

<!-- <details>
<summary> <strong> <b> Applies to: Azure Stack HCI, version 21H2 </b></strong></summary>
<br>
<div style="padding-left: 30px;">
Test text 
</div>
</details> -->

This article guides you through the requirements, best practices, and deployment of Network ATC. Network ATC simplifies the deployment and network configuration management for Azure Stack HCI clusters. This provides an intent-based approach to host network deployment. By specifying one or more intents (management, compute, or storage) for a network adapter, you can automate the deployment of the intended configuration. For more information on Network ATC, including an overview and definitions, see [Network ATC overview](../concepts/network-atc-overview.md). 

If you have feedback or encounter any issues, review the Requirements and best practices section, check the Network ATC event log, and work with your Microsoft support team.

## Requirements and best practices
# [21H2](#tab/21H2)

The following are requirements and best practices for using Network ATC in Azure Stack HCI:

- Supported on Azure Stack HCI, version 21H2 or later.

- All servers in the cluster must be running Azure Stack HCI, version 21H2.

- Must use physical hosts that are Azure Stack HCI certified.

- Any number of cluster nodes are supported.

- Adapters in the same Network ATC intent must be symmetric (of the same make, model, speed, and configuration) and available on each cluster node. For more information on adapter symmetry, see [Switch Embedded Teaming (SET)](../concepts/host-network-requirements.md#set)

- Each physical adapter specified in an intent, must use the same name on all nodes in the cluster.

- Ensure each network adapter has an "Up" status, as verified by the PowerShell `Get-NetAdapter` cmdlet.

- Each node must have the following Azure Stack HCI features installed:

  - Network ATC
  - Data Center Bridging (DCB)
  - Failover Clustering
  - Hyper-V
   Here's an example of installing the required features via PowerShell:
   
   ```powershell
   Install-WindowsFeature -Name NetworkATC, Data-Center-Bridging, Hyper-V, Failover-Clustering -IncludeManagementTools
   ```
- Best practice: Insert each adapter in the same PCI slot(s) in each host. This leads to ease in automated naming conventions by imaging systems.

- Best practice: Configure the physical network (switches) prior to Network ATC including VLANs, MTU, and DCB configuration. See [Physical Network Requirements](../concepts/physical-network-requirements.md) for more information.


# [22H2](#tab/22H2)

The following are requirements and best practices for using Network ATC in Azure Stack HCI:

- Supported on Azure Stack HCI, version 22H2.

- All servers in the cluster must be running Azure Stack HCI, version 22H2.

- Must use physical hosts that are Azure Stack HCI certified.

- A maximum of 16 nodes supported per cluster. 

- Adapters in the same Network ATC intent must be symmetric (of the same make, model, speed, and configuration) and available on each cluster node. Network ATC, after version 22H2, will confirm symmetric properties for adapters on the node, and across the cluster before deploying an intent. Asymmetric adapters will lead to a failure in deploying any intent. For more information on adapter symmetry, see [Switch Embedded Teaming (SET)](../concepts/host-network-requirements.md#set)

- Each physical adapter specified in an intent, must use the same name on all nodes in the cluster.

- Ensure each network adapter has an "Up" status, as verified by the PowerShell `Get-NetAdapter` cmdlet.

- When running the 22H2 Azure Stack HCI OS, each node will come with Network ATC pre-installed, along with all it's required modules. So you do not need to run an installation command. 

- Best practice: Insert each adapter in the same PCI slot(s) in each host. This leads to ease in automated naming conventions by imaging systems.

- Best practice: Configure the physical network (switches) prior to Network ATC including VLANs, MTU, and DCB configuration. See [Physical Network Requirements](../concepts/physical-network-requirements.md) for more information.

--- 

> [!IMPORTANT]
> Updated: Deploying Network ATC in virtual machines may be used for test and validation purposes only. VM-based deployment requires an override to the default adapter settings to disable the NetworkDirect property. For more information on submission of an override, please see: [Override default network settings](../manage/manage-network-atc.md#update-or-override-network-settings).
> 
> Deploying Network ATC in standalone mode may be used for test and validation purposes only.

## Common Network ATC commands

There are several new PowerShell commands included with Network ATC. Run the`Get-Command -ModuleName NetworkATC` cmdlet to identify them. Ensure PowerShell is run as an administrator.

The `Remove-NetIntent` cmdlet removes an intent from the local node or cluster. This does not destroy the invoked configuration.

## Example intents

Network ATC modifies how you deploy host networking, not what you deploy. Multiple scenarios may be implemented so long as each scenario is supported by Microsoft. Here are some examples of common deployment options, and the PowerShell commands needed. These are not the only combinations available but they should give you an idea of the possibilities.

For simplicity we only demonstrate two physical adapters per SET team, however it is possible to add more. Refer to [Plan Host Networking](../concepts/host-network-requirements.md) for more information.

### Fully converged intent

For this intent, compute, storage, and management networks are deployed and managed across all cluster nodes.

:::image type="content" source="media/network-atc/network-atc-2-full-converge.png" alt-text="Fully converged intent" lightbox="media/network-atc/network-atc-2-full-converge.png":::
<details>
<summary> <strong> <b> 21H2 </b></strong></summary>

```powershell
Add-NetIntent -Name ConvergedIntent -Management -Compute -Storage -ClusterName HCI01 -AdapterName pNIC01, pNIC02
```

</details>

<details>
<summary> <strong> <b> 22H2 </b></strong></summary>

```powershell
Add-NetIntent -Name ConvergedIntent -Management -Compute -Storage -AdapterName pNIC01, pNIC02
```

</details>

### Converged compute and storage intent; separate management intent

Two intents are managed across cluster nodes. Management uses pNIC01, and pNIC02; Compute and storage are on different adapters.

:::image type="content" source="media/network-atc/network-atc-3-separate-management-compute-storage.png" alt-text="Storage and compute converged intent"  lightbox="media/network-atc/network-atc-3-separate-management-compute-storage.png":::
<details>
<summary> <strong> <b> 21H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Mgmt -Management -ClusterName HCI01 -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute_Storage -Compute -Storage -ClusterName HCI01 -AdapterName pNIC03, pNIC04
```
</details>

<details>
<summary> <strong> <b> 22H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Mgmt -Management -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute_Storage -Compute -Storage -AdapterName pNIC03, pNIC04
```
</details>

### Fully disaggregated intent

For this intent, compute, storage, and management networks are all managed on different adapters across all cluster nodes.

:::image type="content" source="media/network-atc/network-atc-4-fully-disaggregated.png" alt-text="Fully disaggregated intent"  lightbox="media/network-atc/network-atc-4-fully-disaggregated.png":::

<details>
<summary> <strong> <b> 21H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Mgmt -Management -ClusterName HCI01 -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute -Compute -ClusterName HCI01 -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Storage -Storage -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```
</details>

<details>
<summary> <strong> <b> 22H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Mgmt -Management -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute -Compute -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Storage -Storage -AdapterName pNIC05, pNIC06
```
</details>

### Storage-only intent

For this intent, only storage is managed. Management and compute adapters are not be managed by Network ATC.

:::image type="content" source="media/network-atc/network-atc-5-fully-disaggregated-storage-only.png" alt-text="Storage only intent"  lightbox="media/network-atc/network-atc-5-fully-disaggregated-storage-only.png":::

<details>
<summary> <strong> <b> 21H2 </b></strong></summary>
```powershell
Add-NetIntent -Name Storage -Storage -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```
</details>

<details>
<summary> <strong> <b> 22H2 </b></strong></summary>
```powershell
Add-NetIntent -Name Storage -Storage -AdapterName pNIC05, pNIC06
```
</details>

### Compute and management intent

For this intent, compute and management networks are managed, but not storage.

:::image type="content" source="media/network-atc/network-atc-6-disaggregated-management-compute.png" alt-text="Management and compute intent"  lightbox="media/network-atc/network-atc-6-disaggregated-management-compute.png":::

<details>
<summary> <strong> <b> 21H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Management_Compute -Management -Compute -ClusterName HCI01 -AdapterName pNIC01, pNIC02
```
</details>

<details>
<summary> <strong> <b> 22H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Management_Compute -Management -Compute -AdapterName pNIC01, pNIC02
```
</details>

### Multiple compute (switch) intent

For this intent, multiple compute switches are managed.

:::image type="content" source="media/network-atc/network-atc-7-multiple-compute.png" alt-text="Multiple switches intent"  lightbox="media/network-atc/network-atc-7-multiple-compute.png":::

<details>
<summary> <strong> <b> 21H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Compute1 -Compute -ClusterName HCI01 -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Compute2 -Compute -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```
</details>

<details>
<summary> <strong> <b> 22H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Compute1 -Compute -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Compute2 -Compute -AdapterName pNIC05, pNIC06
```
</details>

## Default Network ATC values

This section lists some of the key default values used by Network ATC.

### 21H2 Default Values 

#### Default VLANs 


The following default VLANs are used. These VLANs must be available on the physical network for proper operation.

|Adapter Intent|Default Value|
|--|--|
|Management|Configured VLAN for management adapters isn't modified|
|Storage Adapter 1|711|
|Storage Adapter 2|712|
|Storage Adapter 3|713|
|Storage Adapter 4|714|
|Storage Adapter 5|715|
|Storage Adapter 6|716|
|Storage Adapter 7|717|
|Storage Adapter 8|718|
|Future Use|719|

Consider the following command:
<details>
<summary> <strong> <b> 21H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Cluster_ComputeStorage -Storage -ClusterName HCI01 -AdapterName pNIC01, pNIC02, pNIC03, pNIC04
```
</details>

<details>
<summary> <strong> <b> 22H2 </b></strong></summary>

```powershell
Add-NetIntent -Name Cluster_ComputeStorage -Storage -AdapterName pNIC01, pNIC02, pNIC03, pNIC04
```
</details>

The physical NIC (or virtual NIC if required) is configured to use VLANs 711, 712, 713, and 714 respectively.

> [!NOTE]
> Network ATC allows you to change the VLANs used with the `StorageVlans` parameter on `Add-NetIntent`.

### 22H2 Default Values 

#### Automatic Storage IP Addressing 
If you choose the <code> -Storage</code> intent type, Network ATC after version 22H2, will configure your IP Addresses, Subnets and VLANs for you. Network ATC does this in a consistent and uniform manner across all nodes in your cluster. 

The default IP Address for each adapter on each node in the storage intent will be set up as follows: 

|Adapter|IP Address and Subnet|VLAN|
|--|--|--|
|pNIC1|10.71.1.X |711|
|pNIC2|10.71.2.X |712|
|pNIC3|10.71.3.X |713|

The IP Addresses and subnets are consistent with the VLANs assigned to the adapters. 

To override Automatic Storage IP Addressing, create a storage override and pass the override when creating an intent: 

```powershell
$storageOverride = new-NetIntentStorageOverrides
$storageOverride.EnableAutomaticIPGeneration = $false
```

```powershell
Add-NetIntent -Name Storage_Compute -Storage -Compute -AdapterName 'pNIC01', 'pNIC02' -StorageOverrides $storageoverride
```

#### Cluster Network Settings 

Version 22H2 and later, Network ATC configures a set of Cluster Network Features by default. The defaults are listed below: 

|Property|Default|
|--|--|
|EnableNetworkNaming | $true|
|EnableLiveMigrationNetworkSelection | $true|
|EnableVirtualMachineMigrationPerformance | $true|
|VirtualMachineMigrationPerformanceOption | Default will be always calculated: SMB, TCP or Compression|
|MaximumVirtualMachineMigrations | 1 |
|MaximumSMBMigrationBandwidthInGbps  | Default will be calculated based on set-up |



### Default Data Center Bridging (DCB) configuration

Network ATC establishes the following priorities and bandwidth reservations. This configuration should also be configured on the physical network.

|Policy|Use|Default Priority|Default Bandwidth Reservation|
|--|--|--|--|
|Cluster|Cluster Heartbeat reservation|7|2% if the adapter(s) are <= 10 Gbps; 1% if the adapter(s) are > 10 Gbps|
|SMB_Direct|RDMA Storage Traffic|3|50%|
|Default|All other traffic types|0|Remainder|

> [!NOTE]
> Network ATC allows you to override default settings like default bandwidth reservation. For examples, see [Update or override network settings](../manage/manage-network-atc.md#update-or-override-network-settings).

## Next steps

- Manage your Network ATC deployment. See [Manage Network ATC](../manage/manage-network-atc.md).

- Learn more about [Stretched clusters](../concepts/stretched-clusters.md).
