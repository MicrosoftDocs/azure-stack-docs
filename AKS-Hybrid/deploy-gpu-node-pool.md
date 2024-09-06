---
title: Use GPUs for compute-intensive workloads (AKS on Azure Stack HCI 23H2)
description: Learn how to deploy GPU-enabled node pools in AKS enabled by Arc.
author: sethmanheim
ms.topic: how-to
ms.date: 06/05/2024
ms.author: sethm 
ms.lastreviewed: 06/05/2024
ms.reviewer: baziwane

# Intent: As an IT Pro, I want to learn how to deploy GPU-enabled node pools
# Keyword: Run GPU workloads on Kubernetes
---

# Use GPUs for compute-intensive workloads (AKS on Azure Stack HCI 23H2)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

> [!NOTE]
> For information about GPUs in AKS on Azure Stack HCI 22H2, see [Use GPUs (HCI 22H2)](deploy-gpu-node-pool-22h2.md).

Graphical Processing Units (GPU) are used for compute-intensive workloads such as machine learning, deep learning, and more. This article describes how to use GPUs for compute-intensive workloads in AKS enabled by Azure Arc.

## Supported GPU models

The following GPU models are supported by AKS on Azure Stack HCI 23H2:

| Manufacturer | GPU model | Supported version |
|--------------|-----------|-------------------|
| NVidia       | A2        | 2311.2            |
| NVidia       | A16       | 2402.0            |
| NVidia       | T4        | 2408.0            |

## Supported VM sizes

The following VM sizes for each GPU models are supported by AKS on Azure Stack HCI 23H2. 

### Nvidia T4 is supported by NK T4 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|-----------------|---|----|-----|----|
| Standard_NK6    | 1 | 8  | 6   | 12 |
| Standard_NK12   | 2 | 16 | 12  | 24 |

### Nvidia A2 is supported by NC2 A2 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|-------------------|---|----|----|----|
| Standard_NC4_A2   | 1 | 16 | 4  | 8  |
| Standard_NC8_A2   | 1 | 16 | 8  | 16 |
| Standard_NC16_A2  | 2 | 48 | 16 | 64 |
| Standard_NC32_A2  | 2 | 48 | 32 | 28 | 

### Nvidia A16 is supported by NC2 A16 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|--------------------|---|----|----|----|
| Standard_NC4_A16   | 1 | 16 | 4  | 8  |
| Standard_NC8_A16   | 1 | 16 | 8  | 16 |
| Standard_NC16_A16  | 2 | 48 | 16 | 64 |
| Standard_NC32_A16  | 2 | 48 | 32 | 28 | 

## Before you begin

To use GPUs in AKS Arc, make sure you installed the necessary GPU drivers before you begin the deployment of the cluster. Follow the steps in this section.

### Step 1: install the OS

Install the Azure Stack HCI, version 23H2 operating system locally on each server in your Azure Stack HCI cluster.

### Step 2: uninstall the NVIDIA host driver

On each host machine, navigate to **Control Panel > Add or Remove programs**, uninstall the NVIDIA host driver, then reboot the machine. After the machine reboots, confirm that the driver was successfully uninstalled. Open an elevated PowerShell terminal and run the following command:

```powershell
Get-PnpDevice  | select status, class, friendlyname, instanceid | findstr /i /c:"3d video" 
```

You should see the GPU devices appear in an error state as shown in this example output:

```output
Error       3D Video Controller                   PCI\VEN_10DE&DEV_1EB8&SUBSYS_12A210DE&REV_A1\4&32EEF88F&0&0000 
Error       3D Video Controller                   PCI\VEN_10DE&DEV_1EB8&SUBSYS_12A210DE&REV_A1\4&3569C1D3&0&0000 
```

### Step 3: dismount the host driver from the host

When you uninstall the host driver, the physical GPU goes into an error state. You must dismount all the GPU devices from the host.

For each GPU (3D Video Controller) device, run the following commands in PowerShell. Copy the instance ID; for example, `PCI\VEN_10DE&DEV_1EB8&SUBSYS_12A210DE&REV_A1\4&32EEF88F&0&0000` from the previous command output:

```powershell
$id1 = "<Copy and paste GPU instance id into this string>"
$lp1 = (Get-PnpDeviceProperty -KeyName DEVPKEY_Device_LocationPaths -InstanceId $id1).Data[0]
Disable-PnpDevice -InstanceId $id1 -Confirm:$false
Dismount-VMHostAssignableDevice -LocationPath $lp1 -Force
```

To confirm that the GPUs were correctly dismounted from the host, run the following command. You should put GPUs in an `Unknown` state:

```powershell
Get-PnpDevice  | select status, class, friendlyname, instanceid | findstr /i /c:"3d video"
```

```output
Unknown       3D Video Controller               PCI\VEN_10DE&DEV_1EB8&SUBSYS_12A210DE&REV_A1\4&32EEF88F&0&0000 
Unknown       3D Video Controller               PCI\VEN_10DE&DEV_1EB8&SUBSYS_12A210DE&REV_A1\4&3569C1D3&0&0000 
```

### Step 4: download and install the NVIDIA mitigation driver

The software might include components developed and owned by NVIDIA Corporation or its licensors. The use of these components is governed by the [NVIDIA end user license agreement](https://www.nvidia.com/content/DriverDownload-March2009/licence.php?lang=us).

See the [NVIDIA data center documentation](https://docs.nvidia.com/datacenter/tesla/gpu-passthrough/) to download the NVIDIA mitigation driver. After downloading the driver, expand the archive and install the mitigation driver on each host machine. You can follow this PowerShell script to download the mitigation driver and extract it:

```powershell
Invoke-WebRequest -Uri "https://docs.nvidia.com/datacenter/tesla/gpu-passthrough/nvidia_azure_stack_inf_v2022.10.13_public.zip" -OutFile "nvidia_azure_stack_inf_v2022.10.13_public.zip"
mkdir nvidia-mitigation-driver
Expand-Archive .\nvidia_azure_stack_inf_v2022.10.13_public.zip .\nvidia-mitigation-driver\
```

To install the mitigation driver, navigate to the folder that contains the extracted files, and select the GPU driver file based on the actual GPU type installed on your Azure Stack HCI hosts. For example, if the type is **A2 GPU**, right-click the **nvidia_azure_stack_A2_base.inf** file, and select **Install**.

You can also install using the command line by navigating to the folder and running the following commands to install the mitigation driver:

```powershell
pnputil /add-driver nvidia_azure_stack_A2_base.inf /install 
pnputil /scan-devices 
```

After you install the mitigation driver, the GPUs are listed in the **OK** state under **Nvidia A2_base - Dismounted**:

```powershell
Get-PnpDevice  | select status, class, friendlyname, instanceid | findstr /i /c:"nvidia"
```

```output
OK       Nvidia A2_base - Dismounted               PCI\VEN_10DE&DEV_1EB8&SUBSYS_12A210DE&REV_A1\4&32EEF88F&0&0000 
OK       Nvidia A2_base - Dismounted               PCI\VEN_10DE&DEV_1EB8&SUBSYS_12A210DE&REV_A1\4&3569C1D3&0&0000
```

### Step 5: repeat steps 1 to 4

Repeat steps 1 to 4 for each server in your HCI cluster.

### Step 6: continue deployment of the Azure Stack HCI cluster

Continue the deployment of the Azure Stack HCI cluster by following the steps in [Azure Stack HCI, version 23H2 deployment.](/azure-stack/hci/deploy/deployment-introduction)

### Get a list of available GPU-enabled VM SKUs

Once the Azure Stack HCI cluster deployment is complete, you can run the following CLI command to show the available VM SKUs on your deployment. If your GPU drivers are installed correctly, the corresponding GPU VM SKUs are listed:

```azurecli
az aksarc vmsize list --custom-location <custom location ID> -g <resource group name>
```

## Create a new workload cluster with a GPU-enabled node pool

Currently, using GPU-enabled node pools is only available for Linux node pools. To create a new Kubernetes cluster:

```azurecli
az aksarc create -n <aks cluster name> -g <resource group name> --custom-location <custom location ID> --vnet-ids <vnet ID>
```

The following example adds a node pool with 2 GPU-enabled (NVDIA A2) nodes with a **Standard\_NC4\_A2** VM SKU:

```azurecli
az aksarc nodepool add --cluster-name <aks cluster name> -n <node pool name> -g <resource group name> --node-count 2 --node-vm-size Standard_NC4_A2 --os-type Linux
```

## Confirm you can schedule GPUs

With your GPU node pool created, confirm that you can schedule GPUs in Kubernetes. First, list the nodes in your cluster using the [kubectl get nodes](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get) command:

```powershell
kubectl get nodes
```

```output
NAME             STATUS  ROLES                 AGE   VERSION
moc-l9qz36vtxzj  Ready   control-plane,master  6m14s  v1.22.6
moc-lhbkqoncefu  Ready   <none>                3m19s  v1.22.6
moc-li87udi8l9s  Ready   <none>                3m5s  v1.22.6
```

Now use the [kubectl describe node](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) command to confirm that the GPUs can be scheduled. Under the **Capacity** section, the GPU should appear as **nvidia.com/gpu: 1**.

```powershell
kubectl describe <node> | findstr "gpu" 
```

The output should display the GPU(s) from the worker node and look something like this:

```output
Capacity: 
  cpu:                4 
  ephemeral-storage:  103110508Ki 
  hugepages-1Gi:      0 
  hugepages-2Mi:      0 
  memory:             7865020Ki 
  nvidia.com/gpu:     1 
  pods:               110
```

## Run a GPU-enabled workload

Once you complete the previous steps, create a new YAML file for testing; for example, **gpupod.yaml**. Copy and paste the following YAML into the new file named **gpupod.yaml**, then save it:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cuda-vector-add
spec:
  restartPolicy: OnFailure
  containers:
  - name: cuda-vector-add
    image: "k8s.gcr.io/cuda-vector-add:v0.1"
    resources:
      limits:
        nvidia.com/gpu: 1
```

Run the following command to deploy the sample application:

```powershell
kubectl apply -f gpupod.yaml
```

Verify that the pod started, completed running, and the GPU is assigned:

```powershell
kubectl describe pod cuda-vector-add | findstr 'gpu'
```

The previous command should show one GPU assigned:

```output
nvidia.com/gpu: 1
nvidia.com/gpu: 1
```

Check the log file of the pod to see if the test passed:

```powershell
kubectl logs cuda-vector-add
```

The following is example output from the previous command:

```output
[Vector addition of 50000 elements]
Copy input data from the host memory to the CUDA device
CUDA kernel launch with 196 blocks of 256 threads
Copy output data from the CUDA device to the host memory
Test PASSED
Done
```

If you receive a version mismatch error when calling into drivers, such as "CUDA driver version is insufficient for CUDA runtime version," review the [NVIDIA driver matrix compatibility chart](https://docs.nvidia.com/deploy/cuda-compatibility/index.html).

## FAQ

### What happens during upgrade of a GPU-enabled node pool?

Upgrading GPU-enabled node pools follows the same rolling upgrade pattern that's used for regular node pools. For GPU-enabled node pools in a new VM to be successfully created on the physical host machine, it requires one or more physical GPUs to be available for successful device assignment. This availability ensures that your applications can continue running when Kubernetes schedules pods on this upgraded node.

Before you upgrade:

1. Plan for downtime during the upgrade.
1. Have one extra GPU per physical host if you are running the **Standard_NK6** or 2 extra GPUs if you are running **Standard_NK12**. If you are running at full capacity and don't have an extra GPU, we recommend scaling down your node pool to a single node before the upgrade, then scaling up after upgrade succeeds.

### What happens if I don't have extra physical GPUs on my physical machine during an upgrade?

If an upgrade is triggered on a cluster without extra GPU resources to facilitate the rolling upgrade, the upgrade process hangs until a GPU is available. If you run at full capacity and don't have an extra GPU, we recommend scaling down your node pool to a single node before the upgrade, then scaling up after the upgrade succeeds.

## Next steps

- [Use GPUs (AKS on Azure Stack HCI 22H2)](deploy-gpu-node-pool-22h2.md)
- [AKS overview](aks-hybrid-options-overview.md)
