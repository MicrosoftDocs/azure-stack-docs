---
title: Manage Azure Stack HCI clusters - Windows Admin Center
description: Learn to manage your Azure Stack HCI clusters using Windows Admin Center.
ms.topic: how-to
author: ManikaDhiman
ms.author: v-mandhiman
ms.reviewer: stevenek
ms.date: 10/11/2022
---

# Manage Azure Stack HCI clusters using Windows Admin Center

> Applies to: Azure Stack HCI, versions 22H2, 21H2, and 20H2; Windows Server 2022, Windows Server 2019

Windows Admin Center can be used to manage your Azure Stack HCI clusters. Specifically, you'll be using the Cluster Manager feature in Windows Admin Center to manage your clusters.

## View the cluster dashboard

The cluster dashboard displays information regarding cluster health and performance.

   :::image type="content" source="media/manage-cluster/2022/dashboard.png" alt-text="Cluster Dashboard screen" lightbox="media/manage-cluster/2022/dashboard.png":::

To view this information, select the cluster name under **All connections**. Then under **Tools**, on the left, select **Dashboard**. You can view the following details:

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
- Azure Stack HCI registration
- Arc-enabled statuses

## Change storage settings

You can select to use server memory to cache frequent reads and specify the maximum memory to be used per server. For more information, see [Understanding the cache in Azure Stack HCI](../concepts/cache.md).

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
2. Under **Tools**, select **Settings**.

- To change your in-memory cache, select **In-memory cache** and set the memory per server to cache reads. Note, writes can't be cached in memory.

   :::image type="content" source="media/manage-cluster/2022/in-memory-cache.png" alt-text="cluster In-memory cache screen" lightbox="media/manage-cluster/2022/in-memory-cache.png":::

- You can change the Storage pool friendly name that Storage Spaces Direct uses, adjust Storage Spaces Direct settings, and more by selecting **Storage Spaces and pools**. This setting is applicable for stretched clusters as well.

     - **Cache State** - enable or disable persistent cache
     
     - **Cache mode for HDD** - change the cache mode for HDD drives
     
     - **Cache mode for SSD** - change the cache for SSD drives

    :::image type="content" source="media/manage-cluster/2022/storage-spaces-and-pools.png" alt-text="cluster Storage Spaces and pools screen" lightbox="media/manage-cluster/2022/storage-spaces-and-pools.png":::

## Change cluster settings

There are several general settings that can be applied to your cluster. Here's where you can view properties, node shutdown behavior, VM load balancing, cluster witness, and affinity rules.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
2. Under **Tools**, select **Settings**.

- To access comprehensive cluster, operating system and hardware related information, select **Properties**.

    :::image type="content" source="media/manage-cluster/2022/properties.png" alt-text="Active/active stretched cluster scenario" lightbox="media/manage-cluster/2022/properties.png":::

- To control node shutdown behavior, select **Node shutdown behavior** and ensure the checkbox is enabled. This setting moves any virtual machines from the node first to allow graceful node shutdown.

    :::image type="content" source="media/manage-cluster/2022/node-shutdown-behavior.png" alt-text="cluster Node shutdown behavior screen" lightbox="media/manage-cluster/2022/node-shutdown-behavior.png":::

- To automatically load-balance virtual machines, across the cluster, select **Virtual machine load balancing** and do the following:

   - For **Balance virtual machines** select the appropriate action
   
   - For **Aggressiveness** select the appropriate behavior

     For information on how load-balance virtual machines works, see [Virtual Machine Load Balancing overview](/windows-server/failover-clustering/vm-load-balancing-overview).

    :::image type="content" source="media/manage-cluster/2022/vm-load-balancing.png" alt-text="cluster Virtual machine load balancing screen" lightbox="media/manage-cluster/2022/vm-load-balancing.png":::

- To choose a quorum witness type select **Witness**. Then for **Witness type** select one of the following:

   - **Cloud witness** - to use an Azure cloud resource as witness

   - **Disk witness** - to use a disk resource as witness (don't use for stretched clusters or clusters using Azure Stack HCI or Storage Spaces Direct)
   
   - **File share witness** - to use a file share as witness

    For detailed information on how to set up a witness, see [Set up a cluster witness](witness.md). Also, see [Understanding cluster and pool quorum on Azure Stack HCI](../concepts/quorum.md).

    :::image type="content" source="media/manage-cluster/2022/witness.png" alt-text="cluster Witness screen" lightbox="media/manage-cluster/2022/witness.png":::

- To use affinity rules to control virtual machine placement, across host servers and sites, select **Affinity rules**. Then select **Create rule**. For detailed information on how set up rules, see [Create server and site affinity rules for VMs](vm-affinity.md).

    :::image type="content" source="media/manage-cluster/2022/affinity-rules.png" alt-text="cluster Affinity rules screen" lightbox="media/manage-cluster/2022/affinity-rules.png":::

## Change Hyper-V settings

There are several Hyper-V host settings that can be applied to your cluster.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
2. Under **Tools** select **Settings**.

- To set virtual hard disk and virtual machine paths, select **General** and then use the following settings:

   - **Virtual Hard Disks Path** - specify the default folder for storing virtual hard disk files.

   - **Virtual Machines Path** - specify the default folder for storing the virtual machine configuration files.

    :::image type="content" source="media/manage-cluster/2022/general.png" alt-text="cluster Hyper-V General settings  screen" lightbox="media/manage-cluster/2022/general.png":::

- To allow redirection of local devices and resources from virtual machines select **Enhanced Session Mode**. Note, Enhanced Session Mode connections require a supported guest operating system.

    :::image type="content" source="media/manage-cluster/2022/enhanced-session-mode.png" alt-text="cluster Hyper-V Enhanced Session Mode screen" lightbox="media/manage-cluster/2022/enhanced-session-mode.png":::

- To allow virtual machines, to span physical NUMA nodes select **NUMA Spanning**. Non-uniform memory architecture (NUMA) spanning can provide a virtual machine with more memory than what is available on a single NUMA node.

    :::image type="content" source="media/manage-cluster/2022/numa-spanning.png" alt-text="cluster NUMA Spanning screen" lightbox="media/manage-cluster/2022/numa-spanning.png":::

- To specify the number of VMs that can be simultaneously moved while running (live migrated) select **Live Migration**. Next, select a number and specify the following details:

   - For **Authentication Protocol** select either **CredSSP** or **Kerberos**.

   - For **Performance Options** select either **Compression** or **SMB**. Compressed data is sent over a TCP/IP connection.

   - Enable the **Use any network** checkbox to use any available network on a node to perform the migration

    :::image type="content" source="media/manage-cluster/2022/live-migration.png" alt-text="cluster Live Migration screen" lightbox="media/manage-cluster/2022/live-migration.png":::

- To specify the number of storage migrations that can be performed at the same time, select **Storage Migration** and then input a number. The default value is 1.

    :::image type="content" source="media/manage-cluster/2022/storage-migration.png" alt-text="cluster Storage Migration screen" lightbox="media/manage-cluster/2022/storage-migration.png":::

## Azure Stack HCI

There are several Azure Stack HCI settings that you can apply to your cluster.

- To change how often log data is collected from your cluster, if monitoring capabilities are enabled, select **Monitoring data**.

    :::image type="content" source="media/manage-cluster/2022/monitoring-data.png" alt-text="cluster Monitoring data screen" lightbox="media/manage-cluster/2022/monitoring-data.png":::

    For information on how to enable log collection, see [How do I enable log collection in Azure](../manage/monitor-hci-single.md).

- To change the Service Health data level, navigate to the Azure Stack HCI cluster in **Azure Portal**. Select **Settings**, then **Configuration**, and **Service Health data**.

    :::image type="content" source="media/manage-cluster/2022/service-health-data.png" alt-text="cluster Service health data screen" lightbox="media/manage-cluster/2022/service-health-data.png":::

> [!NOTE]
> This change can only be performed from Azure Portal. By default, Azure Stack HCI collects basic system metadata necessary to keep its service current, secure, and properly operating. For most systems, this data level doesn't need to be changed.

- To enable VM provisioning, through the Azure Portal on HCI a resource bridge is required. The resource bridge creates Azure Resource Manager entities for VMs including disks, images, interfaces, networks, custom locations, and cluster extensions. For more information, see [VM provisioning through Azure portal on Azure Stack HCI (preview)](../manage/azure-arc-enabled-virtual-machines.md).

    :::image type="content" source="media/manage-cluster/2022/resource-bridge.png" alt-text="cluster Resource bridge screen" lightbox="media/manage-cluster/2022/resource-bridge.png":::

- To utilize Azure-exclusive workloads on Azure Stack HCI that can work outside of the cloud select **Azure benefits**. To learn more, see [Azure Benefits on Azure Stack HCI](../manage/azure-benefits.md).

    :::image type="content" source="media/manage-cluster/2022/azure-benefits.png" alt-text="cluster Azure benefits screen" lightbox="media/manage-cluster/2022/azure-benefits.png":::

- To opt-in as a customer to install the next version of the Azure Stack HCI OS, before it's officially release, select **Join the preview channel**. For more information on this program, see [Join the Azure Stack HCI preview channel](../manage/preview-channel.md).

    :::image type="content" source="media/manage-cluster/2022/join-the-preview-channel.png" alt-text="cluster Join the preview channel screen" lightbox="media/manage-cluster/2022/join-the-preview-channel.png":::

## Add or remove a server from the cluster

To add or remove a server from the cluster, see [Add or remove servers for a cluster](add-cluster.md).

## Register the cluster with Azure

To register or unregister your cluster with Azure, see [Register a cluster with Azure](../deploy/register-with-azure.md).

## Remove (destroy) the cluster

Before you destroy a cluster, you must unregister it from Azure first. For more information, see [Unregister Azure Stack HCI](/azure-stack/hci/deploy/register-with-azure#unregister-azure-stack-hci-using-windows-admin-center).

You use PowerShell to destroy a cluster and its resources. For more information, see [Remove (destroy) a cluster](cluster-powershell.md#remove-a-cluster).

## Next steps

For more detailed information, see also:


- [Manage clusters with PowerShell](cluster-powershell.md).
