---
title: Use GPUs with clustered VMs
description: This topic provides guidance on how to use GPUs with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads in the clustered VMs.
author: rick-man
ms.author: rickman
ms.topic: how-to
ms.date: 04/17/2023
---

# Use GPUs with clustered VMs

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This topic provides guidance on how to use graphics processing units (GPUs) with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads in the clustered VMs.

Starting in Azure Stack HCI, version 21H2, you can include GPUs in your Azure Stack HCI cluster to provide GPU acceleration to workloads running in clustered VMs. This topic covers the basic prerequisites of this capability and how to deploy it.

GPU acceleration is provided via Discrete Device Assignment (DDA), also known as GPU pass-through, which allows you to dedicate one or more physical GPUs to a VM. Clustered VMs can take advantage of GPU acceleration, and clustering capabilities such as high availability via failover. Live migrating VMs isn't currently supported, but VMs can be automatically restarted and placed where GPU resources are available in the event of a failure.

## Prerequisites
To get started, you’ll need an Azure Stack HCI cluster running Azure Stack HCI, version 21H2. You’ll also need GPUs that are physically installed in every server of the cluster.

   >[!NOTE]
   > The Azure Stack HCI Catalog does not yet indicate GPU compatibility or certification information. Follow your manufacturer's instructions for GPU installation.

## Usage instructions
This section describes the steps necessary to use either Windows Admin Center or Windows PowerShell to prepare your cluster servers for GPU usage. You can assign one or more VMs to a clustered GPU resource pool, and remove a VM from a clustered GPU resource pool. You can also use PowerShell to test automatic restart.

### Use Windows Admin Center
Use Windows Admin Center to prepare the cluster, assign a VM to a GPU resource pool, and unassign a VM to a GPU resource pool.

To prepare the cluster and assign a VM to a GPU resource pool:
1. On the **Tools** menu, under **Extensions**, select **GPUs** to open the tool.

   :::image type="content" source="media/use-gpu-with-vm/gpu-extension.png" alt-text="Screenshot of the GPU tool in Windows Admin Center" lightbox="media/use-gpu-with-vm/gpu-extension.png":::

1. On tool's main page, select the **GPU pools** tab, and then select **Create GPU pool**.

   :::image type="content" source="media/use-gpu-with-vm/create-gpu-pool.png" alt-text="Screenshot of the Create GPU pools page in Windows Admin Center" lightbox="media/use-gpu-with-vm/create-gpu-pool.png":::

1. On the **New GPU pool** page, specify the following and then select **Save**:
   1. **Server** name
   1. **GPU pool** name
   1. **GPUs** that you want to add to the pool

   :::image type="content" source="media/use-gpu-with-vm/new-gpu-pool.png" alt-text="Screenshot of the New GPU pool page in Windows Admin Center to specify servers, pool name, and GPUs" lightbox="media/use-gpu-with-vm/new-gpu-pool.png":::

   After the process completes, you'll receive a success prompt that shows the name of the new GPU pool and the host server.

1. On the **Assign VM to GPU pool** page, specify the following and then select **Assign**:
   1. **Server** name
   1. **GPU pool** name
   1. **Virtual machine** that you want to assign the GPU to from the GPU pool.

   You can also define advanced setting values for memory-mapped IO (MMIO) spaces to determine resource requirements for a single GPU.

   :::image type="content" source="media/use-gpu-with-vm/assign-vm-to-gpu-pool.png" alt-text="Screenshot of the Assign VM to GPU pool page in Windows Admin Center where you assign a VM to a GPU from the GPU pool" lightbox="media/use-gpu-with-vm/assign-vm-to-gpu-pool.png":::

   After the process completes, you'll receive a confirmation prompt that shows you successfully assigned the GPU from the GPU resource pool to the VM, which displays under **Assigned VMs**.

   :::image type="content" source="media/use-gpu-with-vm/gpu-assigned-to-vm-confirmed.png" alt-text="Screenshot of success prompt showing GPU assigned to a VM and the VM displaying under Assigned VMs" lightbox="media/use-gpu-with-vm/gpu-assigned-to-vm-confirmed.png":::

To unassign a VM from a GPU resource pool:
1. On the **GPU pools** tab, select the GPU that you want to unassign, and then select **Unassign VM**.
1. On the **Unassign VM from GPU pool** page, in the **Virtual machines** list box, specify the name of the VM, and then select **Unassign**.

   :::image type="content" source="media/use-gpu-with-vm/unassign-vm-from-gpu-pool.png" alt-text="Screenshot of Unassign VM from GPU pool page showing VM to be unassigned" lightbox="media/use-gpu-with-vm/unassign-vm-from-gpu-pool.png":::

   After the process completes, you'll receive a success prompt that the VM has been unassigned from the GPU pool, and under **Assignment status** the GPU shows **Available (Not assigned)**.

### Use PowerShell
Use PowerShell to prepare the cluster, assign a VM to a GPU resource pool, and to test automatic restart.

#### Prepare the cluster
Prepare the GPUs in each server by installing security mitigation drivers on each server, disabling the GPUs, and dismounting them from the host according to the instructions in [Deploy graphics devices using Discrete Device Assignment](/windows-server/virtualization/hyper-v/deploy/deploying-graphics-devices-using-dda). Depending on your hardware vendor, you may also need to configure any GPU licensing requirements.

1. Create a new empty resource pool on each server that will contain the clustered GPU resources. Make sure to provide the same pool name on each server.

    In PowerShell, run the following cmdlet as an administrator:

   ```PowerShell
    New-VMResourcePool -ResourcePoolType PciExpress -Name "GpuChildPool"
   ```

1. Add the dismounted GPUs from each server to the resource pool that you created in the previous step.

    In PowerShell, run the following cmdlets:

   ```PowerShell
    $gpu = Get-VMHostAssignableDevice
   ```

   ```PowerShell
    Add-VMHostAssignableDevice -HostAssignableDevice $gpu -ResourcePoolName "GpuChildPool"
   ```

You now have a cluster-wide resource pool (named `GpuChildPool`) that is populated with assignable GPUs. The cluster will use this pool to determine VM placement for any started or moved VMs that are assigned to the GPU resource pool.

#### Assign a VM to a GPU resource pool
First, either create a new VM in your cluster, or find an existing VM.

Prepare the VM for DDA by setting its cache behavior, stop action, and memory-mapped I/O (MMIO) properties according to the instructions in [Deploy graphics devices using Discrete Device Assignment](/windows-server/virtualization/hyper-v/deploy/deploying-graphics-devices-using-dda).

1. Configure the cluster VM resource’s default offline action as `force-shutdown` rather than `save`.

    In PowerShell, run the following cmdlet:

   ```PowerShell
    Get-ClusterResource -name vmname | Set-ClusterParameter -Name "OfflineAction" -Value 3
   ```

1. Assign the resource pool that you created earlier to the VM. This declares to the cluster that the VM requires an assigned device from the `GpuChildPool` pool when it's either started or moved.

    In PowerShell, run the following cmdlet:

   ```PowerShell
    $vm | Add-VMAssignableDevice -ResourcePoolName "GpuChildPool"
   ```

   >[!NOTE]
   > If you want to add more than one GPU to the VM, first verify that the resource pool has more than one assignable GPU available, and then run the previous command again.

If you start the VM now, the cluster ensures that it is placed on a server with available GPU resources from this cluster-wide pool. The cluster also assigns the GPU to the VM through DDA, which allows the GPU to be accessed from workloads inside the VM.

   >[!NOTE]
   > You also need to install drivers from your GPU manufacturer inside the VM so that apps in the VM can take advantage of the GPU assigned to them.

You can also remove an assigned GPU from a VM. To do so, in PowerShell, run the following cmdlet:

   ```PowerShell
    Get-VMAssignableDevice -VMName $vm | Where-Object { $_.ResourcePoolName -eq "GpuChildPool" } | Remove-VMAssignableDevice
   ```

#### Fail over a VM with an assigned GPU
To test the cluster’s ability to keep your GPU workload available, perform a drain operation on the server where the VM is running with an assigned GPU. To drain the server, follow the instructions in [Failover cluster maintenance procedures](maintain-servers.md). The cluster will restart the VM on another server in the cluster, as long as another server has sufficient available GPU resources in the pool that you created.

## Next steps
For more information, see also:
- [Manage VMs with Windows Admin Center](vm.md)
- [Plan for deploying devices using Discrete Device Assignment](/windows-server/virtualization/hyper-v/plan/plan-for-deploying-devices-using-discrete-device-assignment)
