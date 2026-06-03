---
title: Dedicated Management Cluster for Disconnected Operations
description: Learn hardware, topology, and capacity planning concepts to deploy a dedicated management cluster for disconnected operations.
author: ronmiab
ms.author: robess
ms.reviewer: lihou
ms.date: 06/02/2026
ms.topic: concept-article
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Dedicated management cluster for disconnected operations

::: moniker range=">=azloc-2603"

This article describes the architecture, hardware, and configuration concepts behind acquiring and deploying a dedicated management cluster for disconnected operations.

## Overview

Disconnected operations for Azure Local is a deployment model that brings cloud consistency and data sovereignty to environments with limited or no connectivity. In a disconnected deployment, a local control plane replaces selected Azure control plane functions and runs entirely within your environment, providing a familiar Azure consistent management experience.

To host the local control plane, you must deploy a separate Azure Local management cluster that is:

- Exclusively dedicated to control plane and management components
- Isolated from application or tenant workload clusters
- Sized to meet the hardware requirements of disconnected operations

This separation improves:

- **Availability** of the control plane
- **Operational isolation** from customer workloads
- **Lifecycle predictability** during upgrade and maintenance

This management cluster is separate from the clusters that run customer applications and tenant workloads, for operational isolation and control-plane reliability. Because this control plane is essential for ongoing management and lifecycle operations, it must be deployed on highly available infrastructure.

>[!NOTE]
> Production deployments require a dedicated three-node Azure Local management cluster to host the local control plane. Evaluation and test configurations may use smaller management clusters, as described in the deployment options later in this article.

## Hardware procurement

To procure hardware for a management cluster that hosts the disconnected operations control plane, you must meet specific requirements for performance, availability, and supportability.

For detailed and current hardware requirements, review the [minimum configurations](/azure/azure-local/manage/disconnected-operations-overview#eligibility-criteria) for a management cluster with the disconnected operations control plane appliance.

For a list of hardware solutions that support running as a management cluster for disconnected operations, go to the [Azure Local catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog?gpuSupport=GPU_P&gpuSupport=DDA) and select **Disconnected operations** under **Solution capability** in the left menu. These solutions meet the support requirements and are validated by the hardware solution providers to use as the control plane for disconnected operations.

## Topology and workload separation

For the management cluster, use a three-node Azure Local cluster with a switchless storage network design (recommended). This configuration provides quorum and resiliency for the management plane while minimizing infrastructure footprint and network complexity.

The management cluster is dedicated to:

- Control plane appliance for disconnected operations
- Supporting management services required for disconnected operations

>[!NOTE]
> Deploy tenant workloads (VMs and applications) on separate Azure Local clusters. Don't deploy workloads other than the control plane to the management cluster.

## Capacity planning

Because the control plane runs locally, you need to plan capacity to keep the management cluster reliable.

- Size hardware to meet the control plane requirements.
- Don't use the management cluster as a general-purpose compute pool.
- Keep capacity headroom for updates and lifecycle operations.
- Plan for node repair and replacement scenarios to keep the management cluster operational during unexpected hardware events.

## Proof-of-concept configurations

To get started with a quick proof of concept (POC) for disconnected operations, we recommend you use a four-node Azure Local hardware configuration from the supported solutions in the Azure Local catalog. You can arrange the four nodes in three alternative configurations, depending on which aspects of disconnected operations you want to emphasize during testing.

### Option 1: Management-focus

This option uses:

- Three-node dedicated management cluster that hosts the disconnected operations control plane services
- One-node Azure Local workload cluster used to validate basic workload deployment and management scenarios

:::image type="content" source="media/disconnected-operations-control-plane-appliance/management-focused.png" alt-text="Diagram of a management focused proof-of-concept." lightbox="media/disconnected-operations-control-plane-appliance/management-focused.png":::

Use this configuration when the primary goal is to:

- Evaluate the disconnected control plane architecture
- Understand management cluster sizing and isolation
- Validate operational independence of the control plane

### Option 2: Workload-focused

This option uses:

- One-node management cluster that hosts the disconnected operations control plane for testing purposes
- Three-node Azure Local workload cluster used to evaluate workload placement, resiliency, and management at small scale

:::image type="content" source="media/disconnected-operations-control-plane-appliance/workload-focused.png" alt-text="Diagram of a workload focused proof-of-concept." lightbox="media/disconnected-operations-control-plane-appliance/workload-focused.png":::

Use this configuration when the primary goal is to:

- Focus on Azure Local workload behavior in disconnected mode
- Test application deployment scenarios
- Evaluate workload cluster operations with a minimal management footprint

### Option 3: Multi-cluster-focused

This option uses:

- One-node management cluster that hosts the disconnected operations control plane for testing purposes
- Three separate one-node Azure Local workload clusters used to validate basic workload deployment and multi-cluster management scenarios

:::image type="content" source="media/disconnected-operations-control-plane-appliance/multi-cluster-focused.png" alt-text="Diagram of a multi-cluster focused proof-of-concept." lightbox="media/disconnected-operations-control-plane-appliance/multi-cluster-focused.png":::

Use this configuration when the primary goal is to:

- Manage multiple Azure Local clusters from a single control plane appliance
- Validate cluster-level inventory, visibility, and lifecycle operations
- Perform disconnected management across multiple isolated environments

## Next step

[About Azure Local deployment](../deploy/deployment-introduction.md)

::: moniker-end

::: moniker range="<=azloc-2602"

This feature is available only in Azure Local 2603 or later.

::: moniker-end
