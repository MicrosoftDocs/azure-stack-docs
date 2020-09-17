---
title: Manage Azure Stack HCI clusters - Windows Admin Center
description: Learn to manage your clusters on Azure Stack HCI using Windows Admin Center.
ms.topic: how-to
author: v-dasis
ms.author: v-dasis
ms.reviewer: jgerend
ms.date: 07/21/2020
---

# Manage Azure Stack HCI clusters using Windows Admin Center

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

Windows Admin Center can be used to manage your Azure Stack HCI clusters. Specifically, you will be using the Cluster Manager extension in Windows Admin Center to manage your clusters.

## View the cluster dashboard

The cluster dashboard displays information regarding cluster health and performance.

:::image type="content" source="media/manage-cluster/cluster-dashboard.png" alt-text="Cluster Dashboard screen" lightbox="media/manage-cluster/cluster-dashboard.png":::

To view this information, select the cluster name under **All connections**, then under **Tools** on the left, select **Dashboard**. You can view the following:

- Cluster event alerts
- List of the servers joined to the cluster
- List of virtual machines running on the cluster
- List of disk drives available on the cluster
- List of volumes available on the cluster
- Total cluster CPU usage for the cluster
- Total cluster memory usage for the cluster
- Total cluster storage usage for the cluster
- Total cluster input/output operations/second (IOPS)
- Average cluster latency in milliseconds

## Change cluster storage settings

There are two settings you can change related to Storage Spaces Direct that can be applied to your cluster.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, select **Settings** at the bottom.
1. To configure the storage cache, select **Storage Spaces Direct**, then configure the following:

   - for **Persistent cache**, select either **Enabled** or **Disabled**

   - for **Cache mode for HDD**, select **Read only**, **Write only**, or **Read/Write**

   - for **Cache mode for SSD**, select **Read only**, **Write only**, or **Read/Write**

        :::image type="content" source="media/manage-cluster/cluster-settings-ssd.png" alt-text="cluster Storage Spaces Direct screen" lightbox="media/manage-cluster/cluster-settings-ssd.png":::

1. To use server memory to cache frequent reads, select **In-memory cache** and specify the maximum memory to be used per sever. Also see [Understanding the cache in Azure Stack HCI](../concepts/cache.md).

    :::image type="content" source="media/manage-cluster/cluster-settings-memory.png" alt-text="cluster In-memory cache screen" lightbox="media/manage-cluster/cluster-settings-memory.png":::

## Change cluster general settings

There are five general settings that can be applied to your cluster. Here is where you can set and manage access points, node shutdown behavior, traffic encryption, VM load balancing, and cluster witness.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, select **Settings**.
1. To change the cluster name, select **Access point** and enter the new name.

    :::image type="content" source="media/manage-cluster/cluster-settings-access.png" alt-text="Active/active stretched cluster scenario" lightbox="media/manage-cluster/cluster-settings-access.png":::

1. To control node shutdown behavior, select **Node shutdown behavior** and ensure the checkbox is enabled. This moves any virtual machines from the node first to allow graceful node shutdown.

    :::image type="content" source="media/manage-cluster/cluster-settings-shutdown.png" alt-text="cluster Node shutdown behavior screen" lightbox="media/manage-cluster/cluster-settings-shutdown.png":::

1. To encrypt SMB connections used to send data between cluster nodes, select **Cluster traffic encryption**, then select **Encrypt** from the dropdown boxes for the following:

   - **Core traffic** - encrypts traffic sent over NetFT (cluster virtual adapter) on port 3343

   - **Server traffic** - encrypts Cluster Shared Volume (CSV) and Storage Bus Layer (SBL) traffic

        :::image type="content" source="media/manage-cluster/cluster-settings-encryption.png" alt-text="cluster Cluster traffic encryption screen" lightbox="media/manage-cluster/cluster-settings-encryption.png":::

1. To automatically load-balance virtual machines across the cluster, select **Virtual machine load balancing**, and do the following:

   - For **Balance virtual machines**, select the appropriate action
   - For **Aggressiveness**, select the appropriate behavior

     For information on how this works, see [Virtual Machine Load Balancing overview](/windows-server/failover-clustering/vm-load-balancing-overview).

        :::image type="content" source="media/manage-cluster/cluster-settings-vm-load.png" alt-text="cluster Virtual machine load balancing screen" lightbox="media/manage-cluster/cluster-settings-vm-load.png":::

1. To select a quorum witness type, select **Witness**, then select one of the following:

   - **Cloud witness** - to use an Azure cloud resource as witness
   - **Disk witness** - to use a disk resource as witness (do not use for stretched clusters)
   - **File share witness** - to use a file share as witness

        For more information, see [Understanding cluster and pool quorum on Azure Stack HCI](../concepts/quorum.md).

        :::image type="content" source="media/manage-cluster/cluster-settings-witness.png" alt-text="cluster Witness screen" lightbox="media/manage-cluster/cluster-settings-witness.png":::

## Change cluster Hyper-V settings

There are five Hyper-V host settings that can be applied to your cluster.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, select **Settings**.
1. Select **General** and then use the following settings:

   - **Virtual Hard Disks Path** - specify the default folder for storing virtual hard disk files.

   - **Virtual Machines Path** - specify the default folder for storing the virtual machine configuration files.

   - **Hypervisor Scheduler Type** - select **Core Scheduler** or **Classic Scheduler**. This determines how the hypervisor schedules virtual processes to run on physical processors that use simultaneous multi-threading (also known as SMT or hyper-threading).

        :::image type="content" source="media/manage-cluster/cluster-settings-hyperv.png" alt-text="cluster Hyper-V General settings  screen" lightbox="media/manage-cluster/cluster-settings-hyperv.png":::

1. To allow redirection of local devices and resources from virtual machines, select **Enhanced Session Mode**. Note that enhanced session mode connections require a supported guest operating system.

    :::image type="content" source="media/manage-cluster/cluster-settings-session.png" alt-text="cluster Hyper-V Enhanced Session Mode screen" lightbox="media/manage-cluster/cluster-settings-session.png":::

1. To allow virtual machines to span physical NUMA nodes, select **NUMA Spanning**. Non-uniform memory architecture (NUMA) spanning can provide a virtual machine with more memory than what is available on a single NUMA node.

    :::image type="content" source="media/manage-cluster/cluster-settings-numa.png" alt-text="cluster NUMA Spanning screen" lightbox="media/manage-cluster/cluster-settings-numa.png":::

1. To specify the number of VMs that can be simultaneously moved while running (live migrated), select **Live Migration**, select a number, then specify the following:

   - for **Authentication Protocol**, select either **CredSSP** or **Kerberos**.

   - for **Performance Option**, select either **Compression** or **SMB**. Compressed data is sent over a TCP/IP connection.

   - enable the **Use any network** checkbox to use any available network on a node to perform the migration

        :::image type="content" source="media/manage-cluster/cluster-settings-liv-migration.png" alt-text="cluster Live Migration screen" lightbox="media/manage-cluster/cluster-settings-liv-migration.png":::

1. To specify the number of storage migrations that can be performed at the same time, select **Storage Migration**, then select a number.

    :::image type="content" source="media/manage-cluster/cluster-settings-sto-migration.png" alt-text="cluster Storage Migration screen" lightbox="media/manage-cluster/cluster-settings-sto-migration.png":::

## Next steps

- To monitor your cluster, see [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md).
