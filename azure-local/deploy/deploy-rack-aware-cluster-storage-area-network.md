---
title: Deploy a disaggregated rack aware Azure Local cluster with SAN storage (preview)
description: Deploy a rack aware Azure Local cluster with SAN storage across two local availability zones. Configure synchronous replication, LUNs, storage paths, and failover (preview).
ms.date: 10/20/2026
ms.topic: how-to
author: mindyqdiep
ms.author: mindydiep
ai-usage: ai-assisted
---

# Deploy a disaggregated rack aware Azure Local cluster with SAN storage (preview)

This article describes how to deploy and configure a disaggregated rack aware Azure Local cluster with Storage Area Network (SAN) storage. It covers SAN preparation, synchronous replication, LUN configuration, cluster deployment, storage paths, local availability zones, and deployment validation.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Overview

Azure Local rack aware cluster is an advanced architecture designed to enhance fault tolerance and data distribution within an Azure Local instance. This architecture enables you to cluster nodes that are strategically placed across two physical racks in two different rooms or buildings with high bandwidth and low latency.

A rack aware cluster spans two local availability zones, with one zone representing each rack or room. Azure Local treats the zones as failure domains and distributes data and workloads so the cluster can continue operating after a zone failure.

For disaggregated rack aware clusters using SAN storage, the two-zone Azure Local topology remains unchanged, but external SAN arrays replace Storage Spaces Direct.

:::image type="content" source="media/deploy-rack-aware-cluster-storage-area-network/rack-aware-cluster-storage-area-network-topology.png" alt-text="Diagram of a rack aware cluster with Hyper-V nodes in two availability zones connected via SAN Fabrics A and B to SAN Arrays A and B with synchronous replication." lightbox="media/deploy-rack-aware-cluster-storage-area-network/rack-aware-cluster-storage-area-network-topology.png":::

The deployment includes:

- Two physical racks or local availability zones that contain the Azure Local nodes.

- Two SAN arrays, with one array associated with each rack-level failure domain.

- Synchronous array replication configured before cluster deployment.

- Fibre Channel host connectivity, redundant fabrics, and multipath access to each LUN.

- A dedicated 1 GB cluster witness disk, plus infrastructure, performance history, and workload LUNs.

- Storage paths and local availability zones configured after cluster deployment.

Windows recognizes the replicated LUNs as one set of shared cluster disks with multiple paths. If a zone, array, or storage fabric becomes unavailable, the surviving array continues serving the same disks.

## Plan the deployment

Before you deploy the cluster, plan the LUNs you need for infrastructure, performance history, quorum, and workload storage.

|Purpose|Example size|Cluster use|Notes|
|----|----|----|----|
|Infrastructure|250 GB|Platform infrastructure|Confirm the current product requirements for your approved engagement.|
|Performance history|20 GB|Performance data|Confirm the current product requirements and acceptance criteria.|
|Witness|1 GB|Disk witness|Add the disk to the cluster and configure it as the quorum witness after deployment.|
|Workload storage|Workload dependent|Cluster Shared Volumes|Create one or more LUNs based on capacity, performance, and failure-domain requirements.|

## Prerequisites

Before you deploy a rack aware cluster with SAN storage, make sure your environment meets the following requirements.

### Azure Local requirements

|**Category**|**Requirements**|
|---|---|
|System requirements|All Azure Local system requirements apply to rack aware clusters. See [System requirements for Azure Local](../concepts/system-requirements-23h2.md).|
|Supported node configurations|- 1+1 (2-node cluster)<br>- 2+2 (4-node cluster)<br>- 3+3 (6-node cluster)<br>- 4+4 (8-node cluster)<br>- 5+5 (10-node cluster)<br>- 6+6 (12-node cluster)<br>- 7+7 (14-node cluster)<br>- 8+8 (16-node cluster)|
|Local availability zones|- Supports two local availability zones with a maximum of eight machines per zone.<br>- The two zones contain an equal number of machines.<br>- A machine can belong to only one zone.|
|Deployment type|Only new deployments are supported. Conversion from standard clusters deployments to rack aware clusters isn't supported.|
|Latency |Round-trip latency between racks must be 5 milliseconds or less.|

### SAN and Fibre Channel requirements

- Install Windows Server 2025-certified Fibre Channel host bus adapters and supported drivers on all nodes.

- Provide redundant fabrics and validate physical paths, switch zoning, array ports, and host registrations.

- Verify Multipath I/O (MPIO) on every node and register the storage device with Microsoft Device Specific Module by using the storage-vendor guidance.

- Configure LUN masking so every required node sees the correct devices through the expected paths.

- Keep SAN devices offline on the hosts until the procedure instructs you to bring them online.

- Confirm that replicated LUNs retain consistent identity, capacity, sector size, and presentation after array failover.

### Supported SAN solutions

|**Partner**|**Feature**|
|---|---|
|Pure Storage|ActiveCluster|
|Dell Technologies|PowerStore Metro Volume, **PowerFlex isn't supported**|
|NetApp|SnapMirror Active Sync|
|Hitachi Vantara|Global-Active Device (GAD)|
|HPE|Peer Persistence (transparent-failover variant)|

## Deploy the cluster

Use the following steps to prepare the SAN, deploy the Azure Local cluster, and configure storage and local availability zones.

### Step 1: Configure synchronous replication

Before you deploy the cluster, configure synchronous replication between the two SAN arrays.

1. Create the replication relationship between the two arrays.

1. Configure full synchronous replication for every LUN that the cluster uses.

1. Use the storage vendor tools to verify replication health, write-order consistency, preferred-array behavior, and recovery procedures.

1. Record the replication group, source and target volumes, serial numbers, and operational owner in the change record.

### Step 2: Create the LUNs

Create the required LUNs on the SAN arrays and add them to the synchronous replication group before you present them to the hosts.

1. Create the infrastructure, performance history, witness, and workload LUNs defined in your plan.

1. Apply the approved storage vendor volume settings.

1. Add each LUN to the synchronous replication group before you present it to the hosts.

1. Document the intended role of each LUN.

### Step 3: Zone and present the LUNs

Configure Fibre Channel zoning and present the LUNs so that each intended cluster node has redundant paths to the required storage.

1. Collect the Fibre Channel worldwide port names (WWPNs) from every node.

    ```powershell
    Get-InitiatorPort | Where-Object ConnectionType -eq 'Fibre Channel' | Select-Object NodeAddress, PortAddress, ConnectionType | Format-Table -AutoSize
    ```

1. Register the hosts or host group on both arrays.

1. Create redundant single-initiator zoning according to the fabric and array vendor design.

1. Present each required LUN to every intended cluster node.

1. Validate the expected number of paths for each disk on every node.

    ```powershell
    (Get-WmiObject -Namespace root\wmi -Class mpio_disk_info).driveinfo | ForEach-Object { Write-Host "Name: $($.name) Paths: $($.numberpaths)" }
    ```

### Step 4: Deploy the disaggregated cluster

Follow the general deployment steps in [Deploy an Azure Local system using the Azure portal](./deploy-via-portal-disaggregated.md). For a disaggregated rack aware cluster, use the following deployment settings:

1. Start a new Azure Local deployment and select the **Standard** cluster option and **Storage Area Network (SAN)** storage option. Don't select the **Rack aware** cluster option.

1. Add the registered machines, validate node readiness, and enter the deployment configuration.

1. Complete the networking, management, security, and validation settings for the deployment. Select a **Disk witness** as the system witness type in the Advanced tab.

1. Deploy the cluster.

1. Verify the Azure Local resource, Azure Arc-enabled servers, Arc Resource Bridge, custom location, and associated resources.

### Step 5: Add the witness and workload LUNs

1. On one node, verify that the intended SAN disks are visible and uniquely identifiable. Confirm each disk by serial number and size before you change its state.

1. Bring only the intended new disks online, initialize them if required, and format the witness and workload LUNs with NTFS.

1. Review the disks that are available to the cluster.

    ```powershell
    Get-Disk | Sort-Object Number
    Get-ClusterAvailableDisk
    ```

1. After you identify and prepare the correct disks, add them to the cluster.

    ```powershell
    Get-ClusterAvailableDisk | Add-ClusterDisk
    ```

1. Rename the cluster disk resources with purpose-based names, such as RAC-SAN-Witness and RAC-SAN-User01.

### Step 6: Convert workload LUNs to CSVs

1. Confirm that each workload LUN is online, healthy, formatted, and owned by the cluster.

1. Add each workload disk to Cluster Shared Volumes.

    ```powershell
    Add-ClusterSharedVolume -Name 'RAC-SAN-User01'
    Get-ClusterSharedVolume
    ```

1. Verify the CSV mount paths under C:\ClusterStorage and confirm access from every node.

### Step 7: Create Azure Local storage paths

1. Create an Azure Local storage path for each CSV that will host virtual machines.

1. Use a naming convention that maps each Azure resource to its CSV and replication group.

### Step 8: Configure local availability zones and logical networks

1. [Configure local availability zones](../manage/configure-local-availability-zones-disaggregated.md) and map each node to the local availability zone that represents its physical rack.

1. Create the logical networks required for workload connectivity, including VLAN, subnet, address allocation, DNS, and gateway settings.

1. Create and validate virtual machine placement in each zone.

1. Confirm workload network connectivity from both racks.

## Validate the deployment

|Area|Validation|Pass criteria|
|----|----|----|
|Replication|Review every replicated LUN on both arrays.|All relationships are fully synchronous, with no degraded or paused relationships.|
|Pathing|Inspect each SAN disk from every node.|The expected redundant paths are healthy, with no unexpected duplicate devices.|
|Cluster|Run cluster validation and inspect cluster resources.|No unresolved storage, networking, system-configuration, or inventory failures affect the design.|
|Quorum|Review the active quorum configuration.|The dedicated disk witness is selected and online.|
|CSV|Review CSV state and access from every node.|All workload CSVs are online and accessible under C:\ClusterStorage.|
|Azure integration|Review storage paths and virtual-machine creation.|The intended storage paths are visible and selectable.|
|Fault domains|Verify the node-to-zone mapping.|Each node is assigned to its physical rack or zone.|
|Workload networking|Deploy or test a virtual machine in each zone.|The expected logical network, VLAN, addressing, DNS, and gateway connectivity work.|
|Planned and unplanned failover|Test approved array, node, and full-zone failure scenarios.|Storage remains available, and cluster resources recover without data inconsistency.|

## Next steps

- [Provision VMs in local availability zone for Azure Local](../concepts/rack-aware-cluster-provision-vm-local-availability-zone.md)
- [Spread Azure Kubernetes Service (AKS) nodes in rack aware cluster](../concepts/rack-aware-cluster-aks-nodes.md)