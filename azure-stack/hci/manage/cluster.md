---
title: Manage Azure Stack HCI clusters - Windows Admin Center
description: Learn to manage your clusters on Azure Stack HCI using Windows Admin Center.
ms.topic: how-to
author: v-dasis
ms.author: v-dasis
ms.reviewer: jgerend
ms.date: 01/22/2021
---

# Manage Azure Stack HCI clusters using Windows Admin Center

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

Windows Admin Center can be used to manage your Azure Stack HCI clusters. Specifically, you will be using the Cluster Manager feature in Windows Admin Center to manage your clusters.

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

## Change storage settings

You can select to use server memory to cache frequent reads and specify the maximum memory to be used per sever. For more information, see [Understanding the cache in Azure Stack HCI](../concepts/cache.md).

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, select **Settings** at the bottom.
1. Select **In-memory cache** and enter the new name.

    :::image type="content" source="media/manage-cluster/cluster-settings-memory.png" alt-text="cluster In-memory cache screen" lightbox="media/manage-cluster/cluster-settings-memory.png":::

1. You can change the name of the storage pool that Storage Spaces Direct uses. Select **Storage pools** and enter the new name. This is applicable for stretched clusters.

    :::image type="content" source="media/manage-cluster/cluster-settings-storage-pools.png" alt-text="cluster storage pool screen" lightbox="media/manage-cluster/cluster-settings-storage-pools.png":::

1. You can change Storage Spaces Direct settings. Select **Storage Spaces Direct** and change the following settings as needed:

    - **Persistent cache** - enable or disable the persistent cache
    - **Cache mode for HDD** - change the cache mode for HDD drives
    - **Cache mode for SSD** - change the cache for SSD drives

    :::image type="content" source="media/manage-cluster/cluster-settings-storage-spaces-direct.png" alt-text="cluster Storage Spaces Direct screen" lightbox="media/manage-cluster/cluster-settings-storage-spaces-direct.png":::

## Change cluster settings

There are several general settings that can be applied to your cluster. Here is where you can set and manage access points, node shutdown behavior, traffic encryption, VM load balancing, and cluster witness.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, select **Settings**.
1. To change the cluster name, select **Access point** and enter the new name.

    :::image type="content" source="media/manage-cluster/cluster-settings-access.png" alt-text="Active/active stretched cluster scenario" lightbox="media/manage-cluster/cluster-settings-access.png":::

1. To control node shutdown behavior, select **Node shutdown behavior** and ensure the checkbox is enabled. This moves any virtual machines from the node first to allow graceful node shutdown.

    :::image type="content" source="media/manage-cluster/cluster-settings-shutdown.png" alt-text="cluster Node shutdown behavior screen" lightbox="media/manage-cluster/cluster-settings-shutdown.png":::

1. To encrypt SMB connections used to send data between cluster nodes, select **Cluster traffic encryption**, then select **Encrypt** from the dropdown boxes for the following:

   - **Core traffic** - encrypts traffic sent over NetFT (cluster virtual adapter) on port 3343

   - **Storage traffic** - encrypts Cluster Shared Volume (CSV) and Storage Bus Layer (SBL) traffic

        :::image type="content" source="media/manage-cluster/cluster-settings-encryption.png" alt-text="cluster Cluster traffic encryption screen" lightbox="media/manage-cluster/cluster-settings-encryption.png":::

1. To automatically load-balance virtual machines across the cluster, select **Virtual machine load balancing**, and do the following:

   - For **Balance virtual machines**, select the appropriate action
   - For **Aggressiveness**, select the appropriate behavior

     For information on how this works, see [Virtual Machine Load Balancing overview](/windows-server/failover-clustering/vm-load-balancing-overview).

        :::image type="content" source="media/manage-cluster/cluster-settings-vm-load.png" alt-text="cluster Virtual machine load balancing screen" lightbox="media/manage-cluster/cluster-settings-vm-load.png":::

1. To select a quorum witness type, select **Witness**, then for **Witness type** select one of the following:

   - **Cloud witness** - to use an Azure cloud resource as witness
   - **Disk witness** - to use a disk resource as witness (do not use for stretched clusters)
   - **File share witness** - to use a file share as witness

        For detailed information on how to set up a witness, see [Set up a cluster witness](witness.md). Also see [Understanding cluster and pool quorum on Azure Stack HCI](../concepts/quorum.md).

        :::image type="content" source="media/manage-cluster/cluster-settings-witness.png" alt-text="cluster Witness screen" lightbox="media/manage-cluster/cluster-settings-witness.png":::

1. To use affinity rules to control virtual machine placement across host servers and sites, select **Affinity rules**, then click **Create rule**. For detailed information on how set up rules, see [Create server and site affinity rules for VMs](vm-affinity.md).

    :::image type="content" source="media/manage-cluster/affinity-rules.png" alt-text="cluster Affinity rules screen" lightbox="media/manage-cluster/affinity-rules.png":::

1. To select how much data to send to Microsoft for diagnostics, select **Diagnostic data**, then select one of the following:

    - **Diagnostic data off (Security)** - no data is sent
    - **Required (Basic)** - minimum data sent to keep things secure and up-to-date
    - **Optional (Full)** - all applicable data sent

    :::image type="content" source="media/manage-cluster/cluster-diagnostic-data.png" alt-text="cluster Data Diagnostics screen" lightbox="media/manage-cluster/cluster-diagnostic-data.png":::

## Change Hyper-V settings

There are several Hyper-V host settings that can be applied to your cluster.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Tools**, select **Settings**.
1. Select **General** and then use the following settings:

   - **Virtual Hard Disks Path** - specify the default folder for storing virtual hard disk files.

   - **Virtual Machines Path** - specify the default folder for storing the virtual machine configuration files.

        :::image type="content" source="media/manage-cluster/cluster-settings-hyperv.png" alt-text="cluster Hyper-V General settings  screen" lightbox="media/manage-cluster/cluster-settings-hyperv.png":::

1. To allow redirection of local devices and resources from virtual machines, select **Enhanced Session Mode**. Note that enhanced session mode connections require a supported guest operating system.

    :::image type="content" source="media/manage-cluster/cluster-settings-session.png" alt-text="cluster Hyper-V Enhanced Session Mode screen" lightbox="media/manage-cluster/cluster-settings-session.png":::

1. To allow virtual machines to span physical NUMA nodes, select **NUMA Spanning**. Non-uniform memory architecture (NUMA) spanning can provide a virtual machine with more memory than what is available on a single NUMA node.

    :::image type="content" source="media/manage-cluster/cluster-settings-numa.png" alt-text="cluster NUMA Spanning screen" lightbox="media/manage-cluster/cluster-settings-numa.png":::

1. To specify the number of VMs that can be simultaneously moved while running (live migrated), select **Live Migration**, select a number, then specify the following:

   - for **Authentication Protocol**, select either **CredSSP** or **Kerberos**.

   - for **Performance Options**, select either **Compression** or **SMB**. Compressed data is sent over a TCP/IP connection.

   - enable the **Use any network** checkbox to use any available network on a node to perform the migration

        :::image type="content" source="media/manage-cluster/cluster-settings-live-migration.png" alt-text="cluster Live Migration screen" lightbox="media/manage-cluster/cluster-settings-live-migration.png":::

1. To specify the number of storage migrations that can be performed at the same time, select **Storage Migration**, then select a number.

    :::image type="content" source="media/manage-cluster/cluster-settings-storage-migration.png" alt-text="cluster Storage Migration screen" lightbox="media/manage-cluster/cluster-settings-storage-migration.png":::

## Register the cluster with Azure

To register or unregister your cluster with Azure, select **Azure Stack HCI registration**. For detailed information on how to do this, see [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md).

:::image type="content" source="media/manage-cluster/cluster-registration.png" alt-text="cluster Azure Registration screen" lightbox="media/manage-cluster/cluster-registration.png":::

## Next steps

To monitor your cluster, see [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md).