---
title: Manage GPUs using partitioning for Azure Local (preview)
description: Learn how to manage GPUs using partitioning Azure Local (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 07/22/2025
---

# Manage GPUs using partitioning (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to manage GPUs using partitioning (GPU-P) for Azure Local virtual machines (VMs) enabled by Azure Arc. GPU-P allows you to share a GPU with multiple workloads by splitting the GPU into dedicated fractional partitions.

> [!IMPORTANT]
> This feature is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Limitations

Consider the following limitations when using the GPU-P feature:

- GPU partitioning is unsupported if your configuration isn't homogeneous. Here are some examples of unsupported configurations:

    - Mixing GPUs from different vendors in the same system.

    - Using different GPU models from different product families from the same vendor in the same system.

- You can't assign a physical GPU as both Discrete Device Assignment (DDA) and as partitionable GPU (GPU-P). You can either assign it as DDA or as a partitionable GPU, but not both.

- You can assign only a single GPU partition to a VM.

- Partitions are autoassigned to the VMs. You can't choose a specific partition for a specific VM.

- GPU partitioning on Azure Local supports live migration. The OS build must be 26100.xxxx or later. The host and VMs must be on NVIDIA virtual GPU software version 18 and later. For more information, see [Microsoft Azure Local - NVIDIA Docs](https://docs.nvidia.com/vgpu/18.0/grid-vgpu-release-notes-microsoft-azure-stack-hci/index.html).

- You can partition your GPU using Azure Command-Line Interface (CLI). We recommend that you use Azure CLI to configure and assign GPU partitions. You must manually ensure that the homogeneous configuration is maintained for GPUs across all the machines in your system.

## Prerequisites

- See [Prepare GPUs for Azure Local](gpu-preparation.md) for requirements and to prepare your Azure Local VMs, and to ensure that your GPUs are prepared and partitioned.

# [Azure CLI](#tab/azurecli)

## Attach a GPU during Azure Local VM creation

Follow the steps outlined in [Create Azure Local virtual machines](create-arc-virtual-machines.md?tabs=azurecli) and utilize the extra hardware profile details to add GPU to your create process. Run the following:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gpus GpuP
```

For more information, see [az stack-hci-vm create](/cli/azure/stack-hci-vm).

## Attach a GPU after Azure Local VM creation

Use the following CLI command to attach the GPU:

```azurecli
az stack-hci-vm stop --name your_VM_name --resource-group your_resource_group
```

You can specify the partition size in the command, as shown below. Partition sizes are the same as the `minPartitionVRAM` found in `Get-VMHostPartitionableGpu` on Hyper-V. You can also use the command without specifying the partition size, as seen in the above example.  

```azurecli
az stack-hci-vm gpu attach --resource-group "test-rg" --custom-location "test-location" --vm-name "test-vm" --gpus GpuP
```

After attaching the GPU partition, the output shows the full VM details. You can confirm the GPUs were attached by reviewing the hardware profile `virtualMachineGPUs` section. The output looks as follows:

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

After detaching the GPU partition, the output shows the full VM details. You can confirm the GPUs were detached by reviewing the hardware profile `virtualMachineGPUs`. The output looks as follows:

```azurecli
"properties":{
	"hardwareProfile":{
		"virtualMachineGPUs":[],
```

For more information on the GPU attach command, see [az stack-hci-vm gpu](/cli/azure/stack-hci-vm/gpu).

# [Azure portal](#tab/azureportal)

## Attach GPU during Azure Local VM creation

1. Follow the steps outlined in [Create Azure Local VMs](create-arc-virtual-machines.md?tabs=azureportal#create-azure-local-vms).

1. To attach a GPU to this VM, select **Attach GPU**.

    :::image type="content" source="./media/gpu-manage-via-partitioning/create-vm-attach-gpu.png" alt-text="Screenshot of attach GPU during VM creation." lightbox="./media/gpu-manage-via-partitioning/create-vm-attach-gpu.png":::

1. Once **Attach GPU** is selected, **GPU Setup** options display. Select **GPU Partition**.

    :::image type="content" source="./media/gpu-manage-via-partitioning/create-vm-gpu-partition.png" alt-text="Screenshot of attach GPU using partition method." lightbox="./media/gpu-manage-via-partitioning/create-vm-gpu-partition.png":::

1. Review the specified settings and then select **Create**. It should take a few minutes to provision the VM.

    :::image type="content" source="./media/gpu-manage-via-partitioning/create-vm-review-gpu-partition.png" alt-text="Screenshot of review GPU settings using partition method." lightbox="./media/gpu-manage-via-partitioning/create-vm-review-gpu-partition.png":::

## Attach GPU after Azure Local VM creation

To attach a GPU partition for existing Azure Local VMs, follow these steps in the Azure portal for your Azure Local instance:

1. For your Azure Local resource, go to **Virtual machines**.  

1. In the list of VMs, select the VM that you want to attach a GPU partition to.  

1. Under **Settings**, select **Size**. Modify the setting as needed, then  for **GPU Setup**, select **GPU Partition**.


    :::image type="content" source="./media/gpu-manage-via-partitioning/gpu-attach-after-vm-creation.png" alt-text="Screenshot of attach GPU after VM creation." lightbox="./media/gpu-manage-via-partitioning/gpu-attach-after-vm-creation.png":::

1. When done, select **Save**. Afterwards, Azure Local will shut down the VM, attach the GPU, and restart the VM.

## Detach GPU partitions

To detach a GPU partition for existing Azure Local VMs, follow these steps in the Azure portal for your Azure Local instance:

1. For your Azure Local resource, go to **Virtual machines**.  

1. In the list of VMs, select the VM that you want to detach a GPU partition from.  

1. Under **Settings**, select **Size**. Under **GPU Assignment**, select **Delete assignment**.


    :::image type="content" source="./media/gpu-manage-via-partitioning/gpu-detach-partition.png" alt-text="Screenshot of detach GPU partition." lightbox="./media/gpu-manage-via-partitioning/gpu-detach-partition.png":::

1. When done, select **Save**. Afterwards, Azure Local will shut down the VM, detach the GPU, and restart the VM.

## Next steps

- [Manage GPUs using Discrete Device Assignment](./gpu-manage-via-device.md).
