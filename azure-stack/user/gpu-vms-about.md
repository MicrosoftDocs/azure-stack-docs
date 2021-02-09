---
title:  Graphics processing unit (GPU) VM on Azure Stack Hub
description: Reference for GPU computing in Azure Stack Hub.
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: reference
ms.date: 2/8/2021
ms.reviewer: kivenkat
ms.lastreviewed: /8/2021

# Intent: As a a developer on Azure Stack Hub, I want to use a machine with a Graphics Processing Unit (GPU) in order to deliver an processing intensive visualization application.
# Keyword: Azure Stack Hub Graphics Processing Unit (GPU)
---

# Graphics processing unit (GPU) virtual machine (VM) on Azure Stack Hub

*Applies to: Azure Stack integrated systems*

This article describes which graphics processing unit (GPU) models are supported on an Azure Stack Hub multinode system. You can also find instructions on installing the drivers used with the GPUs. GPU support in Azure Stack Hub enables solutions such as Artificial Intelligence, training, inference, and data visualization. The AMD Radeon Instinct MI25 can be used to support graphic-intensive applications such as Autodesk AutoCAD.

You can choose from three GPU models in the public preview period. They are available in NVIDIA V100, NVIDIA T4 and AMD MI25 GPUs. These physical GPUs align with the following Azure N-Series virtual machine (VM) types as follows:
- [NCv3](/azure/virtual-machines/ncv3-series)
- [NVv4 (AMD MI25)](/azure/virtual-machines/nvv4-series)
- [NCasT4_v3](/azure/virtual-machines/nct4-v3-series)

::: moniker range=">=azs-2005"
> [!IMPORTANT]  
> Azure Stack Hub GPU support is in public preview for the 2005 and 2008 Azure Stack Hub releases.  
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities.
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).
::: moniker-end

::: moniker range="<=azs-2002"
> [!WARNING]  
> GPU VMs are not supported in this release. You will need to upgrade to Azure Stack Hub 2005 or later.
::: moniker-end
## NCv3

NCv3-series VMs are powered by NVIDIA Tesla V100 GPUs. Customers can take advantage of these updated GPUs for traditional HPC workloads such as reservoir modeling, DNA sequencing, protein analysis, Monte Carlo simulations, and others. 

| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | GPU | GPU memory: GiB | Max data disks | Max NICs |
|---|---|---|---|---|---|---|---|---|
| Standard_NC6s_v3    | 6  | 112 | 736  | 1 | 16 | 12 | 4 |
| Standard_NC12s_v3   | 12 | 224 | 1474 | 2 | 32 | 24 | 8 |
| Standard_NC24s_v3   | 24 | 448 | 2948 | 4 | 64 | 32 | 8 |

## NVv4

The NVv4-series virtual machines are powered by [AMD Radeon Instinct MI25](https://www.amd.com/en/products/professional-graphics/instinct-MI25) GPUs. With NVv4-series Azure Stack Hub is introducing virtual machines with partial GPUs. This size can be used for GPU accelerated graphics applications and virtual desktops. NVv4 virtual machines currently support only Windows guest operating system. 

| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | GPU | GPU memory: GiB | Max data disks | Max NICs | 
| --- | --- | --- | --- | --- | --- | --- | --- |   
| Standard_NV4as_v4 |4 |14 |88 | 1/8 | 2 | 4 | 2 | 

## NCasT4_v3

| Size | vCPU | Memory: GiB | GPU | GPU memory: GiB | Max data disks | Max NICs | 
| --- | --- | --- | --- | --- | --- | --- |
| Standard_NC4as_T4_v3 |4 |28 | 1 | 16 | 8 | 4 | 
| Standard_NC8as_T4_v3 |8 |56 | 1 | 16 | 16 | 8 | 
| Standard_NC16as_T4_v3 |16 |112 | 1 | 16 | 32 | 8 | 
| Standard_NC64as_T4_v3 |64 |448 | 4 | 64 | 32 | 8 |

## Patch and update, FRU behavior of VMs 

GPU VMs will undergo downtime during operations such as patch and update (PnU) as well as hardware replacement (FRU) of Azure Stack Hub. The following table goes over the state of the VM as observed during these activities as well as the manual action that the user can do to make these VMs available again post these operations. 

| Operation | PnU - Express Update | PnU - Full Update, OEM update | FRU | 
| --- | --- | --- | --- | 
| VM state  | Unavailable during and post update without manual start operation | Unavailable during update. Available post update with manual operation | Unavailable during update. Available post update with manual operation| 
| Manual operation | If the VM needs to be made available during the update, if there are available GPU partitions, the VM can be restarted from the portal by clicking the **Restart** button. Restart the VM after the update from the portal using the **Restart** button | VM cannot be made available during the update. Post update completion, VM needs to be stop-deallocated using the **Stop** button and started back up using the "Start" button | VM cannot be made available during the update.Post update completion, VM needs to be stop-deallocated using the **Stop** button and started back up using the **Start** button.| 

## Guest driver installation

### AMD MI25

The article [Install AMD GPU drivers on N-series VMs running Windows](/azure/virtual-machines/windows/n-series-amd-driver-setup) provides instructions on installing the driver for the AMD Radeon Instinct MI25 inside the NVv4 GPU-P enabled VM along with steps on how to verify driver installation. This extension only works in connected mode.

### NVIDIA

NVIDIA drivers must be installed inside the virtual machine for  CUDA or GRID workloads using the GPU.

#### Use case: graphics/visualization

This scenario requires the use of GRID drivers. GRID drivers can be downloaded through the NVIDIA Application Hub provided you have the required licenses. The GRID drivers also require a GRID license server with appropriate GRID licenses before using the GRID drivers on the VM. This can be used to learn how to setup the license server.

#### Use case: compute/CUDA

NVIDIA CUDA driers and GRID drivers will need to be manually installed on the VM. The Tesla CUDA drivers can be obtained from the NVIDIA [download website](https://www.nvidia.com/Download/index.aspx). CUDA drivers do not need a license server.

## Next steps

- [Azure Stack VM features](azure-stack-vm-considerations.md)  
- [Deploy a GPU enabled IoT module on Azure Stack Hub](gpu-deploy-sample-module.md)
