---
title: Find your Azure Local deployment type
description: Use this wizard-style guide to choose the Azure Local deployment type that fits your connectivity, scale, and architecture requirements.
#customer intent: As an IT admin evaluating Azure Local, I want a guided way to identify the deployment type that fits my requirements so that I follow the correct setup path on first try.
author: ronmiab
ms.author: robess
ms.date: 09/17/2026
ms.topic: concept-article
ms.service: azure-local
---

# Find your Azure Local deployment type

Azure Local supports several deployment types across two connectivity modes. This article guides you through three decisions - connectivity, scale, and architecture - and recommends a documentation path based on your answers.

Treat this article as your *start here* page. When you identify your deployment type, go to the corresponding Connected or Disconnected section in the table of contents.

## Overview

Azure Local provides a consistent on-premises experience for critical workloads and Arc services. It supports a wide spectrum of scale points and use cases, from a single machine up to hundreds of machines. You can deploy it in different ways depending on your use case and needs.

The following table summarizes the Azure Local deployment types covered by this guide:

| Deployment type | Description | What's new |
| --- | --- | --- |
| [Hyperconverged](../overview/hyperconverged-overview.md) | Clusters of 1-16 machines using hyperconverged storage. You can also attach an external SAN for more storage capacity. | [Hyperconverged what's new](../whats-new.md) |
| [Disaggregated](../overview/disaggregated-overview.md) | Disaggregated deployments range from a single machine footprint to a maximum of 64 machines that use SAN storage. | [Hyperconverged what's new](../whats-new.md) |
| [Multi-rack](../multi-rack/multi-rack-overview.md) | Integrated racks of compute, storage, and networking that expand up to hundreds of machines. | [Multi-rack what's new](../multi-rack/multi-rack-whats-new.md) |
| [Small form factor](../small-form-factor/small-form-factor-overview.md) | Compact deployments for space and power-constrained environments such as retail, branch, and edge sites. | [Small form factor overview](../small-form-factor/small-form-factor-overview.md) |

Disconnected operations is a connectivity mode, not a separate deployment type. You can run hyperconverged and disaggregated deployments in either connected or disconnected mode. Multi-rack and small form factor deployments are supported in connected mode only.

<!-- REVIEWERS: Confirm multi-rack disconnected support. Small form factor disconnected isn't supported per small-form-factor/connectivity-modes.md. -->

For an in-depth overview of each deployment type, see [Azure Local scalability and deployment types](../scalability-deployments.md).

## Step 1: Connected or disconnected?

Pick the connectivity mode that matches your organization's sovereignty, regulatory, and operational requirements.

| Choose | If your environment... |
| --- | --- |
| [**Connected**](../overview.md) | Has reliable outbound connectivity to Azure. The control plane runs in an Azure cloud region. This deployment mode is standard and supports the broadest set of Azure services. |
| [**Disconnected**](../manage/disconnected-operations-overview.md) | Has strict sovereignty, regulatory, or air-gap requirements that prevent connectivity to the Azure public cloud. The control plane runs locally on a dedicated appliance with a subset of Azure capabilities. |

## Step 2: What scale do you need?

Estimate the scale point you need today, plus headroom for growth.

| Choose | If you need... |
| --- | --- |
| **Single machine to small cluster** (1-3 machines) | A small footprint for branch, edge, or evaluation. Switchless storage configurations are available at this scale. |
| **Standard cluster** (4-16 machines) | A typical datacenter or large branch deployment. Requires a physical switch for storage network traffic. |
| **Large cluster** (up to 64 machines) | Compute and storage scaled independently by using SAN storage. |
| **Rack-scale** (hundreds of machines) | Hyperscale workloads that need integrated racks with built-in fault tolerance and dedicated network fabric. |
| **Edge / compact** | Space and power-constrained sites where a compact small form factor appliance is preferred over a server cluster. |

Use the [Azure Local sizer tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer) to refine your scale estimate based on workload profile.

## Step 3: Which deployment architecture fits?

Match your scale and storage strategy to a deployment architecture.

| Choose | If you want... |
| --- | --- |
| [**Hyperconverged**](../overview/hyperconverged-overview.md) | Compute and storage on the same machines. Simplest operational model and the most common choice. Supports cluster sizes of up to 16 machines for standard clusters and up to 8 machines for [rack aware clusters](../concepts/rack-aware-cluster-overview.md). |
| [**Disaggregated**](../overview/disaggregated-overview.md) | Compute and storage scaled independently. Uses SAN storage and supports up to 64 machines. Best when storage requirements grow at a different rate than compute. |
| [**Multi-rack**](../multi-rack/multi-rack-overview.md) | Prescriptive, preintegrated racks of compute, storage, and networking. Required for hundreds-of-machines scale. |
| [**Small form factor**](../small-form-factor/small-form-factor-overview.md) | A compact appliance with zero-touch provisioning for edge, branch, and retail sites. |

## Recommended documentation path

Use your answers from steps 1-3 to find your starting point in the table of contents:

| Your result | Start here |
| --- | --- |
| Connected + Hyperconverged | **Connected environments** > **Hyperconverged and disaggregated** > **Install and deploy (hyperconverged)** |
| Connected + Disaggregated | **Connected environments** > **Hyperconverged and disaggregated** > **Install and deploy (disaggregated)** |
| Connected + Multi-rack | **Connected environments** > **Multi-rack** |
| Connected + Small form factor | **Connected environments** > **Small form factor** |
| Disconnected + Hyperconverged | **Disconnected environments** > **Hyperconverged and disaggregated** > **Install and deploy (hyperconverged)** |
| Disconnected + Disaggregated | **Disconnected environments** > **Hyperconverged and disaggregated** > **Install and deploy (disaggregated)** |

For every deployment type, you start with **About**, then work through **Plan**, **Prepare**, **Deploy**, and (where applicable) **Enable**. After setup, you find ongoing management and monitoring tasks in the **Configure and manage** node within your deployment section. For hyperconverged and disaggregated, a single shared **Configure and manage** node serves both models.

## Workload availability by deployment type

Workload availability varies by deployment type. For example, multi-rack and small form factor deployments might support fewer workloads than hyperconverged and disaggregated deployments.

Connectivity mode also affects availability. For the workloads and services available in disconnected mode, see [Supported services](../manage/disconnected-operations-overview.md#supported-services).

Use the following table to determine which workloads are supported for each deployment type.

<!-- REVIEWERS: Confirm every cell against the current product support matrix before publishing. The Foundry Local and Azure IoT Operations rows are newly added and need product confirmation. -->

| Workload | Hyperconverged | Disaggregated | Multi-rack | Small form factor |
| --- | --- | --- | --- | --- |
| [Azure Local VMs](../manage/azure-arc-vm-management-overview.md) | Yes | Yes | Yes | No |
| [Azure Kubernetes Service (AKS)](/azure/aks/aksarc/aks-whats-new-local) | Yes | Yes | Yes | Yes |
| [SQL Server](../deploy/sql-server-23h2.md) | Yes | Yes | No | No |
| [Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-virtual-desktop) | Yes | Yes | No | No |
| [Microsoft 365 Local](/azure/azure-sovereign-clouds/private/m365-local/microsoft-365-local-overview) | Yes | Yes | No | No |
| [GitHub Enterprise Local](/azure/azure-sovereign-clouds/private/github-local/github-local-overview) | Yes | Yes | No | No |
| [AI workloads](/azure/azure-sovereign-clouds/private/azure-local/ai-workloads-overview) | Yes | Yes | No | Yes (preview) |
| [Foundry Local](/azure/azure-sovereign-clouds/private/foundry-local/overview) | Yes | Yes | No | Yes (preview) |
| [Azure IoT Operations](/azure/iot-operations/deploy-iot-ops/overview-deploy) | Yes | Yes | No | No |

For the latest support information, see the workload overview article linked in the table.

## Next steps

- [Azure Local scalability and deployment types](../scalability-deployments.md)
- [What are hyperconverged deployments of Azure Local?](../overview/hyperconverged-overview.md)
- [What are disaggregated deployments of Azure Local?](../overview/disaggregated-overview.md)
- [What are multi-rack deployments of Azure Local?](../multi-rack/multi-rack-overview.md)
- [About small form factor deployments](../small-form-factor/small-form-factor-overview.md)
- [Disconnected operations for Azure Local overview](../manage/disconnected-operations-overview.md)
