---
title: Share GPU with Azure Stack HCI virtual machines
description: Learn how to share a GPU with multiple virtual machines running the Azure Stack HCI operating system.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.date: 11/22/2022
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Share GPU with your Azure Stack HCI virtual machines

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2.md)]

This article describes how to use the graphics processing unit-partitioning (GPU-P) feature that allows you to share your dedicated GPU with multiple Azure Stack HCI virtual machines (VMs).

The GPU-P feature uses the [Single Root IO Virtualization (SR-IOV) interface](/windows-hardware/drivers/network/overview-of-single-root-i-o-virtualization--sr-iov-), which provides hardware-backed security boundary with predictable performance for each VM. Each VM can access only the GPU resources dedicated to them and the secure hardware partitioning prevents unauthorized access by other VMs.

[!INCLUDE [preview](../../includes/hci-preview.md)]

## Benefits of GPU partitioning

With the GPU-P or GPU virtualization feature, each VM gets a dedicated fraction of the GPU, instead of getting a full GPU. This helps lower the total cost of ownership (TCO) for GPU-powered workloads that can work on a reduced GPU power.

For example, for Azure Virtual Desktop on Azure Stack HCI (preview) workload, GPU-P can provide cost-effective VM options that are sized appropriately with dedicated GPU resources for each user. GPU-P in such VM workloads helps increase the GPU utilization without significantly affecting the performance benefits of GPU.

## Supported guest operating systems

- Windows Server 2019​
- Windows Server 2022​
- Windows 10​
- Windows 11​
- Windows 10 Multisession​
- Windows 11 Multisession
- Linux Ubuntu 18.04 LTS, 20.04 LTS​

## Prerequisites

There are several requirements and things to consider before you begin to use the GPU-P feature:

- To get started, you must have an Azure Stack HCI cluster running Azure Stack HCI, version 22H2.

- If you're using PowerShell to provision GPU-P, you must run all PowerShell commands as administrator.

- If you're using Windows Admin Center to provision GPU-P, you must install the latest version of [Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) with the **GPUs** extension (insert-version-number). For instructions on how to install the **GPUs** extensions in Windows Admin Center, see [install the GPUs extension](#install-the-gpus-extension).

- You must physically install the GPU of the same make, model, and size on every server of the cluster.
    
    > [!NOTE]
    > Currently, we support only Nvidia A16 and A2 GPUs on the Azure Stack HCI solutions. We recommend that you work with your OEM partners to plan, order, and set up the systems for your desired workloads with the appropriate configurations.

- You must install the GPU drivers both on the host and the guest machines. See the Nvidia vGPU documentation \<insert_hyperlink_to_Nvidia_documentation\> for detailed deployment steps, licensing information, and supported operating systems. The deployment process includes performing a set of actions on both the host machine and the guest machines.

- Make sure that virtualization support (SR-IOV) is enabled in the BIOS of each server. If not, you must first enable it to use the GPU-Partitioning feature. Reach out to your system vendor if you are unable to identify the correct setting in your BIOS.
  
    The following sample screenshot of the iDRAC9 dashboard shows the BIOS settings that you must enable:

    :::image type="content" source="./media/partition-gpu/enable-gpu-partitioning.png" alt-text="Screenshot to confirm if SR-IOV is enabled in the BIOS of the host machine." lightbox="./media/partition-gpu/enable-gpu-partitioning.png" :::

## Additional considerations

Consider the following caveats when using the GPU-P feature:

- For best performance, we recommend that you create a homogeneous configuration across all the servers in your cluster. This includes installing the same make and model of the GPU and configuring the same partition size across the servers in the cluster.
    - Azure Stack HCI doesn't support mixing GPUs from different vendors in the same cluster. This is because they have different driver and licensing requirements and can lead to unintended consequences.  
    - Azure Stack HCI doesn't support using different GPU models from different product family from the same vendor in your cluster.
- You cannot assign a physical GPU as both DDA or partitionable GPU. It can either be assigned as DDA or as partitionable GPU, but not both.
- You cannot assign multiple partitions to a single VM.
- Azure Stack HCI auto-assigns the partition to the VMs. You can't chose specific partition for a specific VM.
-  

## GPU-P provisioing workflow

To use GPU-P on Azure Stack HCI, you need to perform a set of actions on both the host and guest machines.

Here's the high-level summary of the workflow on the host machine:

1. Install the same GPU model across all servers in the cluster.
1. Install the host driver across all servers in the cluster. Install drivers from your GPU manufacturer inside the VM so that apps in the VM can take advantage of
the GPU partition assigned to them.
1. Create the same GPU size partitions on all hosts 
1. Stop the VM.
1. Assign one partition to a VM​.
1. Start the VM.

Here's the high-level summary of the workflow on the guest machine:

1. Install guest driver on

## Create and assign GPU partitions

After you've completed all the [prerequisites](#prerequisites), you are ready to provision GPU partitions.

You can set up and manage the VMs and GPUs by using PowerShell \<insert_PS_gallery_link\> or Windows Admin Center.

## [Windows Admin Center](#tab/windows-admin-center)

Follow these steps to create and assign GPU partitions using Windows Admin Center:

1. Launch Windows Admin Center and make sure the **GPUs** extension is already installed. If not, see [install the GPUs extension](#install-the-gpus-extension).

1. Select **Cluster Manager** from the top dropdown menu and connect your Azure Stack HCI cluster.

1. From the **Settings** menu, select **Extensions** > **GPUs**.

1. In the **GPU** pane, go to the **GPU Partitions** tab and then select **Partition New GPU**.

    Windows Admin Center by default checks for homogeneous configurations and guides you to create the recommended partitions across every server in your [cluster.](./media/partition-gpu/)

    :::image type="content" source="./media/partition-gpu/partition-new-gpu.png" alt-text="Screenshot to confirm if SR-IOV is enabled in the BIOS of the host machine." lightbox="./media/partition-gpu/partition-new-gpu.png" :::

1. Once the partitions are created, the VM is force shut down.

1. Assign a partition to a VM.
    
    > [!NOTE]
    > Currently, you can assign only a single GPU partition to a VM. We recommend that you plan ahead and determine the GPU partition size based on your workload performance requirements. Both the VM and the GPU (partition) needs to be on the same host machine. To assign a GPU partition to a VM using PowerShell:  

    :::image type="content" source="./media/partition-gpu/add-gpu-prtition-to-vm.png" alt-text="Screenshot of the GPU Partitions in Windows Admin Center." lightbox="./media/partition-gpu/add-gpu-prtition-to-vm.png" :::

## [PowerShell](#tab/powershell)

Follow these steps to create and assign GPU partitions using PowerShell:

1. Get the host machine’s partitionable GPU.

```powershell
*PS C:\> Get-VMHostPartitionableGpu*
```

1. Create the GPU partitions.

```powershell
Set-VMHostPartitionableGpu -Name \"gpu-name\" -PartitionCount
partitions
```

1. After you created the GPU partitions, run the following command to assign a partition to a VM.

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

Partitions are resolved only when the VM is started.

To list the VM and GPU assignment, run the following command:

*PS C:\> Get-VMGpuPartitionAdapter --VMName \$vm* 

The next step will be to start the VM using PowerShell or WAC. Once the VM is up and running, it will show a GPU in device manager. At this time, you can install the guest driver provided by the partner.

There is no mechanism today to pass the driver to the VM and install the
driver.  

Migrating the VM to a different node:  

In case of a failover, you need to shutdown the VM, drain the node and manually fail it over to another node. We require that the VM cluster resource be set to force-shutdown, like how we configure VMs that use GPU-DDA: Get-ClusterResource -name vmname \| Set-ClusterParameter -Name \"OfflineAction\" -Value 3. 

---

### Install the GPUs extension

Follow these steps to install the **GPU** extension:

1. Launch Windows Admin Center.

1. Select the **Settings** gear icon from the top right corner of the page.
    
1. From the **Settings** menu in the left pane, go to **Gateway** > **Extensions**. The **Available Extensions** tab lists the extensions on the feed that are available for installation.
    
1. Select the **GPUs** extension from the list. Or, use the **Search** box to quickly find the **GPUs** extension from the list and then select it.
    
1. Select **Install**. After you installed the **GPUs** extension, it appears under the **Installed extensions** tab.

## Next steps

For more information on GPUs, see also:

- [Use GPUs with clustered VMs](../manage/use-gpu-with-clustered-vm.md)