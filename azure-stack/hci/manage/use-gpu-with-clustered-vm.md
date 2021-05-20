---
title: Use GPUs with clustered VMs
description: This topic provides guidance on how to use GPUs with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads running in the clustered VMs.
author: rick-man
ms.author: rickman
ms.topic: how-to
ms.date: 05/25/2021
---

# Use GPUs with clustered VMs

>Applies to: Azure Stack HCI, version 21H2 Public Preview

This topic provides guidance on how to use graphics processing units (GPUs) with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads running in the clustered VMs.

Starting in Azure Stack HCI, version 21H2, you can include GPUs in your Azure Stack HCI cluster to provide GPU acceleration to workloads running in clustered VMs. The topic covers the basic prerequisites of this capability and how to deploy it.

GPU acceleration is provided via Discrete Device Assignment (DDA), also known as GPU pass-through, which allows you to dedicate one or more physical GPUs to a VM. Clustered VMs can take advantage of GPU acceleration, as well as clustering capabilities such as high availability via failover. Live migration is not currently supported, but VMs can be automatically restarted and placed where GPU resources are available in the event of a failure.

## Prerequisites
To get started, you’ll need an Azure Stack HCI cluster of at least two nodes, running Azure Stack HCI, version 21H2. You’ll also need GPUs that are physically installed in each node of the cluster.

   >[!NOTE]
   > The Azure Stack HCI Catalog does not yet indicate GPU compatibility or certification information. Follow your manufacturer's instructions for GPU installation.

## Usage instructions
This section describes the steps necessary to prepare your cluster nodes for GPU usage, assign VMs to clustered GPU resource pools, and test automatic restart.

### Prepare the cluster
Prepare the GPUs in each node by installing security mitigation drivers on each node, disabling the GPUs, and dismounting them from the host according to the instructions in [Deploy graphics devices using Discrete Device Assignment](/windows-server/virtualization/hyper-v/deploy/deploying-graphics-devices-using-dda). Depending on your hardware vendor, you may also need to configure any GPU licensing requirements.

1. Create a new empty resource pool on each node that will contain the clustered GPU resources. Make sure to provide the same pool name on each node.

    In PowerShell, run the following cmdlet as an administrator:

   ```PowerShell
    New-VMResourcePool -ResourcePoolType PciExpress -Name "GpuChildPool"
   ```

1. Add the dismounted GPUs from each node to the resource pool that you created in the previous step,

    In PowerShell, run the following cmdlets:

   ```PowerShell
    $gpu = Get-VMHostAssignableDevice
   ```

   ```PowerShell
    Add-VMHostAssignableDevice -HostAssignableDevice $gpu -ResourcePoolName "GpuChildPool"
   ```

You now have a cluster-wide resource pool (named `GpuChildPool`) that is populated with assignable GPUs. The cluster will use this pool to determine VM placement for any started or moved VMs that are assigned to the GPU resource pool.

### Assign a VM to a GPU resource pool
First, either create a new VM in your cluster, or find an existing VM.

Prepare the VM for DDA by setting its cache behavior, stop action, and memory-mapped I/O (MMIO) properties according to the instructions in [Deploy graphics devices using Discrete Device Assignment](/windows-server/virtualization/hyper-v/deploy/deploying-graphics-devices-using-dda).

1. Configure the cluster VM resource’s default offline action as `force-shutdown` rather than `save`.

    In PowerShell, run the following cmdlet:

   ```PowerShell
    $vm | Set-ClusterParameter -Name "OfflineAction" -Value 3
   ```

1. Assign the resource pool that you created earlier to the VM. This declares to the cluster that the VM requires an assigned device from the `GpuChildPool` pool when it is either started or moved.

    In PowerShell, run the following cmdlet:

   ```PowerShell
    $vm | Add-VMAssignableDevice -ResourcePoolName "GpuChildPool"
   ```

If you start the VM now, the cluster ensures that it is placed on a node with available GPU resources from this cluster-wide pool. The cluster also assigns the GPU to the VM through DDA, which allows the GPU to be accessed from workloads inside the VM.

   >[!NOTE]
   > You also need to install drivers from your GPU manufacturer inside the VM so that apps in the VM can take advantage of the GPU assigned to it.

### Fail over a VM with an assigned GPU
To test the cluster’s ability to keep your GPU workload available, perform a drain operation on the node where the VM is running with an assigned GPU. To drain the node, follow the instructions in [Taking an Azure Stack HCI server offline for maintenance](maintain-servers.md). The cluster will restart the VM on another node in the cluster, as long as another node has sufficient available GPU resources in the pool that you created.

## Next steps
For more information, see also:
- [Manage VMs with Windows Admin Center](vm.md)
- [Plan for deploying devices using Discrete Device Assignment](/windows-server/virtualization/hyper-v/plan/plan-for-deploying-devices-using-discrete-device-assignment)
