---
title:  Graphics processing unit (GPU) virtual machine (VM) on Azure Stack Hub
description: Reference for GPU computing in Azure Stack Hub.
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: reference
ms.date: 07/07/2020
ms.reviewer: kivenkat
ms.lastreviewed: 07/07/2020

# Intent: As a a developer on Azure Stack Hub, I want to use a machine with a Graphics Processing Unit (GPU) in order to deliver an processing intensive visualization application.
# Keyword: Azure Stack Hub Graphics Processing Unit (GPU)
---

# Graphics processing unit (GPU) virtual machine (VM) on Azure Stack Hub

*Applies to: Azure Stack integrated systems*

In this article, you can learn which Graphics processing unit (GPU) models are supported on the Azure Stack Hub multinode system. You can also find instructions on installing the drivers used with the GPUs. GPU support in Azure Stack Hub enables solutions such as Artificial Intelligence, training, inference, and data visualization. The AMD Radeon Instinct Mi25 can be used to support graphic-intensive applications such as Autodesk AutoCAD.

You can choose from two GPU models in the public preview period. They are available in NVIDIA V100 Tensor Core and AMD Mi25 GPUs. These physical GPUs align with the following Azure N-Series virtual machine (VM) types as follows:
- [NCv3](https://docs.microsoft.com/azure/virtual-machines/ncv3-series)
- [NVv4 (AMD Mi25)](https://docs.microsoft.com/azure/virtual-machines/nvv4-series)

> [!IMPORTANT]  
> Azure Stack Hub GPU support is currently in public preview. To participate in the preview, complete the form at [aka.ms/azurestackhubgpupreview](https://aka.ms/azurestackhubgpupreview).
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Partitioned GPU VM size 

The NVv4-series virtual machines are powered by [AMD Radeon Instinct MI25](https://www.amd.com/en/products/professional-graphics/instinct-mi25) GPUs. With NVv4-series Azure Stack Hub is introducing virtual machines with partial GPUs. This size can be used for GPU accelerated graphics applications and virtual desktops. NVv4 virtual machines currently support only Windows guest operating system. 

| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | GPU | GPU memory: GiB | Max data disks | Max NICs | 
| --- | --- | --- | --- | --- | --- | --- | --- |   
| Standard_NV4as_v4 |4 |14 |88 | 1/8 | 2 | 4 | 2 | 

## Patch and update, FRU behavior of VMs 

GPU VMs will undergo downtime during operations such as patch and update (PnU) as well as hardware replacement (FRU) of Azure Stack Hub. The following table goes over the state of the VM as observed during these activities as well as the manual action that the user can do to make these VMs available again post these operations. 

| Operation | PnU - Express Update | PnU - Full Update, OEM update | FRU | 
| --- | --- | --- | --- | 
| VM state  | Unavailable during and post update without manual start operation | Unavailable during update. Available post update with manual operation | Unavailable during update. Available post update with manual operation| 
| Manual operation | If the VM needs to be made available during the update, if there are available GPU partitions, the VM can be restarted from the portal by clicking the **Restart** button. Restart the VM after the update from the portal using the **Restart** button | VM cannot be made available during the update. Post update completion, VM needs to be stop-deallocated using the **Stop** button and started back up using the "Start" button | VM cannot be made available during the update.Post update completion, VM needs to be stop-deallocated using the **Stop** button and started back up using the **Start** button.| 

## Guest driver installation 

The article [Install AMD GPU drivers on N-series VMs running Windows](https://docs.microsoft.com/azure/virtual-machines/windows/n-series-amd-driver-setup) provides instructions on installing the driver for the AMD Radeon Instinct Mi25 inside the NVv4 GPU-P enabled VM along with steps on how to verify driver installation.

## Next steps 

[Azure Stack VM features](azure-stack-vm-considerations.md) 
