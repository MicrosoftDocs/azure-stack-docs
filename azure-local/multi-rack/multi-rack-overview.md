---
title: "Azure Local Max Overview: Features, Benefits, and Use Cases (Preview)"
description: Discover Azure Local Max, a new capability for deploying large on-premises datacenters with over 100 nodes and 8,000 cores. Learn how to get started. (Preview)
#customer intent: As an IT admin, I want to understand Azure Local Max so that I can evaluate its suitability for my datacenter modernization needs.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 11/06/2025
ms.topic: overview
---

# What is Azure Local for multi-rack deployments? (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../../includes/multi-rack-applies-to-preview.md)]

This article provides an overview of Azure Local for multi-rack deployments. The overview also details the benefits, key features, use cases for deployment and how to get started with the preview release.

Azure Local max is a new capability in Azure Local that helps you set up large on-premises datacenters. This capability uses prescriptive hardware based on Azure Linux, making it possible to deploy over 100 nodes and more than 8,000 cores in your datacenter.

Azure Local max is available in Limited Preview for qualified opportunities and supports fresh deployments that require new hardware.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Overview

Azure Local max is delivered as multiple integrated racks, uses SAN storage, and provides managed networking. You can use it to run Azure Local virtual machines (VMs) and Azure Kubernetes Service (AKS) workloads.

To ensure performance and consistency, this capability is built on a prescriptive hardware Bill of materials (BOM). This enterprise-grade setup includes one main rack for aggregation with SAN storage and several compute racks, installed in your own datacenter.

:::image type="content" source="media/azure-local-max-overview/rack-structure.png" alt-text="Diagram showing Azure Local max aggregation and compute racks.":::

Azure Local Max uses Microsoft’s own version of Linux, called Azure Linux OS, to run on the host machines. With this setup, customers can run familiar Arc-enabled infrastructure and services at higher scale for datacenter scenarios. Services such as Network Cloud and Network Fabric offer fully managed networking that extends to L2 and L3 networking devices. You can use the Azure Command-line Interface (CLI) or Azure portal to monitor and manage individual instances, and view all the deployments of Azure Local max.

## Benefits

Azure Local max has the following key benefits:

- Uses the same familiar Azure Local experiences and APIs available through the Azure portal.

- Operates a resilient rack-scale infrastructure with built-in redundancies for enterprise-grade availability.

- Managed Network Fabric service lets you manage L2 and L3 networking devices.

- Allows you to access key Azure services through the same connection as the on-premises network. You can also monitor logs and metrics and analyze telemetry data.

- Offers unified governance and compliance across cloud and on-premises infrastructure. You can use [Azure role-based access control](/azure/role-based-access-control/overview) and [Azure Policy](/azure/governance/policy/overview) to unify data governance and enforce security and compliance policies.

## Features

The following table lists the various features and capabilities available on Azure Local Rack Scale:

| **Features** | **Description** |
|----|----|
| Hardware | Curated and certified hardware for enterprise use cases procured from a hardware partner. Each instance has 1 aggregation rack and 3-8 compute racks with each rack having up to 128 nodes. Each aggregation rack contains WAN uplinks and SAN storage. |
| Azure Linux Operating System | Runs Microsoft's own Linux distribution called [Azure Linux](https://github.com/microsoft/azurelinux)  on the bare-metal hosts in the datacenter. |
| SAN storage | Shared SAN storage infrastructure layer. |
| Bare metal and cluster management | Enables operators to manage and provision bare-metal hosts at their sites, offering capabilities like restarting, shutting down, or reimaging. The service also includes a cluster manager responsible for the lifecycle management of infrastructure Kubernetes clusters built on these hosts. |
| Azure Local services | Foundational services such as virtual machines, Kubernetes services, SAN storage, and managed network fabric. |
| Tenant layer | Uses the Azure Local tenant layer and provides Software-defined Networking capabilities. |
| Observability | Sends metrics and logs from on-premises infrastructure to Azure Monitor and Log Analytics for both infrastructure and tenant resources. |
| Region availability | Currently available in East US, Australia East, and South Central US. |
| Management tools | Cloud management via Azure portal, Azure Resource Manager templates, Azure CLI. |

## Architecture

The following diagram illustrates the architecture of Azure Local Rack Scale.

:::image type="content" source="media/azure-local-max-overview/architecture.png" alt-text="Architecture diagram of Azure Local Max.":::

The important points about this architecture are as follows:

- **Infrastructure layer** –Prescriptive hardware Bill of Materials (BOM) with racks from Microsoft partners. This layer also includes **SAN based storage that consists of Pure Storage Flash Array.**

- **Operating system** – Azure Linux OS installed on the hardware.

- **Hypervisor** – Consists of Kernel-based Virtual Machine (KVM) and Quick Emulator (QEMU) for virtualization.

- **Managed network fabric and observability tools**.

- **SDN networking** - Capabilities such as virtual networks, logical networks, load balancer and a Network Address Translation (NAT) gateway.

- **Workload layer** – Deployment of Windows and Linux Azure Local virtual machines (VMs) as workloads.

- **Azure services** – Include Azure Monitor, Azure Policy, Microsoft Defender for Cloud and more.

## Use cases

Customers often choose Azure Local in the following scenarios:

- **Datacenter modernization**

- **Large scale data residency**

- **Low latency scenarios**

- **Legacy applications**

- **Local data gravity** – examples include personnel safety checks or a pipeline leak detection.

- **Mission critical business continuity** – examples include production line operations or point of sale systems.

- **Near real time systems** - examples includes quality assurance or a manufacturing execution system.

- **Custom sovereignty and regulatory requirements** – examples include highly regulated industries or defense and intelligence.

## Get started

To get started with Azure Local Rack Scale (Preview), you need:

- A form filled out to be a Preview customer.

- Access to an [Azure subscription](https://azure.microsoft.com/) used for Preview. This subscription is enabled for Azure Local Rack Scale and is registered with the required Resource Providers.

- Access to a deployed Azure Local Rack Scale instance. This deployed instance meets the [system requirements](/azure/azure-local/concepts/system-requirements-23h2), [physical network](/azure/azure-local/concepts/physical-network-requirements) and [host network](/azure/azure-local/concepts/host-network-requirements) requirements.

## Next steps

- Read the blog post: [Blog list short link](https://techcommunity.microsoft.com/blog/azurearcblog/introducing-azure-local-cloud-infrastructure-for-distributed-locations-enabled-b/4296017).

- Learn more about [Azure Local max deployment](/azure/azure-local/deploy/deployment-introduction) prerequisites.
