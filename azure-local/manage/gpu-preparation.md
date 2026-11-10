---
title: Prepare GPUs for Azure Local instance
description: Learn how to prepare GPUs for an Azure Local instance.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.date: 10/27/2026
ms.service: azure-local
ms.subservice: hyperconverged
---

# Prepare GPUs for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to prepare graphical processing units (GPUs) on your Azure Local instance for workloads running on Azure Local virtual machines (VMs) enabled by Azure Arc and on Azure Kubernetes Service (AKS) enabled by Azure Arc. GPUs are used for computation-intensive workloads such as machine learning and deep learning.

## Attaching GPUs on Azure Local

You can attach your GPUs in one of two ways for Azure Local:

- **[Discrete Device Assignment (DDA)](/windows-server/virtualization/hyper-v/deploy/deploying-graphics-devices-using-dda)** - allows you to dedicate a physical GPU to your workload. In a DDA deployment, virtualized workloads run on the native driver and typically have full access to the GPU's functionality. DDA offers the highest level of app compatibility and potential performance.  

- **[GPU Partitioning (GPU-P)](/windows-server/virtualization/hyper-v/gpu-partitioning?pivots=azure-stack-hci)** - allows you to share a GPU with multiple workloads by splitting the GPU into dedicated fractional partitions.

Consider the following functionality and support differences between the two options of using your GPUs:

| Description | Discrete Device Assignment | GPU Partitioning |
| --- | --- | --- |
| GPU resource model | Entire device | Equally partitioned device |
| VM density | Low (one GPU to one VM) | High (one GPU to many VMs) |
| App compatibility | All GPU capabilities provided by vendor (DX 12, OpenGL, CUDA) | All GPU capabilities provided by vendor (DX 12, OpenGL, CUDA) |
| GPU VRAM | Up to VRAM supported by the GPU | Up to VRAM supported by the GPU per partition |
| GPU driver in guest | GPU vendor driver (NVIDIA) | GPU vendor driver (NVIDIA) |

## Supported GPU models

To see the full list of supported solutions and GPUs, see [Azure Local catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog?gpuSupport=GPU_P&gpuSupport=DDA). The page opens with GPU support options already selected.

For a list of Premier Solutions and Integrated Systems that support accelerated AI workloads with Azure Local supported GPU models, go to the Azure Local catalog and select **AI workload** under **Solution capability** in the left menu.

NVIDIA supports their workloads separately with their virtual GPU software. For more information, see [Microsoft Azure Local - Supported NVIDIA GPUs and Validated Server Platforms](https://docs.nvidia.com/vgpu/17.0/grid-vgpu-release-notes-microsoft-azure-stack-hci/index.html#hardware-configuration).

For AKS workloads, see [GPUs for AKS for Arc](/azure/aks/hybrid/deploy-gpu-node-pool#supported-gpu-models).


The following table shows GPU model support by GPU assignment type and VM workload type:

| GPU Model | DDA | DDA | DDA | GPU-P |
| --- | --- | --- | --- | --- |
| | **VMs**<br>(Enabled by Azure Arc) | **VMs**<br> (Unmanaged) | **AKS** | **VMs only** * |
| NVIDIA T4 | &check; Yes | &check; Yes | &check; Yes | &cross; No |
| NVIDIA A2 |&check; Yes |&check; Yes |&check; Yes |&check; Yes |
| NVIDIA A10 |&cross; No |&check; Yes |&cross; No |&check; Yes |
| NVIDIA A16 |&check; Yes |&check; Yes |&check; Yes |&check; Yes |
| NVIDIA A40 |&cross; No |&check; Yes |&cross; No |&check; Yes |
| NVIDIA L4 |&check; Yes |&check; Yes |&check; Yes |&check; Yes |
| NVIDIA L40 |&check; Yes |&check; Yes |&check; Yes |&check; Yes |
| NVIDIA L40S |&check; Yes |&check; Yes |&check; Yes |&check; Yes |
| NVIDIA RTX Pro 6000 |&check; Yes |&check; Yes |&check; Yes |&check; Yes |

*AKS Arc doesn't currently support GPU partitions.

## Host requirements

Your Azure Local host must meet the following requirements:

- Your system must support an Azure Local solution with GPU support. To browse your options, see the [Azure Local Catalog](https://azurestackhcisolutions.azure.microsoft.com/#/catalog?gpuSupport=GPU_P&gpuSupport=DDA).

- You must have access to Azure Local.

- You must create a homogeneous configuration for GPUs across all the machines in your system. A homogeneous configuration consists of installing the same make and model of GPU.

- For GPU-P, ensure that the virtualization support and SR-IOV are enabled in the BIOS of each machine in the system. Contact your hardware vendor if you can't identify the correct setting in your BIOS.

## Prepare GPU drivers on each host

The process for preparing and installing GPU drivers for each machine differs somewhat between DDA and GPU-P. Follow the applicable process for your situation.

### Find GPUs on each host

For a new DDA setup, ensure that you don't install the NVIDIA host graphics or runtime driver on any machine. If the driver is installed, uninstall it, and then restart the machine.

> [!NOTE] 
> This step doesn't apply to the DDA mitigation driver, which is separate from the host graphics or runtime driver.

If your GPUs are already prepared for DDA, don't uninstall a working mitigation driver or restart the host to recreate the unprepared state. Instead, use `Get-VMHostAssignableDevice` and the [bound-driver verification commands](#2-download-and-install-the-mitigation-driver) to check how the GPUs are currently prepared.


Next, run PowerShell as administrator and run the following command:

```powershell
Get-PnpDevice -Status Error | fl FriendlyName, InstanceId
```
On an unprepared host without a GPU driver, the GPUs appear as **3D Video Controller** devices in an error state, as shown in the following example output. GPUs that are already prepared and working correctly don't appear in the output, because this query returns only devices in an error state.

```output
[ASRR1N26R02U46A]: PS C:\Users\HCIDeploymentUser\Documents> Get-PnpDevice -Status Error

Status		Class			FriendlyName
------		-----			------------
Error					SD Host Controller
Error					3D Video Controller
Error					3D Video Controller
Error		USB			Unknown USB Device (Device Descriptor Request Failed)

[ASRR1N26R02U46A]: PS C:\Users\HCIDeploymentUser\Documents> Get-PnpDevice -Status Error | Format-List InstanceId

InstanceId : PCI\VEN_8086&DEV_18DB&SUBSYS_7208086REV_11\3&11583659&0&E0

InstanceId : PCI\VEN_10DE&DEV_25B6&SUBSYS_157E10DE&REV_A1\4&23AD3A43&0&0010

InstanceId : PCI\VEN_10DE&DEV_25B6&SUBSYS_157E10DE&REV_A1\4&17F8422A&0&0010

InstanceId : USB\VID_0000&PID_0002\S&E492A46&0&2
```

## Using DDA

Follow this process when using DDA:

### 1. Disable and dismount GPUs from the host

For DDA, the physical GPU goes into an error state when you uninstall the host graphics or runtime driver, or when you set up a new Azure Local. You must dismount each GPU before you can assign it through DDA. To disable and dismount GPUs that aren't already dismounted, use Device Manager or PowerShell with the `InstanceId` value from the previous step. Skip this step for any GPU that's already listed in the output of `Get-VMHostAssignableDevice`.

```powershell
$id1 = "GPU_instance_ID"
Disable-PnpDevice -InstanceId $id1 -Confirm:$false
Dismount-VMHostAssignableDevice -InstancePath $id1 -Force
```

Confirm the GPUs are correctly dismounted by listing the devices available for DDA. Check the `InstanceID` and `LocationPath` for each GPU:

```powershell
Get-VMHostAssignableDevice | Format-List InstanceID, LocationPath
```

Repeat this process for each machine in your system to prepare the GPUs.

### 2. Download and install the mitigation driver

The software might include components developed and owned by NVIDIA Corporation or its licensors. The use of these components is governed by the [NVIDIA end user license agreement](https://www.nvidia.com/content/DriverDownloads/licence.php?lang=us).

You need the NVIDIA mitigation driver so that Hyper-V can correctly reset the GPU during VM reboots. This driver is separate from the NVIDIA graphics driver installed in the guest VM. Install the applicable mitigation driver on every GPU-capable host, including hosts that can receive the VM during failover.

To download the applicable package for your hardware, see the [NVIDIA GPU Passthrough Support documentation](https://docs.nvidia.com/datacenter/tesla/gpu-passthrough/). The following example downloads and extracts `Azure_Local_Mitigation_092525.zip`. The model-specific INFs in this package report driver version `2025.02.13.0`:

```powershell
$downloadUrl = "https://docs.nvidia.com/datacenter/tesla/gpu-passthrough/Azure_Local_Mitigation_092525.zip"
Invoke-WebRequest -Uri $downloadUrl -OutFile ".\Azure_Local_Mitigation_092525.zip"
Expand-Archive -LiteralPath ".\Azure_Local_Mitigation_092525.zip" -DestinationPath ".\nvidia-mitigation-driver"
```

Before you install the driver, make sure that a model entry in the model-specific INF file matches a hardware ID or compatible ID for each dismounted GPU. The match must also meet any subsystem or revision restrictions in that entry. To view these IDs, use Device Manager, or run `Get-PnpDeviceProperty` with the `DEVPKEY_Device_HardwareIds` and `DEVPKEY_Device_CompatibleIds` properties.

An INF file can match a less specific compatible ID, so the full hardware ID, including the subsystem and revision, doesn't need to appear exactly in the INF file. If no model entry matches either list, contact your hardware vendor for a supported package.

> [!IMPORTANT]
> An INF being included in the package doesn't establish support for that GPU or Azure Local solution. Check the [supported GPU models](#supported-gpu-models) and your hardware vendor's requirements.

Install the INF for your GPU model. The extracted `drivers\nvidia_azure_stack_RTX6000` directory contains INFs for multiple models. For example, to install the NVIDIA A2 mitigation driver, run:

```powershell
$driverPath = ".\nvidia-mitigation-driver\drivers\nvidia_azure_stack_RTX6000"
pnputil /add-driver "$driverPath\nvidia_azure_stack_A2_base.inf" /install
```

> [!NOTE]
> If an identical package is already installed, PnPUtil can report that it already exists and that the device's driver is up to date. An existing-package operation can return exit code `259` (`No more data is available`) with those messages. This isn't evidence of a fresh installation. Check the command output and verify the actual device binding below; don't treat other nonzero exit codes or error messages as success, or uninstall a working package just to obtain a zero exit code.

Confirm that the mitigation driver is bound to each GPU, not just added to the driver store. Dismounted NVIDIA GPUs use a `PCIP\VEN_10DE` device instance and can appear in the `System` class, so a `Get-PnpDevice -Class Display` check doesn't verify these devices.

Run the following commands to inspect each dismounted NVIDIA GPU and its bound driver:

```powershell
$properties = @(
    'DEVPKEY_Device_HardwareIds'
    'DEVPKEY_Device_CompatibleIds'
    'DEVPKEY_Device_DriverInfPath'
    'DEVPKEY_Device_DriverVersion'
    'DEVPKEY_Device_DriverProvider'
    'DEVPKEY_Device_Service'
    'DEVPKEY_Device_ProblemCode'
)

Get-VMHostAssignableDevice |
    Where-Object { $_.InstanceID -like 'PCIP\VEN_10DE&*' } |
    ForEach-Object {
        $id = $_.InstanceID
        Get-PnpDevice -InstanceId $id |
            Format-List FriendlyName, Status, Class, InstanceId
        Get-PnpDeviceProperty -InstanceId $id -KeyName $properties |
            Format-Table KeyName, @{Name = 'Data'; Expression = { $_.Data -join ', ' }} -Wrap

        $inf = (Get-PnpDeviceProperty -InstanceId $id -KeyName DEVPKEY_Device_DriverInfPath).Data
        Get-WindowsDriver -Online -Driver $inf |
            Select-Object Driver, OriginalFileName, ProviderName, Version -Unique |
            Format-List Driver, OriginalFileName, ProviderName, Version
    }
```

For each GPU you expect to see, verify that:

- The device status is `OK`.
- The problem code is `0`.
- The service is `pcip`.
- The published `oem*.inf` file maps to the NVIDIA model-specific INF file that you selected.
- The driver version matches the package version.
- The `FriendlyName` value matches the name defined in that INF file.

> [!IMPORTANT]
> A message saying that the package was staged successfully doesn't confirm that the driver is bound to the GPU. Complete all the preceding checks.

Repeat these checks on every GPU-capable host, including failover hosts, before assigning GPUs to VMs.

## Using GPU-P

Follow this process if using GPU-P:

### Download and install the host driver

GPU-P requires drivers on the host level that differ from DDA. For NVIDIA GPUs, you need an NVIDIA vGPU software graphics driver on each host and on each VM that uses GPU-P. For more information, see the latest version of [NVIDIA vGPU Documentation](https://docs.nvidia.com/vgpu/latest/grid-vgpu-release-notes-microsoft-azure-stack-hci/index.html) and details on licensing at [Client Licensing User Guide](https://docs.nvidia.com/vgpu/latest/grid-licensing-user-guide/index.html).

After identifying the GPUs as `3D Video Controller` on your host machine, download the host vGPU driver. Through your NVIDIA GRID license, you can obtain the proper host driver .zip file.

You need to obtain and move the following folder to your host machine: *\vGPU_<Your_vGPU_version>_GA_Azure_Stack_HCI_Host_Drivers*

Navigate to *\vGPU_<Your_vGPU_version>_GA_Azure_Stack_HCI_Host_Drivers\Display.Driver* and install the driver.  

```powershell
pnputil /add-driver .\nvgridswhci.inf /install /force
```

To confirm the installation of these drivers, run:

```powershell
pnputil /enum-devices
```

You should see the correctly identified GPUs in `Get-PnpDevice`:

```powershell
Get-PnpDevice -Class Display | fl FriendlyName, InstanceId
```
You can also run the NVIDIA System Management Interface `nvidia-smi` to list the GPUs on the host machine as follows:

```powershell
nvidia-smi
```

If the driver is correctly installed, you see an output similar to the following sample:

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
> When using PowerShell, you must manually ensure the GPU configuration is homogeneous across all machines in your Azure Local.

1. Connect to the machine whose GPU partition count you want to configure.

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

1. To keep the configuration homogeneous, repeat the partition count configuration steps on each machine in your system.

## Guest requirements

GPU management supports the following VM workloads:

- Generation 2 VMs

- A supported 64-bit OS as detailed in the latest [NVIDIA vGPU support Supported Products](https://docs.nvidia.com/vgpu/latest/product-support-matrix/index.html#abstract__microsoft-azure-stack-hci)

## Next steps

- [Manage GPU via Discrete Device Assignment (DDA)](./gpu-manage-via-device.md)
- [Manage GPU via GPU Partitioning (GPU-P)](./gpu-manage-via-partitioning.md)
