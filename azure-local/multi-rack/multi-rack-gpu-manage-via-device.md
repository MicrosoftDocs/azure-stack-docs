---
title: Manage GPUs via Discrete Device Assignment for Multi-Rack Deployments of Azure Local
description: Learn how to manage GPUs via Discrete Device Assignment for multi-rack deployments of Azure Local.
author: eak13
ms.author: ekarandjeff
ms.topic: how-to
ms.service: azure-local
ms.date: 06/12/2026
ms.subservice: multi-rack
---

# Manage GPUs through Discrete Device Assignment for multi-rack deployments of Azure Local

This article describes how to manage GPUs by using Discrete Device Assignment (DDA) for Azure Local multi-rack virtual machines (VMs) enabled by Azure Arc. For GPU DDA management on Azure Kubernetes Service (AKS) enabled by Azure Arc, see [Deploy GPU node pools for AKS Arc on Azure Local multi-rack](../../AKS-Arc/multi-rack/deploy-gpu-node-pool.md).

DDA dedicates a physical graphical processing unit (GPU) to your workload. In a DDA deployment, virtualized workloads run on the native driver and typically have full access to the GPU's functionality. DDA offers the highest level of app compatibility and potential performance.

## Prerequisites

Before you begin, satisfy the following prerequisites:

- Follow the setup instructions in [Prepare GPUs for Azure Local multi-rack](./multi-rack-gpu-preparation.md) to ensure that your GPUs are prepared for DDA.

> [!IMPORTANT]
> Keep the following limitations in mind when working with GPU-attached VMs:
> - Live migration isn't supported for VMs with an attached GPU.
> - Attaching or detaching a GPU requires the VM to be in a stopped (deallocated) state.
> - Specifying an invalid or unavailable GPU name causes VM creation or update to fail.

## Attach a GPU during Azure Local multi-rack VM creation

To create a VM with a GPU attached, include the `--gpus` parameter with the assignment type and partition size. The platform automatically places the VM on a GPU-capable host and handles all device passthrough configuration.

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gpus GpuDDA,0
```

The `--gpus` parameter takes one or more `assignmentType,partitionSizeMB` tokens. To attach multiple GPUs, repeat the token for each GPU:

```azurecli
--gpus GpuDDA,0 GpuDDA,0
```

> [!NOTE]
> The CLI doesn't expose `gpuName`. In this release, the platform defaults to the NVIDIA RTX Pro 6000. If you need to target a specific GPU model explicitly, deploy via an ARM template or use `az rest` to issue a PATCH against the VM's `hardwareProfile.virtualMachineGPUs` array.

## Attach a GPU after Azure Local multi-rack VM creation

You can add GPUs to an existing VM by using a PATCH operation on hardwareProfile.virtualMachineGPUs. The VM must be in the Stopped state before you apply the change. The service rejects GPU updates on a running VM.

The process is: stop VM → attach GPU → start VM.

Use the following CLI command to attach the GPU:

```azurecli
az stack-hci-vm gpu attach --resource-group "test-rg" --custom-location "test-location" --vm-name "test-vm" --gpus GpuDDA,0
```

After you attach the GPU, the output shows the full VM details. You can confirm the GPUs are attached by reviewing the hardware profile `virtualMachineGPUs` section - the output looks like this:

```azurecli
"properties":{
    "hardwareProfile":{
        "virtualMachineGPUs":[
            {
                "assignmentType": "GpuDDA",
                "gpuName": "NVIDIA RTX Pro 6000",
            }
         ],
```

For details on the GPU attach command, see [az stack-hci-vm gpu](/cli/azure/stack-hci-vm/gpu).

## Detach a GPU

The VM must be in the **Stopped** power state before detaching a GPU. Use the following CLI command:

```azurecli
az stack-hci-vm gpu detach --resource-group "test-rg" --custom-location "test-location" --vm-name "test-vm"
```

After you detach the GPU, the output shows the full VM details. You can confirm the GPUs are detached by reviewing the hardware profile `virtualMachineGPUs` section - the output looks like this:

```azurecli
"properties":{
    "hardwareProfile":{
        "virtualMachineGPUs":[],
```

For details on the GPU detach command, see [az stack-hci-vm gpu](/cli/azure/stack-hci-vm/gpu).

