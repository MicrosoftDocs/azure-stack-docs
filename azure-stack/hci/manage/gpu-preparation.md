---
title: Prepare GPUs for Azure Stack HCI (preview)
description: Learn how to prepare GPUs for Azure Stack HCI  (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 09/25/2024
---

# Prepare GPUs for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare graphical processing units (GPUs) for Azure Stack HCI for computation-intensive workloads running on Arc virtual machines (VMs) and AKS enabled by Azure Arc. GPUs are used for computation-intensive workloads such as machine learning and deep learning.

> [!IMPORTANT]
> This feature is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Attaching GPUs on Azure Stack HCI

You can attach your GPUs in one of two ways for Azure Stack HCI:

- **[Discrete Device Assignment (DDA)](/windows-server/virtualization/hyper-v/deploy/deploying-graphics-devices-using-dda)** - allows you to dedicate a physical GPU to your workload. In a DDA deployment, virtualized workloads run on the native driver and typically have full access to the GPU's functionality. DDA offers the highest level of app compatibility and potential performance.  

- **[GPU Partitioning (GPU-P)](/windows-server/virtualization/hyper-v/gpu-partitioning?pivots=azure-stack-hci)** - allows you to share a GPU with multiple workloads by splitting the GPU into dedicated fractional partitions.

Consider the following functionality and support differences between the two options of using your GPUs:

| Description | Discrete Device Assignment | GPU Partitioning |
| --- | --- | --- |
GPU resource model | Entire device | Equally partitioned device |
| VM density | Low (one GPU to one VM) | High (one GPU to many VMs) |
| App compatibility | All GPU capabilities provided by vendor (DX 12, OpenGL, CUDA) | All GPU capabilities provided by vendor (DX 12, OpenGL, CUDA) |
| GPU VRAM | Up to VRAM supported by the GPU | Up to VRAM supported by the GPU per partition |
| GPU driver in guest | GPU vendor driver (NVIDIA) | GPU vendor driver (NVIDIA) |

## Supported GPU models

To see the full list of supported solutions and GPUs available, see [Azure Stack HCI Solutions](https://azurestackhcisolutions.azure.microsoft.com/#/catalog?gpuSupport=GPU_P&gpuSupport=DDA) and select **GPU support** in the left menu for options.  

NVIDIA supports their workloads separately with their virtual GPU software. For more information, see [Microsoft Azure Stack HCI - Supported NVIDIA GPUs and Validated Server Platforms](https://docs.nvidia.com/vgpu/17.0/grid-vgpu-release-notes-microsoft-azure-stack-hci/index.html#hardware-configuration).

For AKS workloads, see [GPUs for AKS for Arc](/azure/aks/hybrid/deploy-gpu-node-pool#supported-gpu-models).

The following GPU models are supported using both DDA and GPU-P for Arc VM workloads:

- NVIDIA A2
- NVIDIA A16

These additional GPU models are supported using GPU-P (only) for Arc VM workloads:

- NVIDIA A10
- NVIDIA A40
- NVIDIA L4
- NVIDIA L40
- NVIDIA L40S

## Host requirements

Your Azure Stack HCI host must meet the following requirements:

- Your system must support an Azure Stack HCI solution with GPU support. To browse your options, see the [Azure Stack HCI Catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog?gpuSupport=GPU_P&gpuSupport=DDA).

- You've access to an Azure Stack HCI, version 23H2 cluster.

- You must create a homogeneous configuration for GPUs across all the servers in your cluster. A homogeneous configuration consists of installing the same make and model of GPU.

- For GPU-P, ensure that the virtualization support and SR-IOV are enabled in the BIOS of each server in the cluster. Contact your system vendor if you're unable to identify the correct setting in your BIOS.

## Prepare GPU drivers on each host

The process for preparing and installing GPU drivers for each host server differs somewhat between DDA and GPU-P. Follow the applicable process for your situation.

### Find GPUs on each host

First ensure there is no driver installed for each host server. If there is a host driver installed, uninstall the host driver and restart the server.  

After you uninstalled the host driver or if you did not have any driver installed, run PowerShell as administrator with the following command:

```powershell
Get-PnpDevice -Status Error | fl FriendlyName, InstanceId
```
You should see the GPU devices appear in an error state as `3D Video Controller` as shown in the example output that lists the friendly name and instance ID of the GPU:

```output
[ASRR1N26R02U46A]: PS C:\Users\HCIDeploymentUser\Documents> Get-PnpDevice - Status Error

Status		Class			FriendlyName
------		-----			------------
Error					SD Host Controller
Error					3D Video Controller
Error					3D Video Controller
Error		USB			Unknown USB Device (Device Descriptor Request Failed)

[ASRR1N26R02U46A]: PS C:\Users\HCIDeploymentUser\Documents> Get-PnpDevice - Status Error | f1 InstanceId

InstanceId : PCI\VEN_8086&DEV_18DB&SUBSYS_7208086REV_11\3&11583659&0&E0

InstanceId : PCI\VEN_10DE&DEV_25B6&SUBSYS_157E10DE&REV_A1\4&23AD3A43&0&0010

InstanceId : PCI\VEN_10DE&DEV_25B6&SUBSYS_157E10DE&REV_A1\4&17F8422A&0&0010

InstanceId : USB\VID_0000&PID_0002\S&E492A46&0&2
```

## Using DDA

Follow this process if using DDA:

### 1. Disable and dismount GPUs from the host

For DDA, when you uninstall the host driver or have a new Azure Stack HCI cluster setup, the physical GPU goes into an error state. You must dismount all the GPU devices to continue. You can use Device Manager or PowerShell to disable and dismount the GPU using the `InstanceID` obtained in the prior step.

```powershell
$id1 = "GPU_instance_ID"
Disable-PnpDevice -InstanceId $id1 -Confirm:$false
Dismount-VMHostAssignableDevice -InstancePath $id1 -Force
```

Confirm the GPUs were correctly dismounted from the host. The GPUs will now be in an `Unknown` state:

```powershell
Get-PnpDevice -Status Unknown | fl FriendlyName, InstanceId
```

Repeat this process for each server in the Azure Stack HCI cluster to prepare the GPUs.

### 2. Download and install the mitigation driver

The software might include components developed and owned by NVIDIA Corporation or its licensors. The use of these components is governed by the [NVIDIA end user license agreement](https://www.nvidia.com/content/DriverDownloads/licence.php?lang=us).

See the [NVIDIA documentation](https://docs.nvidia.com/datacenter/tesla/gpu-passthrough/) to download the applicable NVIDIA mitigation driver. After downloading the driver, expand the archive and install the mitigation driver on each host server. Use the following PowerShell script to download the mitigation driver and extract it:

```powershell
Invoke-WebRequest -Uri "https://docs.nvidia.com/datacenter/tesla/gpu-passthrough/nvidia_azure_stack_inf_v2022.10.13_public.zip" -OutFile "nvidia_azure_stack_inf_v2022.10.13_public.zip"
mkdir nvidia-mitigation-driver
Expand-Archive .\nvidia_azure_stack_inf_v2022.10.13_public.zip .\nvidia-mitigation-driver
```

Once the mitigation driver files are extracted, find the version for the correct model of your GPU and install it. For example, if you were installing an NVIDIA A2 mitigation driver, run the following:

```powershell
pnputil /add-driver nvidia_azure_stack_A2_base.inf /install /force
```

To confirm the installation of these drivers, run:

```powershell
pnputil /enum-devices OR pnputil /scan-devices
```

You should be able to see the correctly identified GPUs in `Get-PnpDevice`:

```powershell
Get-PnpDevice -Class Display | fl FriendlyName, InstanceId
```

Repeat the above steps for each host in your Azure Stack HCI cluster.

## Using GPU-P

Follow this process if using GPU-P:

### Download and install the host driver

GPU-P requires drivers on the host level that differ from DDA. For NVIDIA GPUs, you will need an NVIDIA vGPU software graphics driver on each host and on each VM that will use GPU-P. For more information, see the latest version of [NVIDIA vGPU Documentation](https://docs.nvidia.com/vgpu/17.0/grid-vgpu-release-notes-microsoft-azure-stack-hci/index.html) and details on licensing at [Client Licensing User Guide](https://docs.nvidia.com/vgpu/17.0/grid-licensing-user-guide/index.html).

After identifying the GPUs as `3D Video Controller` on your host server, download the host vGPU driver. Through your NVIDIA GRID license, you should be able to obtain the proper host driver .zip file.

You will need to obtain and move the following folder to your host server: *\vGPU_<Your_vGPU_version>_GA_Azure_Stack_HCI_Host_Drivers*

Navigate to *\vGPU_<Your_vGPU_version>_GA_Azure_Stack_HCI_Host_Drivers\Display.Driver* and install the driver.  

```powershell
pnputil /add-driver .\nvgridswhci.inf /install /force
```

To confirm the installation of these drivers, run:

```powershell
pnputil /enum-devices
```

You should be able to see the correctly identified GPUs in `Get-PnpDevice`:

```powershell
Get-PnpDevice -Class Display | fl FriendlyName, InstanceId
```
You can also run the NVIDIA System Management Interface `nvidia-smi` to list the GPUs on the host server as follows:

```powershell
nvidia-smi
```

If the driver is correctly installed, you will see an output similar to the following sample:

```output
Wed Nov 30 15:22:36 2022
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 527.27       Driver Version: 527.27       CUDA Version: N/A      |
|-------------------------------+----------------------+----------------------+
| GPU  Name            TCC/WDDM | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA A2          WDDM  | 00000000:65:00.0 Off |                    0 |
|  0%   24C    P8     5W /  60W |  15192MiB / 15356MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA A2          WDDM  | 00000000:66:00.0 Off |                    0 |
|  0%   24C    P8     5W /  60W |  15192MiB / 15356MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
 
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

### Configure GPU partition count

Follow these steps to configure the GPU partition count in PowerShell:

> [!NOTE]
> When using PowerShell, you must manually ensure the GPU configuration is homogenous across all servers in your Azure Stack HCI cluster.

1. Connect to the server whose GPU partition count you want to configure.

1. Run the `Get-VMHostPartitionableGpu` command and refer to the **Name** and **ValidPartitionCounts** values.

1. Run the following command to configure the partition count. Replace `GPU-name` with the **Name** value and `partition-count` with one of the supported counts from the **ValidPartitionCounts** value:

    ```powershell
    Set-VMHostPartitionableGpu -Name "<GPU-name>" -PartitionCount <partition-count>
    ```

    For example, the following command configures the partition count to `4`:

    ```powershell
    PS C:\Users> Set-VMHostPartitionableGpu -Name "\\?\PCI#VEN_10DE&DEV_25B6&SUBSYS_157E10DE&REV_A1#4&18416dc3&0&0000#{064092b3-625e-43bf-9eb5-dc845897dd59}" -PartitionCount 4
    ```

    You can run the command `Get-VMHostPartitionableGpu | FL Name,ValidPartitionCounts,PartitionCount` again to verify that the partition count is set to `4`.

    Here's a sample output:

    ```powershell
    PS C:\Users> Get-VMHostPartitionableGpu | FL Name,ValidPartitionCounts,PartitionCount

    Name                    : \\?\PCI#VEN_10DE&DEV_25B6&SUBSYS_157E10DE&REV_A1#4&18416dc3&0&0000#{064092b3-625e-43bf-9eb5-dc845897dd59}
    ValidPartitionCounts    : {16, 8, 4, 2...}
    PartitionCount          : 4

    Name                    : \\?\PCI#VEN_10DE&DEV_25B6&SUBSYS_157E10DE&REV_A1#4&5906f5e&0&0010#{064092b3-625e-43bf-9eb5-dc845897dd59}
    ValidPartitionCounts    : {16, 8, 4, 2...}
    PartitionCount          : 4
     ```

1. To keep the configuration homogeneous, repeat the partition count configuration steps on each server in your Azure Stack HCI cluster.

## Guest requirements

GPU management is supported for the following Arc VM workloads:

- Generation 2 VMs

- A supported 64-bit OS as detailed in the latest [NVIDIA vGPU support Supported Products](https://docs.nvidia.com/vgpu/17.0/product-support-matrix/index.html#abstract__microsoft-azure-stack-hci)

## Next steps

- [Manage GPU via Discrete Device Assignment (DDA)](./gpu-manage-via-device.md)
- [Manage GPU via GPU Partitioning (GPU-P)](./gpu-manage-via-partitioning.md)