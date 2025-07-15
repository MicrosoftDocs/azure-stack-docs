---
title: Disconnected operations for Azure Local overview (preview)
description: Learn how to use disconnected operations to deploy and manage Azure Local (preview).
ms.topic: overview
author: ronmiab
ms.author: robess
ms.date: 06/20/2025
ai-usage: ai-assisted
---

# Disconnected operations for Azure Local (preview)

::: moniker range=">=azloc-2506"

This article explains disconnected operations and how it can be used in the deployment and management of your Azure Local instances. Learn how this capability supports compliance, security, and remote deployments.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Overview

Disconnected operations for Azure Local enable the deployment and management of Azure Local instances without a connection to the Azure public cloud. This feature allows you to build, deploy, and manage virtual machines (VMs) and containerized applications using select Azure Arc-enabled services from a local control plane, providing a familiar Azure portal and Azure Command-Line Interface (CLI) experience.

To run Azure Local with disconnected operations, it's essential to plan for extra capacity for the virtual appliance. The minimum hardware requirements to deploy and operate Azure Local in a disconnected environment are higher because you need to host a local control plane. Proper planning helps ensure smooth operations.

For more information, see technical prerequisites and hardware in the [Preview participation criteria](./disconnected-operations-overview.md#preview-participation-criteria) section.

## Why use disconnected operations?

Here are some scenarios for running Azure Local with disconnected operations:

- **Data sovereignty and compliance**: In sectors like government, healthcare, and finance, there's a necessity to meet data residency or compliance requirements. When you run disconnected, data and control remain within your organization's boundaries.

- **Remote or isolated locations**: In areas with limited network infrastructure, like remote or protected regions, disconnected operations lets you use Azure Arc services and run workloads without relying on internet connectivity. For example, oil rigs and manufacturing sites.

- **Security**: For industries with strict security requirements, disconnected operations help reduce the attack surface by not exposing systems to external networks.

## Supported services

Disconnected operations for Azure Local support the following services:

|Service                            | Description                                  |
|-----------------------------------|----------------------------------------------|
| Azure portal                      | Delivers an Azure portal experience that's similar to Azure Public. |
| Azure Resource Manager (ARM)      | Manage and utilize subscriptions, resource groups, ARM templates, and CLI. |
| Role based access control (RBAC)  | Implement RBAC for subscriptions and resource groups. |
| Managed identity                  | Use **system-assigned** managed identity for resource types that support managed identity. |
| Arc-enabled servers               | Manage VM guests for Azure Local VMs. |
| Azure Local VMs           | Set up and manage Windows or Linux virtual machines using the disconnected operations feature for Azure Local. |
| Arc-enabled Kubernetes clusters   | Connect and manage Cloud Native Computing Foundation (CNCF) Kubernetes clusters deployed on Azure Local VMs, enabling unified configuration and management. |
| Azure Kubernetes Service (AKS) enabled by Arc for Azure Local | Set up and manage AKS on Azure Local. |
| Azure Local device management     | Create and manage Azure Local instances including the ability to add and remove nodes. |
| Azure Container Registry          | Create and manage container registries to store and retrieve container images and artifacts. |
| Azure Key Vault                   | Create and manage key vaults to store and access secrets. |
| Azure Policy                      | Enforce standards through policies when creating new resources. |

## Preview participation criteria

To participate in the preview, you must meet the following criteria:

- **Enterprise agreement**: A current enterprise agreement with Microsoft, typically covering a period of at least three years.

- **Business needs to operate disconnected**: Disconnected operations are for organizations that can't connect to Azure because of connectivity issues or regulatory restrictions. To join the preview, show a valid business need for running disconnected. For more information, see [Why use disconnected operations?](./disconnected-operations-overview.md#why-use-disconnected-operations)

- **Technical prerequisites**: Your organization must meet the technical requirements to ensure secure and reliable operation when running disconnected for Azure Local. For more information, see [System requirements](../concepts/system-requirements-23h2.md).

- **Hardware**: The disconnected operations feature is supported on validated Azure Local hardware during preview. You must bring your own validated Azure Local hardware. For a list of supported configurations, see the [Azure Local solutions catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog).

  Make sure your hardware meets the minimum specifications to run the disconnected operations appliance:

    | Specification                | Minimum configuration            |
    | -----------------------------| ---------------------------------|
    | Number of nodes              | 3 nodes                          |
    | Memory per node              | 64 GB                            |
    | Cores per node               | 24 physical cores                |
    | Storage per node             | 2 TB SSD/NVME                    |
    | Boot disk drive storage      | 960 GB SSD/NVME                  |

## Get started

To access the preview, complete this [form](https://aka.ms/az-local-disconnected-operations-prequalify) and wait for approval. You get notified of your status (approved, rejected, queued, or need more information) within 10 business days. If you're approved, you receive instructions on how to get, download, and operate disconnected for Azure Local.

## Deployment and management flow

Here's the flow to deploy and manage Azure Local with disconnected operations:

| Step | Description |
|------------|------------------|
| Review [Known issues for disconnected operations](disconnected-operations-known-issues.md). | Check known issues with disconnected operations for Azure Local. |
| Review the [Preview participation criteria](#preview-participation-criteria) | Check the preview participation criteria before you get started. |
| **Plan** |        |
| Review [Network requirements for disconnected operations](disconnected-operations-network.md). | Configure the required network settings. |
| Review [Identity integration for disconnected operations](disconnected-operations-identity.md). | Understand and configure your identity solution. |
| Review [Security controls for disconnected operations](disconnected-operations-security.md). | Understand and configure security controls. |
| Review [Public key infrastructure (PKI) integration for disconnected operations](disconnected-operations-pki.md). | Configure PKI and secure the endpoints. |
| **Deploy** |       |
| Review [Set up disconnected operations](disconnected-operations-set-up.md). | Make sure you have the access and permissions you need to set up disconnected operations. |
| Review [Deploy Azure Local with disconnected operations](disconnected-operations-deploy.md). | Deploy Azure Local with disconnected operations. |
| **Manage** |       |
| Review [Azure CLI for disconnected operations](disconnected-operations-cli.md). | Use the CLI to manage Azure Local with disconnected operations. |
| Review [Azure Local VMs for disconnected operations](disconnected-operations-arc-vm.md). | Manage Azure Local VMs. |
| Review [Azure Kubernetes Service enabled by Arc for disconnected operations](disconnected-operations-aks.md). | Manage Azure Kubernetes Service enabled by Arc on Azure Local. |
| Review [Azure Container Registry for disconnected operations](disconnected-operations-azure-container-registry.md). | Manage Azure Container Registry on Azure Local. |
| Review [Azure Policy for disconnected operations](disconnected-operations-policy.md). | Enforce standards with policies when creating new resources. |
| Review [Azure Key Vault for disconnected operations](/azure/key-vault/general/quick-create-cli#create-a-key-vault). | Use the CLI to create an Azure Key Vault. |
| Review [Monitor disconnected operations for Azure Local](disconnected-operations-monitoring.md). | Monitor infrastructure and workloads running on Azure Local with disconnected operations. |
| **Troubleshoot** |      |
| Review [On-demand log collection](disconnected-operations-on-demand-logs.md). | Collect logs on demand for troubleshooting. |
| Review [Fallback log collection](disconnected-operations-fallback.md). | Use fallback log collection for troubleshooting. |

## Related content

- Learn more about [Azure Local with Disconnected operations](https://techcommunity.microsoft.com/blog/azurearcblog/cloud-infrastructure-for-disconnected-environments-enabled-by-azure-arc/4413561)

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
