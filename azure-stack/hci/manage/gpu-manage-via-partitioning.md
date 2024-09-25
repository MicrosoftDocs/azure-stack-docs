---
title: Manage GPUs using partitioning for Azure Stack HCI (preview)
description: Learn how to manage GPUs using partitioning Azure Stack HCI (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/25/2024
---

# Manage GPUs using partitioning (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage GPU-P with Arc virtual machines (VMs). For using GPU-P management on AKS enabled by Azure Arc, see [Use GPUs for compute-intensive workloads](/azure/aks/hybrid/deploy-gpu-node-pool#create-a-new-workload-cluster-with-a-gpu-enabled-node-pool).

GPU Partitioning (GPU-P) allows you to share a graphical processing unit (GPU) with multiple workloads by splitting the GPU into dedicated fractional partitions.

> [!IMPORTANT]
> This feature is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Limitations

Consider the following limitations when using the GPU-P feature:

- GPU partitioning is unsupported if your configuration isn't homogeneous. Here are some examples of unsupported configurations:

    - Mixing GPUs from different vendors in the same cluster.

    - Using different GPU models from different product families from the same vendor in the same cluster.

- You can't assign a physical GPU as both Discrete Device Assignment (DDA) and as partitionable GPU (GPU-P). You can either assign it as DDA or as a partitionable GPU, but not both.

- You can assign only a single GPU partition to a VM.

- Partitions are autoassigned to the VMs. You can't choose a specific partition for a specific VM.

- Currently, GPU partitioning on Azure Stack HCI doesn't support live migration of VMs. But VMs can be automatically restarted and placed where GPU resources are available if there's a failure.

- You can partition your GPU using Azure Command-Line Interface (CLI). We recommend that you use Azure CLI to configure and assign GPU partitions. You must manually ensure that the homogeneous configuration is maintained for GPUs across all the servers in your cluster.

## Prerequisites

- See [Prepare GPUs for Azure Stack HCI](./gpu-manage-via-partitioning.md) for requirements and to prepare your Azure Stack HCI cluster and Arc VMs and to ensure that your GPUs are prepared and partitioned.

## Attach a GPU during Arc VM creation

Follow the steps outlined in [Create Arc virtual machines on Azure Stack HCI](create-arc-virtual-machines.md?tabs=azurecli) and utilize the additional hardware profile details to add GPU to your create process. Run the following:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gpus GpuP
```

For more information, see [az stack-hci-vm create](/cli/azure/stack-hci-vm).

## Attach a GPU after Arc VM creation

Use the following CLI command to attach the GPU:

```azurecli
az stack-hci-vm stop --name your_VM_name --resource-group your_resource_group
```

You can specify the partition size in the command, as shown below. Partition sizes are the same as the `minPartitionVRAM` found in `Get-VMHostPartitionableGpu` on Hyper-V. You can also use the command without specifying the partition size, as seen in the above example.  

```azurecli
az stack-hci-vm gpu attach --resource-group "test-rg" --custom-location "test-location" --vm-name "test-vm" --gpus GpuP
```

After attaching the GPU partition, the output will show the full VM details. You can confirm the GPUs were attached by reviewing the hardware profile `virtualMachineGPUs` section. The output will look as follows:

```azurecli
"properties":{
	"hardwareProfile":{
		"virtualMachineGPUs":[
			{
				"assignmentType": "GpuP",
				"gpuName": null,
				"partitionSizeMb": 3648
			}
         ],
```

For more information on the GPU attach command, see [az stack-hci-vm gpu](/cli/azure/stack-hci-vm/gpu).

## Detach a GPU

Use the following CLI command to detach the GPU:

```azurecli
az stack-hci-vm gpu detach --resource-group "test-rg" --custom-location "test-location" --vm-name "test-vm" --gpus GpuP
```

After detaching the GPU partition, the output will show the full VM details. You can confirm the GPUs were detached by reviewing the hardware profile `virtualMachineGPUs`. The output will look as follows:

```azurecli
"properties":{
	"hardwareProfile":{
		"virtualMachineGPUs":[],
```

For more information on the GPU attach command, see [az stack-hci-vm gpu](/cli/azure/stack-hci-vm/gpu).

## Next steps

- [Manage GPUs using Discrete Device Assignment](./gpu-manage-via-device.md)