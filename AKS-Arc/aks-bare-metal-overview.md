---
title: What is Azure Kubernetes Service on bare metal?
description: Learn about Azure Kubernetes Service (AKS) on bare metal, a deployment option that runs Kubernetes directly on hardware without a hypervisor layer.
ms.topic: overview
ms.date: 06/01/2026
author: SummerSmith
ms.author: sumsmith
---

# What is Azure Kubernetes Service on bare metal?

> [!IMPORTANT]
> Azure Kubernetes Service on bare metal is currently in preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability. Azure Kubernetes Service on bare metal previews are partially covered by customer support on a best-effort basis.

Azure Kubernetes Service (AKS) on bare metal is a deployment option that runs Kubernetes clusters directly on physical hardware without a hypervisor layer. It extends the unified AKS experience to bare metal infrastructure, giving you the same Azure management plane, APIs, and tooling you use with AKS in the cloud - while eliminating virtualization overhead.


## Key benefits

- **No hypervisor overhead** - Run Kubernetes directly on hardware, dedicating all compute resources to your workloads.
- **Unified Azure management** - Create, manage, and monitor clusters through the Azure portal, ARM templates, or Bicep - the same tools you use for AKS everywhere else.
- **Arc-connected** - Clusters are automatically connected to Azure Arc, enabling Azure Policy, Azure Monitor, GitOps, and other Azure services.
- **Consistent Kubernetes experience** - Same core APIs, lifecycle management, and operational tooling as AKS across cloud, hybrid, and edge.

## When to use AKS on bare metal

AKS on bare metal is ideal for scenarios where:

- **Maximum performance matters** - Workloads that can't tolerate hypervisor overhead.
- **Edge and remote locations** - Small-footprint deployments at retail stores, factories, or field sites where a full hyperconverged infrastructure isn't needed.
- **Sovereign and regulated environments** - Deployments that must remain on-premises with full Azure management capabilities.
- **Resource-constrained hardware** - Single-machine deployments where every CPU cycle and byte of memory counts.

## How it works

AKS on bare metal deploys a Kubernetes cluster directly onto an Azure Arc-enabled machine. The deployment creates:

1. **Edge Machine** — Registers the physical hardware with Azure
1. **Device Pool** — Groups machines for AKS workload placement (auto-creates a Custom Location)
1. **Logical Network** — Configures networking with IP pools for the cluster
1. **AKS cluster** — A fully managed Kubernetes cluster running directly on the hardware

You manage all resources through Azure Resource Manager and see them in the Azure portal.

## Architecture overview

![image.png](/.attachments/image-98ec65d9-ecdb-42a0-8615-05330040805c.png)

## Public preview scope

During public preview, AKS on bare metal supports:

- Single-node clusters
- Small form factor Azure Local device as the host OS
- Kubernetes versions 1.34.2 and 1.34.3
- Region: **East US** only
- Zero-rated billing (no charges during preview)
- Cluster creation via Azure portal, Bicep, and ARM templates

## Next steps

- [System requirements and prerequisites](system-requirements.md)
- [Create a Kubernetes cluster using the Azure portal](create-cluster-portal.md)
