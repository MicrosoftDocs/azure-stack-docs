---
title: Manage clusters on Azure Stack HCI
description: Learn how to manage your hyperconverged clusters on Azure Stack HCI. 
ms.topic: article
ms.prod: 
author: v-dasis
ms.author: v-dasis
ms.reviewer: jgerend
ms.date: 03/04/2020
---

# Manage clusters on Azure Stack HCI

>Applies to: Windows Server 2019

Windows Admin Center can be used to manage your hyperconverged clusters on Azure Stack HCI hardware running Windows Server 2019 Datacenter. Specifically, you will be using the Cluster Manager extension in Windows Admin Center to manage your clusters.

## View cluster metrics ##

1. Open Windows Admin Center and click the Windows Server Cluster name under **All connections**.
1. Under **Tools** on the left, click **Servers**, then click the **Inventory** tab under **Servers** on the right. You can view the following:
    - Cluster event alerts
    - List of the servers joined to the cluster
    - List of virtual machines running on the cluster
    - List of disk drives available on the cluster
    - List of disk volumes available on the cluster
    - Total cluster CPU usage for the cluster
    - Total cluster memory usage for the cluster
    - Total cluster storage usage for the cluster
    - Total cluster input/output operations/second (IOPS)
    - Average cluster latency in milliseconds

## View cluster server inventory ##

1. Open Windows Admin Center and click the Windows Server Cluster name under **All connections**.
1. Under **Tools** on the left, click **Servers**, then click the **Inventory** tab under **Servers** on the right.
1. Select a server to view metrics for.

## Change cluster general settings ##

1. In Windows Admin Center, click **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, click **Settings**.
1. In the **Cluster** section, select the following to:
   - **Access point** - change the cluster name
   - **Node shutdown behavior** - enable virtual machine move upon shutdown
   - **Cluster traffic encryption** - encrypt all SMB connections between servers for core traffic (NetFT on port 3343) and for storage traffic (CSV and SBL) 
   - **Virtual machine load balancing** - automatically redistribute VMs to less busy nodes
   - **Witness** - select a quorum witness type for your cluster

## Change cluster networking settings ##

1. In Windows Admin Center, click **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, click **Virtual switches**.
1. Under **Virtual Switches**, select a switch and click **Settings**.
1. Make changes as needed.

## Change cluster storage settings ##

1. In Windows Admin Center, click **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, click **Settings**.
1. In the **Storage** section, select the following to:
   - **Storage Spaces Direct** - specify cache persistence, cache mode for HDD/SSD, cache page size, and cache metadata reserve.
   - **In-memory cache** - specify maximum memory per server used to boost performance.

## Change cluster Hyper-V settings ##

1. In Windows Admin Center, click **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, click **Settings**.
1. In the **Hyper-V Host Settings** section, select the following to:
   - **General** - default paths for Virtual Hard Disks and Virtual Machines Paths and Hypervisor Scheduler Type for virtual processes.
   - **Enhanced Session Mode** - allow enhanced session mode connections to VMs running on each server node.
   - **NUMA Spanning** - allow VMs to span non-uniform memory architecture (NUMA) nodes for additional computing resources.
   - **Live Migration** - enable incoming and outgoing live migrations, and specify authentication and performance options.
   - **Storage Migration** - specify how many storage migrations can be performed at the same time.

## Next Steps ##

- Learn how to add or remove server nodes from your cluster.