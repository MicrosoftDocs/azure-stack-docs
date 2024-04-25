---
title: Regional redundancy and failover recovery with Azure Managed Lustre
description: Techniques to provide failover capabilities for disaster recovery with Azure Managed Lustre 
author: pauljewellmsft
ms.author: pauljewell
ms.topic: conceptual
ms.date: 05/08/2023
---

# Use multiple clusters for regional failover recovery

Each Azure Managed Lustre instance runs within a particular subscription and in one region. This configuration means that your workflow could possibly be disrupted if the cluster's region has a full outage.

This article describes a strategy to reduce the risk of work disruption by using a second region for cluster failover. The important thing is to use Azure Blob storage that is accessible from multiple regions.

As your workflow proceeds in your primary region, you must manually save data in the blob storage outside of the region. If the cluster region becomes unavailable, you can create another Azure Managed Lustre instance in a secondary region, connect to the same storage, and resume work from the new cluster.

> [!NOTE]
> This failover plan does not cover a complete outage in a storage account's region. 
>
> Managed Lustre does support locally redundant storage (LRS), zone-redundant storage (ZRS), geo-redundant storage (GRS), read-access-geo-redundant storage (RAGRS), geo-zone-redundant storage (GZRS), and read-access-geo-zone-redundant storage (RA-GZRS).


## Planning for regional failover

To set up a cluster that is prepared for possible failover, follow these steps:

1. Make sure that your back-end storage is accessible in a second region.
1. When planning to create the primary cluster instance, you should also prepare to replicate this setup process in the second region. Include these items:

   1. Virtual network and subnet structure
   1. Cluster capacity
   1. Details about client machines, if they're located in the same region as the cluster
   1. Mount command for use by cluster clients
1. Add and implement a checkpoint to the workflow: [Archive your data to blob](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj574114(v=ws.11)).

   > [!NOTE]
   > Azure Managed Lustre can be created programmatically, either through an [Azure Resource Manager template](/azure/azure-resource-manager/templates/overview) or by [directly accessing its API](create-file-system-resource-manager.md). 

## Failover example

As an example, you want to locate your Azure Managed Lustre cluster in Azure's East US region. It accesses data stored in your designated blob location. You can use a cluster in the West US 2 region as a failover backup.

When you create the cluster in East US, prepare a second cluster for deployment in West US 2. You can use scripting or templates to automate this preparation.

In the event of a region-wide failure in East US, create the cluster you prepared in the West US 2 region.

During the cluster creation, specify a blob integration target that points to the same blob data store. If the original clients are affected, create new clients in the West US 2 region for use with the new cluster. All clients must mount the new cluster, even if the clients weren't affected by the region outage. The new cluster has different mount addresses from the old one.

## Next steps

- The Azure application architecture guide includes more information about how to [recover from a region-wide service disruption](/azure/architecture/resiliency/recovery-loss-azure-region).
