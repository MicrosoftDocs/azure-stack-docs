---
title: System requirements for AKS on Azure Local
description: Learn about system storage requirements for Azure Kubernetes Service (AKS) for Azure Local.
ms.topic: concept-article
author: xelu86
ms.author: alalve
ms.date: 12/09/2025
# Intent: As a system administrator, I want to understand the storage requirements needed to run my infrastructure.
# Keyword: AKS Azure Local storage requirements
---

# System requirements for AKS on Azure Local

With Azure Kubernetes Service (AKS) Arc on Azure Local, you can deploy Kubernetes clusters to your local infrastructure using Azure Arc. You can initiate cluster creation and management from familiar tools such as the Azure portal, Azure CLI, and Resource Manager templates. The clusters are automatically onboarded to Azure Arc, allowing centralized management and secure access through Microsoft Entra ID.

## System requirements

Microsoft and trusted hardware partners preconfigure and validate certified Azure Local platforms to deliver dependable AKS Arc deployments. These platforms feature the following essential infrastructure components:

- **Hardware:** Enterprise-grade servers and devices designed for high availability and performance.
- **Networking:** Integrated network fabric supporting redundancy, security, and scalable connectivity.
- **Storage:** Robust storage solutions optimized for Kubernetes workloads and data durability.
- **Operating systems:** Supported and secure OS images tailored for AKS Arc compatibility.
- **Management tools:** Built-in monitoring, automation, and lifecycle management utilities for streamlined operations.

The mentioned features provide a seamless Azure Arc integration out of the box, which allows administrators to concentrate on managing Kubernetes clusters and workloads, while the platform handles infrastructure maintenance and optimization. While the Azure Local platform provides integrated system requirements to reliably host AKS cluster nodes and control planes, certain configurations should be adjusted based on your environment and workload needs.

### Storage requirements

Storage requirements for AKS Arc on Azure Local depend primarily on hardware configuration, expected AKS workloads, and overall cluster sizing. While certified Azure Local platforms provide built-in baseline hardware, it’s important to assess your storage needs according to the types and scale of applications you plan to run.

- **Single storage path:** Ensure at least one storage path is configured in your Azure Local environment. To learn more, see [Create storage path for Azure Local](/azure/azure-local/manage/create-storage-path).

- **Storage per AKS Arc cluster:** For a standard AKS Arc cluster with a single control plane, such as a virtual machine (VM) with one node pool and one control plane running Azure on Linux:

  - **Minimum required:** A total of 10 GB of storage per node
  - **Maximum usage:** Up to 200 GB total, depending on the number of VMs and the workloads deployed

- **Workload usage recommendations:**

  - Use the designated storage volume exclusively for Kubernetes workloads.
  - Avoid storing unrelated files or data on these storage paths.
  - Store backup files and related data in a different location to prevent potential storage exhaustion issues.

## See also

- [AKS on Azure Local architecture](cluster-architecture.md)
- [How to deploy a Kubernetes cluster using the Azure portal](aks-create-clusters-portal.md)
- [Storage options for applications in AKS enabled by Azure Arc](concepts-storage.md)
