---
title:  Graphics processing unit (GPU) VM on Azure Stack Hub
description: Reference for GPU computing in Azure Stack Hub.
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: reference
ms.date: 04/21/2025
ms.reviewer: rtibi
ms.lastreviewed: 4/28/2021

# Intent: As a a developer on Azure Stack Hub, I want to use a machine with a Graphics Processing Unit (GPU) in order to deliver an processing intensive visualization application.
# Keyword: Azure Stack Hub Graphics Processing Unit (GPU)
---

# Graphics processing unit (GPU) virtual machine (VM) on Azure Stack Hub

This article describes which graphics processing unit (GPU) models are supported on an Azure Stack Hub integrated system. The article also contains instructions on installing the drivers used with the GPUs. GPU support in Azure Stack Hub enables solutions such as artificial intelligence, training, inference, and data visualization. The AMD Radeon Instinct MI25 can be used to support graphic-intensive applications such as Autodesk AutoCAD.

You can choose from three GPU models. They are available in NVIDIA V100, NVIDIA T4, and AMD MI25 GPUs. These physical GPUs align with the following Azure N-Series virtual machine (VM) types as follows:

- [NCv3](/azure/virtual-machines/ncv3-series)
- [NVv4 (AMD MI25)](/azure/virtual-machines/nvv4-series)
- [NCasT4_v3](/azure/virtual-machines/nct4-v3-series)

::: moniker range="<=azs-2002"
> [!WARNING]  
> GPU VMs are not supported in this release. You must upgrade to Azure Stack Hub 2005 or later. In addition, your Azure Stack Hub hardware must have physical GPUs.
::: moniker-end

## NCv3

NCv3-series VMs are powered by NVIDIA Tesla V100 GPUs. Customers can take advantage of these updated GPUs for traditional HPC workloads such as reservoir modeling, DNA sequencing, protein analysis, Monte Carlo simulations, and others.

| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | GPU | GPU memory: GiB | Max data disks | Max NICs |
|---|---|---|---|---|---|---|---|
| Standard_NC6s_v3    | 6  | 112 | 736  | 1 | 16 | 12 | 4 |
| Standard_NC12s_v3   | 12 | 224 | 1474 | 2 | 32 | 24 | 8 |
| Standard_NC24s_v3   | 24 | 448 | 2948 | 4 | 64 | 32 | 8 |

## NVv4

The NVv4-series virtual machines are powered by AMD Radeon Instinct MI25 GPUs. With the NVv4-series, Azure Stack Hub introduces virtual machines with partial GPUs. This size can be used for GPU accelerated graphics applications and virtual desktops. NVv4 virtual machines currently support only the Windows guest operating system.

| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | GPU | GPU memory: GiB | Max data disks | Max NICs |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Standard_NV4as_v4 |4 |14 |88 | 1/8 | 2 | 4 | 2 |
| Standard_NV8as_v4 |8 |28 |176 | 1/4 | 4 | 8 | 4 |
| Standard_NV16as_v4 |16 |56 |352 | 1/2 | 8 | 16 | 8 |
| Standard_NV32as_v4 |32 |112 |704 | 1 | 16 | 32 | 8 |

## NCasT4_v3

| Size | vCPU | Memory: GiB | GPU | GPU memory: GiB | Max data disks | Max NICs |
| --- | --- | --- | --- | --- | --- | --- |
| Standard_NC4as_T4_v3 |4 |28 | 1 | 16 | 8 | 4 |
| Standard_NC8as_T4_v3 |8 |56 | 1 | 16 | 16 | 8 |
| Standard_NC16as_T4_v3 |16 |110 | 1 | 16 | 32 | 8 |
| Standard_NC64as_T4_v3 |64 |440 | 4 | 64 | 32 | 8 |

## NC_A100 v4

The NC_A100 series VMs are powered by NVIDIA Ampere A100 GPUs, the successor of the Tesla V100 GPUs. You can take advantage of these updated GPUs for traditional HPC workloads such as reservoir modeling, DNA sequencing, protein analysis, Monte Carlo simulations, and others.

|       Size                    |     vCPU  |     Memory: GiB  |     Temp storage (GiB)  |     Max data disks  |     GPU   |     GPU memory GiB  |     Max NICs  |
|-------------------------------|-----------|------------------|-------------------------|---------------------|-----------|---------------------|---------------|
|     Standard_NC24ads_A100_v4  |   24      |   220            |   1123                  |   12                |   1       |   80                |   2           |
|     Standard_NC48ads_A100_v4  |   48      |   440            |   2246                  |   24                |   2       |   160               |   4           |

## NC_L40S v4

|       Size                    |     vCPU  |     Memory: GiB  |     Temp storage (GiB)  |     Max data disks  |     GPU   |     GPU memory GiB  |     Max NICs  |
|-------------------------------|-----------|------------------|-------------------------|---------------------|-----------|---------------------|---------------|
|     Standard_NC24ads_L40S_v4  |   24      |   220            |   1123                  |   8                 |   1       |   80                |   2           |
|     Standard_NC48ads_L40S_v4  |   48      |   440            |   2246                  |   16                |   2       |   160               |   4           |

## GPU system considerations

- GPU must be one of these SKUs: AMD MI-25, Nvidia V100 (and variants), Nvidia T4.
- Number of GPUs per server supported (1, 2, 3, 4). Preferred are: 1, 2, and 4.
- All GPUs must be of the exact same SKU throughout the scale unit.
- All GPU quantities per server must be the same throughout the scale unit.
- GPU partition size (for AMD Mi25) needs to be the same for all GPU VMs on the scale unit.

> [!NOTE]
> Resizing GPU VMs is not supported.

## Capacity planning

The Azure Stack Hub capacity planner was updated to support GPU configurations. [It's accessible here](https://aka.ms/azstackcapacityplanner).

## Adding GPUs on an existing Azure Stack Hub

Azure Stack Hub now supports adding GPUs to any existing system. To add a GPU, run `stop-azurestack`, run through the procedure of `stop-azurestack`, add GPUs, and then run `start-azurestack` until completion. If the system already had GPUs, then any previously created GPU VMs must be `stop-deallocated` and then restarted.

## Patch and update, FRU behavior of VMs

GPU VMs undergo downtime during operations such as patch and update (PnU) and hardware replacement (FRU) of Azure Stack Hub. The following table covers the state of the VM as observed during these activities and the manual action you can do to make these VMs available after the operation.

| Operation | PnU - Full Update, OEM update | FRU |
| --- | --- | --- |
| VM state  | Unavailable during update. Can be made available with manual operation. VM is automatically online post update. | Unavailable during FRU. Can be made available with manual operation. VM needs to be brought back up after FRU|
| Manual operation | If the VM needs to be made available during the update, if there are available GPU partitions, the VM can be restarted from the portal by clicking the **Restart** button. VM automatically comes back up post update. | VM is not available during FRU. If there are available GPUs, VM may be stop-deallocated and restarted during FRU. Post FRU completion, the VM must be `stop-deallocated` using the **Stop** button, then restarted using the **Start** button.|

## Guest driver installation

You can use the [Set-AzVMExtension](/powershell/module/az.compute/set-azvmextension) PowerShell cmdlet for driver installation:

```powershell
$VmName = <VM Name In Portal>
$ResourceGroupName = <Resource Group of VM>
$Location = "redmond"
$driverName = <Give a name to the driver>
$driverPublisher = "Microsoft.HpcCompute"
$driverType = <Specify Driver Type> #GPU Driver Types: "NvidiaGpuDriverWindows"; "NvidiaGpuDriverLinux"; "AmdGpuDriverWindows"
$driverVersion = <Specify Driver Version> #Nvidia Driver Version:"1.3"; AMD Driver Version:"1.0"

Set-AzVMExtension  -Location $Location `
                       -Publisher $driverPublisher `
                       -ExtensionType $driverType `
                       -TypeHandlerVersion $driverVersion `
                       -VMName $VmName `
                       -ResourceGroupName $ResourceGroupName `
                       -Name $driverName `
                       -Settings $Settings ` # If no settings are set, omit this parameter
                       -Verbose
```

Depending on the OS, type, and connectivity of your Azure Stack Hub GPU VM, you must replace these values with the following settings.

### AMD MI25

The guest driver version must match the Azure Stack Hub version, regardless of the connectivity state. Using newer versions not aligned with the Azure Stack Hub version can cause usability issues.

|     Azure Stack Hub Version    |     AMD Guest driver    |
|--------------------------------|-------------------------|
|     2206 and later                       |     [21.Q2-1](https://download.microsoft.com/download/4/e/a/4ea28d3f-28e2-4eaa-8ef2-4f7d32882a0b/AMD-Azure-NVv4-Driver-21Q2-1.exe), [20.Q4-1](https://download.microsoft.com/download/0/e/6/0e611412-093f-40b8-8bf9-794a1623b2be/AMD-Azure-NVv4-Driver-20Q4-1.exe)             |
|     2108                       |     [21.Q2-1](https://download.microsoft.com/download/4/e/a/4ea28d3f-28e2-4eaa-8ef2-4f7d32882a0b/AMD-Azure-NVv4-Driver-21Q2-1.exe), [20.Q4-1](https://download.microsoft.com/download/0/e/6/0e611412-093f-40b8-8bf9-794a1623b2be/AMD-Azure-NVv4-Driver-20Q4-1.exe)             |
|     2102                       |     [21.Q2-1](https://download.microsoft.com/download/4/e/a/4ea28d3f-28e2-4eaa-8ef2-4f7d32882a0b/AMD-Azure-NVv4-Driver-21Q2-1.exe), [20.Q4-1](https://download.microsoft.com/download/0/e/6/0e611412-093f-40b8-8bf9-794a1623b2be/AMD-Azure-NVv4-Driver-20Q4-1.exe)             |

#### Connected

Use the PowerShell script in the previous section with the appropriate driver type for AMD. The article [Install AMD GPU drivers on N-series VMs running Windows](/azure/virtual-machines/windows/n-series-amd-driver-setup) provides instructions on installing the driver for the AMD Radeon Instinct MI25 inside the NVv4 GPU-P enabled VM, along with steps on how to verify driver installation.

#### Disconnected

Since the extension pulls the driver from a location on the internet, a VM that is disconnected from the external network can't access it. You can [download the driver from the previous table](#amd-mi25) and upload to a storage account in your local network that's accessible to the VM.

Add the AMD driver to a storage account and specify the URL to that account in `Settings`. These settings must be used in the **Set-AzureRMVMExtension** cmdlet. For example:

```powershell  
$Settings = @{
"DriverURL" = <URL to driver in storage account>
}
```

### NVIDIA

NVIDIA drivers must be installed inside the virtual machine for CUDA or GRID workloads using the GPU.

#### Use case: graphics/visualization GRID

This scenario requires the use of GRID drivers. GRID drivers can be downloaded through the NVIDIA Application Hub provided you have the required licenses. The GRID drivers also require a GRID license server with appropriate GRID licenses before using the GRID drivers on the VM.

```powershell  
$Settings = @{
"DriverURL" = "https://download.microsoft.com/download/e/8/2/e8257939-a439-4da8-a927-b64b63743db1/431.79_grid_win10_server2016_server2019_64bit_international.exe"; "DriverCertificateUrl" = "https://go.microsoft.com/fwlink/?linkid=871664"; 
"DriverType"="GRID"
}
```

### Use case: compute/CUDA - Connected

CUDA drivers don't need a license server and don't need modified settings.

### Use case: compute/CUDA - Disconnected

You can get [links to NVIDIA CUDA drivers here](https://raw.githubusercontent.com/Azure/azhpc-extensions/master/NvidiaGPU/resources.json).

**Windows:**

```powershell  
$Settings = @{
"DriverURL" = "";
"DriverCertificateUrl" = "https://go.microsoft.com/fwlink/?linkid=871664"; 
"DriverType"="CUDA"
}
```

**Linux:**

You must reference some URLs for your settings:

| URL | Notes |
| --- | --- |
| PUBKEY_URL | The PUBKEY_URL is the public key for the Nvidia driver repository not for the Linux VM. It's used to install driver for Ubuntu. |
| DRIVER_URL  | DRIVER_URL is the URL to download the Nvidia driver's repository information and is added to the Linux VM's list of repos. |

Add the URLs to your settings.

```powershell
$Settings=@{
"isCustomInstall"=$true;
"DRIVER_URL"="https://go.microsoft.com/fwlink/?linkid=874273";
"CUDA_ver"="10.0.130";
"PUBKEY_URL"="http://download.microsoft.com/download/F/F/A/FFAC979D-AD9C-4684-A6CE-C92BB9372A3B/7fa2af80.pub";
"DKMS_URL"="https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm";
"LIS_URL"="https://aka.ms/lis";
"LIS_RHEL_ver"="3.10.0-1062.9.1.el7"
}
```

## Next steps

- [Azure Stack VM features](azure-stack-vm-considerations.md)  
- [Deploy a GPU enabled IoT module on Azure Stack Hub](gpu-deploy-sample-module.md)
