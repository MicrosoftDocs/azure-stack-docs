---
title: What are multi-rack deployments for Azure Local? (Preview)
description: Discover Azure Local multi-rack deployments, a new capability for deploying large on-premises datacenters with over 100 machines and 8,000 cores. Learn how to get started (Preview).
#customer intent: As an IT admin, I want to understand Azure Local multi-rack deployments so that I can evaluate its suitability for my datacenter modernization needs.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 11/14/2025
ms.topic: overview
ms.custom: references_regions
---

# What are multi-rack deployments for Azure Local? (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides an overview of multi-rack deployments for Azure Local. The overview also details the benefits, key features, use cases, and how to get started with the preview release.

Multi-rack deployments extend the scale of Azure Local, supporting hundreds of servers across multiple racks in a single instance. Microsoft currently offers multi-rack deployments in preview for qualified opportunities.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Overview

Multi-rack deployments of Azure Local are delivered as preintegrated racks with compute, storage, and networking included. You can use it to run Azure Local virtual machines and Azure services through Azure Arc. Support for Azure Kubernetes Service (AKS) enabled by Azure Arc will be available in a future release.

This capability is designed around a prescriptive hardware bill of materials (BOM) to deliver optimal performance and reliability. The setup features one main rack for network aggregation with SAN storage alongside several compute racks, which are installed at your on-premises location.

:::image type="content" source="media/multi-rack-overview/rack-structure.png" alt-text="Diagram showing Azure Local aggregation and compute racks." lightbox="media/multi-rack-overview/rack-structure.png":::

With this solution, you can run familiar Arc-enabled infrastructure and services at a higher scale. The platform offers fully Azure-managed compute, storage, and networking capabilities. You can use the Azure Command-line Interface (CLI) or Azure portal to monitor and manage individual instances or view all multi-rack deployments.

## Benefits

Azure Local for multi-rack deployments offers the following key benefits:

- Uses the same familiar Azure Local experiences and APIs available through the Azure portal.

- Provides resilient large-scale infrastructure with built-in redundancies for high availability.

- Provides managed networking, with all network devices and settings managed through familiar Azure concepts and APIs.

- Allows you to access key Arc-enabled Azure services within your on-premises environment.

- Offers unified governance and compliance across cloud and on-premises infrastructure. You can use [Azure role-based access control](/azure/role-based-access-control/overview) and [Azure Policy](/azure/governance/policy/overview) to unify data governance and enforce security and compliance policies.

## Features

The following table lists the various features and capabilities available on Azure Local multi-rack deployments:

| **Features** | **Description** |
|----|----|
| Hardware | Prescriptive hardware procured from a Microsoft hardware partner. Each instance has one main rack for network aggregation and SAN storage plus three or more compute racks. The minimum footprint is four racks.  |
| SAN storage | Built-in SAN storage shared by compute racks. |
| Managed networking | Automated bootstrapping and lifecycle management of network devices using Azure APIs and ARM templates. Includes deployment of logical Layer 2 and Layer 3 networks spanning racks to support workloads. |
| Azure Local services | Foundational services such as Azure Local virtual machines, Azure Kubernetes Service (AKS) enabled by Azure Arc, and software-defined networking (SDN) services. |
| Observability | Sends metrics and logs from on-premises infrastructure to Azure Monitor and Log Analytics for both infrastructure and workload resources. |
| Management tools | Cloud management via Azure portal, Azure Resource Manager templates, and Azure CLI. |
| Region availability | The control plane is currently available in East US, Australia East, and South Central US. |

## Architecture

The following diagram illustrates the architecture of Azure Local for multi-rack deployments.

:::image type="content" source="media/multi-rack-overview/architecture.png" alt-text="Architecture diagram of Azure Local." lightbox="media/multi-rack-overview/architecture.png":::

The important points about this architecture are as follows:

- Prescriptive hardware bill of materials (BOM) featuring preintegrated racks that contain SAN storage, servers, and network devices.
- Azure Linux OS installed on the hardware and hypervisor for virtualization.
- Azure Local services:
  - Software-defined networking (SDN) services including virtual networks, logical networks, software load balancers, Network Address Translation (NAT) gateways, and network security groups.
  - Deployment of Windows and Linux Azure Local virtual machines (VMs) and Azure Kubernetes services (AKS) enabled by Azure Arc.
- Azure ExpressRoute to connect your on-premises infrastructure to Azure.
- Azure Arc-enabled add-on services like Azure Monitor, Azure Policy, Microsoft Defender for Cloud, and more.

## Get started

To get started with Azure Local multi-rack deployments (Preview), contact your account team.

## Next steps

- Read the blog post: [Blog list short link](https://aka.ms/ignite25/blog/azurelocal).

- Learn more about [Azure Local multi-rack deployment prerequisites](multi-rack-prerequisites.md) .
