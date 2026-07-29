---
title: REST APIs for GPU Management in Azure Local (Preview)
description: Learn how to use REST APIs to discover GPUs, view GPU capabilities and inventory, and configure GPU partitioning in Azure Local. (preview).
author: ronmiab
ms.author: robess
ms.reviewer: saniyaislam
ms.topic: reference
ms.service: azure-local
ms.date: 07/28/2026
ms.subservice: hyperconverged
---

# REST APIs for GPU management in Azure Local (preview)

This article describes the REST APIs that you can use to discover GPUs, view GPU capabilities and inventory, and configure GPU partitioning (GPU-P) in Azure Local.

GPU inventory and discovery operations are performed at the edge machine level. GPU partitioning operations are performed at the cluster level because partition configuration is applied across cluster resources.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

- Ensure that your machine has a supported GPU model. For more information, see [Supported GPU models](./gpu-preparation.md#supported-gpu-models).
- GPU APIs are supported only on edge machines. If needed, run the [Edge machine creation script](https://github.com/Azure-Samples/AzureLocal/tree/main/GpuFabricManagement/EdgeMachineCreationScript) before proceeding.
- Run the `Sync-AzureStackHci` cmdlet on one of the cluster nodes to ensure that GPU capabilities appear on the cluster.

## List GPUs

Returns all GPU resources available on the specified edge machine.

### Request

Use the following HTTP request to list the GPUs on an edge machine:

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureStackHCI/edgeMachines/{edgeMachineName}/gpus?api-version={api-version}
```

### URI parameters

The following table describes the URI parameters for this request.

| Name | In | Required | Type | Description |
|----|----|----|----|----|
| subscriptionId | path | Yes | string | Azure subscription ID supplied through the common Azure Resource Manager (ARM) parameter set. |
| resourceGroupName | path | Yes | string | Azure resource group identifier supplied through the common ARM parameter set used by the GPU operation. |
| edgeMachineName | path | Yes | string | Name of the edge machine resource. |
| api-version | query | Yes | string | API version used for the request. |

### Responses

This operation returns one of the following responses.

#### 200 OK

Returns a collection of GPU resources.

#### Default

Returns an error response as defined in the standard ARM `ErrorResponse` schema.

### Example response

The following JSON shows an example response for a successful request.

```json
{
  "value": [
    {
      "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureStackHCI/edgeMachines/{edgeMachineName}/gpus/{gpuName}",
      "name": "{gpuName}",
      "type": "Microsoft.AzureStackHCI/edgeMachines/gpus",
      "properties": {
        "gpuId": "{gpuId}",
        "provisioningState": "Succeeded",
        "manufacturer": "NVIDIA",
        "model": "NVIDIA A2",
        "status": "OK",
        "pciLocation": "PCIROOT(x)#PCI(xxxx)#PCI(xxxx)",
        "assignable": true,
        "partitionable": true,
        "hostDriverVersion": "31.0.15.5160",
        "gpuMode": "GPUP",
        "ddaDetails": {},
        "partitionDetails": {
          "validPartitionCount": [16, 8, 4, 2, 1],
          "totalPartitions": 8,
          "availablePartitions": 6,
          "assignedPartitions": 2,
          "availableEncode": "28",
          "availableDecode": "18",
          "availableVram": "11959418880",
          "totalVram": "15945891840",
          "partitionableGpuName": "{partitionableGpuName}"
        }
      }
    }
  ]
}
```

### Azure CLI example

The following example shows how to use Azure CLI to retrieve the GPUs associated with an edge machine.

```azurecli
az rest --method GET --url "/subscriptions/$subscriptionid/resourceGroups/$rg/providers/Microsoft.AzureStackHCI/edgeMachines/$edgeMachineName/gpus?api-version=$apiVersion"
```

### Resource definition

The following section describes the resource properties returned by this operation.

#### GpuProperties

The following table describes the properties of a GPU resource.

| Name | Type | Description |
|----|----|----|
| provisioningState | ProvisioningState | Provisioning state of the GPU resource. |
| gpuId | string | Instance ID of the GPU. |
| manufacturer | string | GPU vendor or manufacturer. |
| model | string | GPU model. |
| status | string | Current status of the GPU. |
| pciLocation | string | PCI Express (PCIe) location of the GPU on the host system. |
| assignable | boolean | Indicates whether the GPU can be assigned to a workload. |
| partitionable | boolean | Indicates whether the GPU can be partitioned (GPU-P). |
| hostDriverVersion | string | Version of the host driver installed on the host that contains the GPU. Applicable only to DDA GPUs. |
| assignmentStatus | string | Assignment status of the GPU. |
| gpuMode | GpuMode | Mode in which the GPU operates, such as DDA or GPU-P. |
| ddaDetails | DdaDetails | Details of the GPU when operating in DDA mode. |
| partitionDetails | GpuPartitionDetails | Details of the GPU when operating in GPU-P mode. |

## Get a GPU

Returns information about the specified GPU resource.

### Request

Use the following HTTP request to retrieve information about a specific GPU.

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureStackHCI/edgeMachines/{edgeMachineName}/gpus/{gpuResourceName}?api-version={api-version}
```

### URI parameters

The following table describes the URI parameters for this request.

| Name | In | Required | Type | Description |
|----|----|----|----|----|
| subscriptionId | path | Yes | string | Azure subscription identifier supplied through the common ARM parameter set. |
| resourceGroupName | path | Yes | string | Azure resource group identifier supplied through the common ARM parameter set used by the GPU operation. |
| edgeMachineName | path | Yes | string | Name of the edge machine resource. |
| gpuResourceName | path | Yes | string | Name of the GPU resource. |
| api-version | query | Yes | string | API version used for the operation. |

### Responses

This operation returns one of the following responses.

#### 200 OK

Returns a single GPU resource.

#### Default

Returns an error response as defined in the standard ARM `ErrorResponse` schema.

### Example response

The following JSON shows an example response for a successful request.

```json
{
    "id":
    "/subscriptions/.../providers/Microsoft.AzureStackHCI/edgeMachines/{name}/gpus/{gpuName}",
    "name": "{gpuName}",
    "type": "Microsoft.AzureStackHCI/edgeMachines/gpus",
    "properties": {
      "gpuId": "string",
      "manufacturer": "string",
      "model": "string",
      "gpuMode": "DDA | GPUP",
      "partitionable": true,
      "partitionDetails": {
        "validPartitionCount": [2, 4, 8],
        "totalPartitions": 8,
        "availablePartitions": 4,
        "assignedPartitions": 4
        }
    }
}
```

## Configure a GPU partition

Configures the partition count on all the GPU-P capable GPUs in the Azure Local cluster.

### Request

Use the following HTTP request to configure GPU partitions on the cluster.

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureStackHCI/clusters/{clusterName}/jobs/GpuCreatePartition?api-version={api-version}
```

### URI parameters

The following table describes the URI parameters for this request.

| Name | In | Required | Type | Description |
|----|----|----|----|----|
| subscriptionId | path | Yes | string | Azure subscription identifier supplied through the common ARM parameter set used by the GPU Job operation. |
| resourceGroupName | path | Yes | string | Azure resource group identifier supplied through the common ARM parameter set used by the GPU Job operation. |
| clusterName | path | Yes | string | Name of the Azure Local cluster. |
| api-version | query | Yes | string | API version used for the operation. |

### Responses

This operation returns one of the following responses.

#### 200 OK / 201 Created

Returns the GPU job resource.

| Name | Type | Description |
|----|----|----|
| jobType | string | Type of GPU job. For this operation, the value is `GpuCreatePartition`. |
| deploymentMode | string | Deployment mode for the GPU job. |
| partitionCount | integer | Number of GPU partitions to create. |

#### Default

Returns an error response as defined in the standard ARM ErrorResponse schema.

### Example request

Specify the partition count and deployment mode in the request body.

```json
{
  "properties": {
    "jobType": "GpuCreatePartition",
    "deploymentMode": "Deploy",
    "partitionCount": 4
    }
}
```

### Example response

The following JSON shows an example response for a successful request.

```json
{
  "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureStackHCI/Clusters/{clusterName}/jobs/GpuCreatePartition",
  "name": "GpuCreatePartition",
  "type": "microsoft.azurestackhci/clusters/jobs",
  "properties": {
    "partitionCount": 0,
    "jobType": "GpuCreatePartition",
    "deploymentMode": "Deploy",
    "provisioningState": "Succeeded",
    "jobId": "{jobId}",
    "startTimeUtc": "{startTimeUtc}",
    "status": "Succeeded",
    "reportedProperties": {
      "percentComplete": 0,
      "deploymentStatus": {
        "status": "DeploymentSuccess",
        "steps": [
          {
            "name": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureStackHCI/EdgeMachines/{edgeMachineName}/gpus/{gpuId}",
            "description": "GPU [{gpuInstancePath}] partition count is now [4].",
            "startTimeUtc": "{stepStartTimeUtc}",
            "endTimeUtc": "{stepStartTimeUtc}",
            "status": "Success"
          },
          {
            "name": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureStackHCI/EdgeMachines/{edgeMachineName}/gpus/{gpuId}",
            "description": "GPU [{gpuInstancePath}] partition count is now [4].",
            "startTimeUtc": "{stepStartTimeUtc}",
            "endTimeUtc": "{stepEndTimeUtc}",
            "status": "Success"
          }
        ]
      },
      "validationStatus": {}
    }
  }
}
```

### Resource definition

The following section describes the resource properties returned by this operation.

#### GpuJobProperties

Contains properties for a GPU job resource.

| Name | Type | Description |
|----|----|----|
| jobType | GpuJobType | Type of GPU job to be performed. |
| deploymentMode | DeploymentMode | Deployment mode for the GPU job. |
| provisioningState | ProvisioningState | Provisioning state of the GPU job resource. Possible values include `Succeeded`, `Failed`, and `InProgress`. |
| startTimeUtc | string (date-time) | UTC date and time when the job started. |
| endTimeUtc | string (date-time) | UTC date and time when the job completed. |
| status | string | Current status of the GPU job. |
| reportedProperties | object | Status, progress, validation, and deployment details reported by the GPU job. |
| error | object / null | Error details if the job fails. |

## Next steps

- [Prepare GPUs for Azure Local instance](./gpu-preparation.md)
- [Manage GPUs using partitioning for Azure Local](./gpu-manage-via-partitioning.md)