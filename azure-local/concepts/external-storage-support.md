---
title: External storage support for Azure Local
ms.service: azure-local
ms.reviewer: robess
description: Learn how Azure Local supports external SAN integration, enabling high-performance storage for VMs, AKS clusters, and AVD instances without re-architecture.
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 11/13/2025
ai-usage: ai-assisted
---

# External storage support for Azure Local

This article explains external storage support for Azure Local, its benefits, supported configurations, and other essential information.

## Overview

Azure Local supports integration with external Storage Area Networks (SAN), enabling customers to attach new or existing SAN arrays as block storage devices for Virtual Machines (VMs), Azure Kubernetes Service (AKS) clusters, and Azure Virtual Desktop (AVD) instances.

This capability extends Azure Local's hybrid flexibility by allowing organizations to use enterprise-grade, high-performance SAN infrastructure without disrupting existing investments. External SAN storage operates side-by-side with the in-box Storage Spaces Direct (S2D) solution, giving customers flexibility to choose the right data-tiering and performance model for each workload.

Multiple volumes from the SAN array can be presented as Cluster Shared Volumes (CSVs) on Azure Local nodes. Each CSV appears as a folder path that can be mapped as a Storage Path for VMs.

## Benefits

- **Investment protection**: Extends existing SAN infrastructure into Azure Local without re-architecture.

- **Operational consistency**: Offers the ability to use existing practices for management and operations.

- **Resilience and scale**: Dual fabrics, multipathing, and SAN-native redundancy ensure high availability.

- **Flexibility**: Choose between Storage Spaces Direct or external SAN volumes per workload requirement.

- **Enterprise performance**: Uses Fibre Channel-class bandwidth and latency for demanding workloads.

## Supported configurations
- Fibre Channel (FC) based SAN arrays 
- iSCSI based SAN arrays (Preview)
- Software initiator (Dell PowerFlex)

## Fibre Channel or iSCSI based SAN arrays

Bring your Fibre Channel or iSCSI-based SAN arrays from leading vendors and directly integrate them into Azure Local clusters for consistent management, high throughput, and low-latency I/O. Each Azure Local node connects to the SAN by using Fibre Channel fabrics or iSCSI network paths, ensuring high availability, resiliency, and performance. Host Bus Adapters (HBAs) for Fibre Channel or Ethernet network adapters for iSCSI enable reliable connectivity to external SAN storage.

:::image type="content" source="media/external-storage-support/fibre-channel-disaggregated-architecture.png" alt-text="Diagram that shows Fibre Channel and iSCSI based SAN architecture with Azure Local hosts connected to external storage arrays via dual fabric paths." lightbox="media/external-storage-support/fibre-channel-disaggregated-architecture.png":::

Once connected, the cluster discovers SAN-backed volumes and integrates them as CSVs formatted with NTFS, so you can share access across nodes and give seamless visibility for workloads. This configuration enables independent scaling of compute and storage while maintaining unified Azure management for both local and Arc-enabled services.

## Dell PowerFlex solution integration

**Dell PowerFlex** delivers a robust, software-defined storage solution built for hybrid environments like Azure Local.

:::image type="content" source="media/external-storage-support-azure-local/integration-architecture-diagram.png" alt-text="Diagram that shows connections between Azure Local cluster hosts and PowerFlex storage nodes through dual fabric connectivity." lightbox="media/external-storage-support-azure-local/integration-architecture-diagram.png":::

PowerFlex exposes **remote block volumes** to Azure Local nodes, which are mounted directly into the cluster and consumed by VMs, AKS pods, and AVD instances as if the storage is local. The solution uses PowerFlex's **distributed I/O architecture**, offering predictable throughput, low latency, and linear scalability across nodes.

Each Azure Local node installs the PowerFlex SDC driver, which facilitates efficient multipath communication over dual fabrics. Supported configurations scale from **4 to 512 PowerFlex nodes** and **3 to 16 Azure Local hosts**, ensuring enterprise-grade availability. PowerFlex deployments also employ non-routable dedicated SDS networks, jumbo-frame (MTU 9014) configurations, and NIC bonding/teaming to optimize throughput and failover.

Together, Dell PowerFlex and Azure Local deliver an integrated, high-performance storage fabric that combines Azure operational simplicity with PowerFlex's software-defined resiliency and scale.

## Unsupported configurations

Rack aware clusters are not supported with External SAN storage for hyperconverged deployments.

## Related content

- Learn more about [Dell PowerFlex for Azure Local Integration Guide (PDF)](https://infohub.delltechnologies.com/static/media/client/7phukh/DAM_fd0e04d5-d47e-4b55-8f7f-0a80d26086af.pdf?utm_source=chatgpt.com).
