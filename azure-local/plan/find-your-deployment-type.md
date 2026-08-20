---
title: Find your Azure Local deployment type
description: Use this wizard-style guide to choose the Azure Local deployment type that fits your connectivity, scale, and architecture requirements.
#customer intent: As an IT admin evaluating Azure Local, I want a guided way to identify the deployment type that fits my requirements so that I follow the correct setup path on first try.
author: ronmiab
ms.author: robess
ms.date: 08/19/2026
ms.topic: concept-article
ms.service: azure-local
---

# Find your Azure Local deployment type

Azure Local supports several deployment types across two connectivity modes. This article guides you through three decisions - connectivity, scale, and architecture - and recommends a documentation path based on your answers.

Treat this article as your *start here* page. When you identify your deployment type, go to the corresponding Connected or Disconnected section in the table of contents.

## Overview

Azure Local provides a consistent on-premises experience for critical workloads and Arc services. It supports a wide spectrum of scale points and use cases, from a single machine up to hundreds of machines. You can deploy it in different ways depending on your use case and needs.

The following table summarizes the Azure Local deployment types covered by this guide:

| Deployment type | Description |
| --- | --- |
| [Hyperconverged](../overview/hyperconverged-overview.md) | Clusters of 1-16 machines using hyperconverged storage. You can also attach an external SAN for more storage capacity. |
| [Disaggregated](../overview/disaggregated-overview.md) | Disaggregated deployments range from a single machine footprint to a maximum of 64 machines that use SAN storage. |
| [Multi-rack](../multi-rack/multi-rack-overview.md) | Integrated racks of compute, storage, and networking that expand up to hundreds of machines. |
| [Small form factor](../small-form-factor/small-form-factor-overview.md) | Compact deployments for space- and power-constrained environments such as retail, branch, and edge sites. |

Disconnected operations is a connectivity mode, not a separate deployment type. You can run several of the deployment types above in either connected or disconnected mode.

For an in-depth overview of each deployment type, see [Azure Local scalability and deployment types](../scalability-deployments.md).

## Step 1: Connected or disconnected?

Pick the connectivity mode that matches your organization's sovereignty, regulatory, and operational requirements.

| Choose | If your environment... |
| --- | --- |
| **Connected** | Has reliable outbound connectivity to Azure. The control plane runs in an Azure cloud region. This is the standard deployment mode and supports the broadest set of Azure services. |
| **Disconnected** | Has strict sovereignty, regulatory, or air-gap requirements that prevent connectivity to the Azure public cloud. The control plane runs locally on a dedicated appliance with a subset of Azure capabilities. |

For more information about disconnected operations, see [Disconnected operations for Azure Local overview](../manage/disconnected-operations-overview.md).

## Step 2: What scale do you need?

Estimate the scale point you need today, plus headroom for growth.

| Choose | If you need... |
| --- | --- |
| **Single machine to small cluster** (1-3 machines) | A small footprint for branch, edge, or evaluation. Switchless storage configurations are available at this scale. |
| **Standard cluster** (4-16 machines) | A typical datacenter or large branch deployment. Requires a physical switch for storage network traffic. |
| **Rack-scale** (more than 16 machines, hundreds possible) | Hyperscale workloads that need integrated racks with built-in fault tolerance and dedicated network fabric. |
| **Edge / compact** | Space- and power-constrained sites where a compact appliance is preferred over a server cluster. |

Use the [Azure Local sizer tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer) to refine your scale estimate based on workload profile.

## Step 3: Which deployment architecture fits?

Match your scale and storage strategy to a deployment architecture.

| Choose | If you want... |
| --- | --- |
| [**Hyperconverged**](../overview/hyperconverged-overview.md) | Compute and storage on the same machines. Simplest operational model and the most common choice. Supports cluster sizes of up to 16 machines for standard clusters and up to 8 machines for rack aware clusters. |
| [**Disaggregated**](../overview/disaggregated-overview.md) | Compute and storage scaled independently. Uses SAN storage and supports up to 64 machines. Best when storage requirements grow at a different rate than compute. |
| [**Multi-rack**](../multi-rack/multi-rack-overview.md) | Prescriptive, preintegrated racks of compute, storage, and networking. Required for hundreds-of-machines scale. |
| [**Small form factor**](../small-form-factor/small-form-factor-overview.md) | A compact, zero-touch-provisioned appliance for edge, branch, or retail sites. |

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

For every deployment type, you start with **About**, then work through **Plan**, **Prepare**, **Deploy**, and (where applicable) **Enable**. After setup, you find Day-2 operations in the **Configure and manage** node within your deployment section. For hyperconverged and disaggregated, a single shared **Configure and manage** node serves both models.

## Next steps

- [Azure Local scalability and deployment types](../scalability-deployments.md)
- [What are hyperconverged deployments of Azure Local?](../overview/hyperconverged-overview.md)
- [What are disaggregated deployments of Azure Local?](../overview/disaggregated-overview.md)
- [What are multi-rack deployments of Azure Local?](../multi-rack/multi-rack-overview.md)
- [About small form factor deployments](../small-form-factor/small-form-factor-overview.md)
- [Disconnected operations for Azure Local overview](../manage/disconnected-operations-overview.md)
