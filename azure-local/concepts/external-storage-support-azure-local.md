---
title: External Storage support for Azure Local (preview)
ms.service: azure-local
ms.reviewer: robess
description: Learn how Azure Local supports external SAN integration, enabling high-performance storage for VMs, AKS clusters, and AVD instances without re-architecture (preview).
ms.topic: conceptual
author: ronmiab
ms.author: robess
ms.date: 11/05/2025
ai-usage: ai-assisted
---

# External storage support for Azure Local (preview)

This article explains external storage support for Azure Local, its benefits, supported configurations, and other essential information.

[!INCLUDE [IMPORTANT](../includes/hci-preview.md)]

## Overview

Azure Local supports integration with external Storage Area Networks (SAN), enabling customers to attach new or existing SAN arrays as block storage devices for Virtual Machines (VMs), Azure Kubernetes Service (AKS) clusters, and Azure Virtual Desktop (AVD) instances.

This capability extends Azure Local's hybrid flexibility by allowing organizations to leverage enterprise-grade, high-performance SAN infrastructure without disrupting existing investments. External SAN storage operates side-by-side with the in-box Storage Spaces Direct (S2D) solution, giving customers flexibility to choose the right data-tiering and performance model for each workload.

Multiple volumes from the SAN array can be presented as Cluster Shared Volumes (CSVs) on Azure Local nodes, where each CSV appears as a folder path that can be mapped as a Storage Path for VM or container workloads.

## Benefits

- **Investment protection:** Extends existing SAN infrastructure into Azure Local without re-architecture.

- **Operational consistency:** Offers the ability to leverage existing practices for management and operations.

- **Resilience and scale:** Dual fabrics, multipathing, and SAN-native redundancy ensure high availability.

- **Flexibility:** Choice between Storage Spaces Direct or external SAN volumes per workload requirement.

- **Enterprise performance:** Leverages Fibre Channel-class bandwidth and latency for demanding workloads.

## Supported configurations

- **Dell PowerFlex** - Generally Available.

- **Fibre Channel (FC) based SAN connectivity** - Currently in limited preview.

## Dell PowerFlex solution integration

**Dell PowerFlex** delivers a robust, software-defined storage solution built for hybrid environments like Azure Local. In this Limited Preview release, PowerFlex enables external block storage to be presented as **high-performance CSVs** accessible to Azure Local clusters over Fibre Channel.

:::image type="content" source="media/external-storage-support-azure-local/integration-architecture-diagram.png" alt-text="Screenshot of Dell PowerFlex integration architecture diagram showing connections between Azure Local cluster hosts and PowerFlex storage nodes through dual fabric connectivity." lightbox="media/external-storage-support-azure-local/integration-architecture-diagram.png":::

PowerFlex exposes **remote block volumes** to Azure Local nodes, which are mounted directly into the cluster and consumed by VMs, AKS pods, and AVD instances as if the storage is local. The solution leverages PowerFlex's **distributed I/O architecture**, offering predictable throughput, low latency, and linear scalability across nodes.

Each Azure Local node installs the PowerFlex SDC driver, which facilitates efficient multipath communication over dual fabrics. Supported configurations scale from **4 to 512 PowerFlex nodes** and **3 to 16 Azure Local hosts**, ensuring enterprise-grade availability. PowerFlex deployments also employ non-routable dedicated SDS networks, jumbo-frame (MTU 9014) configurations, and NIC bonding/teaming to optimize throughput and failover.

Together, Dell PowerFlex and Azure Local deliver an integrated, high-performance storage fabric that combines Azure operational simplicity with PowerFlex's software-defined resiliency and scale.

## Fibre Channel based SAN arrays (in limited preview)

Customers can bring their Fibre Channel based SAN arrays from leading vendors and directly integrate them into Azure Local clusters for consistent management, high throughput, and low-latency I/O. Each Azure Local node connects to the SAN through dual Fibre Channel fabrics (Fabric A and Fabric B) for redundancy and performance. Host Bus Adapters (HBAs) installed on each host enable resilient, high-throughput connectivity to the external SAN.

:::image type="content" source="media/external-storage-support-azure-local/fibre-channel-architecture-diagram.png" alt-text="Screenshot of Fibre Channel SAN architecture diagram showing Azure Local hosts connected to external storage arrays via dual fabric paths." lightbox="media/external-storage-support-azure-local/fibre-channel-architecture-diagram.png":::

Once connected, SAN-backed volumes are discovered and integrated as Cluster Shared Volumes (CSVs) formatted with NTFS, allowing shared access across nodes and seamless visibility for workloads. This configuration enables independent scaling of compute and storage while maintaining unified Azure management for both local and Arc-enabled services.

> [!IMPORTANT]
> Fibre Channel support is currently available for nonproduction workloads through **limited preview program**. Customers interested in evaluating this capability should contact their Microsoft representative or their Storage vendor for participation in the preview.

## Related content

- Learn more about [Dell PowerFlex for Azure Local Integration Guide (PDF)](https://infohub.delltechnologies.com/static/media/client/7phukh/DAM_fd0e04d5-d47e-4b55-8f7f-0a80d26086af.pdf?utm_source=chatgpt.com).

