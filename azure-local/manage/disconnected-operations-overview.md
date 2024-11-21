---
title: Disconnected operations for Azure Local overview (preview)
description: Use Disconnected operations to deploy and manage your Azure Local (preview).
ms.topic: overview
author: ronmiab
ms.author: robess
ms.date: 11/19/2024

#customer intent: As a Senior Content Developer, I want provide customers with the highest level of content for using disconneced operations to deploy and manage their Azure Local instances.
---

# Disconnected operations for Azure Local (preview)

Applies to: Azure Local, version 23H2, release 2411 and later

This article describes disconnected operations and how they can be used in the deployment and management of your Azure Local.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Overview

Disconnected operations for Azure Local enable the deployment and management of Azure Local instances without a connection to the Azure public cloud. This feature allows you to build, deploy, and manage virtual machines (VMs) and containerized applications using select Azure Arc-enabled services from a local control plane, providing a familiar Azure portal and CLI experience.

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
| Role Based Access Control (RBAC)  | Implement RBAC for subscriptions and resource groups. |
| Managed Identity                  | Use **system-assigned** managed identity for resource types that support managed identity. |
| Arc-enabled servers               | Manage VM Guests for Arc VMs on Azure Local. |
| Arc VMs for Azure Local           | Set up and manage Windows or Linux virtual machines using the disconnected operations feature for Azure Local. |
| Arc-enabled Kubernetes (K8s)      | Connect and manage Cloud Native Computing Foundation (CNCF) Kubernetes clusters deployed on Azure Local virtual machines, enabling unified configuration and management. |
| Azure Kubernetes Service enabled by Arc for Azure Local | Set up and manage Azure Kubernetes (AKS) on Azure Local. |
| Azure Local device management     | Create and manage Azure Local instances including the ability to add and remove nodes. |
| Container Registry                | Create and manage container registries to store and retrieve container images and artifacts. |
| Key Vault                         | Create and manage Key Vaults to store and access secrets. |
| Policy                            | Enforce standards through policies when creating new resources. |

## Prerequisites

Before you begin, make sure you review and apply the appropriate hardware and requirements for Azure Local:

- [System requirements for Azure Local](../concepts/system-requirements-23h2.md).
- Validated nodes or higher, see [Azure Local catalog](https://azurestackhcisolutions.azure.microsoft.com/).

The next sections provide details on the hardware, integration, and access requirements to operate disconnected.

### Hardware requirements

The virtual appliance for disconnected operations runs on Azure Local instances. To operate Azure Local with disconnected operations, you need to plan for extra capacity for the virtual appliance. Additionally, you must meet higher minimum hardware requirements to deploy and operate Azure Local with disconnected operations, as it hosts a local control plane.

This checklist provides you with the minimum hardware requirements each node needs to support the disconnected operations virtual appliance. You should factor in extra capacity for VM or AKS workloads in your capacity planning.

| Specification                        | Minimum configuration            |
| -------------------------------------| ---------------------------------|
| Minimum number of nodes              | 3 nodes                          |
| Minimum memory per node              | 64 GB                            |
| Minimum cores per node               | 24 physical cores                |
| Minimum storage per node             | 2 TB SSD/NVME                    |
| Minimum boot drive storage           | 480 GB SSD/NVME                  |
| Network                              | Switchless and Switched are supported: [Network considerations for cloud deployments of Azure Local, version 23H2](../plan/cloud-deployment-network-considerations.md) <br><br> Note: Switchless configurations work for cluster size of three nodes only. |

### Integration requirements

You must integrate with existing datacenter assets that need to be pre-deployed and configured before starting the disconnected operations deployment process.

The following table lists the requirements to successfully deploy and run disconnected operations on Azure Local instances.

| Area          | Supported system         | Use                          |
| --------------| -------------------------| -----------------------------|
| Identity      | Active Directory Federation Service (ADFS) on Windows Server 2022. | Lightweight Directory Access Protocol (LDAP) provides group membership and synchronization. <br><br> ADFS authenticates users to the Azure Local portal to manage disconnected operations using Open-ID Connect (OIDC). <br><br> Active Directory (AD) is required for disconnected operations. |
| Public Key Infrastructure (PKI)   | Private and Public PKIs are supported. <br><br> If you use a public PKI, the certificate revocation list (CRL) endpoints must be reachable from your infrastructure. <br><br> Active Directory Certificate Services (ADCS) validated as a Private PKI solution. | Issue certificates to secure Azure Local disconnected operations endpoints (TLS). |
| Network Time Protocol (NTP) optional  | Local or Public time server. | Time server synchronizes the system clock. |
| Domain Name System (DNS)   | Any DNS server, such as DNS role on Windows Server. | DNS service is required in the local network to resolve Azure Local-disconnected operations endpoints and configure ingress IPs. <br><br> When you run the appliance for disconnected operations in a connected mode, a DNS server is required to resolve Microsoft domain names for logging and telemetry. |

For information on deploying and configuring the integration components, refer to:

- [Install and configure DNS Server on Windows Server](/windows-server/networking/dns/quickstart-install-configure-dns-server?tabs=powershell)
- [Windows Time Service](/windows-server/networking/windows-time-service/windows-time-service)
- [Active Directory Domain Services Overview](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)
- [What is Active Directory Certificate Services?](/windows-server/identity/ad-cs/active-directory-certificate-services-overview)
- [Implement and manage Active Directory Certificate Services](/training/modules/implement-manage-active-directory-certificate-services/)
- [ADFS 2016 deployment](/windows-server/identity/ad-fs/ad-fs-deployment)
- [Design options for ADFS for Windows Server](/windows-server/identity/ad-fs/ad-fs-design)

### Access requirements

To successfully configure disconnected operations and create the necessary resources, you need appropriate access and permissions to create and modify the following resources:

| Component   | Access required    |
|-------------|--------------------|
| AD + ADFS   | Create a service account with read access for the organizational unit to facilitate LDAP integration. <br><br> Export the configuration for ADFS (OIDC). |
| DNS         | Access to create DNS records or zones to provide lookups for a disconnected operations endpoint. |
| PKI         | Ability to create and export certificates to secure disconnected operations endpoints (TLS). |
| Network     | Access to the firewall (if a local firewall is implemented) to ensure necessary changes can be done. |

## Preview participation criteria

To participate in the preview, you must meet the following criteria:

- **Enterprise agreement**: A current enterprise agreement with Microsoft, typically covering a period of at least three years.

- **Business needs to operate disconnected**: The disconnected operations feature is for those who can't connect to Azure due to connectivity issues or regulatory restrictions. To be eligible for the preview, you must demonstrate a valid business need for operating disconnected. For more information, see [Why use disconnected operations?](./disconnected-operations-overview.md#why-use-disconnected-operations).

- **Technical prerequisites**: Your organization must meet the technical requirements to ensure secure and reliable operation when operating disconnected for Azure Local. For more information, see [Prerequisites](../manage/disconnected-operations-overview.md#prerequisites).

- **Hardware**: The disconnected operations feature is supported on validated Azure Local hardware during preview. You must bring their own validated Azure Local hardware. For a list of supported configurations, see the [Azure Local solutions catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog).

## Get started

To access the preview, you must complete this [form](https://aka.ms/az-local-disconnected-operations-prequalify) and wait for approval. You should be informed of your status, approved, rejected, queued, or need more information, within 10 business days of submitting the form.

If approved, you receive further instructions on how to acquire, download, and operate disconnected for Azure Local.
