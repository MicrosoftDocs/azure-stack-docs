---
title: System requirements for AKS on Azure Local
description: Learn about system storage requirements for Azure Kubernetes Service (AKS) for Azure Local.
ms.topic: concept-article
author: xelu86
ms.author: alalve
ms.date: 12/09/2025
# Intent: As a system administrator, I want to understand the storage requirements needed to run my infrastructure.
# Keyword: AKS Azure Local system requirements
---

# System requirements for AKS on Azure Local

With Azure Kubernetes Service (AKS) Arc on Azure Local, you can deploy Kubernetes clusters to your local infrastructure using Azure Arc. You can initiate cluster creation and management from familiar tools such as the Azure portal, Azure CLI, and Resource Manager templates. The clusters are automatically onboarded to Azure Arc, allowing centralized management and secure access through Microsoft Entra ID.

On certified Azure Local platforms, many hardware and system requirements are integrated to ensure your infrastructure can reliably host AKS cluster nodes and control planes.

## Storage requirements

The storage requirements for AKS Arc on Azure Local can vary depending on the hardware configuration and workload expectations within your specific infrastructure. While certified Azure Local platforms provide built-in baseline hardware, it’s important to assess your storage needs according to the types and scale of applications you plan to run.

- **Single storage path:** Ensure at least one storage path is configured in your Azure Local environment. To learn more, see [Create storage path for Azure Local](/azure/azure-local/manage/create-storage-path).

- **Storage Per Node:** For a standard cluster with a single control plane (one node pool, one control plane running Azure Linux):

  - **Minimum required:** 10 GB per node
  - **Maximum usage:** Up to 200 GB per node, depending on the specific workloads deployed

- **Workload usage recommendations:**

  - Use the designated storage volume exclusively for Kubernetes workloads.
  - Avoid storing unrelated files or data on these storage paths.
  - Store backup files and related data in a different location to prevent potential storage
    exhaustion issues.
