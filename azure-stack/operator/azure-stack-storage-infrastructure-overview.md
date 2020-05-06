---
title: Azure Stack Hub storage infrastructure overview
titleSuffix: Azure Stack
description: Learn how to manage storage infrastructure for Azure Stack Hub.
author: IngridAtMicrosoft

ms.topic: article
ms.date: 5/5/2020
ms.author: inhenkel
ms.lastreviewed: 5/5/2020
ms.reviewer: jiaha

# Intent: As an Azure Stack operator, I want to understand storage infrastructure in Azure Stack.
# Keyword: manage storage infrastructure azure stack

---


# Azure Stack Hub storage infrastructure overview

This article gives an overview of Azure Stack Hub storage infrastructure.

## Understand drives and volumes

### Drives

Powered by Windows Server software, Azure Stack Hub defines storage capabilities with a combination of Storage Spaces Direct (S2D) and Windows Server Failover Clustering. This combination provides a performant, scalable, and resilient storage service.

Azure Stack Hub integrated system partners offer many solution variations, including a wide range of storage flexibility. You currently can select up to two drive types from the three supported drive types: NVMe (non-volatile memory express), SATA/SAS SSD (solid-state drive), HDD (hard disk drive). 

Storage Spaces Direct features a cache to maximize storage performance. In an Azure Stack Hub appliance with one drive type (that is, NVMe or SSD) all drives are used for capacity. If there are two drive types, Storage Spaces Direct automatically uses all drives of the "fastest" (NVMe &gt; SSD &gt; HDD) type for caching. The remaining drives are used for capacity. The drives could be grouped into either an "all-flash" or "hybrid" deployment:

![Azure Stack Hub storage infrastructure](media/azure-stack-storage-infrastructure-overview/image1.png)

All-flash deployments aim to maximize storage performance and don't include rotational HDDs.

![Azure Stack Hub storage infrastructure](media/azure-stack-storage-infrastructure-overview/image2.png)

Hybrid deployments aim to balance performance and capacity or to maximize capacity and do include rotational HDDs.

The behavior of the cache is determined automatically based on the type(s) of drives that are being cached for. When caching for SSDs (such as NVMe caching for SSDs), only writes are cached. This reduces wear on the capacity drives, reducing the cumulative traffic to the capacity drives and extending their lifetime. In the meantime, reads aren't cached. They aren't cached because reads don't significantly affect the lifespan of flash and because SSDs universally offer low read latency. When caching for HDDs (such as SSDs caching for HDDs), both reads and writes are cached, to provide flash-like latency (often /~10x better) for both.

![Azure Stack Hub storage infrastructure](media/azure-stack-storage-infrastructure-overview/image3.png)

For the available configuration of storage, you can check Azure Stack Hub OEM partner (https://azure.microsoft.com/overview/azure-stack/partners/) for detailed specification.

> [!Note]  
> Azure Stack Hub appliance can be delivered in a hybrid deployment, with both HDD and SSD (or NVMe) drives. But the drives of faster type would be used as cache drives, and all remaining drives would be used as capacity drives as a pool. The tenant data (blobs, tables, queues, and disks) would be placed on capacity drives. Provisioning premium disks or selecting a premium storage account type doesn't guarantee the objects will be allocated on SSD or NVMe drives.

### Volumes

The *storage service* partitions the available storage into separate volumes that are allocated to hold system and tenant data. Volumes combine the drives in the storage pool to provide the fault tolerance, scalability, and performance benefits of Storage Spaces Direct.

![Azure Stack Hub storage infrastructure](media/azure-stack-storage-infrastructure-overview/image4.png)

There are three types of volumes created on Azure Stack Hub storage pool:

- Infrastructure: host files used by Azure Stack Hub infrastructure VMs and core services.

- VM Temp: host the temporary disks attached to tenant VMs and that data is stored in these disks.

- Object Store: host tenant data servicing blobs, tables, queues, and VM disks.

In a multi-node deployment, you would see three infrastructure volumes, while the number of VM Temp volumes and Object Store volumes is equal to the number of the nodes in the Azure Stack Hub deployment:

- On a four-node deployment, there are four equal VM Temp volumes and four equal Object Store volumes.

- If you add a new node to the cluster, there would be a new volume for both types created.

- The number of volumes remains the same even if a node malfunctioning or is removed.

- If you use the Azure Stack Development Kit, there's a single volume with multiple shares.

Volumes in Storage Spaces Direct provide resiliency to protect against hardware problems, such as drive or server failures. They also enable continuous availability throughout server maintenance, like software updates. Azure Stack Hub deployment uses three-way mirroring to ensure data resilience. Three copies of tenant data are written to different servers, where they land in cache:

![Azure Stack Hub storage infrastructure](media/azure-stack-storage-infrastructure-overview/image5.png)

Mirroring provides fault tolerance by keeping multiple copies of all data. How that data is striped and placed is non-trivial, but it's true to say that any data stored using mirroring is written in its entirety multiple times. Each copy is written to different physical hardware (different drives in different servers) that are assumed to fail independently. Three-way mirroring can safely tolerate at least two hardware problems (drive or server) at a time. For example, if you're rebooting one server when suddenly another drive or server fails, all data remains safe and continuously accessible.

## Next step

[Manage storage capacity](azure-stack-manage-storage-shares.md) 
