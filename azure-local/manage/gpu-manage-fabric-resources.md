---
title: Manage GPU Fabric Resources in Azure Local (preview)
description: Learn how to monitor and manage GPU fabric resources in Azure Local clusters by using the Azure portal (preview).
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.date: 08/13/2026
ms.service: azure-local
ms.subservice: hyperconverged
---

# Manage GPU fabric resources in Azure Local (preview)

This article explains how to manage graphics processing unit (GPU) fabric resources in Azure Local clusters.

[!INCLUDE [important](../includes/hci-preview.md)]

## Overview

Use GPU management in the Azure portal to monitor and manage GPU fabric resources in Azure Local clusters. From your Azure Local cluster resource, you can:

- View the GPU inventory.
- Configure partition settings for GPU partitioning (GPU-P).
- Assign and unassign GPUs (Discrete Device Assignment (DDA) or GPU-P) to workloads.

For information about GPU-P limitations, see the [Limitations](./gpu-manage-via-partitioning.md#limitations) section in *Manage GPUs using partitioning*.

## Prerequisites

- [Prepare GPUs for an Azure Local instance](./gpu-preparation.md).
- You must be assigned the **Azure Stack HCI Administrator** role to run the API. For more information, see [Use Role-based Access Control to manage Azure Local VMs enabled by Azure Arc](../manage/assign-vm-rbac-roles.md).
- A machine with a supported GPU model. For more information, see [Supported GPU models](./gpu-preparation.md#supported-gpu-models).
- The GPU APIs support only edge machines. If needed, run the [Edge machine creation script](https://github.com/Azure-Samples/AzureLocal/tree/main/GpuFabricManagement/EdgeMachineCreationScript) before proceeding.
- Run the `Sync-AzureStackHci` cmdlet on one of the cluster nodes to ensure that GPU capabilities appear on the cluster.
- To use GPU management, you must have solution version 12.2604.1003.x or later. For more information, see [Azure Local release information](../release-information-23h2.md).

## View GPU utilization

By default, the **GPU** page opens to the **Overview** tab. Use this tab to view GPU availability, utilization trends, and assignment status before you configure GPUs or place workloads.

The **Overview** tab provides:

- Cluster-wide GPU key performance indicators (KPIs).
- The total number of detected GPU devices.
- Cluster-level GPU utilization metrics.

GPU metrics provide insights into GPU utilization and performance. These metrics are collected from `nvidia-smi`. For definitions of available GPU metrics, see [Monitor Azure Local with Azure Monitor metrics](./monitor-cluster-with-metrics.md#metrics-for-gpu).

> [!NOTE]
> The **Overview** tab is available only for GPU-P mode. DDA doesn't have host level metrics.

To view GPU utilization for an Azure Local cluster in the Azure portal:

1. In the cluster navigation pane, select **Infrastructure**.
1. Select **GPU**.

    The **Overview** tab opens and displays a summary of GPU resources and GPU-P metrics for the cluster.

    :::image type="content" source="media/gpu-manage-fabric-resources/overview-tab.png" alt-text="Screenshot of the GPU Overview page showing GPU inventory status, assigned and available GPUs, and GPU-P utilization and performance metrics for an Azure Local cluster." lightbox="media/gpu-manage-fabric-resources/overview-tab.png":::

## View GPU inventory and details

1. Select the **Configuration** tab to view the GPU inventory and cluster-level settings.

    :::image type="content" source="media/gpu-manage-fabric-resources/configuration-tab.png" alt-text="Screenshot of the GPU management Configuration tab showing GPU inventory, assignment and partition metrics, and details for a selected GPU." lightbox="media/gpu-manage-fabric-resources/configuration-tab.png":::

    At the top of the page, KPI cards summarize:

    - Total GPUs.
    - Total DDA assignments.
    - Total GPU-P assignments.
    - Assigned and unassigned GPUs.
    - Total, assigned, and unassigned partitions.

    The inventory grid lists all GPUs and includes details such as GPU type, manufacturer, location, node name, and assignment status.

1. Select a GPU name to open the details pane.

    The details pane includes:

    - GPU name and GPU ID.
    - Driver version.
    - Assignment status.
    - Workload name and status.
    
    :::image type="content" source="media/gpu-manage-fabric-resources/gpu-discrete-device-assignment-details.png" alt-text="Screenshot of the GPU details pane showing DDA assignment status, GPU ID, driver version, and assigned workload information." lightbox="media/gpu-manage-fabric-resources/gpu-discrete-device-assignment-details.png":::

    For GPU-P, the pane also includes partition-related information such as available VRAM, encoder, decoder, and per-partition assignment status.

    :::image type="content" source="media/gpu-manage-fabric-resources/gpu-partition-details.png" alt-text="Screenshot of the GPU-P details pane showing GPU properties, partition availability, VRAM, encoder and decoder resources, and per-partition assignment status." lightbox="media/gpu-manage-fabric-resources/gpu-partition-details.png":::

## Assign a GPU to a VM

> [!NOTE]
> The system automatically assigns GPUs. You can't select a specific physical GPU or partition.

1. On the **Configuration** tab, select **Assign** to attach a DDA or GPU partition (GPU-P) to a VM.

   Choose from the following options:

    - **Assign GPU-P**. Attaches a GPU partition from a physical GPU to the VM, so GPU resources can be shared across multiple workloads. You can assign only one GPU partition to a VM. The system automatically allocates GPU partitions, and you can't select a specific partition.
    - **Assign DDA**. Attaches an entire physical GPU to the VM, giving the VM exclusive access to that GPU.

    :::image type="content" source="media/gpu-manage-fabric-resources/assign-gpu.png" alt-text="Screenshot of the GPU management Assign GPU pane showing an available VM selected for GPU-P assignment." lightbox="media/gpu-manage-fabric-resources/assign-gpu.png":::

1. When the assignment pane opens, select an eligible VM.

    :::image type="content" source="media/gpu-manage-fabric-resources/gpu-assignment-pane.png" alt-text="Screenshot of the GPU management Assign GPU pane showing an unassigned VM selected for GPU assignment." lightbox="media/gpu-manage-fabric-resources/gpu-assignment-pane.png":::

## Unassign a GPU from a VM

1. On the **Configuration** tab, select **Unassign** to detach a GPU or GPU partition from a VM.

    :::image type="content" source="media/gpu-manage-fabric-resources/unassign-gpu.png" alt-text="Screenshot of the GPU management Configuration tab showing assigned and unassigned DDA and GPU-P devices, with the Unassign option available for selected GPU resources." lightbox="media/gpu-manage-fabric-resources/unassign-gpu.png":::

1. Select the VM from the list of assigned VMs.

    :::image type="content" source="media/gpu-manage-fabric-resources/unassign-gpu-pane.png" alt-text="Screenshot of the GPU management Unassign GPU pane showing a VM selected for removal of an assigned GPU partition." lightbox="media/gpu-manage-fabric-resources/unassign-gpu-pane.png":::

1. Select **Unassign**.

1. Confirm the action.

1. After the operation finishes, verify that the assignment status updates to **Unassigned**. Status updates can take up to five minutes to appear.

## Configure GPU partitions (GPU-P only)

In GPU-P mode, you configure the partition size at the cluster level, and it applies to all GPUs. The system doesn't support per-GPU partition sizing.

To configure the partition size:

1. On the **Configuration** tab, select **Configure partition**.

    :::image type="content" source="media/gpu-manage-fabric-resources/configure-gpu-partition.png" alt-text="Screenshot of the GPU management Configure GPU partition pane showing a cluster-wide partition count setting for GPU-P resources." lightbox="media/gpu-manage-fabric-resources/configure-gpu-partition.png":::

1. In the **Configure GPU partition** pane, select the **Partition count** that applies to all GPU-P devices in the cluster. Changing the partition count affects all GPUs and can interrupt running workloads.

1. Select **Configure**, and then confirm the action.

## Troubleshooting

This section provides guidance for troubleshooting common issues.

### GPU blade is empty

**Possible causes**

No GPUs are detected on the cluster.

:::image type="content" source="media/gpu-manage-fabric-resources/no-gpu.png" alt-text="Screenshot of the GPU page showing that no GPUs are detected in the cluster." lightbox="media/gpu-manage-fabric-resources/no-gpu.png":::

**Resolution**

Verify that the required GPUs are available and detected in the cluster.

### GPUs are listed, but actions aren't available

**Possible causes**

The GPU prerequisites might be incomplete.

**Resolution**

Verify that you completed all GPU prerequisites, including installing the required drivers and disabling and dismounting the GPUs. For more information, see [Prepare GPUs for Azure Local](./gpu-preparation.md).

### Partition configuration fails

**Possible causes**

All available GPU partitions are already assigned.

:::image type="content" source="media/gpu-manage-fabric-resources/error-no-unassigned-partitions.png" alt-text="Screenshot of the error message showing that there are no unassigned partitions available in the cluster." lightbox="media/gpu-manage-fabric-resources/error-no-unassigned-partitions.png":::

**Resolution**

Unassign all GPU partitions in the cluster, and then retry the operation. For more information, see [Unassign a GPU from a VM](#unassign-a-gpu-from-a-vm).

### GPU assignment fails

**Possible causes**

The GPU assignment can fail when the cluster node is down or the target VM isn't running or responding.

:::image type="content" source="media/gpu-manage-fabric-resources/gpu-assignment-fails.png" alt-text="Screenshot of a Failed to assign GPU notification caused by an unavailable cluster node or target VM." lightbox="media/gpu-manage-fabric-resources/gpu-assignment-fails.png":::

**Resolution**

1. Bring the cluster node back online if it's down.
1. Start or recover the target VM and verify that it's running and healthy.
1. Retry the GPU assignment operation.

## Next steps

- [Manage GPUs via partitioning](./gpu-manage-via-partitioning.md)
- [Manage GPUs via Discrete Device Assignment](./gpu-manage-via-device.md)
