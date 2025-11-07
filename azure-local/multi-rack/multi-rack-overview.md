---
title: Azure Local multi-rack deployments - Features, Benefits, and Use Cases (Preview)
description: Discover Azure Local multi-rack deployments, a new capability for deploying large on-premises datacenters with over 100 nodes and 8,000 cores. Learn how to get started. (Preview)
#customer intent: As an IT admin, I want to understand Azure Local multi-rack deployments so that I can evaluate its suitability for my datacenter modernization needs.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 11/07/2025
ms.topic: overview
---

# What are Azure Local multi-rack deployments? (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides an overview of Azure Local multi-rack deployments.  The overview also details the benefits, key features, use cases, and how to get started with the preview release.

Multi-rack deployments extend the scale of Azure Local, supporting hundreds of servers across multiple racks in a single instance. Multi-rack deployments are currently offered in Preview for qualified opportunities.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Overview

Multi-rack deployments of Azure Local is delivered as pre-integrated racks with compute, storage, and networking included. You can use it to run Azure Local virtual machines and Azure services via Azure Arc. Support for Azure Kubernetes Service (AKS) enabled by Azure Arc will be available in a future release.

To deliver optimal performance and reliability, this capability is designed around a prescriptive hardware bill of materials (BOM) featuring one main rack for network aggregation with SAN storage alongside several compute racks, installed at your on-premises location.

:::image type="content" source="media/azure-local-max-overview/rack-structure.png" alt-text="Diagram showing Azure Local aggregation and compute racks." lightbox="media/azure-local-max-overview/rack-structure.png":::

With this solution, you can run familiar Arc-enabled infrastructure and services at a higher scale. The platform offers fully Azure-managed compute, storage, and networking capabilities. You can use the Azure Command-line Interface (CLI) or Azure portal to monitor and manage individual instances or view all the multi-rack deployments.

## Benefits

Azure Local for multi-rack deployments has the following key benefits:

- Uses the same familiar Azure Local experiences and APIs available through the Azure portal.

- Provides a resilient large-scale infrastructure with built-in redundancies for high availability.

- Provides managed networking, with all network devices and settings managed via familiar Azure concepts and APIs.

- Allows you to access key Arc-enabled Azure services within your on-premises environment.

- Offers unified governance and compliance across cloud and on-premises infrastructure. You can use [Azure role-based access control](/azure/role-based-access-control/overview) and [Azure Policy](/azure/governance/policy/overview) to unify data governance and enforce security and compliance policies.

## Features

The following table lists the various features and capabilities available on Azure Local Rack Scale:

| **Features** | **Description** |
|----|----|
| Hardware | Prescriptive hardware procured from a Microsoft hardware partner. Each instance has 1 main rack for network aggregation and SAN storage plus 3 or more compute racks. The minimum footprint is 4 racks.  |
| SAN storage | Built-in SAN storage shared by compute racks. |
| Managed networking | Automated bootstrapping and lifecycle management of network devices using Azure APIs and ARM templates. Includes deployment of logical Layer 2 and Layer 3 networks spanning racks to support workloads. |
| Azure Local services | Foundational services such as Azure Local virtual machines, Azure Kubernetes service (AKS) enabled by Azure Arc and software-defined networking (SDN) services. |
| Observability | Sends metrics and logs from on-premises infrastructure to Azure Monitor and Log Analytics for both infrastructure and tenant resources. |
| Management tools | Cloud management via Azure portal, Azure Resource Manager templates, and Azure CLI. |

## Architecture

The following diagram illustrates the architecture of Azure Local for multi-rack deployments.

:::image type="content" source="media/multi-rack-overview/architecture.png" alt-text="Architecture diagram of Azure Local." lightbox="media/multi-rack-overview/architecture.png":::

<!--The important points about this architecture are as follows:

- **Infrastructure layer** –Prescriptive hardware Bill of Materials (BOM) with racks from Microsoft partners. This layer also includes **SAN based storage that consists of Pure Storage Flash Array.**

- **Operating system** – Azure Linux OS installed on the hardware.

- **Hypervisor** – Consists of Kernel-based Virtual Machine (KVM) and Quick Emulator (QEMU) for virtualization.

- **Managed network fabric and observability tools**.

- **SDN networking** - Capabilities such as virtual networks, logical networks, load balancer and a Network Address Translation (NAT) gateway.

- **Workload layer** – Deployment of Windows and Linux Azure Local virtual machines (VMs) as workloads.

- **Azure services** – Include Azure Monitor, Azure Policy, Microsoft Defender for Cloud and more.-->


## Get started

To get started with Azure Local multi-rack deployments (Preview), reach out to your Account team.

## Next steps

- Read the blog post: [Blog list short link](https://techcommunity.microsoft.com/blog/azurearcblog/introducing-azure-local-cloud-infrastructure-for-distributed-locations-enabled-b/4296017).

- Learn more about [Azure Local multi-rack deployment](../index.yml) prerequisites.
