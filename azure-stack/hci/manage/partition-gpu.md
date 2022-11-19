---
title: GPU partitioning
description: Learn how to partition GPUs with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads in the clustered VMs.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.date: 11/18/2022
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2.md)]

This article describes how to partition graphics processing units (GPUs) with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads in the clustered VMs.

The GPU partitioning (GPU-P) or GPU virtualization feature enables your to accelerate and scale your GPU-powered workloads in a cost-effective manner.

The GPU-P feature uses the SR-IOV technology, which ensures hardware-backed security boundary with predictable performance for each virtual machine (VM).

Currently, we support only Nvidia A16 and A2 GPUs on the Azure Stack HCI solutions. We recommend that you work with your OEM partners to plan, order and setup the systems for your desired workloads with the appropriate configurations. To take advantage of the GPU virtualization capabilities in Azure Stack HCI, you must install the Nvidia GPU drivers both on the host and the guest VMs. See the Nvidia vGPU documentation \<insert_hyperlink_to_Nvidia_documentation\> for detailed deployment steps, licensing information and supported operating systems. The deployment steps involve a set of actions you need to take on the host machine, and a set of actions you need to take on the guest machine. 

Once you have installed the host driver on every node of your Azure Stack HCI cluster, you can either use PowerShell \<insert_PS_gallery_link\> or Windows Admin Center (WAC) to setup and manage the virtual machines and GPUs. 

First, check if SR-IOV is enabled in the BIOS of the host machines or not. If not, enable it to use the GPU-Partitioning feature, as shown below. 

![](./media//media/image1.png){width="3.0555555555555554in"
height="0.2222222222222222in"}![](./media//media/image1.png){width="3.0555555555555554in"
height="0.2222222222222222in"}![](./media//media/image1.png){width="3.0555555555555554in"
height="0.2222222222222222in"}![Graphical user interface Description
automatically generated](./media//media/image2.png){width="6.5in"
height="5.445833333333334in"} 

To confirm that the Microsoft Azure Stack HCI host has GPU adapters that can be partitioned by listing the GPUs that support GPU-P.

*PS C:\> Get-VMHostPartitionableGpu* 

We recommend that you create a homogeneous configuration across your cluster for best performance, such as the same GPU model installed across the nodes, and the same partition size across the nodes. To create partitions using PowerShell, 

*Set-VMHostPartitionableGpu -Name \"gpu-name\" -PartitionCount
partitions ~~gpu-name~~* 

*[Or]{.underline}* 

*[PS C:\> Get-VMHostPartitionableGpu \| Set-VMHostPartitionableGpu
-PartitionCount partitions]{.underline}* 

To create partitions using the WAC tool, install the GPU tool extension, go to the GPU partition tab and then click on 'Partition a New GPU'. WAC will by default check for homogeneous configurations and guide you to create the recommended partitions across your cluster. 

 ![Graphical user interface, application, email Description
automatically generated](./media//media/image3.jpeg){width="6.5in"
height="4.69375in"} 

Once the partitions are created, you can assign a partition to a VM. Today, you can only assign a single GPU partition to a VM. We recommend that you plan ahead and determine the GPU partition size based on your workload performance requirements. Both the VM and the GPU (partition) needs to be on the same host machine. To assign a GPU partition to a VM using PowerShell:

*PS C:\> Add-VMGpuPartitionAdapter --VMName ~~\$vm~~["Name"]{.underline}
\`* 

*--MinPartitionVRAM min-ram \`* 

*-MaxPartitionVRAM max-ram \`* 

*-OptimalPartitionVRAM opt-ram \`* 

*-MinPartitionEncode min-enc \`* 

*-MaxPartitionEncode max-enc \`* 

*-OptimalPartitionEncode opt-enc \`* 

*-MinPartitionDecode min-dec \`* 

*-MaxPartitionDecode max-dec \`* 

*-OptimalPartitionDecode opt-dec \`* 

*-MinPartitionCompute min-compute \`* 

*-MaxPartitionCompute max-compute \`* 

*-OptimalPartitionCompute opt-compute* 

To assign a GPU partition to a VM using WAC: 

 ![Graphical user interface, text, application Description automatically
generated](./media//media/image4.jpeg){width="6.5in"
height="4.68125in"} 

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