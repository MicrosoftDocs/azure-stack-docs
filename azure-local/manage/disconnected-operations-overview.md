---
title: Disconnected operations for Azure Local overview
description: Learn how to use disconnected operations to deploy and manage Azure Local. Build secure, compliant private clouds for remote or sovereign environments.
ms.topic: overview
author: ronmiab
ms.author: robess
ms.date: 02/23/2026
ai-usage: ai-assisted
ms.subservice: hyperconverged
---

# Disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

Disconnected operations enable you to deploy and manage Azure Local instances to build sovereign private clouds. This article explains how this feature supports compliance, security, and remote deployments.

## Overview

Disconnected operations for Azure Local enable you to deploy and manage Azure Local instances without a connection to the Azure public cloud. This feature allows you to build, deploy, and manage virtual machines (VMs) and containerized applications by using select Azure Arc-enabled services from a local control plane. You get a familiar Azure portal and Azure Command-Line Interface (CLI) experience.

To run Azure Local with disconnected operations, it's essential to plan for extra capacity for the virtual appliance. The minimum hardware requirements to deploy and operate Azure Local in a disconnected environment are higher because you need to host a local control plane. Proper planning helps ensure smooth operations.

For more information, see technical prerequisites and hardware in the [Eligibility criteria](./disconnected-operations-overview.md#eligibility-criteria) section.

## Why use disconnected operations?

Here are some scenarios for running Azure Local with disconnected operations:
- **Sovereign requirements and compliance**: In sectors like government, healthcare, and finance, you have data residency and sovereign requirements that are hard to meet using public sovereign cloud controls. When you run disconnected, data, operations, and control remain within your organization's boundaries. 

- **Remote or isolated locations**: In areas with limited network infrastructure, like remote or protected regions, disconnected operations lets you use Azure Arc services and run workloads without relying on internet connectivity. For example, oil rigs and manufacturing sites.

- **Security**: For industries with strict security requirements, disconnected operations help reduce the attack surface by not exposing systems to external networks.

## Supported services

Disconnected operations for Azure Local support the following services:

| Service | Description |
| ----------------------------------- | ---------------------------------------------- |
| Azure portal | Delivers an Azure portal experience that's similar to Azure Public. |
| Azure Resource Manager (ARM) | Manage and use subscriptions, resource groups, ARM templates, and CLI. |
| Role-based access control (RBAC) | Implement RBAC for subscriptions and resource groups. |
| Managed identity | Use **system-assigned** managed identity for resource types that support managed identity. |
| Arc-enabled servers | Manage VM guests for Azure Local VMs. |
| Azure Local VMs | Set up and manage Windows or Linux VMs by using the disconnected operations feature for Azure Local. |
| Arc-enabled Kubernetes clusters (Preview) | Connect and manage Cloud Native Computing Foundation (CNCF) Kubernetes clusters deployed on Azure Local VMs, enabling unified configuration and management. |
| Azure Kubernetes Service (AKS) enabled by Arc for Azure Local (Preview) | Set up and manage AKS on Azure Local. |
| Azure Local device management | Create and manage Azure Local instances including the ability to add and remove nodes. |
| Azure Container Registry | Create and manage container registries to store and retrieve container images and artifacts. |
| Azure Key Vault | Create and manage key vaults to store and access secrets. |
| Azure Policy | Enforce standards and governance through policies when creating new resources. |

## Eligibility criteria

To be eligible to procure disconnected operations, you must meet the following criteria:

- **Microsoft Customer Agreement for Enterprises (MCA-E)**: A Microsoft Customer agreement with Microsoft for enterprises.

- **Business needs to operate disconnected**: Disconnected operations are for organizations that can't connect to Azure because of connectivity issues or regulatory restrictions. To be able to procure disconnected operations, you need a valid business need for running and operating in a disconnected environment. For more information, see [Why use disconnected operations?](./disconnected-operations-overview.md#why-use-disconnected-operations)

- **Operational and technical prerequisites**: Your organization must have staff that can deploy and operate disconnected operations or work with a preferred partner to deploy and operate disconnected operations on your behalf. You must identify workloads and application requirements for what you deploy and operate disconnected.

- **Hardware**: Disconnected operations support premier Azure Local hardware. You must bring your own Azure Local hardware. For a list of supported configurations, see the [Azure Local solutions catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog).

  - Plan enough capacity for the management cluster to host the disconnected operations appliance VM. Make sure to include capacity for core Azure Local infrastructure components and any workloads you plan to run on the management cluster. Review the minimum specifications for setting up a management cluster with the disconnected operations appliance:

    | Specification                | Minimum configuration            |
    | -----------------------------| ---------------------------------|
    | Number of nodes              | 3 nodes                          |
    | Memory per node              | 96 GB *                          |
    | Cores per node               | 24 physical cores                |
    | Storage per node             | 2 TB SSD/NVME                    |
    | Boot disk drive storage      | 960 GB SSD/NVME **               |

    *<sub> The disconnected operations appliance running on the management cluster needs at least 64 GB of memory. We recommend that management cluster nodes have at least 96 GB of memory to provide enough capacity to run the appliance and other infrastructure components.</sub>

    **<sub> For systems with boot disks smaller than 960 GB, you must use extra data disks from the nodes (capacity) to install the appliance. A 960 GB boot drive is recommended as the minimum to reduce deployment complexity if your OEM configuration allows for a larger boot drive.</sub>

## Get started

To get access, work with your account team to understand the terms and agreements of the product. The account team or you can complete this [form](https://aka.ms/az-local-disconnected-operations-prequalify) and wait for approval. You receive a notification of your status (approved, rejected, queued, or need more information) within 10 business days. If you're approved, you receive instructions for how you get access.

## Deployment and management flow

Here's the flow to deploy and manage Azure Local with disconnected operations:

### Review

| Description | Step |
| ------------ | ------------------ |
| Check known issues with disconnected operations for Azure Local. | [Known issues for disconnected operations](disconnected-operations-known-issues.md) |
| Check the eligibility criteria before you get started. | [Eligibility criteria](#eligibility-criteria) |

### Plan

| Description | Step |
| ------------ | ------------------ |
| Configure the required network settings. | [Network requirements for disconnected operations](disconnected-operations-network.md) |
| Understand and configure your identity solution. | [Identity integration for disconnected operations](disconnected-operations-identity.md) |
| Understand and configure security controls. | [Security controls for disconnected operations](disconnected-operations-security.md) |
| Configure PKI and secure the endpoints. | [Public key infrastructure (PKI) integration for disconnected operations](disconnected-operations-pki.md) |

### Deploy

| Description | Step |
| ------------ | ------------------ |
| Make sure you have the access and permissions you need to set up disconnected operations. | [Acquire disconnected operations](disconnected-operations-acquire.md) |
| Prepare an Azure Local instance to support disconnected deployments. | [Prepare Azure Local for disconnected deployments](disconnected-operations-prepare.md) |
| Deploy the management cluster with the disconnected appliance. | [Deploy Azure Local with disconnected operations](disconnected-operations-deploy.md) |
| Register after management cluster deployment. | [Register disconnected operations](disconnected-operations-registration.md) |

### Manage

| Description | Step |
| ------------ | ------------------ |
| Use the CLI to manage Azure Local with disconnected operations. | [Azure CLI for disconnected operations](disconnected-operations-cli.md) |
| Manage Azure Local VMs. | [Azure Local VMs for disconnected operations](disconnected-operations-arc-vm.md) |
| Manage Azure Kubernetes Service enabled by Arc on Azure Local. | [Azure Kubernetes Service enabled by Arc for disconnected operations (preview)](/azure/aks/aksarc/disconnected-operations-aks) |
| Manage Azure Container Registry on Azure Local. | [Azure Container Registry for disconnected operations](disconnected-operations-azure-container-registry.md) |
| Enforce standards with policies when creating new resources. | [Azure Policy for disconnected operations](disconnected-operations-policy.md) |
| Use the CLI to create an Azure Key Vault. | [Azure Key Vault for disconnected operations](/azure/key-vault/general/quick-create-cli#create-a-key-vault) |
| Monitor infrastructure and workloads running on Azure Local with disconnected operations. | [Monitor disconnected operations for Azure Local](disconnected-operations-monitoring.md) |

### Troubleshoot

| Description | Step |
| ------------ | ------------------ |
| Collect logs on demand for troubleshooting. | [On-demand log collection](disconnected-operations-on-demand-logs.md) |
| Use fallback log collection for troubleshooting. | [Fallback log collection](disconnected-operations-fallback.md) |

## Related content

- Learn more about [Azure Local with Disconnected operations](https://techcommunity.microsoft.com/blog/azurearcblog/cloud-infrastructure-for-disconnected-environments-enabled-by-azure-arc/4413561)

::: moniker-end

::: moniker range="<=azloc-2601"

This feature is available only in Azure Local 2602 or later.

::: moniker-end
