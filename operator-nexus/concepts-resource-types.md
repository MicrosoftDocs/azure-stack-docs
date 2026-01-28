---
title: Azure Operator Nexus resource types
description: Operator Nexus platform and tenant resource types
author: scottsteinbrueck
ms.author: ssteinbrueck
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 01/21/2026
ms.custom: template-concept
---

# Azure Operator Nexus resource types

This article provides an overview of Azure Operator Nexus components and their representation as Azure Resource Manager resources.

:::image type="content" source="media/resource-types.png" alt-text="Screenshot of Resource Types.":::

Figure: Resource model

## Network Fabric infrastructure

These resources represent the physical and logical infrastructure that forms your Operator Nexus instance.

### Network Fabric Controller

The Network Fabric Controller bridges Azure and your on-premises network infrastructure, managing the lifecycle and configuration of network devices. See [Network Fabric Controller overview](concepts-network-fabric-controller.md).

### Network Fabric

Network Fabric represents your on-premises network topology in Azure, containing network racks, devices, and isolation domains. See [How to configure Network Fabric](howto-configure-network-fabric.md).

### Network racks

Network racks represent on-premises racks from the networking perspective, containing network devices like routers, switches, and network packet brokers. Lifecycle is tied to the Network Fabric resource.

### Network devices

Network devices represent physical networking equipment (CE routers, ToR switches, management switches, NPBs) deployed in your instance. See [Network Fabric read-only commands](concepts-network-fabric-read-only-commands.md) and [Network Fabric read-write commands](concepts-network-fabric-read-write-commands.md).

### Isolation domains

Isolation domains provide network connectivity for east-west and north-south traffic, supporting both Layer 2 and Layer 3 networks. See [Isolation domain concepts](concepts-isolation-domain.md).

## Compute and Storage infrastructure

### Cluster Manager

The Cluster Manager runs in Azure and manages the lifecycle of on-premises infrastructure clusters. A single Cluster Manager can manage multiple Operator Nexus instances.

### Cluster

The Cluster resource represents a collection of racks, bare metal machines (BMM), storage, and networking, providing a holistic view of deployed compute capacity. See [Cluster deployment overview](concepts-cluster-deployment-overview.md).

### Rack

Racks represent compute servers (bare metal machines), management servers, and networking equipment. Lifecycle is managed as part of the Cluster.

### Bare Metal Machine

Bare metal machines (BMM) are physical servers that host virtual machines and Kubernetes clusters for your workloads. See [Compute concepts](concepts-compute.md).

### Storage appliance

Storage appliances provide persistent local storage for your instance, ensuring data remains on-premises. See [Storage concepts](concepts-storage.md).

## Workload resources

These resources support your virtualized and containerized workloads.

### Network resources

Network resources provide virtual networking for workloads hosted on VMs or Kubernetes clusters. See [Nexus workload network types](concepts-nexus-workload-network-types.md).

- **Cloud Services Network** - Provides access to DNS, NTP, and Azure PaaS services
- **Layer 2 Network** - Enables east-west communication between workloads
- **Layer 3 Network** - Facilitates north-south communication with external networks
- **Trunked Network** - Provides access to multiple Layer 2 and Layer 3 networks

### Virtual machine

Virtual machines host your Virtualized Network Function (VNF) workloads. See [How to deploy virtual machines](quickstarts-virtual-machine-deployment-cli.md).

### Nexus Kubernetes cluster

Nexus Kubernetes clusters are Kubernetes clusters designed to host Containerized Network Function (CNF) workloads on your on-premises instance. See [Nexus Kubernetes cluster concepts](concepts-nexus-kubernetes-cluster.md).

## Related content

- [Cluster deployment overview](concepts-cluster-deployment-overview.md)
- [Network Fabric concepts](concepts-network-fabric.md)
- [Nexus networking concepts](concepts-nexus-networking.md)
- [Limits and quotas](reference-limits-and-quotas.md)
