---
title: Infrastructure resiliency for Azure Local
description: Infrastructure resiliency considerations for Azure Local.
ms.topic: article
author: sipastak
ms.author: sipastak
ms.date: 09/10/2025
---

# Infrastructure resiliency for Azure Local

This article explores the key infrastructure elements that contribute to a resilient Azure Local deployment and how they support continuity in the face of hardware faults, network outages, and site-level disasters.

Infrastructure resiliency is the foundation of a robust disaster recovery strategy for Azure Local deployments. Before virtual machines (VMs) and applications can be protected, the underlying physical and logical infrastructure must be designed to withstand failures and disruptions. This includes selecting validated hardware, implementing high-performance storage, designing redundant network topologies, and configuring resilient operating system components. In hybrid environments where Azure Local bridges on-premises infrastructure with Azure cloud services, ensuring that each layer of the infrastructure stack is resilient is critical to maintaining uptime, safeguarding data, and enabling seamless recovery.

## Hardware

The resilience of any Azure Local instance deployment begins with its physical hardware. It's imperative to run Azure Local on hardware that is tested and certified, which ensures reliability, compatibility, optimal performance, and supportability for critical workloads. Consequently, Azure Local can only be installed on validated hardware that is available from specific OEM hardware partners.  

You can choose from different hardware categories, including Validated Nodes, Integrated Systems, or Premier Solutions. Premier Solutions for Azure Local represent turnkey solutions developed through extensive collaboration with our hardware partners, ensuring the highest levels of integration and validation. For all the available platforms and solution categories, see the [Azure Local catalog](https://azurelocalsolutions.azure.microsoft.com/#/catalog).  

## Failover clustering  

Windows Server failover clustering is a core component of the high-availability technology for Azure Local, providing the framework for resiliency and failover of VMs. Azure Local instances can consist of multiple physical nodes that are configured in a failover cluster. If one or more server nodes fail, their roles (VMs, storage, network, etc.) automatically failover to another node within the cluster. This means workloads continue to run on the surviving nodes, with minimal disruption to systems and end users. The number of nodes in the cluster directly impacts its resilience and the types of storage fault tolerance that can be implemented.  

When designing your storage architecture, it's crucial to select a storage fault tolerance configuration that aligns with your organization's specific space/business continuity needs and the number of nodes present in your cluster, ensuring optimal protection without unnecessary overhead. 

For more information, see the [cluster design choices for Azure Local](/azure/architecture/hybrid/azure-local-baseline#cluster-design-choices).

## Storage

When considering the storage underpinning your Azure Local deployment, the choice of disk technology plays a pivotal role in overall performance and resilience. Solid-state drives (SSDs), especially enterprise-class models, are the preferred standard for modern Azure Local instances, offering rapid input/output operations and lower latency compared to traditional spinning disks. Their inherent speed accelerates both general workload responsiveness and the completion of backup and replication tasks integral to your disaster recovery strategy.

For organizations seeking even greater performance, Nonvolatile Memory Express (NVMe) drives represent an advanced option. NVMe disks connect directly via the PCIe bus, bypassing legacy storage protocols and delivering unparalleled throughput and reduced latency. This is valuable for workloads with intensive transactional requirements or high-frequency data access, as seen in SQL databases, virtual desktop infrastructure, and analytics operations. 

For more information, see [Physical disk drives for Azure Local](/azure/architecture/hybrid/azure-local-baseline#physical-disk-drives).

## Storage Spaces Direct

Azure Local uses Storage Spaces Direct (S2D) for software-defined storage, which is integrated with failover clustering. By using appropriate S2D resiliency (for example, three-way mirroring or dual parity), an Azure Local instance can sustain disk failures or node failures across two fault domains (nodes) without losing data or incurring downtime. Integrating SSD or NVMe drives within S2D not only boosts performance but also augments the fault tolerance of the storage subsystem. By combining the speed and reliability of these modern disk technologies with S2D’s mirroring or parity-based resiliency schemes, Azure Local deployments can sustain multiple drive or node failures while still delivering high availability and consistent performance for mission-critical workloads.

For more information, see [Storage Spaces Direct overview](/windows-server/storage/storage-spaces/storage-spaces-direct-overview).

## Network  

Azure Local has specific network requirements. A reliable, high-bandwidth, and low-latency network connection between each server node is a mandatory prerequisite for stable operation. In addition, each node should have multiple network adapters (NICs) and ideally be connected to multiple switches for each network role (storage, management, VM traffic) for redundancy and performance. Implementing a design that provides a redundant physical and logical network topology is essential to ensure the cluster remains operational in the event of failure of a network switch, or network adapter port (removing single points of failure). 

For more information, see [Network design for Azure Local](/azure/architecture/hybrid/azure-local-baseline#network-design).  

## Logical networks

In Azure Local, logical networks are used to create and manage VLAN-based networks for virtual machines, allowing for effective network segmentation and policy application. Segmenting workloads by function and trust level helps enforce security boundaries and simplifies recovery planning. This structure allows critical systems to be isolated and prioritized during a disruption, improving continuity and reducing risk.

For more information, see [Logical network topology for Azure Local](/azure/architecture/hybrid/azure-local-baseline#logical-network-topology).  

## Next steps

- Learn more about [Virtual machine resiliency](disaster-recovery-vm-resiliency.md).
