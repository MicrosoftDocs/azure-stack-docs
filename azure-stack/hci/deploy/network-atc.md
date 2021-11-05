---
title: Simplify host networking with Network ATC
description: This topic covers how to simplify host networking for Azure Stack HCI.
author: v-dasis
ms.topic: how-to
ms.date: 10/19/2021
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Simplify host networking with Network ATC

> Applies to: Azure Stack HCI, version 21H2

This article guides you through the key functions of using Network ATC, which simplifies the deployment and network configuration management for Azure Stack HCI clusters. This provides an intent-based approach to host network deployment. By specifying one or more intents (management, compute, or storage) for a network adapter, you can automate the deployment of the intended configuration.

If you have feedback or encounter any issues, review the Requirements and best practices section, check the Network ATC event log, and work with your Microsoft support team.

## Overview

Deployment and operation of Azure Stack HCI networking can be a complex and error-prone process. Due to the configuration flexibility provided with the host networking stack, there are many moving parts that can be easily misconfigured or overlooked. Staying up to date with the latest best practices is also a challenge as improvements are continuously made to the underlying technologies. Additionally, configuration consistency across HCI cluster nodes is important as it leads to a more reliable experience.

Network ATC can help:

- Reduce host networking deployment time, complexity, and errors
- Deploy the latest Microsoft validated and supported best practices
- Ensure configuration consistency across the cluster
- Eliminate configuration drift

## Definitions

Here is some new terminology:

**Intent**: An intent is a definition of how you intend to use the physical adapters in your system. An intent has a friendly name, identifies one or more physical adapters, and includes one or more intent types.

An individual physical adapter can only be included in one intent. By default, an adapter does not have an intent (there is no special status or property given to adapters that don’t have an intent). You can have multiple intents; the number of intents you have will be limited by the number of adapters in your system.

**Intent type**: Every intent requires one or more intent types. The currently supported intent types are:

- Management - adapters are used for management access to nodes
- Compute - adapters are used to connect virtual machine (VM) traffic to the physical network
- Storage - adapters are used for SMB traffic including Storage Spaces Direct

Any combination of the intent types can be specified for any specific single intent. However, certain intent types can only be specified in one intent:

- Management: Can be defined in a maximum of one intent
- Compute: Unlimited
- Storage: Can be defined in a maximum of one intent

**Intent mode**: An intent can be specified at a standalone level or at a cluster level. Modes are system-wide; you can't have an intent that is standalone and another that is clustered on the same host system. Clustered mode is the most common choice as Azure Stack HCI nodes are clustered.

- *Standalone mode*: Intents are expressed and managed independently for each host. This mode allows you to test an intent before implementing it across a cluster. Once a host is clustered, any standalone intents are ignored. Standalone intents can be copied to a cluster from a node that is not a member of that cluster, or from one cluster to another cluster.

- *Cluster mode*: Intents are applied to all cluster nodes. This is the recommended deployment mode and is required when a server is a member of a failover cluster.

**Override**: By default, Network ATC deploys the most common configuration, asking for the smallest amount of user input. Overrides allow you to customize your deployment if required. For example, you may choose to modify the VLANs used for storage adapters from the defaults.

Network ATC allows you to modify all configuration that the OS allows. However, the OS limits some modifications to the OS and Network ATC respects these limitations. For example, a virtual switch does not allow modification of SR-IOV after it has been deployed.

## Requirements and best practices

The following are requirements and best practices for using Network ATC in Azure Stack HCI:

- Supported on Azure Stack HCI, version 21H2 or later.

- All servers in the cluster must be running Azure Stack HCI, version 21H2.

- Must use two or more physical host systems that are Azure Stack HCI certified.

- Adapters in the same Network ATC intent must be symmetric (of the same make, model, speed, and configuration) and available on each cluster node. For more information on adapter symmetry, see [Switch Embedded Teaming (SET)](../concepts/host-network-requirements.md#set)

- Each physical adapter specified in an intent, must use the same name on all nodes in the cluster.

- Ensure each network adapter has an "Up" status, as verified by the PowerShell `Get-NetAdapter` cmdlet.

- Cluster nodes must install the following Azure Stack HCI features on each node:

  - Network ATC
  - Data Center Bridging (DCB)
  - Failover Clustering
  - Hyper-V

- Best practice: Insert each adapter in the same PCI slot(s) in each host. This leads to ease in automated naming conventions by imaging systems.

- Best practice: Configure the physical network (switches) prior to Network ATC including VLANs, MTU, and DCB configuration. See [Physical Network Requirements](../concepts/physical-network-requirements.md) for more information.

You can use the following cmdlet to install the required Windows features:

> [!NOTE]
> Network ATC does not require a system reboot if the other Azure Stack HCI features have already been installed.

## Common Network ATC commands

There are several new PowerShell commands included with Network ATC. Run the`Get-Command -ModuleName NetworkATC` cmdlet to identify them. Ensure PowerShell is run as an administrator.

Typically, only a few of these cmdlets are needed. Here is a brief overview of the cmdlets before you start:

|PowerShell command|Description|
|--|--|
|Add-NetIntent|Creates and submits an intent|
|Set-NetIntent|Modifies an existing intent|
|Get-NetIntent|Gets a list of intents|
|Get-NetIntentStatus|Gets the status of intents|
|Set-NetIntentAdapter|Sets the adapters managed by an existing intent|
|Remove-NetIntent|Removes an intent from the local node or cluster. This does not destroy the invoked configuration.|
|Set-NetIntentRetryState|This command instructs Network ATC to try implementing the intent again if it has failed after three attempts. (`Get-NetIntentStatus` = 'Failed').|

You can also modify the default configuration Network ATC creates using overrides. To see a list of possible override commandlets, use the following command:

```powershell
Get-Command -Noun NetIntent*Over* -Module NetworkATC
```

> [!IMPORTANT]
> Network ATC implements the Microsoft-tested, **Best Practice** configuration. We highly recommend that you only modify the default configuration with guidance from Microsoft Azure Stack HCI support teams.

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

## Deploy intents

The following activities represent common host networking deployment tasks using Network ATC. You can specify any combination of the following types of intents:

- Compute – adapters will be used to connect virtual machines traffic to the physical network
- Storage – adapters will be used for SMB traffic including Storage Spaces Direct
- Management – adapters will be used for management access to nodes. This intent is not covered in this article, but feel free to explore.

This article covers the following deployment tasks:

- Configure an intent

- Configure an intent override

- Validate automatic remediation

This article assumes you have already created a cluster. See [Create a cluster using PowerShell](create-cluster-powershell.md).



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

### Default Data Center Bridging (DCB) configuration

Network ATC establishes the following priorities and bandwidth reservations. This configuration should also be configured on the physical network.

|Policy|Use|Default Priority|Default Bandwidth Reservation|
|--|--|--|--|
|Cluster|Cluster Heartbeat reservation|7|2% if the adapter(s) are <= 10 Gbps; 1% if the adapter(s) are > 10 Gbps|
|SMB_Direct|RDMA Storage Traffic|3|50%|
|Default|All other traffic types|0|Remainder|

## Next steps

- Manage your Network ATC deployment. See [Manage Network ATC](../manage/manage-network-atc.md).

- Learn more about [Stretched clusters](../concepts/stretched-clusters.md).