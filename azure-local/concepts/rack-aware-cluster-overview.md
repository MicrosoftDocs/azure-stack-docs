---
title: Overview of Azure Local rack aware clustering (Preview)
description: Use this article to learn about Azure Local rack aware clustering. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-local
ms.date: 10/15/2025
---

# Azure Local rack aware clustering overview (Preview)

> Applies to: Azure Local version 2510 and later

This article gives a high-level overview of the Azure Local rack aware clustering feature including its benefits and use cases. The article also details the supported configurations and deployment requirements for rack aware clusters. This article applies only to new deployments of Azure Local.

[!INCLUDE [important](../includes/hci-preview.md)]

## About rack aware cluster

Azure Local rack aware cluster is an advanced architecture designed to enhance fault tolerance and data distribution within an Azure Local instance. This architecture enables you to cluster nodes that are strategically placed across two physical racks in two different rooms or buildings with high bandwidth and low latency.

The following diagram shows a cluster of two racks of servers with top-of-rack (TOR) switches connected between rooms. Each rack functions as a local availability zone across layers from the operating system to Azure Local management, including Azure Local VMs enabled by Azure Arc.  

:::image type="content" source="media/rack-aware-cluster-overview/rack-aware-cluster-architecture.png" alt-text="Diagram of rack aware cluster architecture." lightbox="media/rack-aware-cluster-overview/rack-aware-cluster-architecture.png":::

This direct connection between racks supports a single storage pool, with rack aware clusters guaranteeing data copy distribution evenly between the two racks.  

This design is valuable in environments that require high availability and disaster recovery capabilities. Even if an entire rack encounters an issue, the other rack maintains the integrity and accessibility of the data.

To support the synchronous replications between racks, a dedicated storage network intent is required to secure the bandwidth and low latency for storage traffic. The required round-trip latency between the two racks should be 1 ms or less.

For detailed networking requirements, see [rack aware clustering network design](rack-aware-cluster-reference-architecture.md).

## Benefits

The main benefits of Azure Local rack aware cluster include:

- **High availability**: By distributing data across two or more racks, the system can withstand the failure of an entire rack without losing access to data. This is important for mission-critical applications that require continuous uptime.

- **Improved performance**: The architecture allows for better load balancing and resource utilization, as workloads can be distributed across multiple racks.


## Use cases

The use cases for Azure Local rack aware cluster include:


- Use rack aware cluster in a manufacturing plant, in a hospital or an airport to minimize the risk of data loss or downtime in the event of a rack-level failure.  

## Review requirements

All the [System requirements for Azure Local](../concepts/system-requirements-23h2.md) apply to rack aware clusters. There are [Other requirements](rack-aware-cluster-requirements.md) for rack aware clusters including those for drives, Availability Zones, node configurations, latency, and bandwidth.


## Prepare to deploy a rack aware cluster

Before you deploy a rack aware cluster, ensure that you have completed the tasks detailed in [Prepare to deploy](../deploy/rack-aware-cluster-deploy-prep.md).

## Deploy a rack aware cluster

To deploy a rack aware cluster, use one of the following methods:

- Deploy via the [Azure portal](../deploy/rack-aware-cluster-deploy-portal.md).
- Deploy via an [Azure Resource Manager template](../deploy/rack-aware-cluster-deployment-via-template.md).

## Complete post deployment tasks

After you deploy a rack aware cluster, make sure to complete the [post deployment tasks](../deploy/rack-aware-cluster-post-deployment.md).

## Scale a rack aware cluster

To scale the cluster, you can add a pair of nodes to a rack aware cluster. The 2+2 configuration can be expanded to 3+3, and 3+3 to 4+4.

For more information, see [Add nodes to a rack aware cluster](rack-aware-cluster-add-server.md).

## Place an Azure Local VM

To balance workloads between zones, create Azure Local VMs to place in a specified zone. Based on the criticality of the VMs, you can configure strict or non-strict placement to disable or enable failover to the other zone.

For more information about VM placement in a rack aware cluster, see [Manage VM placement in a rack aware cluster](rack-aware-cluster-provision-vm-local-availability-zone.md).

## Fail over Azure Local VMs

We recommend that you conduct live migration and failover testing of your VM workloads within a rack aware cluster. The failover behavior depends on the VM placement configuration and can be a planned failover or unplanned failover.

For more information, see [Fail over Azure Local VMs in a rack aware cluster](rack-aware-cluster-requirements.md#recommendations).


## Next steps

- Review [rack aware cluster network design](rack-aware-cluster-reference-architecture.md).
- Deploy a rack aware cluster via [Azure portal](../deploy/rack-aware-cluster-deploy-portal.md) or [ARM template](../deploy/rack-aware-cluster-deployment-via-template.md).
- Learn how to [Configure availability zones](rack-aware-cluster-provision-vm-local-availability-zone.md) in a rack aware cluster.
