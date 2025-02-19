---
title: Disconnected operations for Azure Local overview (preview)
description: Use Disconnected operations to deploy and manage your Azure Local (preview).
ms.topic: overview
author: ronmiab
ms.author: robess
ms.date: 02/10/2025
---

# Disconnected operations for Azure Local (preview)

Applies to: Azure Local, version 23H2, release 2411 and later

This article describes disconnected operations and how they can be used in the deployment and management of your Azure Local.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Overview

Disconnected operations for Azure Local enable the deployment and management of Azure Local instances without a connection to the Azure public cloud. This feature allows you to build, deploy, and manage virtual machines (VMs) and containerized applications using select Azure Arc-enabled services from a local control plane, providing a familiar Azure portal and CLI experience.

To run Azure Local with disconnected operations, it is essential to plan for extra capacity for the virtual appliance. The minimum hardware requirements to deploy and operate Azure Local in a disconnected environment are higher due to the need to host a local control plane. Proper planning is important to ensure smooth operations.

For more information, see technical prerequisites and hardware in the [Preview participation criteria](./disconnected-operations-overview.md#preview-participation-criteria) section.

## Why use disconnected operations?

Here are some scenarios for running Azure Local with disconnected operations:

- **Data sovereignty and compliance**: In sectors like government, healthcare, and finance, there's a necessity to meet data residency or compliance requirements. When operating disconnected, data and control remain within the designated organizational boundaries.

- **Remote or isolated locations**: In areas with limited network infrastructure, such as remote or protected regions, disconnected operations allow you to use Azure Arc services and run workloads without relying on internet connectivity. For example, oil rigs and manufacturing sites.

- **Security**: For industries with stringent security requirements, disconnected operations help reduce the attack surface by not exposing systems to external networks.

## Supported services

Disconnected operations for Azure Local support the following services:

|Service                            | Description                                  |
|-----------------------------------|----------------------------------------------|
| Azure portal                      | Delivers an Azure portal experience that's similar to Azure Public. |
| Azure Resource Manager (ARM)      | Manage and utilize subscriptions, resource groups, ARM templates, and Azure Command-Line Interface (CLI). |
| Role based access control (RBAC)  | Implement RBAC for subscriptions and resource groups. |
| Managed identity                  | Use **system-assigned** managed identity for resource types that support managed identity. |
| Arc-enabled servers               | Manage VM guests for Arc VMs on Azure Local. |
| Arc VMs for Azure Local           | Set up and manage Windows or Linux virtual machines using the disconnected operations feature for Azure Local. |
| Arc-enabled Kubernetes clusters   | Connect and manage Cloud Native Computing Foundation (CNCF) Kubernetes clusters deployed on Azure Local virtual machines, enabling unified configuration and management. |
| Azure Kubernetes Service (AKS) enabled by Arc for Azure Local | Set up and manage AKS on Azure Local. |
| Azure Local device management     | Create and manage Azure Local instances including the ability to add and remove nodes. |
| Azure Container Registry                | Create and manage container registries to store and retrieve container images and artifacts. |
| Azure Key Vault                         | Create and manage key vaults to store and access secrets. |
| Azure Policy                            | Enforce standards through policies when creating new resources. |

## Preview participation criteria

To participate in the preview, you must meet the following criteria:

- **Enterprise agreement**: A current enterprise agreement with Microsoft, typically covering a period of at least three years.

- **Business needs to operate disconnected**: The disconnected operations feature is for those who can't connect to Azure due to connectivity issues or regulatory restrictions. To be eligible for the preview, you must demonstrate a valid business need for operating disconnected. For more information, see [Why use disconnected operations?](./disconnected-operations-overview.md#why-use-disconnected-operations)

- **Technical prerequisites**: Your organization must meet the technical requirements to ensure secure and reliable operation when operating disconnected for Azure Local. For more information, see [System requirements](../concepts/system-requirements-23h2.md).

- **Hardware**: The disconnected operations feature is supported on validated Azure Local hardware during preview. You must bring their own validated Azure Local hardware. For a list of supported configurations, see the [Azure Local solutions catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog).

  In addition to the Azure Local hardware requirements, each node must meet the following minimum hardware specifications to run the disconnected operations appliance:

    | Specification                | Minimum configuration            |
    | -----------------------------| ---------------------------------|
    | Number of nodes              | 3 nodes                          |
    | Memory per node              | 64 GB                            |
    | Cores per node               | 24 physical cores                |
    | Storage per node             | 2 TB SSD/NVME                    |
    | Boot disk drive storage      | 480 GB SSD/NVME                  |

## Get started

To access the preview, you must complete this [form](https://aka.ms/az-local-disconnected-operations-prequalify) and wait for approval. You should be informed of your status, approved, rejected, queued, or need more information, within 10 business days of submitting the form.

If approved, you receive further instructions on how to acquire, download, and operate disconnected for Azure Local.

## Deployment sequence

Follow these steps to deploy and manage Azure Local with disconnected operations using the following Azure services:

| Step # | Description |
|------------|------------------|
| Read the overview | Review the overview to understand the disconnected operations feature and its benefits. |
| Review the participation criteria | Review the participation criteria before you get started. |
| **Plan** |        |
| Step 1: [Hardware requirements for disconnected operations](../manage/disconnected-operations-overview.md#preview-participation-criteria). | Ensure that you have the necessary hardware. |
| Step 2: [Network requirements for disconnected operations](../manage/disconnected-operations-network.md). | Configure the required network settings. |
| Step 3: [Identity integration for disconnected operations](../manage/disconnected-operations-identity.md). | Understand and configure your identity solution. |
| Step 4: [Security controls for disconnected operations](../manage/disconnected-operations-security.md). | Understand and configure security controls. |
| Step 5: [Public key infrastructure (PKI) integration for disconnected operations](../manage/disconnected-operations-pki.md). | Configure PKI and secure the endpoints. |
| **Deploy** |       |
| Step 6: [Set up disconnected operations](../index.yml). | Ensure you have the necessary access and permissions to set up disconnected operations. |
| Step 7: [Deploy Azure Local with disconnected operations](../index.yml). | Deploy Azure Local with disconnected operations. |
| **Manage** |       |
| [Azure CLI for disconnected operations](../index.yml). | Use the Azure CLI to manage Azure Local with disconnected operations. |
| [Arc VMs for disconnected operations](../index.yml). | Manage Arc VMs on Azure Local. |
| [Azure Kubernetes Service enabled by Arc for disconnected operations](../index.yml). | Manage Azure Kubernetes Service enabled by Arc on Azure Local. |
| [Azure Container Registry for disconnected operations](../index.yml). | Manage Azure Container Registry on Azure Local. |
| [Azure Policy for disconnected operations](../manage/disconnected-operations-policy.md). | Enforce standards through policies when creating new resources. |
| **Troubleshoot** |      |
| [On-demand log collection](../index.yml). | Collect logs on-demand for troubleshooting. |
| [Fallback log collection](../index.yml). | Use fallback log collection for troubleshooting. |

<!--Next steps-->