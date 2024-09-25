---
title: Manage GPUs via Discrete Device Assignment for Azure Stack HCI  (preview)
description: Learn how to Manage GPUs via Discrete Device Assignment for Azure Stack HCI (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/25/2024
---

# Manage GPUs via Discrete Device Assignment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage GPU DDA with Arc virtual machines (VMs). For GPU DDA management on AKS enabled by Azure Arc, see [Use GPUs for compute-intensive workloads](/azure/aks/hybrid/deploy-gpu-node-pool#create-a-new-workload-cluster-with-a-gpu-enabled-node-pool).

Discrete Device Assignment (DDA) allows you to dedicate a physical graphical processing unit (GPU) to your workload. In a DDA deployment, virtualized workloads run on the native driver and typically have full access to the GPU's functionality. DDA offers the highest level of app compatibility and potential performance.

> [!IMPORTANT]
> This feature is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.


## Prerequisites

Before you begin, satisfy the following prerequisites:

- Follow the set up instructions found at [Prepare for GPUs for Azure Stack HCI](./gpu-manage-via-device.md) to prepare your Azure Stack HCI cluster and Arc VMs and to ensure that your GPUs are prepared for DDA.  

## Attach a GPU during Arc VM creation

Follow the steps outlined in [Create Arc virtual machines on Azure Stack HCI](create-arc-virtual-machines.md?tabs=azurecli) and utilize the additional hardware profile details to add GPU to your create process.

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gpus GpuDDA
```

## Attach a GPU after Arc VM creation

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

## Next steps

- [Manage GPUs via partitioning](./gpu-manage-via-partitioning.md)