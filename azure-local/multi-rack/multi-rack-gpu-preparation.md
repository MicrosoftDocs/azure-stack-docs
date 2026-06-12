---
title: Prepare GPUs for a multi-rack Azure Local instance
description: Learn how to prepare GPUs for a multi-rack Azure Local instance.
author: eak13
ms.author: ekarandjeff
ms.topic: how-to
ms.date: 06/12/2026
ms.service: azure-local
ms.subservice: multi-rack
---

# Prepare GPUs for Azure Local multi-rack

This article describes how to prepare graphical processing units (GPUs) on your Azure Local multi-rack instance for workloads running on Azure Local virtual machines (VMs) enabled by Azure Arc and on Azure Kubernetes Service (AKS) enabled by Azure Arc. GPUs are used for computation-intensive workloads such as machine learning and deep learning.

## Attaching GPUs on Azure Local multi-rack

Azure Local multi-rack supports **Discrete Device Assignment (DDA)** which allows you to dedicate a physical GPU to your workload. In a DDA deployment, virtualized workloads run on the native driver and typically have full access to the GPU's functionality. DDA offers the highest level of app compatibility and potential performance.  

Discrete Device Assignment dedicates an entire physical GPU to a single virtual machine, giving each VM exclusive access to the full device. This model delivers the highest level of GPU performance and compatibility: applications running in the guest VM use the native GPU vendor driver (NVIDIA) and have access to the complete set of GPU capabilities the hardware provides, including OpenGL and CUDA. Because the full GPU is allocated to one VM, the VM also has access to the GPU's entire VRAM. This approach makes DDA well suited for workloads that require maximum GPU throughput, predictable performance, or vendor-specific GPU features without virtualization overhead.

## Supported GPU models

Azure Local multi-rack currently supports the NVIDIA RTX Pro 6000 GPU for DDA workloads for Azure Local VMs enabled by Azure Arc.

For AKS Arc workloads with GPU support, see [Deploy GPU node pools for AKS Arc on Azure Local multi-rack](../../AKS-Arc/multi-rack/deploy-gpu-node-pool.md).

## Host requirements

Your Azure Local host must meet the following requirements:

- Your system must be an Azure Local multi-rack solution with GPU support.

- You must have access to Azure Local multi-rack.

- You must create a homogeneous configuration for GPUs across all the machines in your system. A homogeneous configuration consists of installing the same make and model of GPU.

> [!NOTE]
> GPU drivers aren't automatically installed inside the VM. After attaching a GPU to a VM, you must install the appropriate NVIDIA guest driver inside the VM before your workload can use the GPU.

## Next steps

- [Deploy GPUs on Arc VMs via Discrete Device Assignment (DDA)](./multi-rack-gpu-manage-via-device.md)
- [Deploy GPU node pools for AKS Arc on Azure Local multi-rack](../../AKS-Arc/multi-rack/deploy-gpu-node-pool.md)
