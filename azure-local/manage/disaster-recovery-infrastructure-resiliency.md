---
title: Infrastructure resiliency for Azure Local
description: Infrastructure resiliency considerations for Azure Local.
ms.topic: article
author: sipastak
ms.author: sipastak
ms.date: 07/22/2025
---

# Infrastructure resiliency for Azure Local

Intro

## Hardware

The resilience of any Azure Local instance deployment begins with its physical hardware. It's imperative to run Azure Local on hardware that is tested and certified, which ensures reliability, compatibility, optimal performance, and supportability for critical workloads. Consequently, Azure Local can only be installed on validated hardware that is available from specific OEM hardware partners.  

You can choose from different hardware categories, including Validated Nodes, Integrated Systems, or Premier Solutions. Premier Solutions for Azure Local represent turnkey solutions developed through extensive collaboration with our hardware partners, ensuring the highest levels of integration and validation. For all the available platforms and solution categories, see the Azure Local catalog.  

## Storage  

Equally important to the physical hardware is the selection of high-performance, low-latency disks. Fast storage is essential for maintaining the responsiveness, reliability, and throughput required by critical workloads running on Azure Local instances.  

When considering the storage underpinning your Azure Local deployment, the choice of disk technology plays a pivotal role in overall performance and resilience. Solid-state Drives (SSDs), especially enterprise-class models, are the preferred standard for modern Azure Local instances, offering rapid input/output operations and lower latency compared to traditional spinning disks. Their inherent speed accelerates both general workload responsiveness and the completion of backup and replication tasks integral to your disaster recovery strategy.

For organizations seeking even greater performance, Nonvolatile Memory Express (NVMe) drives represent an advanced option. NVMe disks connect directly via the PCIe bus, bypassing legacy storage protocols and delivering unparalleled throughput and reduced latency. This is valuable for workloads with intensive transactional requirements or high-frequency data access, as seen in SQL databases, virtual desktop infrastructure, and analytics operations. For more information, see physical disk drives for Azure Local in Azure Architecture Center.

## Network  

Azure Local has specific network requirements. A reliable, high-bandwidth, and low-latency network connection between each server node is a mandatory prerequisite for stable operation. In addition, each node should have multiple network adapters (NICs) and ideally be connected to multiple switches for each network role (storage, management, VM traffic) for redundancy and performance. Implementing a design that provides a redundant physical and logical network topology is essential to ensure the cluster remains operational in the event of failure of a network switch, or network adapter port (removing single points of failure). For more information, see network design for Azure Local in Azure Architecture Center.  

## Failover clustering  

Windows Server Failover clustering is a core component of the high-availability technology for Azure Local, providing the framework for resiliency and failover of virtual machines. Azure Local instances can consist of multiple physical nodes that are configured in a failover cluster. In a cluster, if one or more server nodes fail, their roles (virtual machines, storage, network, etc.) automatically failover to another node within the cluster. This means workloads continue to run on the surviving nodes, with minimal disruption to systems and end users. The number of nodes in the cluster directly impacts its resilience and the types of storage fault tolerance that can be implemented.  

When designing your storage architecture, it's crucial to select a storage fault tolerance configuration that aligns with your organization's specific space/business continuity needs and the number of nodes present in your cluster, ensuring optimal protection without unnecessary overhead. For more information, see the Cluster design choices for Azure Local in Azure Architecture Center.  

## Storage Spaces Direct

Azure Local uses Storage Spaces Direct (S2D) for software-defined storage, which is integrated with failover clustering. S2D aggregates disks across the cluster nodes into a protected storage pool. Cluster Shared Volumes (CSV) allow all nodes to concurrently access this shared storage pool. This design provides both high performance and fault tolerance: if a disk fails or even if an entire node goes down, copies of the data exist on other drives/nodes, enabling VMs to continue running using redundant copies of data in the surviving nodes. By using appropriate S2D resiliency (for example, three-way mirroring or dual parity), an Azure Local instance can sustain disk failures or node failures across two fault domains (nodes) without losing data or incurring downtime. Integrating SSD or NVMe drives within Storage Spaces Direct (S2D) not only boosts performance but also augments the fault tolerance of the storage subsystem. By combining the speed and reliability of these modern disk technologies with S2D’s mirroring or parity-based resiliency schemes, Azure Local deployments can sustain multiple drive or node failures while still delivering high availability and consistent performance for mission-critical workloads. For more information, see Storage Spaces Direct overview.

## Logical Networks

A resilient and well-structured network architecture is foundational to any effective disaster recovery strategy. Logical network topology, particularly in hybrid environments like Azure Local, plays a critical role in ensuring that workloads remain secure, segmented, and recoverable. Microsoft’s recommended approach uses a layered model that segments workloads into subnets based on their function and trust level. This segmentation not only enforces security boundaries but also simplifies management by grouping resources with similar recovery and access requirements. In a disaster recovery context, this means that critical systems can be isolated and prioritized for recovery without interference from less essential services. 

The hub-and-spoke model is especially valuable for disaster recovery planning. In this design, the hub hosts shared services such as DNS, NTP, and identity infrastructure, while spokes represent individual environments like development, staging, or production. Traffic between spokes is routed through the hub, allowing centralized control and visibility—key for monitoring, enforcing policies, and initiating recovery workflows. Firewalls and network security groups (NSGs) further enhance this setup by controlling access and ensuring that only authorized communication occurs between segments. This architecture not only supports operational efficiency but also ensures that in the event of a disruption, recovery can be executed in a controlled, secure, and prioritized manner. For more information, see Logical Network Topology for Azure Local.  

## Next steps

- Learn more about [Virtual machine resiliency](disaster-recovery-vm-resiliency.md).
