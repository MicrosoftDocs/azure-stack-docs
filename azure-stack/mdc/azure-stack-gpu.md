--- 
title: GPU VMs on Azure Stack | Microsoft Docs 
description: Reference for GPU computing in Azure Stack. 
services: azure-stack 
documentationcenter: '' 
author: PatAltimore 
manager: femila 
ms.service: azure-stack 
ms.workload: na 
pms.tgt_pltfrm: na 
ms.devlang: na 
ms.topic: article 
ms.date: 01/02/2020 
ms.author: patricka 
ms.reviewer: kivenkat 
ms.lastreviewed: 01/02/2020

# Content note: This topic has been copied/refactored in to commercial.

--- 

# GPU VMs on Azure Stack 

*Applies to: Azure Stack integrated systems* 

This topic covers how to manage GPU VMs on Azure Stack Hub.


## Partitioned GPU VM size 

The NVv4-series virtual machines are powered by [AMD Radeon Instinct MI25](https://www.amd.com/en/products/professional-graphics/instinct-mi25) GPUs. With NVv4-series Azure Stack Hub is introducing virtual machines with partial GPUs. This size can be used for GPU accelerated graphics applications and virtual desktops. NVv4 virtual machines currently support only Windows guest operating system. 

| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | GPU | GPU memory: GiB | Max data disks | Max NICs | 
| --- | --- | --- | --- | --- | --- | --- | --- |   
| Standard_NV4as_v4 |4 |14 |88 | 1/8 | 2 | 4 | 2 | 

## Patch and Update, FRU behavior of VMs 

GPU VMs will undergo downtime during operations such as patch and update (PnU) as well as hardware replacement (FRU) of Azure Stack Hub. The following table goes over the state of the VM as observed during these activities as well as the manual action that the user can do to make these VMs available again post these operations. 

| Operation | PnU - Express Update | PnU - Full Update, OEM update | FRU | 
| --- | --- | --- | --- | 
| VM state  | Unavailable during and post update without manual start operation | Unavailable during update. Available post update with manual operation | Unavailable during update. Available post update with manual operation| 
| Manual operation | If the VM needs to be made available during the update, if there are available GPU partitions, the VM can be restarted from the portal by clicking the "Restart" button. VM needs to be restarted post update from the portal using the "Restart" button | VM cannot be made available during the update. Post update completion, VM needs to be stop-deallocated using the "Stop" button and started back up using the "Start" button | VM cannot be made available during the update.Post update completion, VM needs to be stop-deallocated using the "Stop" button and started back up using the "Start" button.| 

## Guest driver installation 

[This](/azure/virtual-machines/windows/n-series-amd-driver-setup) document goes over setting up the AMD guest driver inside the NVv4 GPU-P enabled VM along with steps on how to verify driver installation. 

## Next steps 

[Azure Stack VM features](azure-stack-vm-considerations.md)