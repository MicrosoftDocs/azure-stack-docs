---
title: Microsoft 365 Local on Azure Local Infrastructure
description: Learn how Microsoft 365 Local enables private cloud productivity with Exchange, SharePoint, and Skype for Business on customer-managed Azure Local infrastructure.
author: alkohli
ms.topic: concept-article
ms.date: 02/17/2026
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# What is Microsoft 365 Local?

This article provides an overview of Microsoft 365 Local on Azure Local infrastructure.

## Overview

Microsoft 365 Local enables organizations to run Exchange Server, SharePoint Server, and Skype for Business Server on Azure Local infrastructure that is entirely customer-owned and managed. By using Microsoft 365 Local, organizations gain enhanced control over data residency, access, and compliance, helping them meet their sovereignty requirements.

Designed for organizations that need productivity tools in a private cloud environment, Microsoft 365 Local leverages Azure Arc to provide a unified control plane with simplified deployment and streamlined updates for easy infrastructure management.

The solution includes a validated reference architecture with certified hardware, along with a hardened security baseline and robust controls to protect your infrastructure. <!--can we link out to the security baseline for Microsoft 365 Local?-->

## Why use Microsoft 365 Local?

Organizations choose Microsoft 365 Local for several key reasons:

- Gain the agility and simplicity of cloud management within your own data center by implementing a sovereign private cloud with Azure-consistent management.
- Plan and deploy with confidence through a Microsoft-authorized partner, reducing risk and accelerating time to value.
- Choose between seamless integration with cloud services or a fully disconnected environment based on your sovereignty requirements.
- Keep sensitive workloads and data entirely on-premises to meet the strictest jurisdictional and sovereignty mandates.

## Microsoft 365 Local capabilities

- **Exchange Server, SharePoint Server, and Skype for Business Server:** Deliver core productivity and collaboration services on-premises. These services address compliance and stringent data residency requirements while providing enterprise-grade capabilities for email, document management, and unified communications.

- **Certified and validated solutions by Microsoft and hardware partners:** Microsoft 365 Local is supported on Azure Local Premier Solutions offered in collaboration with hardware partners to guarantee compatibility and support for sovereign deployments.

- **Full-stack deployment based on validated reference architecture:** Offers validated architecture based on best practices to ensure optimal performance and resiliency. This architecture includes guidance for networking, storage, compute, and identity integration, ensuring consistency and best practices across the entire stack.

- **Built on Azure Local providing Sovereign Private Cloud capabilities:** Delivers a private cloud environment designed for governments and regulated industries, with Arc-enabled management for hybrid control, enhanced security features such as encryption and access controls, and compliance mechanisms aligned with local regulatory frameworks.

- **Supports hybrid connectivity and fully disconnected:** Enables centralized management through Azure services for monitoring, updates, and policy enforcement in connected mode. It also provides disconnected mode for complete isolation for environments requiring air-gapped operations, ensuring compliance with strict sovereignty or security mandates. For more information about disconnected operations, see [Disconnected operations for Azure Local overview](../manage/disconnected-operations-overview.md).

## Microsoft 365 Local hardware requirements

This section outlines an example for a large-scale deployment of Microsoft 365 Local in connected mode. This deployment supports enterprise environments and is optimized for performance and resiliency. Alternative configurations and hardware specifications are available to support different scales and requirements, including small-scale and mid scale deployments. The overall architecture of Microsoft 365 Local is tailored to each customer’s needs. Customers should work with their authorized Microsoft partner to appropriately size and design their deployment.

Microsoft 365 Local must be deployed on an Azure Local Premier Solution that meets the hardware requirements for Microsoft 365 Local. Supported solutions can be found in the [Azure Local Solutions catalog](https://aka.ms/azurelocalcatalog).

<!--The baseline architecture for a Microsoft 365 Local deployment consists of nine physical servers, all certified as Premier Solutions.

### Minimum server specifications

Each server must meet the following minimum specifications:

| Component | Minimum specification |
|--|--|
| **Chassis** | 2U form factor, NVMe enabled (24 × 2.5" drive slots) |
| **CPU** | Dual socket, Intel Xeon Gold 5418Y 2G, 24 cores (or equivalent) |
| **Memory** | 512 GB RAM |
| **Boot Storage** | 2 × 960 GB NVMe drives configured in RAID-1 |
| **Capacity Storage** | 16 or 24 × 4TB NVMe Read Intensive drives |
| **Networking** | 2 × Nvidia ConnectX-6 10/25 GbE dual-port adapters |
| **Power Supplies** | Dual, redundant, hot-swappable units |
| **Platform Security** | TPM 2.0 |-->

### Server role allocation

Here's an example of server role allocation within a large-scale reference architecture to support Microsoft 365 workloads in connected mode.

- Three servers configured as a three-node Azure Local instance, supporting SharePoint Server and SQL Server workloads.

- Four servers each configured as single-node Azure Local instances, designated for Exchange Server mailbox roles.

- Two servers each configured as single-node Azure Local instances, assigned to Exchange Server edge transport roles.

The reference architectures also include prescriptive guidance for networking and security, such as virtual networks, network security groups, and load balancers, to segment, isolate, and secure workload access. In connected mode, they use Azure as the cloud-connected control plane. In disconnected mode, they use a local control plane.

## Microsoft 365 Local deployment

A Microsoft 365 Local solution partner certified by Microsoft must deploy Microsoft 365 Local. To ensure correct configuration and support throughout the product lifecycle, it's highly recommended that customers work with a certified partner.

A typical engagement with a solution partner involves the following phases:

| Phase | Description |
| -- | -- |
| **Assessment** | Analyze organizational requirements, compliance needs, and desired outcomes. |
| **Planning** | Define appropriate hardware configurations and specifications, as well as software solutions, including migration and integration strategies aligned with business needs. |
| **Acquisition** | Procure necessary hardware, software, and licenses. |
| **Deployment** | Execute the planned rollout in accordance with best practices. |

Microsoft 365 Local is now generally available. For information about authorized partners, contact your Microsoft account team or visit [Microsoft 365 Local General Availability Sign-Up](https://aka.ms/m365localsignup).
