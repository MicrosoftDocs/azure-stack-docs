---
title: Manage GPUs via Discrete Device Assignment for Azure Local (preview)
description: Learn how to manage GPUs via Discrete Device Assignment for Azure Local (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 05/01/2025
---

# Manage GPUs via Discrete Device Assignment (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manage GPUs using Discrete Device Assignment (DDA) for Azure Local VMs enabled by Azure Arc. For GPU DDA management on Azure Kubernetes Service (AKS) enabled by Azure Arc, see [Use GPUs for compute-intensive workloads](/azure/aks/hybrid/deploy-gpu-node-pool#create-a-new-workload-cluster-with-a-gpu-enabled-node-pool).

DDA allows you to dedicate a physical graphical processing unit (GPU) to your workload. In a DDA deployment, virtualized workloads run on the native driver and typically have full access to the GPU's functionality. DDA offers the highest level of app compatibility and potential performance.

> [!IMPORTANT]
> This feature is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.


## Prerequisites

Before you begin, satisfy the following prerequisites:

- Follow the setup instructions found at [Prepare GPUs for Azure Local](./gpu-manage-via-device.md) to prepare your Azure Local VMs, and to ensure that your GPUs are prepared for DDA.

# [Azure CLI](#tab/azurecli)

## Attach a GPU during Azure Local VM creation

Follow the steps outlined in [Create Azure Local VMs enabled by Azure Arc](create-arc-virtual-machines.md?tabs=azurecli) and utilize the additional hardware profile details to add GPU to your create process.

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gpus GpuDDA
```

## Attach a GPU after VM creation

Use the following CLI command to attach the GPU:

```azurecli
az stack-hci-vm gpu attach --resource-group "test-rg" --custom-location "test-location" --vm-name "test-vm" --gpus GpuDDA
```

After attaching the GPU, the output shows the full VM details. You can confirm the GPUs were attached by reviewing the hardware profile `virtualMachineGPUs` section - the output looks like this:

```azurecli
"properties":{
	"hardwareProfile":{
		"virtualMachineGPUs":[
			{
				"assignmentType": "GpuDDA",
				"gpuName": "NVIDIA A2",
				"partitionSizeMb": null
			}
         ],
```

For details on the GPU attach command, see [az stack-hci-vm gpu](/cli/azure/stack-hci-vm/gpu).

## Detach a GPU

Use the following CLI command to detach the GPU:

```azurecli
az stack-hci-vm gpu detach --resource-group "test-rg" --custom-location "test-location" --vm-name "test-vm"
```

After detaching the GPU, the output shows the full VM details. You can confirm the GPUs were detached by reviewing the hardware profile `virtualMachineGPUs` section - the output looks like this:

```azurecli
"properties":{
	"hardwareProfile":{
		"virtualMachineGPUs":[],
```

For details on the GPU attach command, see [az stack-hci-vm gpu](/cli/azure/stack-hci-vm/gpu).

# [Azure portal](#tab/azureportal)

## Attach GPU during Azure Local VM creation 

1. Follow the steps outlined in [Create Azure Local VMs](create-arc-virtual-machines.md?tabs=azureportal#create-azure-local-vms).  

1. To attach a GPU to this VM, select **Attach GPU**.

    :::image type="content" source="./media/gpu-manage-via-device/create-vm-attach-gpu.png" alt-text="Screenshot of attach GPU during VM creation." lightbox="./media/gpu-manage-via-device/create-vm-attach-gpu.png":::

1. Once **Attach GPU** is selected, **GPU Setup** options display. Select **DDA**.

    :::image type="content" source="./media/gpu-manage-via-device/create-vm-gpu-via-device.png" alt-text="Screenshot of attach GPU using DDA method." lightbox="./media/gpu-manage-via-device/create-vm-gpu-via-device.png":::

1. Review the specified settings and then select **Create**. It should take a few minutes to provision the VM.

    :::image type="content" source="./media/gpu-manage-via-device/create-vm-review-gpu-via-device.png" alt-text="Screenshot of review page for attach GPU using DDA method." lightbox="./media/gpu-manage-via-device/create-vm-review-gpu-via-device.png":::

## Attach GPU after Azure Local VM creation

To attach GPUs using Azure portal for existing Azure Local VMs, follow these steps in the Azure portal for your Azure Local instance:

1. For your Azure Local resource, go to **Virtual machines**.  

1. In the list of VMs, select the VM that you want to attach a GPU partition to.  

1. Under **Settings**, select **Size**. Modify the setting as needed, then  for **GPU Setup**, select **DDA**.


    :::image type="content" source="./media/gpu-manage-via-device/gpu-via-device-attach-after-vm-creation.png" alt-text="Screenshot of attach GPU using DDA after VM creation." lightbox="./media/gpu-manage-via-device/gpu-via-device-attach-after-vm-creation.png":::

1. When done, select **Save**. Afterwards, Azure Local will shut down the VM, attach the GPU, and restart the VM.

## Detach GPU partitions

To detach a GPU partition for existing Azure Local VMs, follow these steps in the Azure portal for your Azure Local instance:

1. For your Azure Local resource, go to **Virtual machines**.  

1. In the list of VMs, select the VM that you want to detach a GPU from.

1. Under **Settings**, select **Size**. Under **GPU Assignment**, select **Delete assignment**.


    :::image type="content" source="./media/gpu-manage-via-device/gpu-detach-via-device.png" alt-text="Screenshot of detach GPU using DDA method." lightbox="./media/gpu-manage-via-device/gpu-detach-via-device.png":::

1. When done, select **Save**. Afterwards, Azure Local will shut down the VM, detach the GPU, and restart the VM.


## Next steps

- [Manage GPUs via partitioning](./gpu-manage-via-partitioning.md)