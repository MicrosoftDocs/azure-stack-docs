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


The graphics processing unit-partitioning (GPU-P) feature allows you to share a physical GPU device with multiple virtual machines (VMs) in Azure Stack HCI.

This article describes how to use the GPU-P feature in Azure Stack HCI. This includes how to configure GPU partition count, assign GPU partitions, and unassign GPU partitions via Windows Admin Center and PowerShell.

[!INCLUDE [preview](../../includes/hci-preview.md)]

## About GPU partitioning

Many machine learning or other compute workloads, such as Azure Virtual Desktop on Azure Stack HCI (preview) may not need a dedicated GPU. For such workloads, you can share a physical GPU with multiple VMs, instead of dedicating the full GPU to a single VM. With the GPU-P or GPU virtualization feature, each VM gets a dedicated fraction of the GPU. This can help lower the total cost of ownership (TCO) for GPU-powered workloads that can work on a reduced GPU power.

For example, for Azure Virtual Desktop on Azure Stack HCI (preview) workloads, GPU-P can provide cost-effective VM options that are sized appropriately with dedicated GPU resources for each user. GPU-P in such VM workloads helps increase the GPU utilization without significantly affecting the performance benefits of GPU.

The GPU-P feature uses the [Single Root IO Virtualization (SR-IOV) interface](/windows-hardware/drivers/network/overview-of-single-root-i-o-virtualization--sr-iov-), which provides hardware-backed security boundary with predictable performance for each VM. Each VM can access only the GPU resources dedicated to them and the secure hardware partitioning prevents unauthorized access by other VMs.

## Supported guest operating systems

GPU-P on Azure Stack HCI supports these guest operating systems:

- Windows Server 2019​
- Windows Server 2022​
- Windows 10​
- Windows 11​
- Windows 10 Multisession​
- Windows 11 Multisession
- Linux Ubuntu 18.04 LTS, 20.04 LTS​

## Prerequisites

There are several requirements and things to consider before you begin to use the GPU-P feature:

> [!NOTE]
> Currently, we support only Nvidia A16 and A2 GPUs on the Azure Stack HCI solutions. We recommend that you work with your OEM partners to plan, order, and set up the systems for your desired workloads with the appropriate configurations.

- To get started, you must have an Azure Stack HCI cluster running Azure Stack HCI, version 22H2.

- A VM to be enabled with vGPU is created.

- Your chosen guest operating system is installed in the VM. See [Supported guest operating systems](#supported-guest-operating-systems) for a list of supported guest operating systems.

- If you're using Windows Admin Center to provision GPU-P, you must install the latest version of [Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) with the **GPUs** extension <!--insert-version-number-->. For instructions on how to install the **GPUs** extensions in Windows Admin Center, see [install the GPUs extension](#install-the-gpus-extension).

- If you're using PowerShell to provision GPU-P, you must run all PowerShell commands as an administrator.

- You must install the GPU device of the same make, model, and size on every server of the cluster.
    
- You must install the GPU drivers both on the host and the guest machines. See the Nvidia vGPU documentation \<insert_hyperlink_to_Nvidia_documentation\> for detailed deployment steps, licensing information, and supported operating systems. The deployment process includes performing a set of actions on both the host machine and the guest machines.

- You must ensure that the virtualization support (SR-IOV) is enabled in the BIOS of each server in the cluster. If not, you must first enable it to use the GPU-Partitioning feature. Reach out to your system vendor if you are unable to identify the correct setting in your BIOS.
  
    The following sample screenshot of the iDRAC9 dashboard shows the BIOS settings that you must enable in Dell systems:

    :::image type="content" source="./media/partition-gpu/enable-gpu-partitioning.png" alt-text="Screenshot to confirm if SR-IOV is enabled in the BIOS of the host machine." lightbox="./media/partition-gpu/enable-gpu-partitioning.png" :::

## GPU partitioning caveats

Consider the following caveats when using the GPU-P feature:

- For best performance, we recommend that you create a homogeneous configuration across all the servers in your cluster. A homogeneous configuration consists of installing the same make and model of the GPU, and configuring the same partition size cross all the servers in the cluster. Azure Stack HCI doesn't support GPU-P if your configuration is not homogeneous. Here are some examples of the configurations that Azure Stack HCI doesn't support:

    - Mixing GPUs from different vendors in the same cluster. This is not supported because they have different driver and licensing requirements and can lead to unintended consequences.
    
    - Using different GPU models from different product family from the same vendor in your cluster.
    
    - Having cluster configuration with servers that have a mix of Discrete Device Assignment (DDA)-supported and partitionable GPUs. All the servers in your cluster should have GPUs set up either for DDA or partitioning, but not both.

- You cannot assign a physical GPU as both Discrete Device Assignment (DDA) or partitionable GPU. It can either be assigned as DDA or partitionable GPU, but not both.

- You cannot assign multiple partitions to a single VM.

- Azure Stack HCI auto-assigns the partition to the VMs. You can't chose specific partition for a specific VM.

- Currently, GPU-P on Azure Stack HCI doesn't support live migration of VMs.

## GPU-P provisioing workflow

To use GPU-P on Azure Stack HCI, you need to perform a set of actions on both the host and guest machines.

Here's the high-level summary of the workflow on the host machine:

1. Install the GPU device. You must install the same GPU model across all the servers in your cluster.
1. Install the host GPU driver. You must install the same host GPU driver across all the servers in your cluster.
1. Enable SR-IOV in the BIOS of the host machine.
1. Configure the same GPU partition count on all the servers in your cluster.
1. Assign a GPU partition to a VM​.
1. If required, unassign a GPU partition from a VM.

Here's the high-level summary of the workflow on the guest machine:

1. Install the guest GPU driver on the VM.

## Check if the GPU is partionable

After you've completed all the [prerequisites](#prerequisites), you must verify if the GPU is partionable.

## [Windows Admin Center](#tab/windows-admin-center)

Follow these steps to verify if the GPU is partionable using Windows Admin Center:

1. Launch Windows Admin Center and make sure the **GPUs** extension is already installed. If not, see [install the GPUs extension](#install-the-gpus-extension) for instructions on how to install it.

1. Select **Cluster Manager** from the top dropdown menu and connect to your Azure Stack HCI cluster.

1. From the **Settings** menu, select **Extensions** > **GPUs**.

   The **GPUs** tab on the **GPU** page displays inventory of the servers and the physical GPUs that are installed on each server.

1. Check the **Assigned status** column for each GPU across all the servers. The **Assigned status** column can have one of these statuses:
    
    - **Ready for DDA assignment**. Indicates that the GPU is available for DDA assignment. You can't use this GPU for partitioning.
    
    - **Partitioned**. Indicates that the GPU is partitionable.
    
    - **Paravirtualization**. Indicates that the GPU has the partitioned driver capability installed but SR-IOV on the server isn't enabled.
    
    - **Not assignable**. Indicates that the GPU is not assignable because it's an older PCI-style device or switch port.

Proceed further only if the **Assigned status** column shows the status as **Partitioned** for all the GPUs across all the servers in your cluster.

## [PowerShell](#tab/powershell)

Follow these steps to verify the host driver is installed:

1. Connect to a server in your cluster using Remote Desktop Protocol (RDP), and then run the following PowerShell command to verify if the GPU device is installed:

```powershell
Get-PnpDevice | where {$_.friendlyname -like "*nvidia"}
```

Here's a sample output:

```powershell
Status    Class    FriendlyName
------    -----    ------------
OK        Display  NVIDIA A2
```

1. Run the following command to confirm that Azure Stack HCI host has GPU adapters that can be partitioned by listing the GPUs that support GPU-P.

```powershell
Get-VMHostPartitionableGpu
```

<!--Here's a sample output:-->
---

## Configure GPU partitions

After you install the GPU-P driver on the host server, it displays the maximum partition count that the GPU can have. The partition counts can vary for different GPU types depending on their manufacturer setting. After you confirm the installed GPU is partitionable, you can proceed with configuring its partition count.

## [Windows Admin Center](#tab/windows-admin-center)

1. Select the **GPU partitions** tab. This tab allows you to configure partitions for the selected GPU, assign partition to VMs or unassign partitions from VMs.
    
    This tab displays the inventory of all the GPUs that are currently partitioned and their assignment statuses. You can select a GPU or GPU partition resource to display its details in the bottom section of the page, under **Selected item details**. For example, if you select a GPU, it displays the GPU name, GPU ID, available encoder and decoder, available VRAM, valid partition count, and the current partition count. If you select a GPU partition, it displays the partition ID, VM ID, instance path, partition VRAM, partition encode, and partition decode.

    > [!NOTE]
    > If there are no partitionable GPUs available in your cluster or the correct GPU-P driver isn't installed, the GPU partitions page displays the following message:
    > *No partitionable GPUs have been found. Please check that you have a GPU with the correct GPU-P driver to proceed.*

1. Select **Configure partition count**.
   The **Configure partition count on GPUs** window is displayed. For each server, it displays the installed GPU name, status, manufacturer, number of partitions, and total VRAM. By default, the number of partitions displays the maximum partition count the GPU comes with.

1. Select a set of homogeneous GPUs. A set of GPUs is called a homogeneous set if all the GPUs across all the servers have the same size, manufacturer, model number, and number of partitions. By default, Windows Admin Center automatically selects a set of homogenous GPUs if it detects one.
    You may see a warning or an error depending on the GPU selection you make:

    - Warning. If you deselect one or more GPUs from the homogeneous set of GPUs, Windows Admin Center gives a warning but doesn't stop you from proceeding further. Warning indicates you are not selecting all the GPUs and it may result in different partition count, which is not recommended.
    
    - Warning. If not all the GPUs across all the servers have the same configuration, Windows Admin Center gives a warning. You must manually select the GPUs with the same configuration to proceed further.
    
    - Error. If you select GPUs with different configurations, Windows Admin Center gives you an error and doesn't let you proceed.
    
    - Error. If none of the GPUs have the same configuration, Windows Admin Center gives an error and stops you from proceeding further.
    
    - Error. If a GPU for which you are configuring a partition count is already assigned to a VM, selecting that GPU will give you an error. You must first unassign the partition from the VM before proceeding further. See <!--unassign a partition>

1. After you select the GPUs, select the partition count from the **Number of Partitions** dropdown list. This list is automatically populated with the partition counts configured by the manufacturer of the selected GPU. The number displayed in the list can vary depending on the type of GPU you selected.

    As soon as you select a different partition count, a tooltip appears below the dropdown list, which dynamically displays the size of VRAM that each partition will get. For example, suppose the total VRAM is 16 GB for 8 partitions in the GPU. If you change the partition count from 8 to 4, each partition now gets 4 GB of VRAM.

1. Select **Configure partition count**. <!--any message after selecting the button?>

## [PowerShell](#tab/powershell)

We recommend that you create a homogeneous configuration across your cluster for best performance, such as the same GPU model installed across the nodes, and the same partition size across the nodes. 

Run the following command to configure GPU partition count using PowerShell:

```powershell
PS C:> Get-VMHostPartitionableGpu | Set-VMHostPartitionableGpu -PartitionCount partitions 
```

---

## Assign GPU partition to VMs

Save your workloads before assigning partition to the VM.

> [!NOTE]
> Currently, you can assign only a single GPU partition to a VM. We recommend that you plan ahead and determine the GPU partition size based on your workload performance requirements. Both the VM and the GPU (partition) needs to be on the same host machine.

## [Windows Admin Center](#tab/windows-admin-center)

You must save your workloads before assigning partitions. If your VM is currently turned on or running, Windows Admin Center automatically turns it off first, assigns the partition, and then automatically turns it on.

1. On the **GPU partitions** tab, select **+ Assign partition**.
   The **Assign GPU partition to VM** page is displayed.

1. From **Choose the server** list, select the server where the VM resides. This list displays all the servers in your cluster.
1. Search for and select the VM to assign GPU partition. The list automatically populates the VMs that reside on the server that you selected in step 2.

    - If a GPU partition is already to a VM, that VM appears as grayed out.

    - Select all the VMs at once by selecting the **Select All** checkbox.

1. Select the available VRAM options. The value in this field must match the size of the partition when you configured the partition count.

1. (Optional, but recommended) Select the **Configure offline action for force shutdown** checkbox if you want your VM to be highly available and failover if their host server goes down.

    :::image type="content" source="./media/partition-gpu/add-gpu-prtition-to-vm.png" alt-text="Screenshot of the GPU Partitions in Windows Admin Center." lightbox="./media/partition-gpu/add-gpu-prtition-to-vm.png" :::

1. Select **Assign partition** to assign partition of the selected VRAM size to the selected VM on the selected server.

After the partition is assigned, you'll get a notification that the partition is successfully assigned to the VM. On the **GPU partitions** tab, the VM shows up under the GPU partition of the server it's installed on.

## [PowerShell](#tab/powershell)

Follow these steps to assign GPU partitions using PowerShell:

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

## Unassign a partition from a VM

You can unassign a partition from the VM if it's no longer needed. Unassigning the partition frees up the GPU partition resource, which you can reassign to another VM if needed.

You must save your workloads before unassigning partitions. If your VM is currently turned on or running, Windows Admin Center automatically turns it off first, unassigns the partition, and then automatically turns it on.

## [Windows Admin Center](#tab/windows-admin-center)

You must save your workloads before unassigning partitions. If your VM is currently turned on or running, Windows Admin Center automatically turns it off first, unassigns the partition, and then automatically turns it on.

1. On the **GPU partitions** tab, select the GPU-partition that you want to unassign.

1. Select **- Unassign partition**.
   The **Unassign GPU partition from VM** page is displayed.

1. From **Choose the server** list, select the server which has the GPU partition that you want to unassign.

1. From **Choose virtual machine to unassign partition from** list, search or select the VM to unassign the partition from.

1. Select **Unassign partition**.

After the partition is unassigned, you'll get a notification that the partition is successfully unassigned from the VM. On the **GPU partitions** tab, the table refreshes and the VM from which the partition is unassigned no longer displays under the GPU row.

## [PowerShell](#tab/powershell)

Follow these steps to unassign a GPU partition from a VM using PowerShell:

1. Get the host machine’s partitionable GPU.

```powershell
*PS C:\> Get-VMHostPartitionableGpu*
```

1. Create the GPU partitions.

---

## Install the GPUs extension

The **GPUs** extension in Windows Admin Center allows you to view your partitioned GPU resources across your Azure Stack HCI cluster. It also allows you to assign or unassign GPU partitions resources to and from VMs.

Follow these steps to install the **GPU** extension in your Windows Admin Center application:

1. Launch Windows Admin Center.

1. Select the **Settings** gear icon from the top right corner of the page.
    
1. From the **Settings** menu in the left pane, go to **Gateway** > **Extensions**. The **Available Extensions** tab lists the extensions on the feed that are available for installation.
    
1. Select the **GPUs** extension from the list. Or, use the **Search** box to quickly find the **GPUs** extension from the list and then select it.
    
1. Select **Install**. After you installed the **GPUs** extension, it appears under the **Installed extensions** tab.

## Next steps

For more information on GPUs, see also:

- [Use GPUs with clustered VMs](../manage/use-gpu-with-clustered-vm.md)