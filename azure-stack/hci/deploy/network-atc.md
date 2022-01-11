---
title: Deploy host networking with Network ATC
description: This topic covers how to deploy host networking for Azure Stack HCI.
author: v-dasis
ms.topic: how-to
ms.date: 10/19/2021
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Deploy host networking with Network ATC

> Applies to: Azure Stack HCI, version 21H2

This article guides you through the requirements, best practices, and deployment of Network ATC. Network ATC simplifies the deployment and network configuration management for Azure Stack HCI clusters. This provides an intent-based approach to host network deployment. By specifying one or more intents (management, compute, or storage) for a network adapter, you can automate the deployment of the intended configuration. For more information on Network ATC, including an overview and definitions, see [Network ATC overview](../concepts/network-atc-overview.md). 

If you have feedback or encounter any issues, review the Requirements and best practices section, check the Network ATC event log, and work with your Microsoft support team.

## Requirements and best practices

The following are requirements and best practices for using Network ATC in Azure Stack HCI:

- Supported on Azure Stack HCI, version 21H2 or later.

- All servers in the cluster must be running Azure Stack HCI, version 21H2.

- Must use two or more physical host systems that are Azure Stack HCI certified.

- Adapters in the same Network ATC intent must be symmetric (of the same make, model, speed, and configuration) and available on each cluster node. For more information on adapter symmetry, see [Switch Embedded Teaming (SET)](../concepts/host-network-requirements.md#set)

- Each physical adapter specified in an intent, must use the same name on all nodes in the cluster.

- Ensure each network adapter has an "Up" status, as verified by the PowerShell `Get-NetAdapter` cmdlet.

- Install features from [Step 1.3: Install roles and features](../deploy/create-cluster-powershell.md#step-13-install-roles-and-features).

- Best practice: Insert each adapter in the same PCI slot(s) in each host. This leads to ease in automated naming conventions by imaging systems.

- Best practice: Configure the physical network (switches) prior to Network ATC including VLANs, MTU, and DCB configuration. See [Physical Network Requirements](../concepts/physical-network-requirements.md) for more information.

> [!IMPORTANT]
> Deploying Network ATC in virtual environments is not supported. Several of the host networking properties it configures are not available in virtual machines, which will result in errors.    

## Common Network ATC commands

There are several new PowerShell commands included with Network ATC. Run the`Get-Command -ModuleName NetworkATC` cmdlet to identify them. Ensure PowerShell is run as an administrator.

Typically, only a few of these cmdlets are needed. Here is a brief overview of the cmdlets before you start:

|PowerShell command|Description|
|--|--|
|Add-NetIntent|Creates and submits an intent|
|Set-NetIntent|Modifies an existing intent|
|Get-NetIntent|Gets a list of intents|
|Get-NetIntentStatus|Gets the status of intents|
|Update-NetIntentAdapter|Updates the adapters managed by an existing intent|
|Remove-NetIntent|Removes an intent from the local node or cluster. This does not destroy the invoked configuration.|
|Set-NetIntentRetryState|This command instructs Network ATC to try implementing the intent again if it has failed after three attempts. (`Get-NetIntentStatus` = 'Failed').|

You can also modify the default configuration Network ATC creates using overrides. To see a list of possible override commandlets, use the following command:

```powershell
Get-Command -Noun NetIntent*Over* -Module NetworkATC
```

For more information on overrides, see [Update an intent override](../manage/manage-network-atc.md#update-an-intent-override).

## Example intents

Network ATC modifies how you deploy host networking, not what you deploy. Multiple scenarios may be implemented so long as each scenario is supported by Microsoft. Here are some examples of common deployment options, and the PowerShell commands needed. These are not the only combinations available but they should give you an idea of the possibilities.

For simplicity we only demonstrate two physical adapters per SET team, however it is possible to add more. Refer to [Plan Host Networking](../concepts/host-network-requirements.md) for more information.

### Fully converged intent

For this intent, compute, storage, and management networks are deployed and managed across all cluster nodes.

:::image type="content" source="media/network-atc/network-atc-2-full-converge.png" alt-text="Fully converged intent"  lightbox="media/network-atc/network-atc-2-full-converge.png":::

```powershell
Add-NetIntent -Name ConvergedIntent -Management -Compute -Storage -ClusterName HCI01 -AdapterName pNIC01, pNIC02
```

### Converged compute and storage intent; separate management intent

Two intents are managed across cluster nodes. Management uses pNIC01, and pNIC02; Compute and storage are on different adapters.

:::image type="content" source="media/network-atc/network-atc-3-separate-management-compute-storage.png" alt-text="Storage and compute converged intent"  lightbox="media/network-atc/network-atc-3-separate-management-compute-storage.png":::

```powershell
Add-NetIntent -Name Mgmt -Management -ClusterName HCI01 -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute_Storage -Compute -Storage -ClusterName HCI01 -AdapterName pNIC03, pNIC04
```

### Fully disaggregated intent

For this intent, compute, storage, and management networks are all managed on different adapters across all cluster nodes.

:::image type="content" source="media/network-atc/network-atc-4-fully-disaggregated.png" alt-text="Fully disaggregated intent"  lightbox="media/network-atc/network-atc-4-fully-disaggregated.png":::

```powershell
Add-NetIntent -Name Mgmt -Management -ClusterName HCI01 -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute -Compute -ClusterName HCI01 -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Storage -Storage -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```

### Storage-only intent

For this intent, only storage is managed. Management and compute adapters are not be managed by Network ATC.

:::image type="content" source="media/network-atc/network-atc-5-fully-disaggregated-storage-only.png" alt-text="Storage only intent"  lightbox="media/network-atc/network-atc-5-fully-disaggregated-storage-only.png":::

```powershell
Add-NetIntent -Name Storage -Storage -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```

### Compute and management intent

For this intent, compute and management networks are managed, but not storage.

:::image type="content" source="media/network-atc/network-atc-6-disaggregated-management-compute.png" alt-text="Management and compute intent"  lightbox="media/network-atc/network-atc-6-disaggregated-management-compute.png":::

```powershell
Add-NetIntent -Name Management_Compute -Management -Compute -ClusterName HCI01 -AdapterName pNIC01, pNIC02
```

### Multiple compute (switch) intent

For this intent, multiple compute switches are managed.

:::image type="content" source="media/network-atc/network-atc-7-multiple-compute.png" alt-text="Multiple switches intent"  lightbox="media/network-atc/network-atc-7-multiple-compute.png":::

```powershell
Add-NetIntent -Name Compute1 -Compute -ClusterName HCI01 -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Compute2 -Compute -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```


## Default Network ATC values

This section lists some of the key default values used by Network ATC.

### Default VLANs

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

```powershell
Add-NetIntent -Name Cluster_ComputeStorage -Storage -ClusterName HCI01 -AdapterName pNIC01, pNIC02, pNIC03, pNIC04
```

The physical NIC (or virtual NIC if required) is configured to use VLANs 711, 712, 713, and 714 respectively.

> [!NOTE]
> Network ATC allows you to change the VLANs used with the `StorageVlans` parameter on `Add-NetIntent`.

### Default Data Center Bridging (DCB) configuration

Network ATC establishes the following priorities and bandwidth reservations. This configuration should also be configured on the physical network.

|Policy|Use|Default Priority|Default Bandwidth Reservation|
|--|--|--|--|
|Cluster|Cluster Heartbeat reservation|7|2% if the adapter(s) are <= 10 Gbps; 1% if the adapter(s) are > 10 Gbps|
|SMB_Direct|RDMA Storage Traffic|3|50%|
|Default|All other traffic types|0|Remainder|

> [!NOTE]
> Network ATC allows you to override default settings like default bandwidth reservation. For examples, see [Update an intent override](../manage/manage-network-atc.md#update-an-intent-override).

## Next steps

- Manage your Network ATC deployment. See [Manage Network ATC](../manage/manage-network-atc.md).

- Learn more about [Stretched clusters](../concepts/stretched-clusters.md).