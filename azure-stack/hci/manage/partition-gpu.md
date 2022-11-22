---
title: Use GPU partitioning on Azure Stack HCI
description: Learn how to partition GPUs with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads in the clustered VMs.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.date: 11/18/2022
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2.md)]

# Use GPU partitioning on Azure Stack HCI virtual machines

This article describes how to use the graphics processing units-partitioning (GPU-P) feature on Azure Stack HCI virtual machines (VMs). The GPU-P or GPU virtualization feature enables you to accelerate and scale your GPU-powered workloads, such as virtual desktop infrastructure in a cost-effective manner.

The GPU-P feature uses the Single Root IO Virtualization (SR-IOV) interface, which provides hardware-backed security boundary with predictable performance for each VM. Each VM can access only the GPU resources dedicated to them and the secure hardware partitioning prevents unauthorized access by other VMs.

[!INCLUDE [preview](../../includes/hci-preview.md)

## Prerequisites

There are several requirements and things to consider before you begin to provision GPU partitioning:

- You must have an Azure Stack HCI cluster running Azure Stack HCI, version 22H2.
- You must physically install the same GPU model on every server of the cluster.

- You must install the Nvidia GPU drivers both on the host and the guest VMs. See the Nvidia vGPU documentation \<insert_hyperlink_to_Nvidia_documentation\> for detailed deployment steps, licensing information, and supported operating systems. The deployment process includes performing a set of actions on both the host machine and the guest machines.

    > [!NOTE]
    > Currently, we support only Nvidia A16 and A2 GPUs on the Azure Stack HCI solutions. We recommend that you work with your OEM partners to plan, order, and set up the systems for your desired workloads with the appropriate configurations.

- For best performance, we recommend that you create a homogeneous configuration across all servers in your cluster. This includes installing the same GPU model and configuring the same partition size across the servers in the cluster.

## Workflow

1. Complete the prerequisites.
1. Install 

1. Check if SR-IOV is enabled in the BIOS of the host machine. If not, enable it to use the GPU-Partitioning feature, as shown below.

    :::image type="content" source="./media/partition-gpu/enable-gpu-partitioning.png" alt-text="Screenshot to confirm if SR-IOV is enabled in the BIOS of the host machine." lightbox="./media/partition-gpu/enable-gpu-partitioning.png" :::

1. 
## Create GPU partitions

After you've installed the host driver on every server of your Azure Stack HCI cluster, you can either use PowerShell \<insert_PS_gallery_link\> or Windows Admin Center to set up and manage the VMs and GPUs.

## [Windows Admin Center](#tab/windows-admin-center)

Follow these steps to create GPU partitions using Windows Admin Center:

1. Launch Windows Admin Center.
1. Install the GPUs extension.
    1. Select the **Settings** gear icon from the top right corner of the page.
    1. From the **Settings** menu in the left pane, go to **Gateway** > **Extensions**.
       The **Available Extensions** tab lists the extensions on the feed that are available for installation.
    1. Select the **GPUs** extension from the list. Or, use the **Search** box to quickly find the **GPUs** extension from the list and then select it.
    1. Select **Install**.
    1. After you installed the extension, it appears under the **Installed extensions** tab.
1. Select **Cluster Manager** from the top dropdown menu and connect your Azure Stack HCI cluster.
1. From the **Settings** menu, select **Extensions** > **GPUs**.
1. In the **GPU** pane, go to the **GPU Partitions** tab and then select **Partition New GPU**.

    Windows Admin Center by default checks for homogeneous configurations and guides you to create the recommended partitions across every server in your [cluster.](./media/partition-gpu/)

    :::image type="content" source="./media/partition-gpu/partition-new-gpu.png" alt-text="Screenshot to confirm if SR-IOV is enabled in the BIOS of the host machine." lightbox="./media/partition-gpu/partition-new-gpu.png" :::

1. Once the partitions are created, assign a partition to a VM.
    > [!NOTE]
    > Currently, you can assign only a single GPU partition to a VM. We recommend that you plan ahead and determine the GPU partition size based on your workload performance requirements. Both the VM and the GPU (partition) needs to be on the same host machine. To assign a GPU partition to a VM using PowerShell:  

    :::image type="content" source="./media/partition-gpu/add-gpu-prtition-to-vm.png" alt-text="Screenshot of the GPU Partitions in Windows Admin Center." lightbox="./media/partition-gpu/add-gpu-prtition-to-vm.png" :::

## [PowerShell](#tab/powershell)

1. Run the following command to list the GPUs that support GPU-P in the Azure Stack HCI host machine.

```powershell
*PS C:\> Get-VMHostPartitionableGpu*
```

1. Create partitions.

```powershell
Set-VMHostPartitionableGpu -Name \"gpu-name\" -PartitionCount
partitions
```

1. After you created a partition, run the following command to assign a partition to a VM.

> [!NOTE]
> Currently, you can assign only a single GPU partition to a VM. We recommend that you plan ahead and determine the GPU partition size based on your workload performance requirements. Both the VM and the GPU (partition) needs to be on the same host machine. To assign a GPU partition to a VM using PowerShell:  

```powershell
PS C:> Add-VMGpuPartitionAdapter –VMName $vm "VM-Name" ` 

–MinPartitionVRAM min-ram ` 
-MaxPartitionVRAM max-ram ` 
-OptimalPartitionVRAM opt-ram ` 
-MinPartitionEncode min-enc ` 
-MaxPartitionEncode max-enc ` 
-OptimalPartitionEncode opt-enc ` 
-MinPartitionDecode min-dec ` 
-MaxPartitionDecode max-dec ` 
-OptimalPartitionDecode opt-dec ` 
-MinPartitionCompute min-compute ` 
-MaxPartitionCompute max-compute ` 
-OptimalPartitionCompute opt-compute 
```

Partitions are resolved only when the VM is started. To list the VM and
GPU assignment, you can run the following command: 

*PS C:\> Get-VMGpuPartitionAdapter --VMName \$vm* 

The next step will be to start the VM using PowerShell or WAC. Once the
VM is up and running, it will show a GPU in device manager. At this
time, you can install the guest driver provided but the partner.   

There is no mechanism today to pass the driver to the VM and install the
driver.  

Migrating the VM to a different node:  

In case of a failover, you need to shutdown the VM, drain the node and manually fail it over to another node. We require that the VM cluster resource be set to force-shutdown, like how we configure VMs that use GPU-DDA: Get-ClusterResource -name vmname \| Set-ClusterParameter -Name \"OfflineAction\" -Value 3. 

## Next steps

For more information, see also:
- [Manage VMs with Windows Admin Center](../manage/vm.md)