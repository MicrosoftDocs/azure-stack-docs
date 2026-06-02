---
title: Dedicated Management Cluster for Disconnected Operations
description: Learn hardware, topology, and capacity planning concepts to deploy successfully.
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

Disconnected operations for Azure Local is a deployment model that brings cloud consistency and data sovereignty to environments with limited or no connectivity. In a disconnected deployment, a local control plane replaces selected Azure control plane functions and runs entirely within the customer environment, providing a familiar Azure consistent management experience.

To support this local control plane, you must provision dedicated infrastructure beyond the workload clusters. You must deploy a dedicated management cluster to host the control plane services. This management cluster is separate from the clusters that run customer applications and tenant workloads, for operational isolation and control-plane reliability.

## Dedicated management (control plane) cluster

In a disconnected Azure Local environment, the control plane runs as a virtual appliance hosted on Azure Local infrastructure. Because this control plane is essential for ongoing management and lifecycle operations, it must be deployed on highly available infrastructure.

You need a three-node Azure Local cluster that's:

- Exclusively dedicated to control plane and management components
- Isolated from application or tenant workload clusters
- Sized to meet the hardware requirements of disconnected operations

This separation improves:

- **Availability** of the control plane
- **Operational isolation** from customer workloads
- **Lifecycle predictability** during upgrade and maintenance

## Hardware procurement

Start with the Azure Local catalog when procuring hardware for a management cluster. For a list of hardware solutions that support running as a management cluster for disconnected operations, go to the [Azure Local catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog?gpuSupport=GPU_P&gpuSupport=DDA) and select **Disconnected operations** under **Solution capability** in the left menu. These solutions meet the support requirements and are validated by the hardware solution providers to use as the control plane for disconnected operations.

For detailed and current hardware requirements, review the [minimum configurations](/azure/azure-local/manage/disconnected-operations-overview#eligibility-criteria) for a management cluster with the disconnected operations control plane appliance.

Key requirements include:

- Sufficient CPU, memory, and storage capacity to host the control plane services
- High-availability clustering across three physical nodes
- Premier solutions that meet the disconnected operations requirements and are validated to use as the control plane

## Cluster topology and workload separation

For the management cluster, use a three-node Azure Local cluster with a switchless storage network design (recommended). This configuration provides quorum and resiliency for the management plane while minimizing infrastructure footprint and network complexity.

The management cluster is dedicated to:

- Control plane appliance for disconnected operations
- Supporting management services required for disconnected operations

You must deploy customer application workloads and tenant VMs on separate Azure Local clusters to ensure operational isolation and predictable management behavior. You can't deploy workloads other than the control plane to the management cluster.

## Capacity planning

Because the control plane runs locally, you need to plan capacity to keep the management cluster reliable.

- Size hardware to meet the control plane requirements.
- Don't use the management cluster as a general-purpose compute pool.
- Keep capacity headroom for updates and lifecycle operations.
- Plan for node repair and replacement scenarios to keep the management cluster operational during unexpected hardware events.

## Proof-of-concept configurations

To get started with a quick proof of concept (POC) for disconnected operations, we recommend you use a four-node Azure Local hardware configuration from the supported solutions in the Azure Local catalog. You can arrange the four nodes in three alternative configurations, depending on which aspects of disconnected operations you want to emphasize during testing.

### Option 1: Dedicated management cluster

This option uses:

- Three-node dedicated management cluster that hosts the disconnected operations control plane services
- One-node Azure Local workload cluster used to validate basic workload deployment and management scenarios

Use this configuration when the primary goal is to:

- Evaluate the disconnected control plane architecture
- Understand management cluster sizing and isolation
- Validate operational independence of the control plane

### Option 2: Workload cluster

This option uses:

- One-node management cluster that hosts the disconnected operations control plane for testing purposes
- Three-node Azure Local workload cluster used to evaluate workload placement, resiliency, and management at small scale

Use this configuration when the primary goal is to:

- Focus on Azure Local workload behavior in disconnected mode
- Test application deployment scenarios
- Evaluate workload cluster operations with a minimal management footprint

### Option 3: Multi-cluster management

This option uses:

- One-node management cluster that hosts the disconnected operations control plane for testing purposes
- Three separate one-node Azure Local workload clusters used to validate basic workload deployment and multi-cluster management scenarios

Use this configuration when the primary goal is to:

- Manage multiple Azure Local clusters from a single control plane appliance
- Validate cluster-level inventory, visibility, and lifecycle operations
- Perform disconnected management across multiple isolated environments

## Next steps

To proceed with an Azure Local deployment with disconnected operations, complete the following steps:

1. Review the [disconnected operations overview and eligibility criteria](/azure/azure-local/manage/disconnected-operations-overview#eligibility-criteria).
1. Select a [catalog listed hardware solution](https://azurelocalsolutions.azure.microsoft.com/#/catalog) marked as disconnected operations supported.
1. After you're approved to access disconnected operations, contact the OEM partner and procure a four-node configuration to start the POC or a three-node dedicated management cluster if you have the workload clusters.
1. Follow the deployment documentation for installation and configuration of disconnected operations.

::: moniker-end

::: moniker range="<=azloc-2602"

This feature is available only in Azure Local 2603 or later.

::: moniker-end
